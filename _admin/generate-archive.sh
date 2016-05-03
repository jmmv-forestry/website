# Generates an archive.html include based on a generated site.
#
# The first argument to this program specifies the directory of an already-built
# Jekyll site, and the second specifies the target archive.html file to write
# which should be in the _includes directory.  Once the archive.html file has
# been written, a second Jekyll build needs to be executed to incorporate the
# changes.
#
# This is a hack, and it is so because this breaks the functionality of
# incremental Jekyll rebuilds: we control the logic to generate the contents of
# the archive from the Makefile and Jekyll has no knowledge of what is
# happening.  (This is a minor evil because, for publication purposes, we
# regenerate the site from scratch anyway.)
#
# Unfortunately, the alternative of implementing this purely within Jekyll via
# Liquid processing is extremely slow and convoluted.  See what was done in
# ae0ebafc3620bf4473613c2ca8ce9b52d603ed0e for some details.  Ideally, we would
# just extend the jekyll-archives plugin to expose the calendar in some way,
# which then would make Liquid processing simple, but I haven't investigated
# this route because I don't know Ruby.

shtk_import cleanup
shtk_import cli

count_posts() {
    local dir="${1}"; shift

    find "${dir}" -name "*.html" \! -name index.html | wc -l | awk '{print $1}'
}

month_number_to_name() {
    local number="${1}"; shift

    case "${number}" in
        01) echo "January" ;;
        02) echo "February" ;;
        03) echo "March" ;;
        04) echo "April" ;;
        05) echo "May" ;;
        06) echo "June" ;;
        07) echo "July" ;;
        08) echo "August" ;;
        09) echo "September" ;;
        10) echo "October" ;;
        11) echo "November" ;;
        12) echo "December" ;;
        *)
            shtk_cli_error "Invalid month number ${number}"
            ;;
    esac
}

main() {
    [ ${#} -eq 2 ] || shtk_cli_usage_error "Must provide the site directory" \
        "and the target archive file name"
    local sitedir="${1}"; shift
    local archive="${1}"; shift

    local temp="${archive}.tmp"
    eval "remove_temp_file() { rm -f '${temp}'; }"
    shtk_cleanup_register remove_temp_file

    echo >"${temp}" "<ul>"

    for year in $(cd "${sitedir}" && ls -1dr [0-9][0-9][0-9][0-9]); do
        local year_count="$(count_posts "${sitedir}/${year}")"

        echo >>"${temp}" "  <li>"
        echo >>"${temp}" "    <a data-toggle=\"collapse\"" \
            "href=\"#archive-year-${year}\">${year}</a>" \
            "(${year_count})"
        echo >>"${temp}" "     {% if archive-year == '${year}' %}"
        echo >>"${temp}" "    <ul id=\"archive-year-${year}\"" \
            "class=\"collapse in\">"
        echo >>"${temp}" "     {% else %}"
        echo >>"${temp}" "    <ul id=\"archive-year-${year}\"" \
            "class=\"collapse\">"
        echo >>"${temp}" "     {% endif %}"

        for month in $(cd "${sitedir}/${year}" && ls -1dr [0-9][0-9]); do
            local month_name="$(month_number_to_name "${month}")"
            local month_count="$(count_posts "${sitedir}/${year}/${month}")"
            echo >>"${temp}" "      <li><a" \
                "href=\"/${year}/${month}\">${month_name} ${year}</a>" \
                "(${month_count})</li>"
        done

        echo >>"${temp}" "      <li><a href=\"/${year}\">All year</a></li>"
        echo >>"${temp}" "    </ul>"
        echo >>"${temp}" "  </li>"
    done

    echo >>"${temp}" "</ul>"

    mv "${temp}" "${archive}"
}

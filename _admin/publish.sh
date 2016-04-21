# Takes a draft file and publishes it.
#
# Publication of a draft involves setting the date of the published post
# (which the draft should not have), moving the file into _posts with the
# correct file name, and committing the result.

shtk_import bool
shtk_import cli

# Ensure dates are generated in English.
export LANG=C LC_ALL=C

sed_in_place() {
    local file="${1}"; shift

    if sed "${@}" "${file}" >"${file}.tmp"; then
        mv -f "${file}.tmp" "${file}"
    else
        rm -f "${file}.tmp"
        shtk_cli_error "Failed to modify ${file} in place"
    fi
}

add_date() {
    local file="${1}"; shift
    local date="${1}"; shift

    sed_in_place "${file}" -E "/^title:/p;s/^title:( *).*$/date: \1${date}/"

    grep "^date: *${date}" "${file}" >/dev/null || \
        shtk_cli_error "Date not found in file after automated edit"
}

update_last_updated() {
    local file="${1}"; shift

    local year="$(date +'%Y')"
    local month="$(date +'%B')"
    local day="$(date +'%d')"
    case "${day}" in
        1|21|31) day="${day}st" ;;
        2|22) day="${day}nd" ;;
        3|23) day="${day}rd" ;;
        *) day="${day}th" ;;
    esac

    local date="${month} ${day}, ${year}"

    sed_in_place "${file}" -E "/^last_updated:/s/:.*$/: ${date}/"
}

main() {
    [ ${#} -eq 1 ] || shtk_cli_usage_error "Must provide a single draft name"
    local draft_file="${1}"; shift

    local post_date="$(date +'%Y-%m-%d %H:%M:%S')"
    local file_date="$(echo "${post_date}" | cut -d ' ' -f 1)"

    local draft_name="$(basename "${draft_file}")"
    local post_name="${file_date}-${draft_name}"
    local post_file="_posts/${post_name}"

    [ -e "${draft_file}" ] || shtk_cli_error "${draft_file} does not exist"
    [ ! -e "${post_file}" ] || shtk_cli_error "${post_file} already exists"

    local is_tracked_draft=true
    git ls-files --error-unmatch "${draft_file}" >/dev/null 2>&1 \
        || is_tracked_draft=false

    if shtk_bool_check "${is_tracked_draft}"; then
        git mv "${draft_file}" "${post_file}"
    else
        cp "${draft_file}" "${post_file}"
        git add "${post_file}"
    fi
    add_date "${post_file}" "${post_date}"

    update_last_updated _config.yml

    if shtk_bool_check "${is_tracked_draft}"; then
        git commit -m "Publish post ${post_name} (from drafts)" \
            "${draft_file}" "${post_file}" _config.yml
    else
        git commit -m "Add post ${post_name}" "${post_file}" _config.yml
    fi
}

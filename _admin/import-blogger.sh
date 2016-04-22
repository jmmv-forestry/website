# Imports the contents of a Blogger export.
#
# This script parses the XML file given as the input, which has to be downloaded
# from Blogger as a backup, and generates one file per post in the corresponding
# _drafts or _posts folder.

shtk_import cleanup
shtk_import cli

PARSE_BLOGGER_XSL="$(shtk_cli_dirname)/parse-blogger.xsl"

main() {
    [ ${#} -eq 1 ] || shtk_cli_usage_error "Must provide name of Blogger" \
        "exported data file"
    local input="${1}"; shift

    local pattern="${TMPDIR:-/tmp}/$(shtk_cli_progname).XXXXXX"
    local tempdir="$(mktemp -d "${pattern}" 2>/dev/null)"
    [ -d "${tempdir}" ] || shtk_cli_error "Failed to create temporary directory"

    eval "remove_tempdir() { rm -rf '${tempdir}'; }"
    shtk_cleanup_register remove_tempdir

    shtk_cli_info "Parsing contents of Blogger exported data"
    local chunks="${tempdir}/chunks.txt"
    xsltproc "${PARSE_BLOGGER_XSL}" "${input}" >"${chunks}"

    generate_files "${chunks}" .
}

generate_files() {
    local chunks="${1}"; shift
    local basedir="${1}"; shift

    local chunk=
    while read line; do
        case "${line}" in
            __BEGIN_DRAFT__*)
                local chunk_name="$(echo "${line}" | cut -d ' ' -f 2-)"
                mkdir -p "${basedir}/_drafts"
                chunk="${basedir}/_drafts/${chunk_name}"
                [ ! -f "${chunk}" ] \
                    || shtk_cli_error "Draft ${chunk} already exists"
                shtk_cli_info "Writing draft ${chunk_name}"
                ;;

            __BEGIN_POST__*)
                local chunk_name="$(echo "${line}" | cut -d ' ' -f 2-)"
                mkdir -p "${basedir}/_posts"
                chunk="${basedir}/_posts/${chunk_name}"
                [ ! -f "${chunk}" ] \
                    || shtk_cli_error "Post ${chunk} already exists"
                shtk_cli_info "Writing post ${chunk_name}"
                ;;

            __END__)
                chunk=
                ;;

            *)
                [ -z "${chunk}" ] || echo "${line}" >>"${chunk}"
                ;;
        esac
    done <"${chunks}"
}

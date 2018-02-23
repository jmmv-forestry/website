# Publishes the built site on a separate Git repository.

shtk_import cleanup
shtk_import cli

main() {
    [ ${#} -eq 2 ] || shtk_cli_usage_error "Must provide the location of the" \
        "built site and the target Git repository"
    local site="${1}"; shift
    local repo="${1}"; shift

    [ -f "${site}/CNAME" ] || shtk_cli_error "Invalid site provided; CNAME" \
        "not found in it"

    local pattern="${TMPDIR:-/tmp}/$(shtk_cli_progname).XXXXXX"
    local tempdir="$(mktemp -d "${pattern}" 2>/dev/null)"
    [ -d "${tempdir}" ] || shtk_cli_error "Failed to create temporary directory"
    eval "remove_tempdir() { rm -rf '${tempdir}'; }"
    shtk_cleanup_register remove_tempdir

    git clone "${repo}" "${tempdir}"
    [ -f "${tempdir}/CNAME" ] || shtk_cli_error "Invalid repository provided;" \
        "CNAME not found in it"
    cmp -s "${site}/CNAME" "${tempdir}/CNAME" || shtk_cli_error "CNAMEs do" \
        "not match; refusing to push"

    rsync -av --delete-after --exclude=".git" "${site}/" "${tempdir}"
    touch "${tempdir}/.nojekyll"

    cd "${tempdir}"
    for f in $(git status --porcelain | grep '^\?' | cut -c 4-); do
        git add "${f}"
    done
    for f in $(git status --porcelain | grep '^ D' | cut -c 4-); do
        git rm "${f}"
    done

    git status
    git commit -a -m 'Publish rebuilt new site'
    git push
}

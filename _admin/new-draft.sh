# Creates a new blank draft with the given name.
#
# The draft is populated with a template.  The draft name may or may not
# end with the .md extension; if not present, it is added.

shtk_import cli

main() {
    [ ${#} -eq 1 ] || shtk_cli_usage_error "Must provide a single draft name"
    local draft_name="${1}"; shift

    case "${draft_name}" in
        *.md) ;;
        *) draft_name="${draft_name}.md" ;;
    esac

    cp _admin/_template.md "_drafts/${draft_name}"
    git add "_drafts/${draft_name}"
}

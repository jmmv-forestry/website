# Takes an HTML post and converts it to Markdown.
#
# This is intended to be used on posts imported from Blogger.

shtk_import cleanup
shtk_import cli

extract_content() {
    local input="${1}"; shift

    awk '
BEGIN {
    count = 0
}
/^---$/ {
    count += 1
    next
}
{
    if (count < 2) {
        next
    }
    print
}
    ' <"${input}"
}

extract_front_matter() {
    local input="${1}"; shift

    awk '
BEGIN {
    count = 0
}
/^---$/ {
    count += 1
    if (count <= 2) {
        print
    }
    next
}
{
    if (count != 1) {
        next
    }
    print
}
    ' <"${input}"
}

sed_in_place() {
    local file="${1}"; shift

    if sed "${@}" "${file}" >"${file}.tmp"; then
        mv -f "${file}.tmp" "${file}"
    else
        rm -f "${file}.tmp"
        shtk_cli_error "Failed to modify ${file} in place"
    fi
}

# In The Julipedia posts, I did not use section headings because I was not
# clear on what Blogger expected.  In their place, I used single-line
# paragraphs in bold, which pandoc translates to section 4 levels.  Fix
# this here by "renumbering" the sections.
patch_sections() {
    local markdown="${1}"; shift

    sed_in_place "${markdown}" -E \
        -e 's,^####,#,' \
        -e 's,^\*\*(.*)\*\*$,# \1,'
}

patch_utf8() {
    local markdown="${1}"; shift

    sed_in_place "${markdown}" \
        -e "s,$(printf '\xc3\xa0'),\&agrave;,g" \
        -e "s,$(printf '\xc3\xa1'),\&aacute;,g" \
        -e "s,$(printf '\xc3\xa4'),\&auml;,g" \
        -e "s,$(printf '\xc3\xa7'),\&ccedil;,g" \
        -e "s,$(printf '\xc3\xa8'),\&egrave;,g" \
        -e "s,$(printf '\xc3\xa9'),\&eacute;,g" \
        -e "s,$(printf '\xc3\xab'),\&euml;,g" \
        -e "s,$(printf '\xc3\xac'),\&igrave;,g" \
        -e "s,$(printf '\xc3\xad'),\&iacute;,g" \
        -e "s,$(printf '\xc3\xaf'),\&iuml;,g" \
        -e "s,$(printf '\xc3\xb1'),\&ntilde;,g" \
        -e "s,$(printf '\xc3\xb2'),\&ograve;,g" \
        -e "s,$(printf '\xc3\xb3'),\&oacute;,g" \
        -e "s,$(printf '\xc3\xb6'),\&ouml;,g" \
        -e "s,$(printf '\xc3\xb9'),\&ugrave;,g" \
        -e "s,$(printf '\xc3\xba'),\&uacute;,g" \
        -e "s,$(printf '\xc3\xbc'),\&uuml;,g" \
        -e "s,$(printf '\xe2\x80\x93'),\&ndash;,g" \
        -e "s,$(printf '\xe2\x80\x94'),\&mdash;,g" \
        -e "s,$(printf '\xe2\x80\xa6'),\&hellip;,g"
}

main() {
    [ ${#} -eq 1 ] || shtk_cli_usage_error "Must provide an HTML input name"
    local html_input="${1}"; shift

    local markdown_output="$(echo "${html_input}" | sed -e 's,\.html$,.md,')"

    local front_matter="${markdown_output}.tmp1"
    local html_content="${markdown_output}.tmp2"
    local markdown_content="${markdown_output}.tmp3"
    eval "remove_temp_files() {" \
        "    rm -f '${front_matter}' '${html_content}' '${markdown_content}';" \
        "}"
    shtk_cleanup_register remove_temp_files

    extract_front_matter "${html_input}" \
        | grep -v '^excerpt_separator:' >"${front_matter}"

    extract_content "${html_input}" >"${html_content}"
    pandoc --from=html --to=markdown_strict --output="${markdown_content}" \
        --ascii "${html_content}" || shtk_cli_error "pandoc conversion failed"

    patch_sections "${markdown_content}"
    patch_utf8 "${markdown_content}"

    git mv "${html_input}" "${markdown_output}"
    cat "${front_matter}" "${markdown_content}" >"${markdown_output}"
    git add "${markdown_output}"
}

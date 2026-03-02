BEGIN {
    has_mode4 = 0
    has_mode5 = 0
    has_limit8 = 0
    has_channels3 = 0
    has_str_color_fmt = 0
    has_table_custom = 0
    has_table_base = 0
    has_sprintf = 0
    has_cmp_nocase = 0
    has_parse_hex = 0
    has_transition = 0
    has_terminal = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)

    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /[^0-9]4[^0-9]/ || u ~ /^4$/) has_mode4 = 1
    if (u ~ /[^0-9]5[^0-9]/ || u ~ /^5$/) has_mode5 = 1
    if (u ~ /[^0-9]8[^0-9]/ || u ~ /^8$/) has_limit8 = 1
    if (u ~ /[^0-9]3[^0-9]/ || u ~ /^3$/) has_channels3 = 1
    if (n ~ /GLOBALSTRCOLORPERCENTD/) has_str_color_fmt = 1
    if (n ~ /KYBDCUSTOMPALETTETRIPLESRBASE/) has_table_custom = 1
    if (n ~ /ESQFUNCBASEPALETTERGBTRIPLES/) has_table_base = 1
    if (n ~ /PARSEINIJMPTBLWDISPSPRINTF/) has_sprintf = 1
    if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASE/) has_cmp_nocase = 1
    if (n ~ /SCRIPT3JMPTBLLADFUNCPARSEHEXDIGIT/) has_parse_hex = 1
    if (n ~ /TEXTDISPJMPTBLESQIFFRUNCOPPERRISETRANSITION/) has_transition = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_MODE4=" has_mode4
    print "HAS_MODE5=" has_mode5
    print "HAS_LIMIT8=" has_limit8
    print "HAS_CHANNELS3=" has_channels3
    print "HAS_STR_COLOR_FMT=" has_str_color_fmt
    print "HAS_TABLE_CUSTOM=" has_table_custom
    print "HAS_TABLE_BASE=" has_table_base
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_CMP_NOCASE=" has_cmp_nocase
    print "HAS_PARSE_HEX=" has_parse_hex
    print "HAS_TRANSITION=" has_transition
    print "HAS_TERMINAL=" has_terminal
}

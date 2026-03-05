BEGIN {
    has_entry = 0
    has_ctrl_cmp = 0
    has_ctrl_escape_fmt = 0
    has_quote_case = 0
    has_quote_fmt = 0
    has_comma_case = 0
    has_comma_fmt = 0
    has_hex_case = 0
    has_hex_fmt = 0
    has_literal_fmt = 0
    has_raw_dofmt_call = 0
    has_return = 0
    dofmt_calls = 0
}

function trim(s, t) {
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

    if (u ~ /^LADFUNC2_EMITESCAPEDCHARTOSC[A-Z0-9_]*:/) has_entry = 1

    if (u ~ /^CMP\.B D[0-7],D[0-7]$/ || u ~ /^MOVEQ(\.L)? #32,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$20,D[0-7]$/) has_ctrl_cmp = 1
    if (index(u, "LADFUNC_FMT_CONTROLCHARCARETESCAPE") > 0 || index(u, "LADFUNC_FMT_CONTROLCHARCARETES") > 0) has_ctrl_escape_fmt = 1

    if (u ~ /^MOVEQ(\.L)? #84,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$54,D[0-7]$/ || u ~ /^ADD\.L D[0-7],D[0-7]$/) has_quote_case = 1
    if (index(u, "LADFUNC_FMT_REPLACEMENTQUOTECHAR") > 0 || index(u, "LADFUNC_FMT_REPLACEMENTQUOTEC") > 0) has_quote_fmt = 1

    if (u ~ /^MOVEQ(\.L)? #86,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$56,D[0-7]$/ || u ~ /^NOT\.B D[0-7]$/) has_comma_case = 1
    if (index(u, "LADFUNC_FMT_REPLACEMENTCOMMACHAR") > 0 || index(u, "LADFUNC_FMT_REPLACEMENTCOMMAC") > 0) has_comma_fmt = 1

    if (u ~ /^MOVEQ(\.L)? #126,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$7E,D[0-7]$/) has_hex_case = 1
    if (index(u, "LADFUNC_FMT_HEXESCAPEBYTE") > 0 || index(u, "LADFUNC_FMT_HEXESCAPEBY") > 0) has_hex_fmt = 1

    if (index(u, "LADFUNC_FMT_LITERALCHAR") > 0 || index(u, "LADFUNC_FMT_LITERALCH") > 0) has_literal_fmt = 1

    if (index(u, "GROUP_AX_JMPTBL_FORMAT_RAWDOFMTWITHSCRATCHBUFFER") > 0 || index(u, "GROUP_AX_JMPTBL_FORMAT_RAWDOFM") > 0) {
        has_raw_dofmt_call = 1
        dofmt_calls += 1
    }

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CTRL_CMP=" has_ctrl_cmp
    print "HAS_CTRL_ESCAPE_FMT=" has_ctrl_escape_fmt
    print "HAS_QUOTE_CASE=" has_quote_case
    print "HAS_QUOTE_FMT=" has_quote_fmt
    print "HAS_COMMA_CASE=" has_comma_case
    print "HAS_COMMA_FMT=" has_comma_fmt
    print "HAS_HEX_CASE=" has_hex_case
    print "HAS_HEX_FMT=" has_hex_fmt
    print "HAS_LITERAL_FMT=" has_literal_fmt
    print "HAS_RAW_DOFMT_CALL=" has_raw_dofmt_call
    print "HAS_RAW_DOFMT_CALLS_GE3=" (dofmt_calls >= 3 ? 1 : 0)
    print "HAS_RETURN=" has_return
}

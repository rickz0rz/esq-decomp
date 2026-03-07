BEGIN {
    has_entry=0
    has_find_quote=0
    has_hasquotes_write=0
    has_paren_skip=0
    has_trim_leading=0
    has_trim_trailing=0
    has_outstart_write=0
    has_return_len=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TEXTDISP_FINDQUOTEDSPAN:/ || u ~ /^TEXTDISP_FINDQUOTEDSPA[A-Z0-9_]*:/) has_entry=1
    if (n ~ /STRFINDCHARPTR/ || n ~ /FINDCHARPTR/) has_find_quote=1
    if (n ~ /MOVEQ(L)?1D0/ || n ~ /MOVELD0A0/ || n ~ /HASQUOTES/ || n ~ /20A5/) has_hasquotes_write=1
    if (u ~ /#40/ || u ~ /#\$28/ || n ~ /ADDQL84A5/) has_paren_skip=1
    if (n ~ /WDISPCHARCLASSTABLE/ && n ~ /BTST3/) has_trim_leading=1
    if (n ~ /WDISPCHARCLASSTABLE/ && n ~ /SUBQL18A5/) has_trim_trailing=1
    if (n ~ /MOVEAA0A2/ || n ~ /A2/) has_outstart_write=1
    if (n ~ /SUBL[0-9A-Z]+D0/ || n ~ /ADDQL1D7/ || n ~ /ADDQL1D0/) has_return_len=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FIND_QUOTE_CALL=" has_find_quote
    print "HAS_HASQUOTES_WRITE=" has_hasquotes_write
    print "HAS_PAREN_SKIP=" has_paren_skip
    print "HAS_TRIM_LEADING=" has_trim_leading
    print "HAS_TRIM_TRAILING=" has_trim_trailing
    print "HAS_OUTSTART_WRITE=" has_outstart_write
    print "HAS_RETURN_LEN=" has_return_len
    print "HAS_RTS=" has_rts
}

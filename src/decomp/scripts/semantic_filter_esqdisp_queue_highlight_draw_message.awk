BEGIN {
    has_entry = 0
    has_link = 0
    has_validate = 0
    has_pattern_init = 0
    has_init_rast = 0
    has_setfont = 0
    has_setdrmd = 0
    has_putmsg = 0
    has_unlk = 0
    has_rts = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQDISP_QUEUEHIGHLIGHTDRAWMESSAGE:/) has_entry = 1
    if (uline ~ /LINK\.W A5,#-4/) has_link = 1
    if (uline ~ /ESQIFF_JMPTBL_NEWGRID_VALIDATESELECTIONCODE/) has_validate = 1
    if (uline ~ /ESQDISP_INITHIGHLIGHTMESSAGEPATTERN/) has_pattern_init = 1
    if (uline ~ /LVOINITRASTPORT/) has_init_rast = 1
    if (uline ~ /LVOSETFONT/) has_setfont = 1
    if (uline ~ /LVOSETDRMD/) has_setdrmd = 1
    if (uline ~ /LVOPUTMSG/) has_putmsg = 1
    if (uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_VALIDATE=" has_validate
    print "HAS_PATTERN_INIT=" has_pattern_init
    print "HAS_INIT_RAST=" has_init_rast
    print "HAS_SETFONT=" has_setfont
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_PUTMSG=" has_putmsg
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}

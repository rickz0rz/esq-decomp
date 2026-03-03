BEGIN {
    has_entry = 0
    has_link = 0
    has_initbitmap = 0
    has_loop = 0
    has_alloc = 0
    has_bltclear = 0
    has_return_label = 0
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

    if (uline ~ /^ESQDISP_ALLOCATEHIGHLIGHTBITMAPS:/) has_entry = 1
    if (uline ~ /LINK\.W A5,#-4/) has_link = 1
    if (uline ~ /LVOINITBITMAP/) has_initbitmap = 1
    if (uline ~ /^\.ALLOC_PLANE_LOOP:/ || uline ~ /BRA(\.[A-Z]+)? \.ALLOC_PLANE_LOOP/) has_loop = 1
    if (uline ~ /ESQDISP_JMPTBL_GRAPHICS_ALLOCRASTER/) has_alloc = 1
    if (uline ~ /LVOBLTCLEAR/) has_bltclear = 1
    if (uline ~ /^ESQDISP_ALLOCATEHIGHLIGHTBITMAPS_RETURN:/) has_return_label = 1
    if (uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_INITBITMAP=" has_initbitmap
    print "HAS_LOOP=" has_loop
    print "HAS_ALLOC=" has_alloc
    print "HAS_BLTCLEAR=" has_bltclear
    print "HAS_RETURN_LABEL=" has_return_label
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}

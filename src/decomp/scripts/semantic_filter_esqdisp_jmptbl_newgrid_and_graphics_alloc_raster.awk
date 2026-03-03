BEGIN {
    has_newgrid_entry = 0
    has_newgrid_jmp = 0
    has_graphics_entry = 0
    has_graphics_jmp = 0
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

    if (uline ~ /^ESQDISP_JMPTBL_NEWGRID_PROCESSGRIDMESSAGES:/) has_newgrid_entry = 1
    if (uline ~ /JMP NEWGRID_PROCESSGRIDMESSAGES/) has_newgrid_jmp = 1
    if (uline ~ /^ESQDISP_JMPTBL_GRAPHICS_ALLOCRASTER:/) has_graphics_entry = 1
    if (uline ~ /JMP GRAPHICS_ALLOCRASTER/) has_graphics_jmp = 1
}

END {
    print "HAS_NEWGRID_ENTRY=" has_newgrid_entry
    print "HAS_NEWGRID_JMP=" has_newgrid_jmp
    print "HAS_GRAPHICS_ENTRY=" has_graphics_entry
    print "HAS_GRAPHICS_JMP=" has_graphics_jmp
}

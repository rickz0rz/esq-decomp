BEGIN {
    has_label = 0
    has_mem_dealloc = 0
    has_graphics_free_raster = 0
    has_close_font = 0
    has_close_library = 0
    has_loop_set1 = 0
    has_loop_set2 = 0
    has_loop_set3 = 0
    has_loop_set4 = 0
    has_stack_fix = 0
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

    if (uline ~ /^CLEANUP_RELEASEDISPLAYRESOURCES:/) has_label = 1
    if (uline ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/) has_mem_dealloc = 1
    if (uline ~ /GROUP_AB_JMPTBL_GRAPHICS_FREERASTER/) has_graphics_free_raster = 1
    if (uline ~ /LVOCLOSEFONT/) has_close_font = 1
    if (uline ~ /LVOCLOSELIBRARY/) has_close_library = 1
    if (uline ~ /^\\.FREERASTER_SET1_LOOP:/) has_loop_set1 = 1
    if (uline ~ /^\\.FREERASTER_SET2_LOOP:/) has_loop_set2 = 1
    if (uline ~ /^\\.FREERASTER_SET3_LOOP:/) has_loop_set3 = 1
    if (uline ~ /^\\.FREERASTER_SET4_LOOP:/) has_loop_set4 = 1
    if (uline ~ /MOVE.L \\(A7\\)\\+,D7/ || uline ~ /LEA 32\\(A7\\),A7/ || uline ~ /LEA 20\\(A7\\),A7/) has_stack_fix = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_MEM_DEALLOC=" has_mem_dealloc
    print "HAS_GRAPHICS_FREE_RASTER=" has_graphics_free_raster
    print "HAS_CLOSE_FONT=" has_close_font
    print "HAS_CLOSE_LIBRARY=" has_close_library
    print "HAS_LOOP_SET1=" has_loop_set1
    print "HAS_LOOP_SET2=" has_loop_set2
    print "HAS_LOOP_SET3=" has_loop_set3
    print "HAS_LOOP_SET4=" has_loop_set4
    print "HAS_STACK_FIX=" has_stack_fix
}

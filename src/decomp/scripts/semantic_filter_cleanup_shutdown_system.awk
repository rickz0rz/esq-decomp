BEGIN {
    has_label = 0
    has_forbid = 0
    has_permit = 0
    has_clear_vertb = 0
    has_clear_aud1 = 0
    has_clear_rbf = 0
    has_shutdown_input = 0
    has_release_display = 0
    has_newgrid_shutdown = 0
    has_free_brush = 0
    has_dealloc = 0
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

    if (uline ~ /^CLEANUP_SHUTDOWNSYSTEM:/) has_label = 1
    if (uline ~ /LVOFORBID/) has_forbid = 1
    if (uline ~ /LVOPERMIT/) has_permit = 1
    if (uline ~ /CLEANUP_CLEARVERTBINTERRUPTSERVER/) has_clear_vertb = 1
    if (uline ~ /CLEANUP_CLEARAUD1INTERRUPTVECTOR/) has_clear_aud1 = 1
    if (uline ~ /CLEANUP_CLEARRBFINTERRUPTANDSERIAL/) has_clear_rbf = 1
    if (uline ~ /CLEANUP_SHUTDOWNINPUTDEVICES/) has_shutdown_input = 1
    if (uline ~ /CLEANUP_RELEASEDISPLAYRESOURCES/) has_release_display = 1
    if (uline ~ /NEWGRID_SHUTDOWNGRIDRESOURCES/) has_newgrid_shutdown = 1
    if (uline ~ /BRUSH_FREEBRUSHLIST/) has_free_brush = 1
    if (uline ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/) has_dealloc = 1
    if (uline ~ /MOVEM.L \\(A7\\)\\+,D6-D7/ || uline ~ /ADDQ.W #4,A7/) has_stack_fix = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_FORBID=" has_forbid
    print "HAS_PERMIT=" has_permit
    print "HAS_CLEAR_VERTB=" has_clear_vertb
    print "HAS_CLEAR_AUD1=" has_clear_aud1
    print "HAS_CLEAR_RBF=" has_clear_rbf
    print "HAS_SHUTDOWN_INPUT=" has_shutdown_input
    print "HAS_RELEASE_DISPLAY=" has_release_display
    print "HAS_NEWGRID_SHUTDOWN=" has_newgrid_shutdown
    print "HAS_FREE_BRUSH=" has_free_brush
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_STACK_FIX=" has_stack_fix
}

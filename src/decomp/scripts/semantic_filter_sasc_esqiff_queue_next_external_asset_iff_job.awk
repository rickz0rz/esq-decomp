BEGIN {
    has_entry=0
    has_forbid=0
    has_permit=0
    has_task_done_gate=0
    has_logo_quota=0
    has_gads_quota=0
    has_read_next=0
    has_wildcard_rewrite=0
    has_find_sep=0
    has_find_wild=0
    has_compare_prefix=0
    has_alloc=0
    has_start_iff=0
    has_pending_ptr_write=0
    has_grid_idle=0
    has_return=0
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
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^ESQIFF_QUEUENEXTEXTERNALASSETIFFJOB:/ || u ~ /^ESQIFF_QUEUENEXTEXTERNALASSET[A-Z0-9_]*:/) has_entry=1
    if (n ~ /LVOFORBID/) has_forbid=1
    if (n ~ /LVOPERMIT/) has_permit=1
    if (n ~ /CTASKSIFFTASKDONEFLAG/) has_task_done_gate=1
    if (n ~ /ESQIFFLOGOBRUSHLISTCOUNT/) has_logo_quota=1
    if (n ~ /ESQIFFGADSBRUSHLISTCOUNT/) has_gads_quota=1
    if (n ~ /ESQIFFREADNEXTEXTERNALASSETPATHENTRY/ || n ~ /ESQIFFREADNEXTEXTERNALASSETPAT/) has_read_next=1
    if (u ~ /\#\$2A/ || u ~ /'\*'/ || n ~ /MOVEB42/) has_wildcard_rewrite=1
    if (n ~ /GCOMMANDFINDPATHSEPARATOR/ || n ~ /GCOMMANDFINDPATHSEPARATO/) has_find_sep=1
    if (n ~ /TEXTDISPFINDENTRYINDEXBYWILDCARD/ || n ~ /TEXTDISPFINDENTRYINDEXBYWIL/ || n ~ /TEXTDISPFINDENTRY/) has_find_wild=1
    if (n ~ /ESQIFFPATHDF0COLON/ || n ~ /ESQIFFPATHRAMCOLONLOGOSSLASH/ || n ~ /COMPAR_NO_CASEN/ || n ~ /STRINGCOMPAR/) has_compare_prefix=1
    if (n ~ /ALLOCBRUSHNODE/ || n ~ /ALLOCBRUSHNO/) has_alloc=1
    if (n ~ /CTASKSSTARTIFFTASKPROCESS/ || n ~ /STARTIFFTASKPROCESS/ || n ~ /STARTIFFTAS/) has_start_iff=1
    if (n ~ /CTASKSPENDINGLOGOBRUSHDESCRIPTOR/ || n ~ /CTASKSPENDINGGADSBRUSHDESCRIPTOR/ || n ~ /ESQIFFPENDINGEXTERNALBRUSHNODE/) has_pending_ptr_write=1
    if (n ~ /ESQDISPPROCESSGRIDMESSAGESIFIDLE/ || n ~ /ESQDISPPROCESSGRIDMESSAGESIFIDL/) has_grid_idle=1
    if (u ~ /^RTS$/) has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FORBID=" has_forbid
    print "HAS_PERMIT=" has_permit
    print "HAS_TASK_DONE_GATE=" has_task_done_gate
    print "HAS_LOGO_QUOTA=" has_logo_quota
    print "HAS_GADS_QUOTA=" has_gads_quota
    print "HAS_READ_NEXT=" has_read_next
    print "HAS_WILDCARD_REWRITE=" has_wildcard_rewrite
    print "HAS_FIND_SEPARATOR=" has_find_sep
    print "HAS_FIND_WILDCARD=" has_find_wild
    print "HAS_COMPARE_PREFIX=" has_compare_prefix
    print "HAS_ALLOC_BRUSH=" has_alloc
    print "HAS_START_IFF=" has_start_iff
    print "HAS_PENDING_PTR_WRITE=" has_pending_ptr_write
    print "HAS_GRID_IDLE_CALL=" has_grid_idle
    print "HAS_RETURN=" has_return
    print "HAS_RTS=" has_rts
}

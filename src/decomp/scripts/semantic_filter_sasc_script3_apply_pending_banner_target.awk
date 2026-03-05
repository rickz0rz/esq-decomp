BEGIN {
    has_entry = 0
    has_get_banner = 0
    has_begin_transition = 0
    has_pending_target = 0
    has_readmode_clear = 0
    has_return = 0
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

    if (u ~ /^SCRIPT_APPLYPENDINGBANNERTARGET:/) has_entry = 1
    if (index(u, "SCRIPT3_JMPTBL_GCOMMAND_GETBANNERCHAR") > 0 || index(u, "SCRIPT3_JMPTBL_GCOMMAND_GETBANNERC") > 0 || index(u, "SCRIPT3_JMPTBL_GCOMMAND_GETBANNE") > 0) has_get_banner = 1
    if (index(u, "SCRIPT_BEGINBANNERCHARTRANSITION") > 0 || index(u, "SCRIPT_BEGINBANNERCHARTR") > 0) has_begin_transition = 1
    if (index(u, "SCRIPT_PENDINGBANNERTARGETCHAR") > 0) has_pending_target = 1
    if (index(u, "ESQPARS2_READMODEFLAGS") > 0 || index(u, "SCRIPT_READMODEACTIVELATCH") > 0) has_readmode_clear = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GET_BANNER=" has_get_banner
    print "HAS_BEGIN_TRANSITION=" has_begin_transition
    print "HAS_PENDING_TARGET=" has_pending_target
    print "HAS_READMODE_CLEAR=" has_readmode_clear
    print "HAS_RETURN=" has_return
}

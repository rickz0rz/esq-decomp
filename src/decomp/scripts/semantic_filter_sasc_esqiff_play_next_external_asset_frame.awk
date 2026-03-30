BEGIN {
    has_entry = 0
    has_forbid = 0
    has_permit = 0
    has_pop_brush = 0
    has_show_fx = 0
    has_service_source = 0
    has_run_rise = 0
    has_run_drop = 0
    has_restore_palette = 0
    has_service_source_one = 0
    has_service_source_zero = 0
    has_return_tail = 0
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

    if (uline ~ /^ESQIFF_PLAYNEXTEXTERNALASSETFRAM/ ||
        uline ~ /^ESQIFF_PLAYNEXTEXTERNALASSETFRAME:/) has_entry = 1
    if (uline ~ /_LVOFORBID/) has_forbid = 1
    if (uline ~ /_LVOPERMIT/) has_permit = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_POPBRUSHHEAD/ ||
        uline ~ /BRUSH_POPBRUSHHEAD/) has_pop_brush = 1
    if (uline ~ /ESQIFF_SHOWEXTERNALASSETWITHCOPP/ ||
        uline ~ /ESQIFF_SHOWEXTERNALASSETWITHCOPPERFX/) has_show_fx = 1
    if (uline ~ /ESQIFF_SERVICEEXTERNALASSETSOURC/ ||
        uline ~ /ESQIFF_SERVICEEXTERNALASSETSOURCESTATE/) has_service_source = 1
    if (uline ~ /PEA \(\$1\)\.W/ || uline ~ /MOVEQ #1,D0/ || uline ~ /MOVE\.L #1,-\(A7\)/) {
        saw_one = 1
    }
    if (uline ~ /CLR\.L -\(A7\)/ || uline ~ /MOVEQ #0,D0/ || uline ~ /MOVE\.L #0,-\(A7\)/) {
        saw_zero = 1
    }
    if (has_service_source && saw_one) has_service_source_one = 1
    if (has_service_source && saw_zero) has_service_source_zero = 1
    if (uline ~ /ESQIFF_RUNCOPPERRISETRANSITION/) has_run_rise = 1
    if (uline ~ /ESQIFF_RUNCOPPERDROPTRANSITION/) has_run_drop = 1
    if (uline ~ /ESQIFF_RESTOREBASEPALETTETRIPLES/) has_restore_palette = 1
    if (uline ~ /^RTS$/ || uline ~ /ESQIFF_PLAYNEXTEXTERNALASSETFRAME_RETURN/) has_return_tail = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FORBID=" has_forbid
    print "HAS_PERMIT=" has_permit
    print "HAS_POP_BRUSH=" has_pop_brush
    print "HAS_SHOW_FX=" has_show_fx
    print "HAS_SERVICE_SOURCE=" has_service_source
    print "HAS_SERVICE_SOURCE_ONE=" has_service_source_one
    print "HAS_SERVICE_SOURCE_ZERO=" has_service_source_zero
    print "HAS_RUN_RISE=" has_run_rise
    print "HAS_RUN_DROP=" has_run_drop
    print "HAS_RESTORE_PALETTE=" has_restore_palette
    print "HAS_RETURN_TAIL=" has_return_tail
}

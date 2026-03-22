BEGIN {
    has_entry_label = 0
    target_dispatch_count = 0
    has_wrapper_exit = 0
}

function trim(s,    t) {
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

    if (u == "GROUP_AD_JMPTBL_ESQIFF_RUNCOPPERRISETRANSITION:") has_entry_label = 1
    if (u ~ /^(JMP|JSR|BSR|BSR\.[A-Z]|JBSR) ESQIFF_RUNCOPPERRISETRANSITION$/) target_dispatch_count += 1
    if (u == "RTS" || u ~ /^JMP ESQIFF_RUNCOPPERRISETRANSITION$/) has_wrapper_exit = 1
}

END {
    print "HAS_ENTRY_LABEL=" has_entry_label
    print "TARGET_DISPATCH_COUNT=" target_dispatch_count
    print "HAS_WRAPPER_EXIT=" has_wrapper_exit
}

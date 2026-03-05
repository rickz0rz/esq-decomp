BEGIN {
    has_entry = 0
    has_counter_init = 0
    has_compare_f4240 = 0
    has_counter_inc = 0
    has_loop_branch = 0
    has_cold_reboot = 0
    has_zero_return = 0
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

    if (u ~ /^LOCAVAIL2_DISPLAYALERTDELAYANDRE[A-Z0-9_]*:/) has_entry = 1

    if (u ~ /^MOVEQ(\.L)? #0,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$0,D[0-7]$/) has_counter_init = 1
    if (u ~ /^CMPI\.L #\$F4240,D[0-7]$/ || u ~ /^CMPI\.L #1000000,D[0-7]$/) has_compare_f4240 = 1
    if (u ~ /^ADDQ\.L #1,D[0-7]$/ || u ~ /^ADDQ\.L #\$1,D[0-7]$/) has_counter_inc = 1
    if (u ~ /^BRA\.[BSW] / || u ~ /^BGE\.[BSW] / || u ~ /^BLT\.[BSW] /) has_loop_branch = 1

    if (index(u, "GROUP_AZ_JMPTBL_ESQ_COLDREBOOT") > 0) has_cold_reboot = 1

    if (u ~ /^MOVEQ(\.L)? #0,D0$/ || u ~ /^MOVEQ(\.L)? #\$0,D0$/) has_zero_return = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_COUNTER_INIT=" has_counter_init
    print "HAS_COMPARE_F4240=" has_compare_f4240
    print "HAS_COUNTER_INC=" has_counter_inc
    print "HAS_LOOP_BRANCH=" has_loop_branch
    print "HAS_COLD_REBOOT=" has_cold_reboot
    print "HAS_ZERO_RETURN=" has_zero_return
    print "HAS_RETURN=" has_return
}

BEGIN {
    saw_dst_countdown = 0
    saw_clock_day_slot = 0
    saw_build_call = 0
    saw_return = 0
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

    if (u ~ /DST_PRIMARYCOUNTDOWN/) saw_dst_countdown = 1
    if (u ~ /CLOCK_DAYSLOTINDEX/) saw_clock_day_slot = 1
    if (u ~ /DATETIME_BUILDFROMBASEDAY/) saw_build_call = 1
    if (u ~ /^RTS$/) saw_return = 1
}

END {
    print "HAS_DST_PRIMARYCOUNTDOWN=" saw_dst_countdown
    print "HAS_CLOCK_DAYSLOTINDEX=" saw_clock_day_slot
    print "HAS_BUILDFROMBASEDAY_CALL=" saw_build_call
    print "HAS_RTS=" saw_return
}

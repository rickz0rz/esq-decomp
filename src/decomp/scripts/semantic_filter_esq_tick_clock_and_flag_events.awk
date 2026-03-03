BEGIN {
    has_second_field = 0
    has_minute_field = 0
    has_hour_field = 0
    has_doy_field = 0
    has_leap_field = 0
    has_trigger_globals = 0
    has_update_month_day_call = 0
    has_status3 = 0
    has_status4 = 0
    has_status5 = 0
    has_toggle_ampm = 0
    has_year_limit = 0
    has_rts = 0
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

    if (u ~ /12\(A0\)/ || u ~ /\(12,A0\)/) has_second_field = 1
    if (u ~ /10\(A0\)/ || u ~ /\(10,A0\)/) has_minute_field = 1
    if (u ~ /8\(A0\)/ || u ~ /\(8,A0\)/) has_hour_field = 1
    if (u ~ /16\(A0\)/ || u ~ /\(16,A0\)/) has_doy_field = 1
    if (u ~ /20\(A0\)/ || u ~ /\(20,A0\)/) has_leap_field = 1

    if (u ~ /CLOCK_MINUTETRIGGER30MINUSBASE/ || u ~ /CLOCK_MINUTETRIGGER60MINUSBASE/ || u ~ /CLOCK_MINUTETRIGGERBASEOFFSETPLUS30/ || u ~ /CLOCK_MINUTETRIGGERBASEOFFSET/) has_trigger_globals = 1
    if (u ~ /ESQ_UPDATEMONTHDAYFROMDAYOFYEAR/) has_update_month_day_call = 1
    if (u ~ /#3,D[0-7]/ || u ~ /MOVEQ #3,D[0-7]/) has_status3 = 1
    if (u ~ /#4,D[0-7]/ || u ~ /MOVEQ #4,D[0-7]/) has_status4 = 1
    if (u ~ /#5,D[0-7]/ || u ~ /MOVEQ #5,D[0-7]/) has_status5 = 1
    if (u ~ /EORI\.W #\$?FFFF,18\(A0\)/ || u ~ /EOR\.W #\$?FFFF,18\(A0\)/ || u ~ /EOR\.W #-1,18\(A0\)/ || u ~ /NOT\.W D[0-7]/ || u ~ /NOT\.W 18\(A0\)/) has_toggle_ampm = 1
    if (u ~ /#\$?16E/ || u ~ /#365/ || u ~ /#366/ || u ~ /#367/) has_year_limit = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SECOND_FIELD=" has_second_field
    print "HAS_MINUTE_FIELD=" has_minute_field
    print "HAS_HOUR_FIELD=" has_hour_field
    print "HAS_DOY_FIELD=" has_doy_field
    print "HAS_LEAP_FIELD=" has_leap_field
    print "HAS_TRIGGER_GLOBALS=" has_trigger_globals
    print "HAS_UPDATE_MONTH_DAY_CALL=" has_update_month_day_call
    print "HAS_STATUS3=" has_status3
    print "HAS_STATUS4=" has_status4
    print "HAS_STATUS5=" has_status5
    print "HAS_TOGGLE_AMPM=" has_toggle_ampm
    print "HAS_YEAR_LIMIT=" has_year_limit
    print "HAS_RTS=" has_rts
}

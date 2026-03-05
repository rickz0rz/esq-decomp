BEGIN {
    has_entry = 0
    has_day_index = 0
    has_month_index = 0
    has_day_value = 0
    has_year_value = 0
    has_sprintf = 0
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

    if (u ~ /^GENERATE_GRID_DATE_STRING:/) has_entry = 1
    if (index(u, "CLOCK_CURRENTDAYOFWEEKINDEX") > 0) has_day_index = 1
    if (index(u, "CLOCK_CURRENTMONTHINDEX") > 0) has_month_index = 1
    if (index(u, "CLOCK_CURRENTDAYOFMONTH") > 0) has_day_value = 1
    if (index(u, "CLOCK_CURRENTYEARVALUE") > 0) has_year_value = 1
    if (index(u, "PARSEINI_JMPTBL_WDISP_SPRINTF") > 0 || index(u, "PARSEINI_JMPTBL_WDISP_SPRI") > 0) has_sprintf = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DAY_INDEX=" has_day_index
    print "HAS_MONTH_INDEX=" has_month_index
    print "HAS_DAY_VALUE=" has_day_value
    print "HAS_YEAR_VALUE=" has_year_value
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_RETURN=" has_return
}

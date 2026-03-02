BEGIN {
    has_sprintf = 0
    has_day_idx = 0
    has_month_idx = 0
    has_day_tbl = 0
    has_month_tbl = 0
    has_day_num = 0
    has_year = 0
    has_fmt = 0
    has_terminal = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /PARSEINIJMPTBLWDISPSPRINTF/) has_sprintf = 1
    if (n ~ /CLOCKCURRENTDAYOFWEEKINDEX/) has_day_idx = 1
    if (n ~ /CLOCKCURRENTMONTHINDEX/) has_month_idx = 1
    if (n ~ /GLOBALJMPTBLDAYSOFWEEK/) has_day_tbl = 1
    if (n ~ /GLOBALJMPTBLMONTHS/) has_month_tbl = 1
    if (n ~ /CLOCKCURRENTDAYOFMONTH/) has_day_num = 1
    if (n ~ /CLOCKCURRENTYEARVALUE/) has_year = 1
    if (n ~ /GLOBALSTRGRIDDATEFORMATSTRING/) has_fmt = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_DAY_IDX=" has_day_idx
    print "HAS_MONTH_IDX=" has_month_idx
    print "HAS_DAY_TBL=" has_day_tbl
    print "HAS_MONTH_TBL=" has_month_tbl
    print "HAS_DAY_NUM=" has_day_num
    print "HAS_YEAR=" has_year
    print "HAS_FMT=" has_fmt
    print "HAS_TERMINAL=" has_terminal
}

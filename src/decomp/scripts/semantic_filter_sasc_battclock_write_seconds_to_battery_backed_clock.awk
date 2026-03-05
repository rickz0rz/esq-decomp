BEGIN {
    has_label = 0
    has_write = 0
    has_arg = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^BATTCLOCK_WRITESECONDSTOBATTERYBACKEDCLOCK[A-Z0-9_]*:/ || u ~ /^BATTCLOCK_WRITESECONDSTOBATTERYB[A-Z0-9_]*:/) has_label = 1
    if (u ~ /_LVOWRITEBATTCLOCK/) has_write = 1
    if (u ~ /8\(A7\),D0/ || u ~ /8\(A7\),D7/ || u ~ /MOVE\.L .*D0/ || u ~ /MOVE\.L .*D7/ || u ~ /20\(A7\),D0/ || u ~ /20\(A7\),D7/) has_arg = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_WRITE=" has_write
    print "HAS_ARG=" has_arg
    print "HAS_RETURN=" has_return
}

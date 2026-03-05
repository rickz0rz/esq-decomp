BEGIN { has_label = 0; has_read = 0; has_return = 0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^BATTCLOCK_GETSECONDSFROMBATTERYBACKEDCLOCK[A-Z0-9_]*:/ || u ~ /^BATTCLOCK_GETSECONDSFROMBATTERYB[A-Z0-9_]*:/) has_label = 1
    if (u ~ /_LVOREADBATTCLOCK/) has_read = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_READ=" has_read
    print "HAS_RETURN=" has_return
}

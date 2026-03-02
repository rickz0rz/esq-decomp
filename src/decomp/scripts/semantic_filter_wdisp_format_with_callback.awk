BEGIN {
    l=0; parse=0; cb=0; pct=0; rts=0
}

/^WDISP_FormatWithCallback:$/ { l=1 }
/FORMAT_ParseFormatSpec/ { parse=1 }
/JSR[[:space:]]+\([Aa][0-7]\)|out_fn/ { cb=1 }
/#37|'%'/ { pct=1 }
/^RTS$/ { rts=1 }

END {
    if (l) print "HAS_LABEL"
    if (parse) print "HAS_PARSE_CALL"
    if (cb) print "HAS_CALLBACK_CALL"
    if (pct) print "HAS_PERCENT_CHECK"
    if (rts) print "HAS_RTS"
}

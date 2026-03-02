BEGIN {
    label=0; call=0; rts=0
}

/^DST_WriteRtcFromGlobals:$/ { label=1 }
/GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals/ { call=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (call) print "HAS_PARSEINI_RTC_CALL"
    if (rts) print "HAS_RTS"
}

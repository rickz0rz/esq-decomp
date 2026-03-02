BEGIN {
    label=0; src=0; sub36=0; phase_w=0; pcount=0; scount=0; dec=0; plus=0; rts=0
}

/^DST_TickBannerCounters:$/ { label=1 }
/ESQ_STR_6/ { src=1 }
/#\$36|#54|-54|-55/ { sub36=1 }
/WDISP_BannerCharPhaseShift/ { phase_w=1 }
/DST_PrimaryCountdown/ { pcount=1 }
/DST_SecondaryCountdown/ { scount=1 }
/^SUBQ\.W[[:space:]]+#1,[dD][0-7]$|^SUBI\.W[[:space:]]+#\$36,[dD][0-7]$|^ADD\.W[[:space:]]+#-5[45],[dD][0-7]$/ { dec=1 }
/^ADDQ\.W[[:space:]]+#1,[dD][0-7]$|^ADDQ\.W[[:space:]]+#1,_WDISP_BannerCharPhaseShift$/ { plus=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (src) print "HAS_SOURCE_CHAR"
    if (sub36) print "HAS_SUB_36"
    if (phase_w) print "HAS_PHASE_WRITE"
    if (pcount) print "HAS_PRIMARY_CHECK"
    if (scount) print "HAS_SECONDARY_CHECK"
    if (dec) print "HAS_DECREMENT_LOGIC"
    if (plus) print "HAS_INCREMENT_LOGIC"
    if (rts) print "HAS_RTS"
}

BEGIN {
    label=0; call=0; zeroarg=0; outword=0; ret=0
}

/^DST_BuildBannerTimeWord:$/ { label=1 }
/DST_BuildBannerTimeEntry/ { call=1 }
/^CLR\.L[[:space:]]+-\(A7\)$|^MOVE\.L[[:space:]]+#0,-\(A7\)$|^MOVE\.L[[:space:]]+#0,[dD][0-7]$|^CLR\.L[[:space:]]+-\(sp\)$/ { zeroarg=1 }
/-2\(A5\)|\(.*\),[dD]0$|MOVE\.W.*,[dD]0/ { outword=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (call) print "HAS_BUILD_ENTRY_CALL"
    if (zeroarg) print "HAS_ZERO_ARG"
    if (outword) print "HAS_OUTWORD_RETURN"
    if (ret) print "HAS_RTS"
}

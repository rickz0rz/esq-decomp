BEGIN {
    label=0; build_call=0; div_call=0; c12=0; cmp29=0; c26=0; div48=0; add1=0; ret=0
}

/^DST_ComputeBannerIndex:$/ { label=1 }
/DST_BuildBannerTimeEntry/ { build_call=1 }
/GROUP_AG_JMPTBL_MATH_DivS32|DST_ModByDivS32Helper/ { div_call=1 }
/#12|12\.w/ { c12=1 }
/#\$1d|#29|29\.w/ { cmp29=1 }
/#\$26|#38|38\.w/ { c26=1 }
/#\$30|#48|48\.w|DST_RemS16Div48|DIVS/ { div48=1 }
/^ADDQ\.W[[:space:]]+#1,[dD][0-7]$|^ADDQ\.L[[:space:]]+#1,[dD][0-7]$/ { add1=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (build_call) print "HAS_BUILD_ENTRY_CALL"
    if (div_call) print "HAS_MONTH_DIV_CALL"
    if (c12) print "HAS_CONST_12"
    if (cmp29) print "HAS_DAY_GT_29_TEST"
    if (c26) print "HAS_CONST_26"
    if (div48) print "HAS_DIV_48_FOLD"
    if (add1) print "HAS_FINAL_ADD1"
    if (ret) print "HAS_RTS"
}

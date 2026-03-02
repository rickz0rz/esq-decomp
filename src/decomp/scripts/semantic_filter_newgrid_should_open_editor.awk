BEGIN {
    label=0; skip3=0; btst5=0; offs19=0; offs1=0; offs27=0; c0=0; c1=0; rts=0
}

/^NEWGRID_ShouldOpenEditor:$/ { label=1 }
/NEWGRID2_JMPTBL_STR_SkipClass3Chars/ { skip3=1 }
/BTST[[:space:]]+#5|\bBTST\b.*#\$05|LSR\.[LW][[:space:]]+#5/ { btst5=1 }
/\(19,|19\(A3\)|\+19/ { offs19=1 }
/\(1,|1\(A3\)|\+1/ { offs1=1 }
/27\(A3\)|\+27|\(27,/ { offs27=1 }
/#\$00|#0([^0-9]|$)|\bCLR\./ { c0=1 }
/#\$01|#1([^0-9]|$)|1\.[Ww]/ { c1=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (skip3) print "HAS_SKIPCLASS3_CALL"
    if (btst5) print "HAS_BTST_5"
    if (offs19) print "HAS_OFFSET_19"
    if (offs1) print "HAS_OFFSET_1"
    if (offs27) print "HAS_OFFSET_27"
    if (c0) print "HAS_CONST_0"
    if (c1) print "HAS_CONST_1"
    if (rts) print "HAS_RTS"
}

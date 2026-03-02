BEGIN {
    label=0; parse=0; addoff=0; c12=0; c5=0; c39=0; c38=0; c24=0; c30=0; cffe2=0; out0=0; out1=0; ret=0
}

/^TLIBA2_ComputeBroadcastTimeWindow:$/ { label=1 }
/TLIBA2_ParseEntryTimeWindow/ { parse=1 }
/TLIBA2_JMPTBL_DST_AddTimeOffset|DST_AddTimeOffset/ { addoff=1 }
/#\$0c|#12([^0-9]|$)|12\.[Ww]/ { c12=1 }
/#\$05|#5([^0-9]|$)|5\.[Ww]/ { c5=1 }
/#\$27|#39([^0-9]|$)|39\.[Ww]|#-39/ { c39=1 }
/#\$26|#38([^0-9]|$)|38\.[Ww]/ { c38=1 }
/#\$18|#24([^0-9]|$)|24\.[Ww]/ { c24=1 }
/#\$1e|#30([^0-9]|$)|30\.[Ww]/ { c30=1 }
/#\$ffe2|#65506|#-30/ { cffe2=1 }
/\(A2\)|\([aA][0-7]\)/ { out0=1 }
/4\(A2\)|\(4,[aA][0-7]\)/ { out1=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (parse) print "HAS_PARSE_CALL"
    if (addoff) print "HAS_ADD_TIME_OFFSET_CALL"
    if (c12) print "HAS_CONST_12"
    if (c5) print "HAS_CONST_5"
    if (c39) print "HAS_CONST_39"
    if (c38) print "HAS_CONST_38"
    if (c24) print "HAS_CONST_24"
    if (c30) print "HAS_CONST_30"
    if (cffe2) print "HAS_CONST_FFE2"
    if (out0) print "HAS_OUT0_WRITE"
    if (out1) print "HAS_OUT1_WRITE"
    if (ret) print "HAS_RTS"
}

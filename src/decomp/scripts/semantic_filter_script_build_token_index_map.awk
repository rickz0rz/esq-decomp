BEGIN {
    label=0; minus1=0; termcmp=0; zeroclear=0; loop=0; rts=0
}

/^SCRIPT_BuildTokenIndexMap:$/ { label=1 }
/#-1|\(-1\)/ { minus1=1 }
/CMP\.B .*D5|terminator|CMP\.B/ { termcmp=1 }
/CLR\.B/ { zeroclear=1 }
/CMP\.W|BGE|BRA|ADDQ\.W #1/ { loop=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (minus1) print "HAS_MINUS1_SENTINEL"
    if (termcmp) print "HAS_TERMINATOR_COMPARE"
    if (zeroclear) print "HAS_INPUT_CLEAR"
    if (loop) print "HAS_LOOP_FLOW"
    if (rts) print "HAS_RTS"
}

BEGIN {
    label=0; gridready=0; selectnext=0; force5=0; cyc=0;
    c13=0; c11=0; c5=0; c4=0; c3=0; c2=0; c1=0; c0=0; rts=0
}

/^NEWGRID_MapSelectionToMode:$/ { label=1 }
/NEWGRID_IsGridReadyForInput/ { gridready=1 }
/NEWGRID_SelectNextMode/ { selectnext=1 }
/GCOMMAND_NicheForceMode5Flag/ { force5=1 }
/GCOMMAND_NicheModeCycleCount/ { cyc=1 }
/#\$0d|#13([^0-9]|$)|13\.[Ww]/ { c13=1 }
/#\$0b|#11([^0-9]|$)|11\.[Ww]/ { c11=1 }
/#\$05|#5([^0-9]|$)|5\.[Ww]/ { c5=1 }
/#\$04|#4([^0-9]|$)|4\.[Ww]/ { c4=1 }
/#\$03|#3([^0-9]|$)|3\.[Ww]/ { c3=1 }
/#\$02|#2([^0-9]|$)|2\.[Ww]/ { c2=1 }
/#\$01|#1([^0-9]|$)|1\.[Ww]/ { c1=1 }
/#\$00|#0([^0-9]|$)|\bCLR\./ { c0=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (gridready) print "HAS_GRIDREADY_CALL"
    if (selectnext) print "HAS_SELECTNEXT_CALL"
    if (force5) print "HAS_FORCE5_GLOBAL"
    if (cyc) print "HAS_CYCLECOUNT_GLOBAL"
    if (c13) print "HAS_CONST_13"
    if (c11) print "HAS_CONST_11"
    if (c5) print "HAS_CONST_5"
    if (c4) print "HAS_CONST_4"
    if (c3) print "HAS_CONST_3"
    if (c2) print "HAS_CONST_2"
    if (c1) print "HAS_CONST_1"
    if (c0) print "HAS_CONST_0"
    if (rts) print "HAS_RTS"
}

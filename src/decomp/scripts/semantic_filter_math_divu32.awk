BEGIN {
    label=0; save_d2=0; save_d3=0; divu=0; mulu=0; shifts=0; adjust=0; finalize=0; exg=0; restore=0; rts=0
}

/^MATH_DivU32:$/ { label=1 }
/^MOVE\.L[[:space:]]+D2,-\(A7\)$/ { save_d2=1 }
/^MOVE\.L[[:space:]]+D3,-\(A7\)$/ { save_d3=1 }
/^DIVU[[:space:]]+/ { divu++ }
/^MULU[[:space:]]+/ { mulu=1 }
/^ROL\.L[[:space:]]+#8,D1$|^ROL\.L[[:space:]]+#4,D1$|^ROL\.L[[:space:]]+#2,D1$|^ROL\.L[[:space:]]+#1,D1$|^LSR\.L[[:space:]]+D3,D0$|^LSR\.L[[:space:]]+D3,D2$/ { shifts++ }
/^\.adjust_loop:$/ { adjust=1 }
/^\.div_finalize:$/ { finalize=1 }
/^EXG[[:space:]]+D0,D1$/ { exg=1 }
/^MOVE\.L[[:space:]]+\(A7\)\+,D3$|^MOVE\.L[[:space:]]+\(A7\)\+,D2$/ { restore++ }
/^RTS$/ { rts++ }

END {
    if (label) print "HAS_LABEL"
    if (save_d2) print "HAS_SAVE_D2"
    if (save_d3) print "HAS_SAVE_D3"
    if (divu >= 3) print "HAS_DIVU_CORE"
    if (mulu) print "HAS_MULU_CORE"
    if (shifts >= 6) print "HAS_SHIFT_NORMALIZE"
    if (adjust) print "HAS_ADJUST_LOOP"
    if (finalize) print "HAS_FINALIZE_BLOCK"
    if (exg) print "HAS_EXG_RETURN"
    if (restore >= 2) print "HAS_RESTORE_CORE"
    if (rts >= 2) print "HAS_RTS_PATHS"
}

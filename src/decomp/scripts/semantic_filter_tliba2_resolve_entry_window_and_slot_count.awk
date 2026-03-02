BEGIN {
    label=0; flast=0; parse=0; bit=0; wild=0; divs=0; mulu=0;
    c34=0; c40=0; c41=0; c58=0; c49=0; c30=0; c2=0; ret=0
}

/^TLIBA2_ResolveEntryWindowAndSlotCount:$/ { label=1 }
/TLIBA2_FindLastCharInString/ { flast=1 }
/PARSE_ReadSignedLongSkipClass3_Alt/ { parse=1 }
/TLIBA2_JMPTBL_ESQ_TestBit1Based|ESQ_TestBit1Based/ { bit=1 }
/TLIBA_FindFirstWildcardMatchIndex/ { wild=1 }
/MATH_DivS32/ { divs=1 }
/MATH_Mulu32/ { mulu=1 }
/#\$22|#34|34\.[Ww]/ { c34=1 }
/#\$28|#40|40\.[Ww]/ { c40=1 }
/#\$29|#41|41\.[Ww]/ { c41=1 }
/#\$3a|#58|58\.[Ww]/ { c58=1 }
/#\$31|#49|49\.[Ww]/ { c49=1 }
/#\$1e|#30|30\.[Ww]/ { c30=1 }
/#\$02|#2([^0-9]|$)|2\.[Ww]/ { c2=1 }
/^RTS$/ { ret=1 }

END {
    if (label) print "HAS_LABEL"
    if (flast) print "HAS_FIND_LAST_CALL"
    if (parse) print "HAS_PARSE_LONG_CALL"
    if (bit) print "HAS_TEST_BIT_CALL"
    if (wild) print "HAS_WILDCARD_CALL"
    if (divs) print "HAS_DIVS_CALL"
    if (mulu) print "HAS_MULU_CALL"
    if (c34) print "HAS_CONST_34"
    if (c40) print "HAS_CONST_40"
    if (c41) print "HAS_CONST_41"
    if (c58) print "HAS_CONST_58"
    if (c49) print "HAS_CONST_49"
    if (c30) print "HAS_CONST_30"
    if (c2) print "HAS_CONST_2"
    if (ret) print "HAS_RTS"
}

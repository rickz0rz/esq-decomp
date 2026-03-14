BEGIN {
    label=0; copypad=0; parse=0; freec=0; allocc=0; primary=0; secondary=0; one=0; zero=0; rts=0
}

/^P_TYPE_ParseAndStoreTypeRecord:$/ { label=1 }
/SCRIPT3_JMPTBL_STRING_CopyPadNul|STRING_CopyPadNul/ { copypad=1 }
/SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt|PARSE_ReadSignedLongSkipClass3/ { parse=1 }
/P_TYPE_FreeEntry/ { freec=1 }
/P_TYPE_AllocateEntry/ { allocc=1 }
/TEXTDISP_PrimaryGroupCode|P_TYPE_PrimaryGroupListPtr/ { primary=1 }
/TEXTDISP_SecondaryGroupCode|P_TYPE_SecondaryGroupListPtr/ { secondary=1 }
/#\$?1([^0-9A-Fa-f]|$)|MOVEQ(\.[A-Z])? #\$?1/ { one=1 }
/#\$?0([^0-9A-Fa-f]|$)|MOVEQ(\.[A-Z])? #\$?0|CLR\./ { zero=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (copypad) print "HAS_COPYPAD_CALL"
    if (parse) print "HAS_PARSE_CALL"
    if (freec) print "HAS_FREE_CALL"
    if (allocc) print "HAS_ALLOC_CALL"
    if (primary) print "HAS_PRIMARY_FLOW"
    if (secondary) print "HAS_SECONDARY_FLOW"
    if (one) print "HAS_CONST_1"
    if (zero) print "HAS_CONST_0"
    if (rts) print "HAS_RTS"
}

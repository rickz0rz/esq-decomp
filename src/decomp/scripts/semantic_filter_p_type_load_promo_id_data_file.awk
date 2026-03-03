BEGIN {
    label=0; loadf=0; find=0; parse=0; alloc=0; freef=0; dealloc=0; class_tbl=0; c406=0; one=0; rts=0
}

/^P_TYPE_LoadPromoIdDataFile:$/ { label=1 }
/PARSEINI_JMPTBL_DISKIO_LoadFileToWorkBuffer/ { loadf=1 }
/P_TYPE_JMPTBL_STRING_FindSubstring/ { find=1 }
/SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt/ { parse=1 }
/P_TYPE_AllocateEntry/ { alloc=1 }
/P_TYPE_FreeEntry/ { freef=1 }
/SCRIPT_JMPTBL_MEMORY_DeallocateMemory/ { dealloc=1 }
/WDISP_CharClassTable/ { class_tbl=1 }
/#406([^0-9]|$)|#\$196|406\.[Ww]/ { c406=1 }
/#1([^0-9]|$)|MOVEQ #1/ { one=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (loadf) print "HAS_LOAD_CALL"
    if (find) print "HAS_FIND_CALL"
    if (parse) print "HAS_PARSE_CALL"
    if (alloc) print "HAS_ALLOC_CALL"
    if (freef) print "HAS_FREE_CALL"
    if (dealloc) print "HAS_DEALLOC_CALL"
    if (class_tbl) print "HAS_CHARCLASS_TABLE"
    if (c406) print "HAS_CONST_406"
    if (one) print "HAS_CONST_1"
    if (rts) print "HAS_RTS"
}

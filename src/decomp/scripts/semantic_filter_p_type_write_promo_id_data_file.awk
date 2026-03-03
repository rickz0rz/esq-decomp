BEGIN {
    label=0; openf=0; writef=0; closef=0; sprintf_call=0; nodata=0; mode=0; len9=0; rts=0
}

/^P_TYPE_WritePromoIdDataFile:$/ { label=1 }
/SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer/ { openf=1 }
/SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes/ { writef=1 }
/SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush/ { closef=1 }
/PARSEINI_JMPTBL_WDISP_SPrintf/ { sprintf_call=1 }
/P_TYPE_STR_NO_DATA/ { nodata=1 }
/#1006([^0-9]|$)|#\$3ee|1006\.[Ww]/ { mode=1 }
/#9([^0-9]|$)|#\$09|9\.[Ww]/ { len9=1 }
/^RTS$/ { rts=1 }

END {
    if (label) print "HAS_LABEL"
    if (openf) print "HAS_OPEN_CALL"
    if (writef) print "HAS_WRITE_CALL"
    if (closef) print "HAS_CLOSE_CALL"
    if (sprintf_call) print "HAS_SPRINTF_CALL"
    if (nodata) print "HAS_NO_DATA_CONST"
    if (mode) print "HAS_MODE_1006"
    if (len9) print "HAS_CONST_9"
    if (rts) print "HAS_RTS"
}

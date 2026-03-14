BEGIN {
    label=0; openf=0; writef=0; closef=0; sprintf_call=0; nodata=0; mode=0; len9=0; rts=0
}

/^P_TYPE_WritePromoIdDataFile:$/ { label=1 }
/SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer|SCRIPT_JMPTBL_DISKIO_OpenFileWit/ { openf=1 }
/SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes|SCRIPT_JMPTBL_DISKIO_WriteBuffer/ { writef=1 }
/SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush|SCRIPT_JMPTBL_DISKIO_CloseBuffer/ { closef=1 }
/PARSEINI_JMPTBL_WDISP_SPrintf/ { sprintf_call=1 }
/P_TYPE_STR_NO_DATA/ { nodata=1 }
/#1006([^0-9]|$)|#\$03?[Ee][Ee]|1006\.[Ww]|\(\$3ee\)\.[Ww]/ { mode=1 }
/#9([^0-9]|$)|#\$09|9\.[Ww]|\(\$9\)\.[Ww]/ { len9=1 }
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

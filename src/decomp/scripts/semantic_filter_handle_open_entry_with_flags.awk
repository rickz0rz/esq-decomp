BEGIN {
    l=0; op=0; opnew=0; del=0; cls=0; ioerr=0; app=0; tbl=0; rts=0
}

/^HANDLE_OpenEntryWithFlags:$/ { l=1 }
/DOS_OpenWithErrorState/ { op=1 }
/DOS_OpenNewFileIfMissing/ { opnew=1 }
/DOS_DeleteAndRecreateFile/ { del=1 }
/DOS_CloseWithSignalCheck/ { cls=1 }
/Global_DosIoErr/ { ioerr=1 }
/Global_AppErrorCode/ { app=1 }
/Global_HandleTableCount|Global_HandleTableBase|Global_HandleTableFlags/ { tbl=1 }
/^RTS$/ { rts=1 }

END {
    if (l) print "HAS_LABEL"
    if (op) print "HAS_OPEN_CALL"
    if (opnew) print "HAS_OPENNEW_CALL"
    if (del) print "HAS_DELETE_RECREATE_CALL"
    if (cls) print "HAS_CLOSE_CALL"
    if (ioerr) print "HAS_DOSIOERR"
    if (app) print "HAS_APPERR"
    if (tbl) print "HAS_TABLE_SCAN"
    if (rts) print "HAS_RTS"
}

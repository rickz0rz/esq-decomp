BEGIN {
    l=0; find=0; write=0; open=0; call348=0; msg=0; out=0; rts=0
}

/^UNKNOWN36_ShowAbortRequester:$/ { l=1 }
/_LVOFindTask|AbsExecBase|exec_find_task_null/ { find=1 }
/_LVOWrite|dos_write|kBreakPrefix|UNKNOWN36_STR_BreakPrefix/ { write=1 }
/_LVOOpenLibrary|exec_open_library|kIntuitionLib|UNKNOWN36_STR_IntuitionLibrary/ { open=1 }
/EXEC_CallVector_348/ { call348=1 }
/Global_UNKNOWN36_MessagePtr/ { msg=1 }
/Global_UNKNOWN36_RequesterOutPtr/ { out=1 }
/^RTS$/ { rts=1 }

END {
    if (l) print "HAS_LABEL"
    if (find) print "HAS_FINDTASK_PATH"
    if (write) print "HAS_WRITE_PATH"
    if (open) print "HAS_OPENLIB_PATH"
    if (call348) print "HAS_EXEC348_CALL"
    if (msg) print "HAS_MESSAGE_PTR"
    if (out) print "HAS_REQUESTER_OUT_PTR"
    if (rts) print "HAS_RTS"
}

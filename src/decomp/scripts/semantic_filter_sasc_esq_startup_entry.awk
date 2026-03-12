BEGIN {
    has_buffer_ref = 0
    has_saved_stack_ref = 0
    has_saved_exec_ref = 0
    has_saved_msg_ref = 0
    has_dos_library_ref = 0
    has_saved_dir_ref = 0
    has_cmdline_size_ref = 0
    has_scratch_ptr_ref = 0
    has_wb_window_ref = 0
    has_wb_cmd_buf_ref = 0

    has_setsignal_call = 0
    has_openlibrary_call = 0
    has_shutdown_call = 0
    has_waitport_call = 0
    has_getmsg_call = 0
    has_currentdir_call = 0
    has_supervisor_call = 0
    has_main_entry_call = 0
    has_parse_call = 0
    has_clear_count = 0
    has_signal_mask = 0
    has_exit_100 = 0
    has_plus_128 = 0
    has_supervisor_1005 = 0
    has_dos_string = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /BUFFER_5929_LONGWORDS/) has_buffer_ref = 1
    if (u ~ /GLOBAL_SAVEDSTACKPOINTER/) has_saved_stack_ref = 1
    if (u ~ /GLOBAL_SAVEDEXECBASE/) has_saved_exec_ref = 1
    if (u ~ /GLOBAL_SAVEDMSG/) has_saved_msg_ref = 1
    if (u ~ /GLOBAL_DOSLIBRARY/) has_dos_library_ref = 1
    if (u ~ /GLOBAL_SAVEDDIRLOCK/) has_saved_dir_ref = 1
    if (u ~ /GLOBAL_COMMANDLINESIZE/) has_cmdline_size_ref = 1
    if (u ~ /GLOBAL_SCRATCHPTR_592/) has_scratch_ptr_ref = 1
    if (u ~ /GLOBAL_WBSTARTUPWINDOWPTR/) has_wb_window_ref = 1
    if (u ~ /GLOBAL_WBSTARTUPCMDBUFFER/) has_wb_cmd_buf_ref = 1

    if (u ~ /_LVOSETSIGNAL/ || u ~ /LVOSETSIGNAL/) has_setsignal_call = 1
    if (u ~ /_LVOOPENLIBRARY/ || u ~ /LVOOPENLIBRARY/) has_openlibrary_call = 1
    if (u ~ /ESQ_SHUTDOWNANDRETURN/) has_shutdown_call = 1
    if (u ~ /_LVOWAITPORT/ || u ~ /LVOWAITPORT/) has_waitport_call = 1
    if (u ~ /_LVOGETMSG/ || u ~ /LVOGETMSG/) has_getmsg_call = 1
    if (u ~ /_LVOCURRENTDIR/ || u ~ /LVOCURRENTDIR/) has_currentdir_call = 1
    if (u ~ /_LVOSUPERVISOR/ || u ~ /LVOSUPERVISOR/) has_supervisor_call = 1
    if (u ~ /GROUP_MAIN_A_JMPTBL_ESQ_MAINENTR/ || u ~ /ESQ_MAINENTRYNOOPHOOK/) has_main_entry_call = 1
    if (u ~ /GROUP_MAIN_A_JMPTBL_ESQ_PARSECOM/ || u ~ /GROUP_MAIN_A_JMPTBL_ESQ_PARSECOMMANDLINEANDRUN/ || u ~ /ESQ_PARSECOMMANDLINEANDRUN/) has_parse_call = 1

    if (u ~ /#5929/ || u ~ /#\$1728/ || u ~ /MOVE\.L #5929,D0/ || u ~ /CMPI\.L #\$1728,D6/) has_clear_count = 1
    if (u ~ /3000/) has_signal_mask = 1
    if (u ~ /#100/ || u ~ /\$64/ || u ~ /0064/) has_exit_100 = 1
    if (u ~ /#128/ || u ~ /#\$80/ || u ~ /ADDI\.L #128,D0/ || u ~ /MOVEQ\.L #\$40,D0/ || u ~ /MOVEQ #127,D0/) has_plus_128 = 1
    if (u ~ /1005/ || u ~ /3ED/) has_supervisor_1005 = 1
    if (u ~ /DOS\\.LIBRARY/ || u ~ /__MERGED/ || u ~ /ESQ_STR_DOSLIBRARY/) has_dos_string = 1
}

END {
    print "HAS_BUFFER_REF=" has_buffer_ref
    print "HAS_SAVED_STACK_REF=" has_saved_stack_ref
    print "HAS_SAVED_EXEC_REF=" has_saved_exec_ref
    print "HAS_SAVED_MSG_REF=" has_saved_msg_ref
    print "HAS_DOS_LIBRARY_REF=" has_dos_library_ref
    print "HAS_SAVED_DIR_REF=" has_saved_dir_ref
    print "HAS_CMDLINE_SIZE_REF=" has_cmdline_size_ref
    print "HAS_SCRATCH_PTR_REF=" has_scratch_ptr_ref
    print "HAS_WB_WINDOW_REF=" has_wb_window_ref
    print "HAS_WB_CMD_BUF_REF=" has_wb_cmd_buf_ref

    print "HAS_SETSIGNAL_CALL=" has_setsignal_call
    print "HAS_OPENLIBRARY_CALL=" has_openlibrary_call
    print "HAS_SHUTDOWN_CALL=" has_shutdown_call
    print "HAS_WAITPORT_CALL=" has_waitport_call
    print "HAS_GETMSG_CALL=" has_getmsg_call
    print "HAS_CURRENTDIR_CALL=" has_currentdir_call
    print "HAS_SUPERVISOR_CALL=" has_supervisor_call
    print "HAS_MAIN_ENTRY_CALL=" has_main_entry_call
    print "HAS_PARSE_CALL=" has_parse_call

    print "HAS_CLEAR_COUNT=" has_clear_count
    print "HAS_SIGNAL_MASK=" has_signal_mask
    print "HAS_EXIT_100=" has_exit_100
    print "HAS_PLUS_128=" has_plus_128
    print "HAS_SUPERVISOR_1005=" has_supervisor_1005
    print "HAS_DOS_STRING=" has_dos_string
}

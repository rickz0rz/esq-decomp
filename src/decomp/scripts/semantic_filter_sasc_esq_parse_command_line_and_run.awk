BEGIN {
    has_argcount_ref = 0
    has_argcount_limit32 = 0
    has_argv_storage_ref = 0
    has_argv_ptr_ref = 0
    has_saved_msg_ref = 0
    has_console_buf_ref = 0
    has_doslib_ref = 0

    has_handle0_ptr_ref = 0
    has_handle1_ptr_ref = 0
    has_handle2_ptr_ref = 0
    has_handle0_flags_ref = 0
    has_handle1_flags_ref = 0
    has_handle2_flags_ref = 0

    has_default_flags_ref = 0
    has_node0_ref = 0
    has_node1_ref = 0
    has_node2_ref = 0
    has_signal_callback_ref = 0

    has_closeall_call = 0
    has_appendn_call = 0
    has_maininit_call = 0
    has_flush_call = 0
    has_open_call = 0
    has_input_call = 0
    has_output_call = 0
    has_findtask_call = 0
    has_open_mode_newfile = 0
    has_open_mode_oldfile = 0
    has_findtask_prwindow_store = 0

    has_space_const = 0
    has_tab_const = 0
    has_nl_const = 0
    has_compact_tabnl = 0
    has_quote_const = 0
    has_maxlen40_const = 0
    has_console_prefix = 0
    has_star_string = 0
    has_savedmsg_argrecord = 0
    has_handle_flag16_seed = 0
    has_flag8000_family = 0
    has_flag80_const = 0
    has_node_index012 = 0
    has_rts = 0
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

    if (u ~ /GLOBAL_ARGCOUNT/) has_argcount_ref = 1
    if (u ~ /CMPI\.L #\$20,GLOBAL_ARGCOUNT/ || u ~ /CMPI\.L #' ',GLOBAL_ARGCOUNT/) has_argcount_limit32 = 1
    if (u ~ /GLOBAL_ARGVSTORAGE/) has_argv_storage_ref = 1
    if (u ~ /GLOBAL_ARGVPTR/) has_argv_ptr_ref = 1
    if (u ~ /GLOBAL_SAVEDMSG/) has_saved_msg_ref = 1
    if (u ~ /GLOBAL_CONSOLENAMEBUFFER/) has_console_buf_ref = 1
    if (u ~ /GLOBAL_DOSLIBRARY/) has_doslib_ref = 1

    if (u ~ /GLOBAL_HANDLEENTRY0_PTR/) has_handle0_ptr_ref = 1
    if (u ~ /GLOBAL_HANDLEENTRY1_PTR/) has_handle1_ptr_ref = 1
    if (u ~ /GLOBAL_HANDLEENTRY2_PTR/) has_handle2_ptr_ref = 1
    if (u ~ /GLOBAL_HANDLEENTRY0_FLAGS/) has_handle0_flags_ref = 1
    if (u ~ /GLOBAL_HANDLEENTRY1_FLAGS/) has_handle1_flags_ref = 1
    if (u ~ /GLOBAL_HANDLEENTRY2_FLAGS/) has_handle2_flags_ref = 1

    if (u ~ /GLOBAL_DEFAULTHANDLEFLAGS/) has_default_flags_ref = 1
    if (u ~ /GLOBAL_PREALLOCHANDLENODE0_HANDLEINDEX/ || u ~ /GLOBAL_PREALLOCHANDLENODE0_OPENFLAGS/ || u ~ /GLOBAL_PREALLOCHANDLENODE0_HANDL/ || u ~ /GLOBAL_PREALLOCHANDLENODE0_OPENF/) has_node0_ref = 1
    if (u ~ /GLOBAL_PREALLOCHANDLENODE1_HANDLEINDEX/ || u ~ /GLOBAL_PREALLOCHANDLENODE1_OPENFLAGS/ || u ~ /GLOBAL_PREALLOCHANDLENODE1_HANDL/ || u ~ /GLOBAL_PREALLOCHANDLENODE1_OPENF/) has_node1_ref = 1
    if (u ~ /GLOBAL_PREALLOCHANDLENODE2_HANDLEINDEX/ || u ~ /GLOBAL_PREALLOCHANDLENODE2_OPENFLAGS/ || u ~ /GLOBAL_PREALLOCHANDLENODE2_HANDL/ || u ~ /GLOBAL_PREALLOCHANDLENODE2_OPENF/) has_node2_ref = 1
    if (u ~ /GLOBAL_SIGNALCALLBACKPTR/) has_signal_callback_ref = 1

    if (u ~ /HANDLE_CLOSEALLANDRETURNWITHCODE/ || u ~ /HANDLE_CLOSEALLANDRETURNW/) has_closeall_call = 1
    if (u ~ /STRING_APPENDN/) has_appendn_call = 1
    if (u ~ /UNKNOWN29_JMPTBL_ESQ_MAININITANDRUN/ || u ~ /UNKNOWN29_JMPTBL_ESQ_MAININIT/ || u ~ /ESQ_MAININITANDRUN/) has_maininit_call = 1
    if (u ~ /BUFFER_FLUSHALLANDCLOSEWITHCODE/ || u ~ /BUFFER_FLUSHALLANDCLOSEWI/) has_flush_call = 1
    if (u ~ /_LVOOPEN/ || u ~ /LVOOPEN/ || u ~ /DOS_LVO_OPEN/) has_open_call = 1
    if (u ~ /_LVOINPUT/ || u ~ /LVOINPUT/ || u ~ /DOS_LVO_INPUT/) has_input_call = 1
    if (u ~ /_LVOOUTPUT/ || u ~ /LVOOUTPUT/ || u ~ /DOS_LVO_OUTPUT/) has_output_call = 1
    if (u ~ /_LVOFINDTASK/ || u ~ /LVOFINDTASK/ || u ~ /EXEC_FIND_TASK_NULL/) has_findtask_call = 1
    if (u ~ /MODE_NEWFILE/ || u ~ /#\$3EE/ || u ~ /PEA \(\$3EE\)\.W/) has_open_mode_newfile = 1
    if (u ~ /MODE_OLDFILE/ || u ~ /#\$3ED/ || u ~ /PEA \(\$3ED\)\.W/) has_open_mode_oldfile = 1
    if (u ~ /164\(/ || u ~ /LEA \$A4\(/ || u ~ /\$A4\(A0\)/) has_findtask_prwindow_store = 1

    if (u ~ /#32/ || u ~ /#\$20/ || u ~ /#\x27 \x27/) has_space_const = 1
    if (u ~ /#9/ || u ~ /#\$9/ || u ~ /#\x27\\T\x27/) has_tab_const = 1
    if (u ~ /#10/ || u ~ /#\$A/ || u ~ /#\x27\\N\x27/) has_nl_const = 1
    if (u ~ /ADD.B #-9/ && u !~ /GLOBAL_/) has_compact_tabnl = 1
    if (u ~ /#34/ || u ~ /#\$22/ || u ~ /#\x27\"\x27/) has_quote_const = 1
    if (u ~ /#40/ || u ~ / 40\.W/ || u ~ /#\$28/ || u ~ /PEA \(\$28\)\.W/) has_maxlen40_const = 1
    if (u ~ /NSTR "CON\.10\/10\/320\/80\/"/ || u ~ /LEA \.LOC\(PC\),A1/ || u ~ /\$636F6E2E/ || u ~ /\$31302F31/ || u ~ /\$302F3332/ || u ~ /\$302F3830/ || u ~ /\$2F00/) has_console_prefix = 1
    if (u ~ /^DC\.B '\*'/ || u ~ /^DC\.B \*/ || u ~ /^DC\.B \$2A/ || u ~ /NSTR "\*"/ || u ~ /LOC_1/ || u ~ /PEA __MERGED\+\$12\(A4\)/) has_star_string = 1
    if (u ~ /36\(A1\)/ || u ~ /LEA \$24\(A0\),A1/ || u ~ /MOVE\.L \(A1\),A6/ || u ~ /LEA \$4\(A6\),A0/ || u ~ /MOVE\.L 4\(A0\),-\(A7\)/ || u ~ /MOVE\.L \(A0\),-\(A7\)/) has_savedmsg_argrecord = 1
    if (u ~ /MOVEQ\.L #\$10,D0/ || u ~ /MOVEQ #16,D1/ || u ~ /MOVEQ #16,D7/) has_handle_flag16_seed = 1
    if (u ~ /#32768/ || u ~ /#32769/ || u ~ /#32770/ || u ~ /#32771/ || u ~ /#\$8000/ || u ~ /#\$8001/ || u ~ /#\$8002/ || u ~ /#\$8003/) has_flag8000_family = 1
    if (u ~ /#128/ || u ~ /#\$80/ || u ~ /#127/) has_flag80_const = 1
    if (u ~ /MOVEQ\.L #\$1,D1/ || u ~ /MOVEQ #1,D0/ || u ~ /MOVEQ\.L #\$2,D1/ || u ~ /MOVEQ #2,D0/) has_node_index012 = 1

    if (u == "RTS") has_rts = 1
}

END {
    if (has_compact_tabnl) {
        has_tab_const = 1
        has_nl_const = 1
    }
    if (!has_doslib_ref && (has_open_call || has_input_call || has_output_call)) {
        has_doslib_ref = 1
    }

    print "HAS_ARGCOUNT_REF=" has_argcount_ref
    print "HAS_ARGCOUNT_LIMIT32=" has_argcount_limit32
    print "HAS_ARGV_STORAGE_REF=" has_argv_storage_ref
    print "HAS_ARGV_PTR_REF=" has_argv_ptr_ref
    print "HAS_SAVED_MSG_REF=" has_saved_msg_ref
    print "HAS_CONSOLE_BUF_REF=" has_console_buf_ref
    print "HAS_DOSLIB_REF=" has_doslib_ref

    print "HAS_HANDLE0_PTR_REF=" has_handle0_ptr_ref
    print "HAS_HANDLE1_PTR_REF=" has_handle1_ptr_ref
    print "HAS_HANDLE2_PTR_REF=" has_handle2_ptr_ref
    print "HAS_HANDLE0_FLAGS_REF=" has_handle0_flags_ref
    print "HAS_HANDLE1_FLAGS_REF=" has_handle1_flags_ref
    print "HAS_HANDLE2_FLAGS_REF=" has_handle2_flags_ref

    print "HAS_DEFAULT_FLAGS_REF=" has_default_flags_ref
    print "HAS_NODE0_REF=" has_node0_ref
    print "HAS_NODE1_REF=" has_node1_ref
    print "HAS_NODE2_REF=" has_node2_ref
    print "HAS_SIGNAL_CALLBACK_REF=" has_signal_callback_ref

    print "HAS_CLOSEALL_CALL=" has_closeall_call
    print "HAS_APPENDN_CALL=" has_appendn_call
    print "HAS_MAININIT_CALL=" has_maininit_call
    print "HAS_FLUSH_CALL=" has_flush_call
    print "HAS_OPEN_CALL=" has_open_call
    print "HAS_INPUT_CALL=" has_input_call
    print "HAS_OUTPUT_CALL=" has_output_call
    print "HAS_FINDTASK_CALL=" has_findtask_call
    print "HAS_OPEN_MODE_NEWFILE=" has_open_mode_newfile
    print "HAS_OPEN_MODE_OLDFILE=" has_open_mode_oldfile
    print "HAS_FINDTASK_PRWINDOW_STORE=" has_findtask_prwindow_store

    print "HAS_SPACE_CONST=" has_space_const
    print "HAS_TAB_CONST=" has_tab_const
    print "HAS_NL_CONST=" has_nl_const
    print "HAS_QUOTE_CONST=" has_quote_const
    print "HAS_MAXLEN40_CONST=" has_maxlen40_const
    print "HAS_CONSOLE_PREFIX=" has_console_prefix
    print "HAS_STAR_STRING=" has_star_string
    print "HAS_SAVEDMSG_ARGRECORD=" has_savedmsg_argrecord
    print "HAS_HANDLE_FLAG16_SEED=" has_handle_flag16_seed
    print "HAS_FLAG8000_FAMILY=" has_flag8000_family
    print "HAS_FLAG80_CONST=" has_flag80_const
    print "HAS_NODE_INDEX012=" has_node_index012
    print "HAS_RTS=" has_rts
}

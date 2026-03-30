BEGIN {
    h_entry = 0
    h_arg_limit_32 = 0
    h_ws_space = 0
    h_ws_tab = 0
    h_ws_nl = 0
    h_quote_token = 0
    h_quote_scan = 0
    h_quote_fail_close = 0
    h_quote_terminate = 0
    h_unquoted_token = 0
    h_unquoted_scan = 0
    h_unquoted_terminate = 0
    h_argv_savedmsg = 0
    h_argv_storage = 0
    h_console_prefix_copy = 0
    h_console_append = 0
    h_console_open_new = 0
    h_console_handle_seed = 0
    h_findtask_patch = 0
    h_input_output_open = 0
    h_open_oldfile = 0
    h_runtime_flag_seed = 0
    h_handle_flag_or = 0
    h_default_flag_choice = 0
    h_node0_setup = 0
    h_node1_setup = 0
    h_node2_setup = 0
    h_signal_callback = 0
    h_main_call = 0
    h_flush_zero = 0
    h_rts = 0

    console_copy_count = 0
    whitespace_checks = 0
    unquoted_delim_checks = 0
    argv_store_count = 0

    prev = ""
    prev2 = ""
    prev3 = ""
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = norm($0)
    if (l == "") {
        next
    }

    if (l ~ /^ESQ_PARSECOMMANDLINEANDRUN:/ || l ~ /^ESQ_PARSECOMMANDLINEANDRUN[A-Z0-9_]*:/) {
        h_entry = 1
    }

    if (l ~ /CMPI?\.L #\$20,GLOBAL_ARGCOUNT/ ||
        l ~ /CMPI?\.L #' ',GLOBAL_ARGCOUNT/ ||
        l ~ /CMPI?\.L #32,GLOBAL_ARGCOUNT/) {
        h_arg_limit_32 = 1
    }

    if ((l ~ /MOVEQ(\.L)? #\$20,D[01]/ || l ~ /MOVEQ(\.L)? #32,D[01]/) &&
        prev ~ /MOVE\.B \(A3\),D0/) {
        h_ws_space = 1
        whitespace_checks++
    }
    if ((l ~ /MOVEQ(\.L)? #\$9,D1/ || l ~ /MOVEQ(\.L)? #9,D1/) &&
        (prev ~ /CMP\.B D1,D0/ || prev2 ~ /CMP\.B D1,D0/ || prev3 ~ /CMP\.B D1,D0/ ||
         prev ~ /MOVE\.B \(A3\),D0/ || prev2 ~ /MOVE\.B \(A3\),D0/)) {
        h_ws_tab = 1
        whitespace_checks++
    }
    if ((l ~ /MOVEQ(\.L)? #\$A,D1/ || l ~ /MOVEQ(\.L)? #10,D1/) &&
        (prev ~ /CMP\.B D1,D0/ || prev2 ~ /CMP\.B D1,D0/ || prev3 ~ /CMP\.B D1,D0/ ||
         prev ~ /MOVE\.B \(A3\),D0/ || prev2 ~ /MOVE\.B \(A3\),D0/)) {
        h_ws_nl = 1
        whitespace_checks++
    }

    if (l ~ /GLOBAL_ARGVSTORAGE/ && (l ~ /ADD/ || l ~ /ADDA/) && l ~ /A0/) {
        h_unquoted_token = 1
    }
    if (l ~ /MOVE\.L A3,\(A2\)/) {
        argv_store_count++
    }
    if (l ~ /MOVE\.L A3,\(A2\)/ && (prev ~ /ADDQ\.L #\$1,GLOBAL_ARGCOUNT/ || prev2 ~ /ADDQ\.L #\$1,GLOBAL_ARGCOUNT/ ||
        prev3 ~ /ADDQ\.L #\$1,GLOBAL_ARGCOUNT/ || prev ~ /GLOBAL_ARGVSTORAGE/ || prev2 ~ /GLOBAL_ARGVSTORAGE/)) {
        h_quote_token = 1
        h_unquoted_token = 1
    }
    if ((l ~ /MOVEQ(\.L)? #\$22,D[01]/ || l ~ /MOVEQ(\.L)? #34,D[01]/) &&
        (prev ~ /MOVE\.L A3,\(A2\)/ || prev2 ~ /MOVE\.L A3,\(A2\)/ || prev3 ~ /MOVE\.L A3,\(A2\)/)) {
        h_quote_token = 1
    }
    if ((l ~ /CMP\.B \(A3\),D0/ || l ~ /CMP\.B D1,D0/) &&
        (prev ~ /MOVEQ(\.L)? #\$22,D[01]/ || prev ~ /MOVEQ(\.L)? #34,D[01]/ ||
         prev2 ~ /MOVEQ(\.L)? #\$22,D[01]/ || prev2 ~ /MOVEQ(\.L)? #34,D[01]/)) {
        h_quote_scan = 1
    }
    if ((l ~ /HANDLE_CLOSEALLANDRETURNWITHCODE/) &&
        (prev ~ /PEA \(\$1\)\.W/ || prev ~ /PEA 1\.W/ || prev2 ~ /PEA \(\$1\)\.W/ || prev2 ~ /PEA 1\.W/)) {
        h_quote_fail_close = 1
    }
    if (l ~ /^CLR\.B \(A3\)\+$/) {
        h_quote_terminate = 1
        h_unquoted_terminate = 1
    }

    if (l ~ /MOVE\.B \(A3\),D0/) {
        if (prev ~ /MOVE\.L A3,\(A2\)/ || prev2 ~ /MOVE\.L A3,\(A2\)/) {
            h_unquoted_scan = 1
        }
    }
    if ((l ~ /MOVEQ(\.L)? #\$20,D1/ || l ~ /MOVEQ(\.L)? #32,D1/ ||
         l ~ /MOVEQ(\.L)? #\$9,D1/ || l ~ /MOVEQ(\.L)? #9,D1/ ||
         l ~ /MOVEQ(\.L)? #\$A,D1/ || l ~ /MOVEQ(\.L)? #10,D1/) &&
        (prev ~ /MOVE\.B \(A3\),D0/ || prev2 ~ /MOVE\.B \(A3\),D0/)) {
        unquoted_delim_checks++
    }

    if (l ~ /MOVE\.L GLOBAL_SAVEDMSG\(A4\),GLOBAL_ARGVPTR\(A4\)/ ||
        (l ~ /MOVEA?\.L GLOBAL_SAVEDMSG\(A4\),A0/ && (prev ~ /TST\.L GLOBAL_ARGCOUNT\(A4\)/ || prev2 ~ /TST\.L GLOBAL_ARGCOUNT\(A4\)/))) {
        h_argv_savedmsg = 1
    }
    if ((l ~ /LEA GLOBAL_ARGVSTORAGE\(A4\),A0/ || l ~ /MOVE\.L A0,GLOBAL_ARGVPTR\(A4\)/) &&
        (prev ~ /LEA GLOBAL_ARGVSTORAGE\(A4\),A0/ || prev2 ~ /LEA GLOBAL_ARGVSTORAGE\(A4\),A0/ ||
         l ~ /LEA GLOBAL_ARGVSTORAGE\(A4\),A0/)) {
        h_argv_storage = 1
    }

    if ((l ~ /^MOVE\.L \(A1\)\+,\(A[06]\)\+$/ || l ~ /^MOVE\.L \(A1\)\+,\(A0\)\+$/)) {
        console_copy_count++
    }
    if (console_copy_count >= 4 &&
        (l ~ /^MOVE\.W \(A1\),\(A6\)$/ || l ~ /^MOVE\.W \(A1\),\(A0\)$/ || l ~ /MOVE\.W __MERGED\+\$10\(A4\),\(A0\)/)) {
        h_console_prefix_copy = 1
    }
    if ((l ~ /STRING_APPENDN/ && (prev ~ /PEA \(\$28\)\.W/ || prev ~ /PEA 40\.W/ || prev2 ~ /PEA \(\$28\)\.W/ || prev2 ~ /PEA 40\.W/)) ||
        (l ~ /STRING_APPENDN/ && (prev ~ /GLOBAL_CONSOLENAMEBUFFER/ || prev2 ~ /GLOBAL_CONSOLENAMEBUFFER/ || prev3 ~ /GLOBAL_CONSOLENAMEBUFFER/))) {
        h_console_append = 1
    }
    if (l ~ /_LVOOPEN/ &&
        (prev ~ /PEA \(\$3EE\)\.W/ || prev ~ /MOVE\.L #MODE_NEWFILE,D2/ ||
         prev2 ~ /PEA \(\$3EE\)\.W/ || prev2 ~ /MOVE\.L #MODE_NEWFILE,D2/ ||
         prev3 ~ /PEA \(\$3EE\)\.W/ || prev3 ~ /MOVE\.L #MODE_NEWFILE,D2/)) {
        h_console_open_new = 1
    }
    if ((l ~ /MOVE\.L D[07],GLOBAL_HANDLEENTRY0_PTR\(A4\)/ || l ~ /MOVE\.L D0,GLOBAL_HANDLEENTRY0_PTR\(A4\)/) &&
        (prev ~ /_LVOOPEN/ || prev2 ~ /_LVOOPEN/ || prev3 ~ /_LVOOPEN/)) {
        h_console_handle_seed = 1
    }
    if ((l ~ /_LVOFINDTASK/ || l ~ /MOVE\.L \(A0\),\(A1\)/ || l ~ /MOVE\.L 8\(A0\),164\(A1\)/) &&
        (prev ~ /_LVOFINDTASK/ || prev2 ~ /_LVOFINDTASK/ || prev3 ~ /_LVOFINDTASK/ ||
         l ~ /_LVOFINDTASK/)) {
        h_findtask_patch = 1
    }

    if (l ~ /_LVOINPUT/) {
        h_input_output_open = 1
    }
    if (l ~ /_LVOOUTPUT/ && h_input_output_open) {
        h_input_output_open = 1
    }
    if (l ~ /_LVOOPEN/ &&
        (prev ~ /PEA \(\$3ED\)\.W/ || prev ~ /MOVE\.L #MODE_OLDFILE,D2/ ||
         prev2 ~ /PEA \(\$3ED\)\.W/ || prev2 ~ /MOVE\.L #MODE_OLDFILE,D2/ ||
         prev3 ~ /PEA \(\$3ED\)\.W/ || prev3 ~ /MOVE\.L #MODE_OLDFILE,D2/)) {
        h_open_oldfile = 1
    }

    if (l ~ /MOVEQ(\.L)? #\$0,D[67]/ || l ~ /MOVEQ(\.L)? #0,D[67]/ ||
        l ~ /MOVEQ(\.L)? #\$10,D[67]/ || l ~ /MOVEQ(\.L)? #16,D[67]/) {
        h_runtime_flag_seed = 1
    }
    if ((l ~ /#\$8001/ || l ~ /#\$8002/ || l ~ /#\$8003/) &&
        (l ~ /ORI\./ || prev ~ /ORI\./ || prev2 ~ /ORI\./ || prev3 ~ /ORI\./)) {
        h_handle_flag_or = 1
    }

    if ((l ~ /MOVE\.L #\$8000,D[057]/ || l ~ /MOVEQ(\.L)? #0,D[057]/) &&
        (prev ~ /GLOBAL_DEFAULTHANDLEFLAGS/ || prev2 ~ /GLOBAL_DEFAULTHANDLEFLAGS/ || prev3 ~ /GLOBAL_DEFAULTHANDLEFLAGS/)) {
        h_default_flag_choice = 1
    }

    if ((l ~ /CLR\.L GLOBAL_PREALLOCHANDLENODE0_HANDLEINDEX\(A4\)/ || l ~ /CLR\.L GLOBAL_PREALLOCHANDLENODE0_HANDL\(A4\)/) ||
        (l ~ /MOVE\.L D1,GLOBAL_PREALLOCHANDLENODE0_OPENFLAGS\(A4\)/ || l ~ /MOVE\.L D1,GLOBAL_PREALLOCHANDLENODE0_OPENF\(A4\)/)) {
        h_node0_setup = 1
    }
    if ((l ~ /MOVEQ(\.L)? #1,D[01]/ || l ~ /MOVE\.L D0,GLOBAL_PREALLOCHANDLENODE1_HANDLEINDEX\(A4\)/ || l ~ /MOVE\.L D1,GLOBAL_PREALLOCHANDLENODE1_HANDL\(A4\)/) &&
        (l ~ /GLOBAL_PREALLOCHANDLENODE1_/ || prev ~ /GLOBAL_PREALLOCHANDLENODE1_/ || prev2 ~ /GLOBAL_PREALLOCHANDLENODE1_/)) {
        h_node1_setup = 1
    }
    if ((l ~ /MOVEQ(\.L)? #2,D[01]/ || l ~ /MOVE\.L D0,GLOBAL_PREALLOCHANDLENODE2_HANDLEINDEX\(A4\)/ || l ~ /MOVE\.L D1,GLOBAL_PREALLOCHANDLENODE2_HANDL\(A4\)/) &&
        (l ~ /GLOBAL_PREALLOCHANDLENODE2_/ || prev ~ /GLOBAL_PREALLOCHANDLENODE2_/ || prev2 ~ /GLOBAL_PREALLOCHANDLENODE2_/)) {
        h_node2_setup = 1
    }
    if ((l ~ /#\$80/ || l ~ /#128/) &&
        (l ~ /ORI\./ || prev ~ /ORI\./ || prev2 ~ /ORI\./) &&
        (l ~ /GLOBAL_PREALLOCHANDLENODE2_/ || prev ~ /GLOBAL_PREALLOCHANDLENODE2_/ || prev2 ~ /GLOBAL_PREALLOCHANDLENODE2_/ || prev3 ~ /GLOBAL_PREALLOCHANDLENODE2_/)) {
        h_node2_setup = 1
    }

    if ((l ~ /UNKNOWN36_SHOWABORTREQUESTER/ || l ~ /MOVE\.L A0,GLOBAL_SIGNALCALLBACKPTR\(A4\)/ || l ~ /MOVE\.L A0,GLOBAL_SIGNALCALLBACKPTR/) &&
        (prev ~ /UNKNOWN36_SHOWABORTREQUESTER/ || prev2 ~ /UNKNOWN36_SHOWABORTREQUESTER/ || l ~ /UNKNOWN36_SHOWABORTREQUESTER/)) {
        h_signal_callback = 1
    }

    if (l ~ /ESQ_MAININITANDRUN/ || l ~ /UNKNOWN29_JMPTBL_ESQ_MAININITANDRUN/) {
        h_main_call = 1
    }
    if (l ~ /BUFFER_FLUSHALLANDCLOSEWITHCODE/ &&
        (prev ~ /^CLR\.L \(A7\)$/ || prev2 ~ /^CLR\.L \(A7\)$/ || prev3 ~ /^CLR\.L \(A7\)$/)) {
        h_flush_zero = 1
    }
    if (l == "RTS") {
        h_rts = 1
    }

    prev3 = prev2
    prev2 = prev
    prev = l
}

END {
    if (whitespace_checks >= 3) {
        h_ws_space = 1
        h_ws_tab = 1
        h_ws_nl = 1
    }
    if (unquoted_delim_checks >= 3) {
        h_unquoted_scan = 1
    }
    if (!h_quote_token && h_quote_scan) {
        h_quote_token = 1
    }
    if (argv_store_count >= 2) {
        h_quote_token = 1
        h_unquoted_token = 1
        h_unquoted_scan = 1
    }
    if (!h_unquoted_token && h_unquoted_scan) {
        h_unquoted_token = 1
    }

    print "HAS_ENTRY=" h_entry
    print "HAS_ARG_LIMIT_32=" h_arg_limit_32
    print "HAS_WS_SPACE_CHECK=" h_ws_space
    print "HAS_WS_TAB_CHECK=" h_ws_tab
    print "HAS_WS_NL_CHECK=" h_ws_nl
    print "HAS_QUOTED_TOKEN_PATH=" h_quote_token
    print "HAS_QUOTED_SCAN_LOOP=" h_quote_scan
    print "HAS_UNMATCHED_QUOTE_CLOSEALL=" h_quote_fail_close
    print "HAS_QUOTED_TERMINATE=" h_quote_terminate
    print "HAS_UNQUOTED_TOKEN_PATH=" h_unquoted_token
    print "HAS_UNQUOTED_SCAN_LOOP=" h_unquoted_scan
    print "HAS_UNQUOTED_TERMINATE=" h_unquoted_terminate
    print "HAS_ARGV_SAVEDMSG_PATH=" h_argv_savedmsg
    print "HAS_ARGV_STORAGE_PATH=" h_argv_storage
    print "HAS_CONSOLE_PREFIX_COPY=" h_console_prefix_copy
    print "HAS_CONSOLE_APPEND=" h_console_append
    print "HAS_CONSOLE_OPEN_NEWFILE=" h_console_open_new
    print "HAS_CONSOLE_HANDLE_SEED=" h_console_handle_seed
    print "HAS_FINDTASK_PATCH=" h_findtask_patch
    print "HAS_INPUT_OUTPUT_OPEN_PATH=" h_input_output_open
    print "HAS_OPEN_OLDFILE_STAR=" h_open_oldfile
    print "HAS_RUNTIME_FLAG_SEED=" h_runtime_flag_seed
    print "HAS_HANDLE_FLAG_ORS=" h_handle_flag_or
    print "HAS_DEFAULT_FLAG_CHOICE=" h_default_flag_choice
    print "HAS_NODE0_SETUP=" h_node0_setup
    print "HAS_NODE1_SETUP=" h_node1_setup
    print "HAS_NODE2_SETUP=" h_node2_setup
    print "HAS_SIGNAL_CALLBACK=" h_signal_callback
    print "HAS_MAIN_CALL=" h_main_call
    print "HAS_FLUSH_ZERO=" h_flush_zero
    print "HAS_RTS=" h_rts
}

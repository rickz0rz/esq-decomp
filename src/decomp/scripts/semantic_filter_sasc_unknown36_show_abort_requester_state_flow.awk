BEGIN {
    has_label = 0
    has_len_clamp = 0
    has_copy_loop = 0
    has_nul_term = 0
    has_findtask = 0
    has_cli_ptr_test = 0
    has_cli_shift = 0
    has_stdout_load = 0
    has_console_fallback = 0
    has_break_write = 0
    has_newline_append = 0
    has_message_write = 0
    has_openlib = 0
    has_requester_out = 0
    has_exec348 = 0
    has_exec348_arg250 = 0
    has_exec348_arg60 = 0
    has_success_on_one = 0
    has_fail_neg1 = 0
    has_rts = 0
}

function norm(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = norm($0)
    if (line == "") next

    if (line ~ /^UNKNOWN36_SHOWABORTREQUESTER:/) has_label = 1

    if ((line ~ /MOVEQ(\.L)? #79,D0/ || line ~ /MOVEQ(\.L)? #\$4F,D0/) &&
        line !~ /#0/) has_len_clamp = 1
    if (line ~ /CMP\.L D0,D7/ || line ~ /CMP\.L D7,D6/) has_len_clamp = 1

    if ((line ~ /MOVE\.B \(A0\)\+,/ || line ~ /MOVE\.B \$0\(A5,D6\.L\),D0/) &&
        (line ~ /\(A1\)\+/ || line ~ /\$1E\(A7,D6\.L\)/)) has_copy_loop = 1
    if (line ~ /SUBQ\.L #1,D0/ || line ~ /ADDQ\.L #\$1,D6/) has_copy_loop = 1
    if (line ~ /CLR\.B -81\(A5,D7\.L\)/ || line ~ /CLR\.B \$1E\(A7,D7\.L\)/) has_nul_term = 1

    if (line ~ /LVOFINDTASK/) has_findtask = 1
    if (line ~ /TST\.L 172\(A0\)/ || line ~ /LEA \$AC\(A3\),A0/) has_cli_ptr_test = 1
    if (line ~ /ASL\.L #2,D1/ || line ~ /ASL\.L #\$2,D0/) has_cli_shift = 1
    if (line ~ /MOVE\.L 56\(A1\),D6/ || line ~ /LEA \$38\(A2\),A0/) has_stdout_load = 1
    if (line ~ /MOVE\.L 160\(A0\),D6/ || line ~ /LEA \$A0\(A3\),A0/) has_console_fallback = 1

    if ((line ~ /LVOWRITE/ || line ~ /_LVOWRITE/) &&
        (line ~ /BREAKPREFIX/ || line ~ /UNKNOWN36_STR_BREAKPREFIX/ || line ~ /__MERGED/)) has_break_write = 1
    if (line ~ /MOVE\.B #\$A,-81\(A5,D0\.L\)/ || line ~ /MOVE\.B #\$A,\$2E\(A7,D7\.L\)/) has_newline_append = 1
    if ((line ~ /LVOWRITE/ || line ~ /_LVOWRITE/) &&
        (line ~ /LEA -81\(A5\),A0/ || line ~ /PEA \$2E\(A7\)/ || line ~ /MOVE\.L D7,D3/ || line ~ /ADDQ\.L #1,D7/)) has_message_write = 1

    if (line ~ /LVOOPENLIBRARY/) has_openlib = 1
    if (line ~ /GLOBAL_UNKNOWN36_REQUESTEROUTPTR/) has_requester_out = 1
    if (line ~ /EXEC_CALLVECTOR_348/) has_exec348 = 1
    if (line ~ /PEA 250\.W/ || line ~ /PEA \(\$FA\)\.W/) has_exec348_arg250 = 1
    if (line ~ /PEA 60\.W/ || line ~ /PEA \(\$3C\)\.W/) has_exec348_arg60 = 1
    if ((line ~ /SUBQ\.L #1,D0/ || line ~ /SUBQ\.L #\$1,D0/) &&
        (line ~ /BEQ\.S \.REQUESTER_OK/ || line ~ /BNE\.B ___UNKNOWN36_SHOWABORTREQUESTER__17/)) has_success_on_one = 1
    if (line ~ /MOVEQ #-1,D0/ || line ~ /MOVEQ(\.L)? #\$FF,D0/) has_fail_neg1 = 1
    if (line == "RTS") has_rts = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LEN_CLAMP=" has_len_clamp
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_NUL_TERM=" has_nul_term
    print "HAS_FINDTASK=" has_findtask
    print "HAS_CLI_PTR_TEST=" has_cli_ptr_test
    print "HAS_CLI_SHIFT=" has_cli_shift
    print "HAS_STDOUT_LOAD=" has_stdout_load
    print "HAS_CONSOLE_FALLBACK=" has_console_fallback
    print "HAS_BREAK_WRITE=" has_break_write
    print "HAS_NEWLINE_APPEND=" has_newline_append
    print "HAS_MESSAGE_WRITE=" has_message_write
    print "HAS_OPENLIB=" has_openlib
    print "HAS_REQUESTER_OUT=" has_requester_out
    print "HAS_EXEC348=" has_exec348
    print "HAS_EXEC348_ARG250=" has_exec348_arg250
    print "HAS_EXEC348_ARG60=" has_exec348_arg60
    print "HAS_SUCCESS_ON_ONE=" has_success_on_one
    print "HAS_FAIL_NEG1=" has_fail_neg1
    print "HAS_RTS=" has_rts
}

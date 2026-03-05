BEGIN {
    has_label = 0
    has_handle_test = 0
    has_close = 0
    has_handle_clear = 0
    has_forbid = 0
    has_dealloc = 0
    has_done = 0
    has_rts = 0
}
function trim(s, t){ t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t }
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CTASKS_CLOSETASKTEARDOWN[A-Z0-9_]*:/) has_label = 1
    if (u ~ /CTASKS_CLOSETASKFILEHANDLE/ || u ~ /TST\.L/) has_handle_test = 1
    if (u ~ /_LVOCLOSE/) has_close = 1
    if (u ~ /MOVE\.L D0,CTASKS_CLOSETASKFILEHANDLE/ || u ~ /CLR\.L CTASKS_CLOSETASKFILEHANDLE/) has_handle_clear = 1
    if (u ~ /_LVOFORBID/) has_forbid = 1
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEM/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT$/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT[A-Z0-9_]*/) has_dealloc = 1
    if (u ~ /MOVE\.W #1,CTASKS_CLOSETASKCOMPLETIONFLAG/ || u ~ /CTASKS_CLOSETASKCOMPLETIONFLAG/) has_done = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_HANDLE_TEST=" has_handle_test
    print "HAS_CLOSE=" has_close
    print "HAS_HANDLE_CLEAR=" has_handle_clear
    print "HAS_FORBID=" has_forbid
    print "HAS_DEALLOC=" has_dealloc
    print "HAS_DONE=" has_done
    print "HAS_RTS=" has_rts
}

BEGIN {
    has_entry = 0
    has_context = 0
    has_handle_cmd = 0
    has_reset = 0
    has_return = 0
}

function trim(s, t) {
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

    if (u ~ /^SCRIPT_RESETCTRLCONTEXTANDCLEARSTATUSLINE:/ || u ~ /^SCRIPT_RESETCTRLCONTEXTANDCLEAR[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "SCRIPT_CTRL_CONTEXT") > 0) has_context = 1
    if (index(u, "TEXTDISP_HANDLESCRIPTCOMMAND") > 0 || index(u, "TEXTDISP_HANDLESCRIPTCO") > 0) has_handle_cmd = 1
    if (index(u, "SCRIPT_RESETCTRLCONTEXT") > 0 || index(u, "SCRIPT_RESETCTRLCONTEX") > 0) has_reset = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CONTEXT=" has_context
    print "HAS_HANDLE_CMD=" has_handle_cmd
    print "HAS_RESET=" has_reset
    print "HAS_RETURN=" has_return
}

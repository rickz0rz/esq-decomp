BEGIN {
    has_ptr = 0
    has_len = 0
    has_ctrlz = 0
    has_path = 0
    has_open = 0
    has_write = 0
    has_close = 0
    has_mode_newfile = 0
    has_neg1 = 0
    has_terminal = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (n ~ /NEWGRID2ERRORLOGENTRYPTR/) has_ptr = 1
    if (n ~ /FLIBLOGENTRYBYTECOUNT/) has_len = 1
    if (n ~ /CLOCKFILEEOFMARKERCTRLZ/) has_ctrlz = 1
    if (n ~ /GLOBALSTRDF0ERRLOG/) has_path = 1
    if (n ~ /SCRIPTJMPTBLDISKIOOPENFILEWITHBUFFER/) has_open = 1
    if (n ~ /SCRIPTJMPTBLDISKIOWRITEBUFFEREDBYTES/) has_write = 1
    if (n ~ /SCRIPTJMPTBLDISKIOCLOSEBUFFEREDFILEANDFLUSH/) has_close = 1
    if (u ~ /MODE_NEWFILE/ || u ~ /1006/) has_mode_newfile = 1
    if (u ~ /#-1/ || u ~ / -1/ || u ~ /^-1$/) has_neg1 = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^BRA / || u ~ /^RTD /) has_terminal = 1
}

END {
    print "HAS_PTR=" has_ptr
    print "HAS_LEN=" has_len
    print "HAS_CTRLZ=" has_ctrlz
    print "HAS_PATH=" has_path
    print "HAS_OPEN=" has_open
    print "HAS_WRITE=" has_write
    print "HAS_CLOSE=" has_close
    print "HAS_MODE_NEWFILE=" has_mode_newfile
    print "HAS_NEG1=" has_neg1
    print "HAS_TERMINAL=" has_terminal
}

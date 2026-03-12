BEGIN {
    has_entry = 0
    has_open = 0
    has_mode = 0
    has_template_ref = 0
    has_copy_loop = 0
    has_clear_slots = 0
    has_sep_ref = 0
    has_scan1 = 0
    has_scan2 = 0
    has_close = 0
    has_return = 0
    write_call_count = 0
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

    if (u ~ /^GCOMMAND_LOADPPVTEMPLATE[A-Z0-9_]*:/) has_entry = 1

    if (index(u, "GROUP_AY_JMPTBL_DISKIO_OPENFILEWITHBUFFER") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_OPENFILEW") > 0 || index(u, "DISKIO_OPENFILEWITHBUFFER") > 0 || index(u, "DISKIO_OPENFILEWITHBUFFE") > 0) has_open = 1
    if (index(u, "MODE_NEWFILE") > 0) has_mode = 1

    if (index(u, "GCOMMAND_DIGITALPPVENABLEDFLAG") > 0) has_template_ref = 1
    if (u ~ /^DBF / || u ~ /^MOVE\.L \(A[0-7]\)\+,\(A[0-7]\)\+$/ || u ~ /^MOVE\.L \$0\(A[0-7],D[0-7]\.L\),\$[0-9A-F]+\((A7|A[0-7]),D[0-7]\.L\)$/) has_copy_loop = 1

    if (u ~ /^CLR\.L -[0-9]+\(A[0-7]\)$/ || u ~ /^CLR\.L \$[0-9A-F]+\(A[0-7]\)$/ || u ~ /^SUBA\.L A[0-7],A[0-7]$/ || u ~ /^MOVE\.L A[0-7],-[0-9]+\(A[0-7]\)$/) has_clear_slots = 1

    if (index(u, "GCOMMAND_PPVTEMPLATEFIELDSEPARATORBYTESTORAGE") > 0 || index(u, "GCOMMAND_PPVTEMPLATEFIELDS") > 0) has_sep_ref = 1

    if (u ~ /^TST\.B \(A[0-7]\)\+$/ || u ~ /^TST\.B \(A[0-7]\)$/) {
        if (!has_scan1) has_scan1 = 1
        else has_scan2 = 1
    }

    if (index(u, "GROUP_AY_JMPTBL_DISKIO_WRITEBUFFEREDBYTES") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_WRITEBUFFER") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_WRITEBUFF") > 0 || index(u, "DISKIO_WRITEBUFFEREDBYTES") > 0 || index(u, "DISKIO_WRITEBUFFEREDBYTE") > 0) write_call_count += 1

    if (index(u, "GROUP_AY_JMPTBL_DISKIO_CLOSEBUFFEREDFILEANDFLUSH") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_CLOSEBUFFE") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_CLOSEBUFF") > 0 || index(u, "DISKIO_CLOSEBUFFEREDFILEANDFLUSH") > 0 || index(u, "DISKIO_CLOSEBUFFEREDFILEANDFLUS") > 0) has_close = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_OPEN=" has_open
    print "HAS_MODE=" has_mode
    print "HAS_TEMPLATE_REF=" has_template_ref
    print "HAS_COPY_LOOP=" has_copy_loop
    print "HAS_CLEAR_SLOTS=" has_clear_slots
    print "HAS_SEP_REF=" has_sep_ref
    print "HAS_SCAN1=" has_scan1
    print "HAS_SCAN2=" has_scan2
    print "HAS_WRITE4=" (write_call_count >= 4 ? 1 : 0)
    print "HAS_CLOSE=" has_close
    print "HAS_RETURN=" has_return
}

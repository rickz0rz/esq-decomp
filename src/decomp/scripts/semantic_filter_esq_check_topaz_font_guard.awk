BEGIN {
    has_entry = 0
    has_link = 0
    has_delay = 0
    has_setapen = 0
    has_rectfill = 0
    has_move = 0
    has_text = 0
    has_lock_loop = 0
    has_sizewindow = 0
    has_mulu32 = 0
    has_remakedisplay = 0
    has_freemem = 0
    has_rerun_write = 0
    has_flush_close = 0
    has_epilogue = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQ_CHECKTOPAZFONTGUARD:/) has_entry = 1
    if (uline ~ /LINK\.W A5,#-32/) has_link = 1
    if (uline ~ /GROUP_MAIN_B_JMPTBL_DOS_DELAY/) has_delay = 1
    if (uline ~ /LVOSETAPEN/) has_setapen = 1
    if (uline ~ /LVORECTFILL/) has_rectfill = 1
    if (uline ~ /LVOMOVE/) has_move = 1
    if (uline ~ /LVOTEXT/) has_text = 1
    if (uline ~ /^\.ENGINEER_LOCK_LOOP:/ || uline ~ /BRA(\.[A-Z]+)? \.ENGINEER_LOCK_LOOP/) has_lock_loop = 1
    if (uline ~ /LVOSIZEWINDOW/) has_sizewindow = 1
    if (uline ~ /GROUP_MAIN_B_JMPTBL_MATH_MULU32/) has_mulu32 = 1
    if (uline ~ /LVOREMAKEDISPLAY/) has_remakedisplay = 1
    if (uline ~ /LVOFREEMEM/) has_freemem = 1
    if (uline ~ /GROUP_MAIN_B_JMPTBL_STREAM_BUFFEREDWRITESTRING/) has_rerun_write = 1
    if (uline ~ /GROUP_MAIN_B_JMPTBL_BUFFER_FLUSHALLANDCLOSEWITHCODE/) has_flush_close = 1
    if (uline ~ /MOVEM\.L \(A7\)\+,D2-D7/ && uline ~ /UNLK A5/) has_epilogue = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_DELAY=" has_delay
    print "HAS_SETAPEN=" has_setapen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_MOVE=" has_move
    print "HAS_TEXT=" has_text
    print "HAS_LOCK_LOOP=" has_lock_loop
    print "HAS_SIZEWINDOW=" has_sizewindow
    print "HAS_MULU32=" has_mulu32
    print "HAS_REMAKEDISPLAY=" has_remakedisplay
    print "HAS_FREEMEM=" has_freemem
    print "HAS_RERUN_WRITE=" has_rerun_write
    print "HAS_FLUSH_CLOSE=" has_flush_close
    print "HAS_EPILOGUE=" has_epilogue
}

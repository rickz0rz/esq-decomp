BEGIN {
    has_entry=0
    has_ensure_alloc=0
    has_seek=0
    has_read=0
    has_write=0
    has_recurse=0
    has_mode_flags=0
    has_state_flags=0
    has_write_remaining=0
    has_buffer_cursor=0
    has_write_reject=0
    has_flush_reject=0
    has_const31=0
    has_const30=0
    has_const1a=0
    has_const0a=0
    has_const0d=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^STREAM_BUFFEREDPUTCORFLUSH:/ || u ~ /^STREAM_BUFFEREDPUTCORFLUSH[A-Z0-9_]*:/) has_entry=1
    if (n ~ /BUFFERENSUREALLOCATED/) has_ensure_alloc=1
    if (n ~ /DOSSEEKBYINDEX/) has_seek=1
    if (n ~ /DOSREADBYINDEX/) has_read=1
    if (n ~ /DOSWRITEBYINDEX/) has_write=1
    if (n ~ /STREAMBUFFEREDPUTCORFLUSH/ && n ~ /BSRW/ || n ~ /STREAMBUFFEREDPUTCORFLUSH/ && n ~ /JSR/) has_recurse=1
    if (n ~ /MODEFLAGS/) has_mode_flags=1
    if (n ~ /STATEFLAGS/) has_state_flags=1
    if (n ~ /WRITEREMAINING/ || n ~ /12A3/ || n ~ /12A5/ || n ~ /CA3/ || n ~ /CA5/) has_write_remaining=1
    if (n ~ /BUFFERCURSOR/ || n ~ /4A3/ || n ~ /4A5/) has_buffer_cursor=1
    if (n ~ /OPENMASKWRITEREJECT/ || u ~ /#\$31/ || u ~ /#49([^0-9]|$)/) has_write_reject=1
    if (n ~ /OPENMASKFLUSHREJECT/ || u ~ /#\$30/ || u ~ /#48([^0-9]|$)/) has_flush_reject=1
    if (u ~ /#\$31/ || u ~ /#49([^0-9]|$)/ || n ~ /OPENMASKWRITEREJECT/) has_const31=1
    if (u ~ /#\$30/ || u ~ /#48([^0-9]|$)/ || n ~ /OPENMASKFLUSHREJECT/) has_const30=1
    if (u ~ /#\$1A/ || u ~ /#26([^0-9]|$)/) has_const1a=1
    if (u ~ /#\$0A/ || u ~ /#\$A/ || u ~ /#10([^0-9]|$)/) has_const0a=1
    if (u ~ /#\$0D/ || u ~ /#13([^0-9]|$)/) has_const0d=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_ENSURE_ALLOCATED_CALL="has_ensure_alloc
    print "HAS_DOS_SEEK_CALL="has_seek
    print "HAS_DOS_READ_CALL="has_read
    print "HAS_DOS_WRITE_CALL="has_write
    print "HAS_RECURSE_PATTERN="has_recurse
    print "HAS_MODE_FLAGS_ACCESS="has_mode_flags
    print "HAS_STATE_FLAGS_ACCESS="has_state_flags
    print "HAS_WRITE_REMAINING_ACCESS="has_write_remaining
    print "HAS_BUFFER_CURSOR_ACCESS="has_buffer_cursor
    print "HAS_WRITE_REJECT_MASK="has_write_reject
    print "HAS_FLUSH_REJECT_MASK="has_flush_reject
    print "HAS_CONST_31="has_const31
    print "HAS_CONST_30="has_const30
    print "HAS_CONST_1A="has_const1a
    print "HAS_CONST_0A="has_const0a
    print "HAS_CONST_0D="has_const0d
    print "HAS_RTS="has_rts
}

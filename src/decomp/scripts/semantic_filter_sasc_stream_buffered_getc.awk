BEGIN {
    has_entry=0
    has_putc_flush=0
    has_ensure_alloc=0
    has_dos_read=0
    has_recurse=0
    has_ctrl_z=0
    has_cr=0
    has_flush_reject=0
    has_read_reject=0
    has_mode_flags=0
    has_state_flags=0
    has_read_remaining=0
    has_buffer_cursor=0
    has_const1a=0
    has_const0d=0
    has_const30=0
    has_const32=0
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

    if (u ~ /^STREAM_BUFFEREDGETC:/ || u ~ /^STREAM_BUFFEREDGETC[A-Z0-9_]*:/) has_entry=1
    if (n ~ /STREAMBUFFEREDPUTCORFLUSH/) has_putc_flush=1
    if (n ~ /BUFFERENSUREALLOCATED/) has_ensure_alloc=1
    if (n ~ /DOSREADBYINDEX/) has_dos_read=1
    if (n ~ /BSRWSTREAMBUFFEREDGETC/ || n ~ /JSRSTREAMBUFFEREDGETC/ || n ~ /BRAWSTREAMBUFFEREDGETC/) has_recurse=1
    if (u ~ /#\$1A/ || u ~ /#26([^0-9]|$)/ || u ~ /#\$001A/) has_ctrl_z=1
    if (u ~ /#\$0D/ || u ~ /#13([^0-9]|$)/ || u ~ /#\$000D/) has_cr=1
    if (n ~ /OPENMASKFLUSHREJECT/ || u ~ /#\$30/ || u ~ /#48([^0-9]|$)/) has_flush_reject=1
    if (n ~ /OPENMASKREADREJECT/ || u ~ /#\$32/ || u ~ /#50([^0-9]|$)/) has_read_reject=1
    if (n ~ /MODEFLAGS/) has_mode_flags=1
    if (n ~ /STATEFLAGS/) has_state_flags=1
    if (n ~ /READREMAINING/ || n ~ /8A5/ || n ~ /8A3/) has_read_remaining=1
    if (n ~ /BUFFERCURSOR/ || n ~ /4A5/ || n ~ /4A3/) has_buffer_cursor=1
    if (u ~ /#\$1A/ || u ~ /#26([^0-9]|$)/ || u ~ /\(\$1A\)/) has_const1a=1
    if (u ~ /#\$0D/ || u ~ /#13([^0-9]|$)/ || u ~ /\(\$D\)/) has_const0d=1
    if (u ~ /#\$30/ || u ~ /#48([^0-9]|$)/ || n ~ /OPENMASKFLUSHREJECT/) has_const30=1
    if (u ~ /#\$32/ || u ~ /#50([^0-9]|$)/ || n ~ /OPENMASKREADREJECT/) has_const32=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_PUTC_OR_FLUSH_CALL="has_putc_flush
    print "HAS_ENSURE_ALLOCATED_CALL="has_ensure_alloc
    print "HAS_DOS_READ_CALL="has_dos_read
    print "HAS_RECURSE_PATTERN="has_recurse
    print "HAS_CTRL_Z_CHECK="has_ctrl_z
    print "HAS_CR_CHECK="has_cr
    print "HAS_FLUSH_REJECT_MASK="has_flush_reject
    print "HAS_READ_REJECT_MASK="has_read_reject
    print "HAS_MODE_FLAGS_ACCESS="has_mode_flags
    print "HAS_STATE_FLAGS_ACCESS="has_state_flags
    print "HAS_READ_REMAINING_ACCESS="has_read_remaining
    print "HAS_BUFFER_CURSOR_ACCESS="has_buffer_cursor
    print "HAS_CONST_1A="has_const1a
    print "HAS_CONST_0D="has_const0d
    print "HAS_CONST_30="has_const30
    print "HAS_CONST_32="has_const32
    print "HAS_RTS="has_rts
}

BEGIN {
    has_entry=0
    has_read_serial=0
    has_preamble55_write=0
    has_armed_write=0
    has_sync_55_check=0
    has_sync_aa_check=0
    has_cmd_a_check=0
    has_checksum_call=0
    has_cmd_w_or_w=0
    has_clear_flags=0
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

    if (u ~ /^ESQPARS_CONSUMERBFBYTEANDDISPATCHCOMMAND:/ || u ~ /^ESQPARS_CONSUMERBFBYTEANDDISPATCHCOMMAN[A-Z0-9_]*:/ || u ~ /^ESQPARS_CONSUMERBFBYTEANDDISPATC[A-Z0-9_]*:/) has_entry=1
    if (n ~ /READSERIALRBFBYTE/ || n ~ /READSERIAL/) has_read_serial=1
    if (n ~ /PREAMBLE55SEENFLAG/) has_preamble55_write=1
    if (n ~ /COMMANDPREAMBLEARMEDFLAG/) has_armed_write=1
    if (n ~ /55/ && (n ~ /CMP/ || n ~ /EQ/)) has_sync_55_check=1
    if (n ~ /AA/ && (n ~ /CMP/ || n ~ /EQ/)) has_sync_aa_check=1
    if (n ~ /41/ || n ~ /CMDBYTEA/ || n ~ /CMPB/ && n ~ /D0/) has_cmd_a_check=1
    if (n ~ /GENERATEXORCHECKSUMBYTE/ || n ~ /GENERATEXORCH/ || n ~ /READSERIALRECORDINTOBUFFER/ || n ~ /READSERIALRECORDINTOBUFF/) has_checksum_call=1
    if (n ~ /VERIFYCHECKSUMANDPARSERECORD/ || n ~ /VERIFYCHECKSUMANDPARSELIST/ || n ~ /ESQPROTOVERIFYCH/) has_cmd_w_or_w=1
    if (n ~ /CLEARFLAGS/ || n ~ /PREAMBLE55SEENFLAG/ && n ~ /MOVEW0/) has_clear_flags=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_READ_SERIAL=" has_read_serial
    print "HAS_PREAMBLE55_WRITE=" has_preamble55_write
    print "HAS_ARMED_WRITE=" has_armed_write
    print "HAS_SYNC_55_CHECK=" has_sync_55_check
    print "HAS_SYNC_AA_CHECK=" has_sync_aa_check
    print "HAS_CMD_A_CHECK=" has_cmd_a_check
    print "HAS_CHECKSUM_CALL=" has_checksum_call
    print "HAS_CMD_W_OR_w=" has_cmd_w_or_w
    print "HAS_CLEAR_FLAGS=" has_clear_flags
    print "HAS_RTS=" has_rts
}

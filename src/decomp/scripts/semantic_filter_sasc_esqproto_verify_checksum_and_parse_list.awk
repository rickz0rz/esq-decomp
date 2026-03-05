BEGIN {
    has_read_call = 0
    has_xor_call = 0
    has_parse_call = 0
    has_error_counter = 0
    has_rts_or_jmp = 0
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

    if (u ~ /UNKNOWN_JMPTBL_ESQIFF2_READSERIA/ || u ~ /UNKNOWN_JMPTBL_ESQIFF2_READSERIALRECORDINTOB/ || u ~ /UNKNOWN_JMPTBL_ESQIFF2_READSERIALRECORDINTOBUFFER/) has_read_call = 1
    if (u ~ /UNKNOWN_JMPTBL_ESQ_GENERATEXORCH/ || u ~ /UNKNOWN_JMPTBL_ESQ_GENERATEXORCHECKSUMBYTE/) has_xor_call = 1
    if (u ~ /UNKNOWN_PARSELISTANDUPDATEENT/ || u ~ /UNKNOWN_PARSELISTANDUPDATEENTRIES/) has_parse_call = 1
    if (u ~ /DATACERRS/) has_error_counter = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_READ_CALL=" has_read_call
    print "HAS_XOR_CALL=" has_xor_call
    print "HAS_PARSE_CALL=" has_parse_call
    print "HAS_ERROR_COUNTER=" has_error_counter
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}

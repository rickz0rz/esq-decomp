BEGIN { l=0; read=0; xor=0; parse=0; err=0; rts=0 }
/^ESQPROTO_VerifyChecksumAndParseRecord:$/ { l=1 }
/UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer/ { read=1 }
/UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte/ { xor=1 }
/UNKNOWN_ParseRecordAndUpdateDisplay/ { parse=1 }
/DATACErrs/ { err=1 }
/^RTS$/ { rts=1 }
END {
    if (l) print "HAS_LABEL"
    if (read) print "HAS_READ_CALL"
    if (xor) print "HAS_XOR_CALL"
    if (parse) print "HAS_PARSE_CALL"
    if (err) print "HAS_ERROR_COUNTER"
    if (rts) print "HAS_RTS"
}

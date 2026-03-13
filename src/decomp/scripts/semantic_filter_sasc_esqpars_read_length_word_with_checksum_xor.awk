BEGIN {
    has_entry = 0
    has_init_len = 0
    has_loop_bound = 0
    has_wait_call = 0
    has_read_call = 0
    has_xor = 0
    has_shift_merge = 0
    has_store_len = 0
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

    if (u ~ /^ESQPARS_READLENGTHWORDWITHCHECKSUMXOR:/ || u ~ /^ESQPARS_READLENGTHWORDWITHCHECKS[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "ESQIFF_RECORDLENGTH") > 0 && (u ~ /^MOVE\.W D[0-7],ESQIFF_RECORDLENGTH$/ || u ~ /^CLR\.W ESQIFF_RECORDLENGTH/ || u ~ /^MOVE\.W D[0-7],ESQIFF_RECORDLENGTH\(A4\)$/)) has_init_len = 1
    if (u ~ /^CMP\.[WL] D[0-7],D[0-7]$/ || u ~ /^CMP\.[WL] #\$2,D[0-7]$/ || u ~ /^CMP\.[WL] #2,D[0-7]$/) has_loop_bound = 1
    if (index(u, "ESQFUNC_WAITFORCLOCKCHANGEANDSERVICEUI") > 0 || index(u, "WAITFORCLOCKCHANGEANDSERVICEUI") > 0 || index(u, "WAITFORCLOCKCHANGEANDSER") > 0) has_wait_call = 1
    if (index(u, "SCRIPT_READNEXTRBFBYTE") > 0 || index(u, "SCRIPT_READSERIALRBFBYTE") > 0 || index(u, "READSERIALRBFBYTE") > 0 || index(u, "READSERIAL") > 0) has_read_call = 1
    if (u ~ /^EOR\.B D[0-7],D[0-7]$/) has_xor = 1
    if (u ~ /^ASL\.[LW] #\$8,D[0-7]$/ || u ~ /^ASL\.[LW] #8,D[0-7]$/ || u ~ /^ADD\.[LW] D[0-7],D[0-7]$/ || u ~ /^OR\.[LW] D[0-7],D[0-7]$/) has_shift_merge = 1
    if (index(u, "ESQIFF_RECORDLENGTH") > 0 && (u ~ /^MOVE\.W D[0-7],ESQIFF_RECORDLENGTH/ || u ~ /^MOVE\.W D[0-7],ESQIFF_RECORDLENGTH\(A4\)$/)) has_store_len = 1
    if (u ~ /^BRA\.[SWB] ESQPARS_READLENGTHWORDWITHCHECKSUMXOR_RETURN$/ || u ~ /^BGE\.[SWB] ESQPARS_READLENGTHWORDWITHCHECKSUMXOR_RETURN$/ || u ~ /^JMP ESQPARS_READLENGTHWORDWITHCHECKSUMXOR_RETURN$/ || u ~ /^BGE\.[SWB] ___ESQPARS_READLENGTHWORDWITHCHECKS/ || u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INIT_LEN=" has_init_len
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_WAIT_CALL=" has_wait_call
    print "HAS_READ_CALL=" has_read_call
    print "HAS_XOR=" has_xor
    print "HAS_SHIFT_MERGE=" has_shift_merge
    print "HAS_STORE_LEN=" has_store_len
    print "HAS_RETURN=" has_return
}

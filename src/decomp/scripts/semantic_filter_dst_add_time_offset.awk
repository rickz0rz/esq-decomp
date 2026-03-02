BEGIN {
    label=0; call_norm=0; call_store=0; c_hour=0; c_min=0; mul=0; add=0; rts=0
    h_s3=0; h_s5=0; h_s4=0; m_s4=0; m_s2=0
}

/^DST_AddTimeOffset:$/ { label=1 }
/DATETIME_NormalizeStructToSeconds/ { call_norm=1 }
/DATETIME_SecondsToStruct/ { call_store=1 }
/#\$e10|#3600|0x0E10/ { c_hour=1 }
/#\$3c|#60|0x3C/ { c_min=1 }
/^LSL\.L[[:space:]]+#3,[dD][0-7]$/ { h_s3=1 }
/^LSL\.L[[:space:]]+#5,[dD][0-7]$/ { h_s5=1 }
/^LSL\.L[[:space:]]+#4,[dD][0-7]$/ { h_s4=1; m_s4=1 }
/^LSL\.L[[:space:]]+#2,[dD][0-7]$/ { m_s2=1 }
/^MULS/ { mul=1 }
/^ADD\.L/ { add=1 }
/^RTS$/ { rts=1 }

END {
    if (h_s3 && h_s5 && h_s4) c_hour=1
    if (m_s4 && m_s2) c_min=1
    if (h_s3 || h_s5 || h_s4 || m_s4 || m_s2) mul=1
    if (label) print "HAS_LABEL"
    if (call_norm) print "HAS_NORMALIZE_CALL"
    if (call_store) print "HAS_SECONDS_TO_STRUCT_CALL"
    if (c_hour) print "HAS_HOUR_SECONDS_CONST"
    if (c_min) print "HAS_MIN_SECONDS_CONST"
    if (mul) print "HAS_MULTIPLY_PATH"
    if (add) print "HAS_ACCUMULATE_PATH"
    if (rts) print "HAS_RTS"
}

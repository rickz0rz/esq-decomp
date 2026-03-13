BEGIN {
    has_label = 0
    has_guard = 0
    has_offset_call = 0
    has_mulu_call = 0
    has_flag_path = 0
    has_delta_call = 0
    has_compare_block = 0
}
function trim(s, t){ t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t }
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^COI_TESTENTRYWITHINTIMEWINDOW[A-Z0-9_]*:/) has_label = 1
    if (u ~ /BEQ|BNE|BLE|BGT|BGE/ && (u ~ /COI_TESTENTRYWITHINTIMEWINDOW_RETURN/ || u ~ /__COI_TESTENTRYWITHINTIMEWINDOW__/ || u ~ /\.LAB_03/)) has_guard = 1
    if (u ~ /TEXTDISP_COMPUTETIMEOFF/ || u ~ /TEXTDISP_COMPUTETIMEOFFSET/ || u ~ /TEXTDISP_COMPUTE$/ || u ~ /TEXTDISP_COMPUTE[A-Z0-9_]*/) has_offset_call = 1
    if (u ~ /GROUP_AG_JMPTBL_MATH_MULU32/ || u ~ /MATH_MULU32/) has_mulu_call = 1
    if (u ~ /BTST #4,27\(A3\)/ || u ~ /\$1B\(A[0-7]\)/ || u ~ /ANDI\.B #\$10/) has_flag_path = 1
    if (u ~ /COI_COMPUTEENTRYTIMEDELTAMINUTES/) has_delta_call = 1
    if (u ~ /NEG\.L D0/ || u ~ /CMP\.L D0,D1/ || u ~ /CMP\.L D[0-7],D[0-7]/) has_compare_block = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_GUARD=" has_guard
    print "HAS_OFFSET_CALL=" has_offset_call
    print "HAS_MULU_CALL=" has_mulu_call
    print "HAS_FLAG_PATH=" has_flag_path
    print "HAS_DELTA_CALL=" has_delta_call
    print "HAS_COMPARE_BLOCK=" has_compare_block
}

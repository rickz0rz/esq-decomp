BEGIN {
    has_entry = 0
    has_base_addr = 0
    has_minus_20 = 0
    has_plus_4 = 0
    has_sub_2 = 0
    has_reset = 0
    has_reset_or_vector_handoff = 0
    has_jump_or_call = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next
    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /#\$1000000/ || l ~ /\$1000000/ || l ~ /01000000/) has_base_addr = 1
    if (l ~ /-20\(A0\)/ || l ~ /-\$14\(A0\)/ || l ~ /SUBA\.L .*,-20/ || l ~ /SUB\.W #\$14,A0/) has_minus_20 = 1
    if (l ~ /4\(A0\)/ || l ~ /\+\$4/ || l ~ /ADDQ\.L #\$4,D0/) has_plus_4 = 1
    if (l ~ /SUBQ\.L #\$?2,A[0-7]/ || l ~ /SUBI\.L #\$2/ || l ~ /-\$2/) has_sub_2 = 1
    if (l ~ /^RESET$/) has_reset = 1
    if (l ~ /^JMP \(A0\)$/ || l ~ /^JSR \(A0\)$/ || l ~ /^JSR \(A[0-7]\)$/) has_jump_or_call = 1
}

END {
    if (has_reset || has_jump_or_call) has_reset_or_vector_handoff = 1
    if (has_reset_or_vector_handoff) has_reset = 1
    print "HAS_ENTRY=" has_entry
    print "HAS_BASE_ADDR=" has_base_addr
    print "HAS_MINUS_20=" has_minus_20
    print "HAS_PLUS_4=" has_plus_4
    print "HAS_SUB_2=" has_sub_2
    print "HAS_RESET=" has_reset
    print "HAS_JUMP_OR_CALL=" has_jump_or_call
    print "HAS_RESET_OR_VECTOR_HANDOFF=" has_reset_or_vector_handoff
}

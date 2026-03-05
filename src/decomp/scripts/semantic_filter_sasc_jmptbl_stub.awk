BEGIN {
    has_entry = 0
    has_target = 0
    has_jump_or_call = 0
    target_up = toupper(TARGET)
    target_short = substr(target_up, 1, 24)
}

function up(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = up($0)
    if (l == "") next

    if (ENTRY != "" && l == toupper(ENTRY) ":") has_entry = 1
    if (TARGET != "" && (index(l, target_up) > 0 || (length(target_up) > 24 && index(l, target_short) > 0))) has_target = 1
    if (l ~ /^JMP / || l ~ /^JSR / || l ~ /^BSR / || l ~ /^BSR\.[A-Z]+ /) has_jump_or_call = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_TARGET_REF=" has_target
    print "HAS_JUMP_OR_CALL=" has_jump_or_call
}

BEGIN {
    has_entry = 0
    target_dispatch_count = 0
    has_wrapper_exit = 0
    target_up = toupper(TARGET)
}

function up(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

function extract_dispatch_target(line, tmp, parts) {
    if (line !~ /^(JMP|JSR|BSR|BSR\.[A-Z]+) /) return ""
    tmp = line
    sub(/^(JMP|JSR|BSR|BSR\.[A-Z]+) /, "", tmp)
    split(tmp, parts, /[^A-Z0-9_]/)
    return parts[1]
}

function matches_target_ref(line, ref) {
    ref = extract_dispatch_target(line)
    return (TARGET != "" &&
            ref != "" &&
            (ref == target_up ||
             index(target_up, ref) == 1 ||
             index(ref, target_up) == 1))
}

{
    l = up($0)
    if (l == "") next

    if (ENTRY != "" && l == toupper(ENTRY) ":") has_entry = 1
    if (l ~ /^(JMP|JSR|BSR|BSR\.[A-Z]+) / && matches_target_ref(l)) target_dispatch_count += 1
    if (l == "RTS" || (l ~ /^JMP / && matches_target_ref(l))) has_wrapper_exit = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "TARGET_DISPATCH_COUNT=" target_dispatch_count
    print "HAS_WRAPPER_EXIT=" has_wrapper_exit
}

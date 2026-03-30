BEGIN {
    has_entry = 0
    target_dispatch_count = 0
    non_target_dispatch_count = 0
    saw_top_level_label = 0
    stop_scan = 0
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

function is_ignored_ref(ref) {
    return (ref == "" || ref == "_XCOVF")
}

function is_top_level_label(line) {
    return (line ~ /^[A-Z0-9_]+:$/ && line !~ /^___/)
}

{
    if (stop_scan) next

    l = up($0)
    if (l == "") next

    if (is_top_level_label(l)) {
        if (!saw_top_level_label) {
            saw_top_level_label = 1
        } else {
            stop_scan = 1
            next
        }
    }

    if (ENTRY != "" && l == toupper(ENTRY) ":") has_entry = 1
    if (l ~ /^(JMP|JSR|BSR|BSR\.[A-Z]+) /) {
        ref = extract_dispatch_target(l)
        if (matches_target_ref(l)) {
            target_dispatch_count += 1
        } else if (!is_ignored_ref(ref)) {
            non_target_dispatch_count += 1
        }
    }
    if (l == "RTS" || (l ~ /^JMP / && matches_target_ref(l))) stop_scan = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "TARGET_DISPATCH_COUNT=" target_dispatch_count
    print "NON_TARGET_DISPATCH_COUNT=" non_target_dispatch_count
}

BEGIN {
    has_entry = 0
    has_impl_fallthrough = 0
    has_impl_dispatch = 0
    has_return = 0
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

{
    l = up($0)
    if (l == "") next

    if (l == "ESQDISP_DRAWSTATUSBANNER:") has_entry = 1
    if (l == "ESQDISP_DRAWSTATUSBANNER_IMPL:") has_impl_fallthrough = 1
    if (extract_dispatch_target(l) == "ESQDISP_DRAWSTATUSBANNER_IMPL") has_impl_dispatch = 1
    if (l == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_IMPL_TRANSFER=" ((has_impl_fallthrough || has_impl_dispatch) ? 1 : 0)
    print "HAS_RETURN=" has_return
}

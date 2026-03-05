BEGIN {
    has_entry = 0
    has_drop = 0
    has_build_ctx = 0
    has_palette = 0
    has_setrast = 0
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

    if (u ~ /^TEXTDISP_SETRASTFORMODE:/) has_entry = 1
    if (index(u, "WDISP_JMPTBL_ESQIFF_RUNCOPPERDROPTRANSITION") > 0 || index(u, "WDISP_JMPTBL_ESQIFF_RUNCOPPERDRO") > 0) has_drop = 1
    if (index(u, "TLIBA3_BUILDDISPLAYCONTEXTFORVIEWMODE") > 0 || index(u, "TLIBA3_BUILDDISPLAYCONTEXT") > 0) has_build_ctx = 1
    if (index(u, "WDISP_PALETTETRIPLESRBASE") > 0 || index(u, "WDISP_PALETTETRIPLESGBASE") > 0 || index(u, "WDISP_PALETTETRIPLESBBASE") > 0) has_palette = 1
    if (index(u, "_LVOSETRAST") > 0) has_setrast = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DROP=" has_drop
    print "HAS_BUILD_CTX=" has_build_ctx
    print "HAS_PALETTE=" has_palette
    print "HAS_SETRAST=" has_setrast
    print "HAS_RETURN=" has_return
}

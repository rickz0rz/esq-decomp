BEGIN {
    has_label = 0
    has_link = 0
    has_alias_call = 0
    has_alias_copy = 0
    has_fallback = 0
    has_append = 0
    has_restore = 0
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
    uline = toupper(line)

    if (uline ~ /^TEXTDISP_BUILDENTRYSHORTNAME:/) has_label = 1
    if (uline ~ /LINK.W A5,#-12/) has_link = 1
    if (uline ~ /BSR.W TEXTDISP_FINDALIASINDEXBYNAME/) has_alias_call = 1
    if (uline ~ /^\.COPY_ALIAS:/) has_alias_copy = 1
    if (uline ~ /^\.FALLBACK_ENTRY_NAME:/) has_fallback = 1
    if (uline ~ /JSR STRING_APPENDATNULL\(PC\)/) has_append = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D6-D7\/A2-A3/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_ALIAS_CALL=" has_alias_call
    print "HAS_ALIAS_COPY=" has_alias_copy
    print "HAS_FALLBACK=" has_fallback
    print "HAS_APPEND=" has_append
    print "HAS_RESTORE=" has_restore
}

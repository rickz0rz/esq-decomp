BEGIN {
    has_label = 0
    has_link = 0
    has_get_entry = 0
    has_copy_name = 0
    has_prefix = 0
    has_append = 0
    has_ready = 0
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

    if (uline ~ /^TEXTDISP_BUILDCHANNELLABEL:/) has_label = 1
    if (uline ~ /LINK.W A5,#-20/) has_link = 1
    if (uline ~ /GETENTRYPOINTERBYMODE\(PC\)/) has_get_entry = 1
    if (uline ~ /^\.COPY_ENTRY_NAME:/) has_copy_name = 1
    if (uline ~ /GLOBAL_STR_ALIGNED_ON/ && uline ~ /GLOBAL_STR_ALIGNED_CHANNEL_1/) has_prefix = 1
    if (uline ~ /JSR STRING_APPENDATNULL\(PC\)/) has_append = 1
    if (uline ~ /TEXTDISP_CHANNELLABELREADYFLAG/) has_ready = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_GET_ENTRY=" has_get_entry
    print "HAS_COPY_NAME=" has_copy_name
    print "HAS_PREFIX=" has_prefix
    print "HAS_APPEND=" has_append
    print "HAS_READY=" has_ready
}

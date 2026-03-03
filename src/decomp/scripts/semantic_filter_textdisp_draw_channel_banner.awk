BEGIN {
    has_label = 0
    has_link = 0
    has_entry = 0
    has_short = 0
    has_label_build = 0
    has_setdrmd = 0
    has_trim = 0
    has_draw_inset = 0
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

    if (uline ~ /^TEXTDISP_DRAWCHANNELBANNER:/) has_label = 1
    if (uline ~ /LINK.W A5,#-8/) has_link = 1
    if (uline ~ /GETENTRYPOINTERBYMODE\(PC\)/) has_entry = 1
    if (uline ~ /BSR.W TEXTDISP_BUILDENTRYSHORTNAME/) has_short = 1
    if (uline ~ /BSR.W TEXTDISP_BUILDCHANNELLABEL/) has_label_build = 1
    if (uline ~ /_LVOSETDRMD/) has_setdrmd = 1
    if (uline ~ /BSR.W TEXTDISP_TRIMTEXTTOPIXELWIDTH/) has_trim = 1
    if (uline ~ /BSR.W TEXTDISP_DRAWINSETRECTFRAME/) has_draw_inset = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D5-D7/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_ENTRY=" has_entry
    print "HAS_SHORT=" has_short
    print "HAS_LABEL_BUILD=" has_label_build
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_TRIM=" has_trim
    print "HAS_DRAW_INSET=" has_draw_inset
    print "HAS_RESTORE=" has_restore
}

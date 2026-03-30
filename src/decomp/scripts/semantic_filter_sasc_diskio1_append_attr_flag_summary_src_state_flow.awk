BEGIN {
    fmt_call_count = 0
    has_entry_summary = 0
    has_btst_2 = 0
    has_str_summary = 0
    has_continue_video_tag_disable = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

function mark_btst(bit, next_label) {
    if (index(uline, "BTST #" bit ",") == 1 || index(uline, "BTST #$" bit ",") == 1) {
        if (bit == "2") {
            has_btst_2 = 1
        }
        pending_branch = next_label
    }
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    uline = line

    if (uline ~ /^DISKIO1_APPENDATTRFLAGSUMMARYSRC[A-Z0-9_]*:/) has_entry_summary = 1

    mark_btst("2", "DISKIO1_APPENDATTRFLAGVIDEOTAGDI")

    if (pending_branch != "" && uline ~ /^BEQ\./ && index(uline, pending_branch) > 0) {
        if (pending_branch ~ /VIDEOTAGDI/) has_continue_video_tag_disable = 1
        pending_branch = ""
    }

    if (uline ~ /DISKIO_STR_SUM_SRC_COMPACTSOURCEATTRFLAGS/ || uline ~ /DISKIO_STR_SUM_SRC_COMPACTSOU/) has_str_summary = 1

    if (uline ~ /FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ ||
        uline ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ ||
        uline ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTWITHSCRAT/ ||
        uline ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTW/) {
        fmt_call_count++
    }

    if (uline ~ /DISKIO1_APPENDATTRFLAGVIDEOTAGDI/ && uline ~ /^(BRA|BSR|JSR|JMP)/) {
        has_continue_video_tag_disable = 1
    }
}

END {
    print "FMT_CALL_COUNT=" fmt_call_count
    print "HAS_ENTRY_SUMMARY=" has_entry_summary
    print "HAS_BTST_2=" has_btst_2
    print "HAS_STR_SUMMARY=" has_str_summary
    print "HAS_CONTINUE_VIDEO_TAG_DISABLE=" has_continue_video_tag_disable
}

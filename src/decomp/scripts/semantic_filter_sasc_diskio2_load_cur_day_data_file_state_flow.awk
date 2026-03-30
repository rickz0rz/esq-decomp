BEGIN {
    has_entry = 0
    first_alloc_pos = 0
    entry_check_pos = 0
    entry_fail_pos = 0
    second_alloc_pos = 0
    title_check_pos = 0
    title_cleanup_pos = 0
    init_defaults_pos = 0
    ensure_anim_pos = 0
    return_pos = 0
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = norm($0)
    if (line == "") {
        next
    }

    if (line ~ /^DISKIO2_LOADCURDAYDATAFILE:/ ||
        line ~ /^DISKIO2_LOADCURDAYDATAFILE[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (first_alloc_pos == 0 &&
        (index(line, "GLOBAL_STR_DISKIO2_C_8") > 0 || line ~ /\(\$27A\)\.W/ || line ~ /634\.W/)) {
        first_alloc_pos = NR
    }

    if (entry_check_pos == 0 && first_alloc_pos > 0 && NR > first_alloc_pos &&
        (line ~ /^BNE(\.| )/ || line ~ /^BNE$/ || line ~ /^BNE\.S / || line ~ /^BNE\.B /)) {
        entry_check_pos = NR
    }

    if (entry_fail_pos == 0 && first_alloc_pos > 0 && second_alloc_pos == 0 &&
        (line ~ /MOVEQ(\.L)? #\$FF,D[07]/ || line ~ /MOVEQ #-1,D[07]/ ||
         line ~ /MOVE\.L #\$FFFFFFFF,-36\(A5\)/ || line ~ /MOVE\.L D7,-36\(A5\)/)) {
        entry_fail_pos = NR
    }

    if (second_alloc_pos == 0 && first_alloc_pos > 0 && NR > first_alloc_pos &&
        (index(line, "GLOBAL_STR_DISKIO2_C_9") > 0 || line ~ /\(\$280\)\.W/ || line ~ /640\.W/)) {
        second_alloc_pos = NR
    }

    if (title_check_pos == 0 && second_alloc_pos > 0 && NR > second_alloc_pos &&
        (line ~ /^BNE(\.| )/ || line ~ /^BNE$/ || line ~ /^BNE\.S / || line ~ /^BNE\.B /)) {
        title_check_pos = NR
    }

    if (title_cleanup_pos == 0 &&
        (index(line, "GLOBAL_STR_DISKIO2_C_10") > 0 || line ~ /\(\$284\)\.W/ || line ~ /644\.W/)) {
        title_cleanup_pos = NR
    }

    if (init_defaults_pos == 0 && index(line, "ESQSHARED_INITENTRYDEFAULTS") > 0) {
        init_defaults_pos = NR
    }
    if (ensure_anim_pos == 0 && index(line, "COI_ENSUREANIMOBJECTALLOCATED") > 0) {
        ensure_anim_pos = NR
    }

    if (line == "RTS") {
        return_pos = NR
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ENTRY_ALLOC_FLOW=" (first_alloc_pos > 0 &&
        entry_check_pos > first_alloc_pos &&
        entry_fail_pos > entry_check_pos &&
        second_alloc_pos > entry_fail_pos)
    print "HAS_TITLE_ALLOC_FLOW=" (second_alloc_pos > 0 &&
        title_check_pos > second_alloc_pos &&
        title_cleanup_pos > title_check_pos)
    print "HAS_INIT_SEQUENCE=" (init_defaults_pos > title_check_pos &&
        ensure_anim_pos > init_defaults_pos)
    print "HAS_RETURN=" (return_pos > 0)
}

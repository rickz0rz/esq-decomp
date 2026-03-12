BEGIN {
    has_entry=0
    has_empty_guard=0
    has_group_mode_dispatch=0
    has_prev_valid_call=0
    has_find_control=0
    has_find_quoted=0
    has_slot_scan=0
    has_mask_check=0
    has_slot_bit_test=0
    has_compare_path=0
    has_substring_path=0
    has_restore_return=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TEXTDISP_FINDENTRYMATCHINDEX:/ || u ~ /^TEXTDISP_FINDENTRYMATCHINDE[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TSTBA0/ || n ~ /TSTBA5/ || n ~ /MOVEBA5D[01]/ || n ~ /MOVEQ(L)?(49|31)D0/) has_empty_guard=1
    if (n ~ /TEXTDISPACTIVEGROUPID/ || n ~ /CLOCKHALFHOURSLOTINDEX/ || n ~ /GETENTRYAUXPOINTERBYMODE/ || n ~ /GETENTRYPOINTERBYMODE/) has_group_mode_dispatch=1
    if (n ~ /FINDPREVIOUSVALIDENTRYINDEX/ || n ~ /FINDPREVIO/) has_prev_valid_call=1
    if (n ~ /TEXTDISPFINDCONTROLTOKEN/) has_find_control=1
    if (n ~ /TEXTDISPFINDQUOTEDSPAN/) has_find_quoted=1
    if (n ~ /CMPW49D5/ || n ~ /MOVEQ(L)?(49|31)D0/ || n ~ /CMPWD0D5/ || n ~ /MOVEQL31D1/ || n ~ /CMPLD1D0/ || n ~ /BGEWRESTOREINPUTCHAR/ || n ~ /SLOT49/) has_slot_scan=1
    if (n ~ /ANDBD6D0/ || n ~ /CMPBD6D0/ || n ~ /ANDBD5D2/ || n ~ /CMPBD5D2/ || n ~ /ANDBD[0-7]D[0-7]/ || n ~ /CMPBD[0-7]D[0-7]/ || n ~ /AND/ && n ~ /MASK/) has_mask_check=1
    if (n ~ /TESTBIT1BASED/) has_slot_bit_test=1
    if (n ~ /STRINGCOMPARENOCASE/) has_compare_path=1
    if (n ~ /FINDSUBSTRINGCASEFOLD/ || n ~ /FINDSUBSTRINGC/) has_substring_path=1
    if (n ~ /MOVEB39A5D0/ || n ~ /MOVEB1FA7A0/ || n ~ /MOVEB1EA7A0/ || n ~ /MOVEB26A7A0/ || n ~ /MOVEB27A7A0/ || n ~ /MOVEB40A7A0/ || n ~ /MOVEBD0A0/ || n ~ /RETURN/) has_restore_return=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_EMPTY_GUARD=" has_empty_guard
    print "HAS_GROUP_MODE_DISPATCH=" has_group_mode_dispatch
    print "HAS_PREV_VALID_CALL=" has_prev_valid_call
    print "HAS_FIND_CONTROL_CALL=" has_find_control
    print "HAS_FIND_QUOTED_CALL=" has_find_quoted
    print "HAS_SLOT_SCAN=" has_slot_scan
    print "HAS_MASK_CHECK=" has_mask_check
    print "HAS_SLOT_BIT_TEST=" has_slot_bit_test
    print "HAS_COMPARE_PATH=" has_compare_path
    print "HAS_SUBSTRING_PATH=" has_substring_path
    print "HAS_RESTORE_RETURN=" has_restore_return
    print "HAS_RTS=" has_rts
}

BEGIN {
    has_entry=0
    has_primary_ptr=0
    has_length_check=0
    has_payload_ptr=0
    has_byte_compare=0
    has_clear_input=0
    has_found_set=0
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

    if (u ~ /^P_TYPE_CONSUMEPRIMARYTYPEIFPRESENT:/ || u ~ /^P_TYPE_CONSUMEPRIMARYTYPEIFPRESENT[A-Z0-9_]*:/ || u ~ /^P_TYPE_CONSUMEPRIMARYTYPEIFPRESE:/ || u ~ /^P_TYPE_CONSUMEPRIMARYTYPEIFPRESE[A-Z0-9_]*:/) has_entry=1
    if (n ~ /PTYPEPRIMARYGROUPLISTPTR/) has_primary_ptr=1
    if (n ~ /2A0/ || n ~ /2A1/ || n ~ /CMPLA0D6/ || n ~ /CMPL2A0D6/) has_length_check=1
    if (n ~ /6A1/ || n ~ /6A0/ || n ~ /LEA6A3A0/ || n ~ /MOVELA0A2/ || n ~ /MOVEAL6A1A0/) has_payload_ptr=1
    if (n ~ /CMPB/ && (n ~ /A0/ || n ~ /A2/ || n ~ /A3/ || n ~ /A5/)) has_byte_compare=1
    if (n ~ /CLRB/ && (n ~ /A3/ || n ~ /A5/ || n ~ /A0/)) has_clear_input=1
    if (u ~ /MOVEQ[.]L #1,D7/ || u ~ /MOVEQ #1,D7/ || u ~ /MOVEQ.L #\$1,D7/ || n ~ /MOVEQL1D7/ || n ~ /MOVEQL1D7/ || n ~ /MOVEQ1D7/) has_found_set=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_PRIMARY_LIST_PTR_GLOBAL="has_primary_ptr
    print "HAS_LENGTH_CHECK_PATTERN="has_length_check
    print "HAS_PAYLOAD_PTR_PATTERN="has_payload_ptr
    print "HAS_BYTE_COMPARE_PATTERN="has_byte_compare
    print "HAS_CLEAR_INPUT_PATTERN="has_clear_input
    print "HAS_FOUND_SET_PATTERN="has_found_set
    print "HAS_RTS="has_rts
}

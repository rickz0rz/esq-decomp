BEGIN {
    has_entry=0
    has_24h_flag=0
    has_find_char=0
    has_colon_check=0
    schedule_calls=0
    has_table=0
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

    if (u ~ /^NEWGRID_APPLY24HOURFORMATTING:/ || u ~ /^NEWGRID_APPLY24HOURFORMATTIN[A-Z0-9_]*:/) has_entry=1
    if (n ~ /GLOBALREFSTRUSE24HRCLOCK/) has_24h_flag=1
    if (n ~ /PARSEINIJMPTBLSTRFINDCHARPTR/ || n ~ /STRFINDCHARPTR/) has_find_char=1
    if (u ~ /CMP\.B .*3\(A[0-7]\)/ || u ~ /CMPI\.B #\$3A/) has_colon_check=1
    if ((u ~ /^(JSR|BSR|JMP)(\.[A-Z])?[ \t]/) && n ~ /NEWGRID2JMPTBLESQDISPCOMPUTES/) schedule_calls++
    if (n ~ /GLOBALJMPTBLHALFHOURS24HRF/) has_table=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_24H_FLAG_GLOBAL="has_24h_flag
    print "HAS_FIND_CHAR_CALL="has_find_char
    print "HAS_COLON_CHECK="has_colon_check
    print "SCHEDULE_CALLS="schedule_calls
    print "HAS_24H_TABLE="has_table
    print "HAS_RTS="has_rts
}

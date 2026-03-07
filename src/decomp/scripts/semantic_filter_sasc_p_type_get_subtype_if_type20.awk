BEGIN {
    has_entry=0
    has_null_check=0
    has_type_check=0
    has_subtype_check=0
    has_const20=0
    has_byte1=0
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

    if (u ~ /^P_TYPE_GETSUBTYPEIFTYPE20:/ || u ~ /^P_TYPE_GETSUBTYPEIFTYPE20[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TSTL/ && (n ~ /A3/ || n ~ /A5/) || n ~ /MOVEA/ && (n ~ /A3/ || n ~ /A5/) || n ~ /MOVELA5D0/ || n ~ /MOVELA3D0/) has_null_check=1
    if (n ~ /CMPB/ && (n ~ /A3/ || n ~ /A5/)) has_type_check=1
    if (n ~ /TSTB1A3/ || n ~ /MOVEB1A3/ || n ~ /MOVEB1A5/ || n ~ /MOVEB1A5D0/) has_subtype_check=1
    if (u ~ /#20([^0-9]|$)/ || u ~ /#\$14/ || u ~ /20\.[Ww]/ || u ~ /\(\$14\)/) has_const20=1
    if (n ~ /1A3/ || n ~ /1A5/) has_byte1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_NULL_CHECK_PATTERN="has_null_check
    print "HAS_TYPE_CHECK_PATTERN="has_type_check
    print "HAS_SUBTYPE_CHECK_PATTERN="has_subtype_check
    print "HAS_CONST_20="has_const20
    print "HAS_BYTE1_ACCESS="has_byte1
    print "HAS_RTS="has_rts
}

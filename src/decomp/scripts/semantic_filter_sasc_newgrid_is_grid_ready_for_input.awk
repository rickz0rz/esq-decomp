BEGIN {
    has_entry=0
    has_secondary_flag=0
    has_secondary_count=0
    has_primary_flag=0
    has_primary_count=0
    has_const0=0
    has_const1=0
    has_return=0
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

    if (u ~ /^NEWGRID_ISGRIDREADYFORINPUT:/ || u ~ /^NEWGRID_ISGRIDREADYFORINPU[A-Z0-9_]*:/) has_entry=1
    if (n ~ /TEXTDISPSECONDARYGROUPPRESENTFLAG/ || n ~ /TEXTDISPSECONDARYGROUPPRESENTF/) has_secondary_flag=1
    if (n ~ /TEXTDISPSECONDARYGROUPENTRYCOUNT/ || n ~ /TEXTDISPSECONDARYGROUPENTRYCOU/) has_secondary_count=1
    if (n ~ /TEXTDISPPRIMARYGROUPPRESENTFLAG/ || n ~ /TEXTDISPPRIMARYGROUPPRESENTFLA/) has_primary_flag=1
    if (n ~ /TEXTDISPPRIMARYGROUPENTRYCOUNT/ || n ~ /TEXTDISPPRIMARYGROUPENTRYCOUNT/) has_primary_count=1
    if (u ~ /#0([^0-9]|$)/ || u ~ /#\$00/ || u ~ /#\$0([^0-9A-F]|$)/ || n ~ /CLR/) has_const0=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /\(\$1\)/) has_const1=1
    if (u=="RTS") has_return=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SECONDARY_FLAG="has_secondary_flag
    print "HAS_SECONDARY_COUNT="has_secondary_count
    print "HAS_PRIMARY_FLAG="has_primary_flag
    print "HAS_PRIMARY_COUNT="has_primary_count
    print "HAS_CONST_0="has_const0
    print "HAS_CONST_1="has_const1
    print "HAS_RETURN="has_return
}

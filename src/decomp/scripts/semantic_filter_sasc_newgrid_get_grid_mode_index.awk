BEGIN {
    has_entry=0
    has_mode_state=0
    has_const1=0
    has_const6=0
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

    if (u ~ /^NEWGRID_GETGRIDMODEINDEX:/ || u ~ /^NEWGRID_GETGRIDMODEIND[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDMODESELECTORSTATE/ || n ~ /NEWGRIDMODESELECTORSTAT/) has_mode_state=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u ~ /#6([^0-9]|$)/ || u ~ /#\$06/ || u ~ /#\$6([^0-9A-F]|$)/ || u ~ /6\.[Ww]/ || u ~ /\(\$6\)/) has_const6=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_MODE_SELECTOR_GLOBAL="has_mode_state
    print "HAS_CONST_1="has_const1
    print "HAS_CONST_6="has_const6
    print "HAS_RTS="has_rts
}

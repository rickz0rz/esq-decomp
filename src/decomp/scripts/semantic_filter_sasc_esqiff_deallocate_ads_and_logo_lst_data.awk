BEGIN {
    has_entry=0
    has_gads_ptr=0
    has_gads_size=0
    has_logo_ptr=0
    has_logo_size=0
    has_dealloc=0
    has_const_1988=0
    has_const_1994=0
    has_add1=0
    has_clear_gads=0
    has_clear_logo=0
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

    if (u ~ /^ESQIFF_DEALLOCATEADSANDLOGOLSTDATA:/ || u ~ /^ESQIFF_DEALLOCATEADSANDLOGOLSTD[A-Z0-9_]*:/ || u ~ /^ESQIFF_DEALLOCATEADSANDLOGOLSTDA[A-Z0-9_]*:/) has_entry=1
    if (n ~ /GLOBALREFLONGGFXGADSDATA/) has_gads_ptr=1
    if (n ~ /GLOBALREFLONGGFXGADSFILESIZE/ || n ~ /GLOBALREFLONGGFXGADSFILESI/) has_gads_size=1
    if (n ~ /GLOBALREFLONGDF0LOGOLSTDATA/ || n ~ /GLOBALREFLONGDF0LOGOLSTDAT/) has_logo_ptr=1
    if (n ~ /GLOBALREFLONGDF0LOGOLSTFILESIZE/ || n ~ /GLOBALREFLONGDF0LOGOLSTFIL/) has_logo_size=1
    if (n ~ /ESQIFFJMPTBLMEMORYDEALLOCATEMEMORY/ || n ~ /ESQIFFJMPTBLMEMORYDEALLOCATEM/) has_dealloc=1
    if (u ~ /1988\.W/ || u ~ /\$7C4/ || u ~ /#1988/) has_const_1988=1
    if (u ~ /1994\.W/ || u ~ /\$7CA/ || u ~ /#1994/) has_const_1994=1
    if (u ~ /ADDQ\.L #1/ || u ~ /ADDQ\.L #\$1/ || u ~ /ADDI\.L #1/ || u ~ /ADDI\.L #\$1/ || n ~ /ADDQL1D0/ || n ~ /ADDQL1D1/) has_add1=1
    if (n ~ /CLRLGLOBALREFLONGGFXGADSDATA/ || n ~ /CLRLGLOBALREFLONGGFXGADSFILESIZE/ || n ~ /CLRLGLOBALREFLONGGFXGADSFILESI/) has_clear_gads=1
    if (n ~ /CLRLGLOBALREFLONGDF0LOGOLSTDATA/ || n ~ /CLRLGLOBALREFLONGDF0LOGOLSTDAT/ || n ~ /CLRLGLOBALREFLONGDF0LOGOLSTFILESIZE/ || n ~ /CLRLGLOBALREFLONGDF0LOGOLSTFIL/) has_clear_logo=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_GADS_PTR="has_gads_ptr
    print "HAS_GADS_SIZE="has_gads_size
    print "HAS_LOGO_PTR="has_logo_ptr
    print "HAS_LOGO_SIZE="has_logo_size
    print "HAS_DEALLOC_CALL="has_dealloc
    print "HAS_CONST_1988="has_const_1988
    print "HAS_CONST_1994="has_const_1994
    print "HAS_ADD_1_SIZE="has_add1
    print "HAS_CLEAR_GADS="has_clear_gads
    print "HAS_CLEAR_LOGO="has_clear_logo
    print "HAS_RTS="has_rts
}

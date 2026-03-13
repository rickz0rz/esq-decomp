BEGIN { has_entry=0; has_alloc=0; has_file=0; has_line=0; has_flags=0; has_store=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^SCRIPT_ALLOCATEBUFFERARRAY:/) has_entry=1
 if (n ~ /SCRIPTJMPTBLMEMORYALLOCATEMEMORY/ || n ~ /SCRIPTJMPTBLMEMORYALLOCATEMEMOR/ || n ~ /SCRIPTJMPTBLMEMORYALLOCATEMEM/ || n ~ /MEMORYALLOCATEMEMORY/ || n ~ /MEMORYALLOCATEMEMOR/ || n ~ /MEMORYALLOCATEMEM/) has_alloc=1
 if (n ~ /GLOBALSTRSCRIPTC1/ || n ~ /GLOBALSCRIPTC1/) has_file=1
 if (u ~ /394/ || u ~ /\$18A/) has_line=1
 if (u ~ /65537/ || u ~ /\$10001/ || (u ~ /MEMF_PUBLIC/ && u ~ /MEMF_CLEAR/)) has_flags=1
 if (u ~ /^MOVE\.L D0,0\(A3,D[01]\.L\)$/ || u ~ /^MOVE\.L D0,\$0\(A5,D[01]\.L\)$/) has_store=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_ALLOC="has_alloc; print "HAS_FILE="has_file; print "HAS_LINE="has_line; print "HAS_FLAGS="has_flags; print "HAS_STORE="has_store; print "HAS_RETURN="has_return }

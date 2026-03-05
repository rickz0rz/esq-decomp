BEGIN { has_entry=0; has_free=0; has_file=0; has_line=0; has_clear=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^SCRIPT_DEALLOCATEBUFFERARRAY:/) has_entry=1
 if (n ~ /SCRIPTJMPTBLMEMORYDEALLOCATEMEMORY/ || n ~ /SCRIPTJMPTBLMEMORYDEALLOCATEMEMOR/ || n ~ /SCRIPTJMPTBLMEMORYDEALLOCATEM/) has_free=1
 if (n ~ /GLOBALSTRSCRIPTC2/ || n ~ /GLOBALSCRIPTC2/) has_file=1
 if (u ~ /405/ || u ~ /\$195/) has_line=1
 if (u ~ /^CLR\.L 0\(A3,D0\.L\)$/ || u ~ /^CLR\.L 0\(A3,D[01]\.L\)$/ || u ~ /^CLR\.L \$0\(A5,D[01]\.L\)$/) has_clear=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_FREE="has_free; print "HAS_FILE="has_file; print "HAS_LINE="has_line; print "HAS_CLEAR="has_clear; print "HAS_RETURN="has_return }

BEGIN { has_entry=0; has_count=0; has_wildcard=0; has_index=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^TLIBA_FINDFIRSTWILDCARDMATCHINDEX:/ || u ~ /^TLIBA_FINDFIRSTWILDCARDMATCHIND[A-Z0-9_]*:/) has_entry=1
 if (n ~ /TEXTDISPSECONDARYGROUPENTRYCOUNT/ || n ~ /TEXTDISPSECONDARYTITLEPTRTABLE/) has_count=1
 if (n ~ /UNKNOWNJMPTBLESQWILDCARDMATCH/ || n ~ /UNKNOWNJMPTBLESQWILDCARDMAT/ || n ~ /ESQWILDCARDMATCH/) has_wildcard=1
 if (u ~ /^MOVE\.L D7,D6/ || u ~ /^MOVE\.L D6,D0/ || n ~ /MOVEQD6/) has_index=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_COUNT="has_count; print "HAS_WILDCARD="has_wildcard; print "HAS_INDEX="has_index; print "HAS_RETURN="has_return }

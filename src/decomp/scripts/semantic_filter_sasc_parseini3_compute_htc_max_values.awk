BEGIN { has_entry=0; has_sub=0; has_wrap=0; has_max_read=0; has_max_write=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_COMPUTEHTCMAXVALUES:/ || u ~ /^PARSEINI_COMPUTEHTCMAXVAL[A-Z0-9_]*:/) has_entry=1
 if (u ~ /^SUB\.L D[0-7],D[0-7]$/) has_sub=1
 if (u ~ /64000/ || u ~ /\$FA00/) has_wrap=1
 if (n ~ /GLOBALWORDMAXVALUE/) has_max_read=1
 if (u ~ /^MOVE\.W D[0-7],GLOBAL_WORD_MAX_VALUE/ || u ~ /GLOBAL_WORD_MAX_VALUE\(A4\)/) has_max_write=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_SUB="has_sub; print "HAS_WRAP="has_wrap; print "HAS_MAX_READ="has_max_read; print "HAS_MAX_WRITE="has_max_write; print "HAS_RETURN="has_return }

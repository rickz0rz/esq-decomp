BEGIN { has_entry=0; has_head_guard=0; has_compare=0; has_alloc=0; has_tagbyte=0; has_head_store=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_LOADWEATHERSTRINGS:/ || u ~ /^PARSEINI_LOADWEATHERSTRING[A-Z0-9_]*:/) has_entry=1
 if (n ~ /PARSEINIBANNERBRUSHRESOURCEHEAD/ || n ~ /PARSEINIWEATHERBRUSHNODEPTR/) has_head_guard=1
 if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASE/ || n ~ /PARSEINIJMPTBLSTRINGCOMPARENO/ || n ~ /PARSEINITAGFILENAMEWEATHERSTRING/ || n ~ /PARSEINITAGFILENAMEWEATHERSTR/) has_compare=1
 if (n ~ /PARSEINIJMPTBLBRUSHALLOCBRUSHNODE/ || n ~ /PARSEINIJMPTBLBRUSHALLOCBRUSHNOD/ || n ~ /PARSEINIJMPTBLBRUSHALLOCBRUSH/) has_alloc=1
 if (u ~ /190\(/ || u ~ /\$BE\(/ || u ~ /#10/) has_tagbyte=1
 if (n ~ /PARSEINIBANNERBRUSHRESOURCEHEAD/ && u ~ /^MOVE\.L [DA][0-7],PARSEINI_BANNERBRUSHRESOURCEHEAD/) has_head_store=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_HEAD_GUARD="has_head_guard; print "HAS_COMPARE="has_compare; print "HAS_ALLOC="has_alloc; print "HAS_TAGBYTE="has_tagbyte; print "HAS_HEAD_STORE="has_head_store; print "HAS_RETURN="has_return }

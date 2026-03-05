BEGIN { has_entry=0; has_fallback=0; has_loop=0; has_sprintf=0; has_append=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^TLIBA1_FORMATCLOCKFORMATENTRY:/ || u ~ /^TLIBA1_FORMATCLOCKFORMATENTR[A-Z0-9_]*:/) has_entry=1
 if (n ~ /TEXTDISPFORMATENTRYFALLBACKTABLE/ || n ~ /TLIBA1FORMATFALLBACKBUFFER/ || n ~ /TLIBA1FORMATFALLBACKFIELDPTR/) has_fallback=1
 if (n ~ /DBFD0/ || n ~ /CMPI.L200/ || n ~ /CMPIL200/) has_loop=1
 if (n ~ /WDISPSPRINTF/ || n ~ /WDISPSPRINTF/) has_sprintf=1
 if (n ~ /STRINGAPPENDATNULL/ || n ~ /STRINGAPPENDATNUL/) has_append=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_FALLBACK="has_fallback; print "HAS_LOOP="has_loop; print "HAS_SPRINTF="has_sprintf; print "HAS_APPEND="has_append; print "HAS_RETURN="has_return }

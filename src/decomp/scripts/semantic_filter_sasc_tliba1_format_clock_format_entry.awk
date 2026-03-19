BEGIN { has_entry=0; has_fallback=0; has_loop=0; has_sprintf=0; has_append=0; has_512=0; has_tag_adjust=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^TLIBA1_FORMATCLOCKFORMATENTRY:/ || u ~ /^TLIBA1_FORMATCLOCKFORMATENTR[A-Z0-9_]*:/) has_entry=1
 if (n ~ /TEXTDISPFORMATENTRYFALLBACKTABLE/ || n ~ /TLIBA1FORMATFALLBACKBUFFER/ || n ~ /TLIBA1FORMATFALLBACKFIELDPTR/) has_fallback=1
 if (n ~ /DBFD0/ || n ~ /CMPI.L200/ || n ~ /CMPIL200/) has_loop=1
 if (n ~ /WDISPSPRINTF/ || n ~ /WDISPSPRINTF/) has_sprintf=1
 if (n ~ /STRINGAPPENDATNULL/ || n ~ /STRINGAPPENDATNUL/) has_append=1
 if (u ~ /#\$200/ || u ~ /#512([^0-9]|$)/ || n ~ /CMPIL200/) has_512=1
 if (u ~ /#\$40/ || u ~ /#64([^0-9]|$)/ || u ~ /#\$41/ || u ~ /#65([^0-9]|$)/ || n ~ /SUBIB41/ || n ~ /SUBIB40/) has_tag_adjust=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_FALLBACK="has_fallback; print "HAS_LOOP="has_loop; print "HAS_SPRINTF="has_sprintf; print "HAS_APPEND="has_append; print "HAS_CONST_512="has_512; print "HAS_TAG_ADJUST="has_tag_adjust; print "HAS_RETURN="has_return }

BEGIN { has_entry=0; has_load=0; has_consume=0; has_findchar=0; has_compare=0; has_init_preset=0; has_replace=0; has_open=0; has_brush_queue=0; has_weather=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_PARSEINIBUFFERANDDISPATCH:/ || u ~ /^PARSEINI_PARSEINIBUFFERANDDISPAT[A-Z0-9_]*:/) has_entry=1
 if (n ~ /PARSEINIJMPTBLDISKIOLOADFILETOWORKBUFFER/ || n ~ /PARSEINIJMPTBLDISKIOLOADFILETOWORKBUFF/ || n ~ /PARSEINIJMPTBLDISKIOLOADFILET/) has_load=1
 if (n ~ /PARSEINIJMPTBLDISKIOCONSUMELINEFROMWORKBUFFER/ || n ~ /PARSEINIJMPTBLDISKIOCONSUMELINEFROMWORKBUFF/ || n ~ /PARSEINIJMPTBLDISKIOCONSUMELI/) has_consume=1
 if (n ~ /PARSEINIJMPTBLSTRFINDCHARPTR/ || n ~ /PARSEINIJMPTBLSTRFINDCHARPT/) has_findchar=1
 if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASE/ || n ~ /PARSEINIJMPTBLSTRINGCOMPARENO/) has_compare=1
 if (n ~ /PARSEINIJMPTBLGCOMMANDINITPRESETTABLEFROMPALETTE/ || n ~ /PARSEINIJMPTBLGCOMMANDINITPRESETTABLE/ || n ~ /PARSEINIJMPTBLGCOMMANDINITPRE/) has_init_preset=1
 if (n ~ /PARSEINIJMPTBLESQPARSREPLACEOWNEDSTRING/ || n ~ /PARSEINIJMPTBLESQPARSREPLACEOWNEDSTR/ || n ~ /PARSEINIJMPTBLESQPARSREPLACEO/) has_replace=1
 if (n ~ /PARSEINIJMPTBLESQIFFQUEUEIFFBRUSHLOAD/ || n ~ /PARSEINIJMPTBLESQIFFHANDLEBRUSHINIRELOADHOTKEY/ || n ~ /PARSEINIJMPTBLESQIFFQUEUEIFFBRUSH/ || n ~ /PARSEINIJMPTBLESQIFFHANDLEBRUSH/) has_brush_queue=1
 if (n ~ /PARSEINIPROCESSWEATHERBLOCKS/ || n ~ /PARSEINILOADWEATHERSTRINGS/ || n ~ /PARSEINILOADWEATHERMESSAGESTRINGS/ || n ~ /PARSEINIPARSECOLORTABLE/ || n ~ /PARSEINILOADWEATHERMESSAGES/) has_weather=1
 if (u ~ /^RTS$/) has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_LOAD="has_load; print "HAS_CONSUME="has_consume; print "HAS_FINDCHAR="has_findchar; print "HAS_COMPARE="has_compare; print "HAS_INIT_PRESET="has_init_preset; print "HAS_REPLACE="has_replace; print "HAS_OPEN="has_open; print "HAS_BRUSH_QUEUE="has_brush_queue; print "HAS_WEATHER="has_weather; print "HAS_RETURN="has_return }

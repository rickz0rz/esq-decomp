BEGIN { has_entry=0; has_mode=0; has_sprintf=0; has_compare=0; has_parsehex=0; has_triples=0; has_copper=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_PARSECOLORTABLE:/ || u ~ /^PARSEINI_PARSECOLORTABL[A-Z0-9_]*:/) has_entry=1
 if (u ~ /#4/ || u ~ /#5/ || n ~ /KYBDCUSTOMPALETTETRIPLESRBASE/ || n ~ /ESQFUNCBASEPALETTERGBTRIPLES/) has_mode=1
 if (n ~ /PARSEINIJMPTBLWDISPSPRINTF/ || n ~ /GLOBALSTRCOLORPERCENTD/) has_sprintf=1
 if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASE/ || n ~ /PARSEINIJMPTBLSTRINGCOMPARENO/) has_compare=1
 if (n ~ /SCRIPT3JMPTBLLADFUNCPARSEHEXDIGIT/ || n ~ /SCRIPT3JMPTBLLADFUNCPARSEHEXD/) has_parsehex=1
 if (u ~ /LSL\.L #2/ || u ~ /ASL\.L #2/ || u ~ /^ADD\.L D[0-7],D[0-7]$/ || u ~ /^MOVE\.B D[0-7],\$0\(A2,D[0-7]\.L\)$/ || u ~ /^MOVE\.B D[0-7],0\(A0,D[0-7]\.L\)$/) has_triples=1
 if (n ~ /TEXTDISPJMPTBLESQIFFRUNCOPPERRISETRANSITION/ || n ~ /TEXTDISPJMPTBLESQIFFRUNCOPPERRISETRANSITIO/ || n ~ /TEXTDISPJMPTBLESQIFFRUNCOPPER/) has_copper=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_MODE="has_mode; print "HAS_SPRINTF="has_sprintf; print "HAS_COMPARE="has_compare; print "HAS_PARSEHEX="has_parsehex; print "HAS_TRIPLES="has_triples; print "HAS_COPPER="has_copper; print "HAS_RETURN="has_return }

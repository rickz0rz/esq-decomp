BEGIN { has_entry=0; has_classcheck=0; has_shift4=0; has_call=0; has_accum=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_PARSEHEXVALUEFROMSTRING:/ || u ~ /^PARSEINI_PARSEHEXVALUEFROMSTRIN[A-Z0-9_]*:/) has_entry=1
 if (n ~ /WDISPCHARCLASSTABLE/ || u ~ /BTST #7/ || u ~ /ANDI\.B #\$80/) has_classcheck=1
 if (u ~ /ASL\.L #4/ || u ~ /LSL\.L #4/ || u ~ /ADD\.L D[0-7],D[0-7]/) has_shift4=1
 if (n ~ /SCRIPT3JMPTBLLADFUNCPARSEHEXDIGIT/ || n ~ /SCRIPT3JMPTBLLADFUNCPARSEHEXDIGI/ || n ~ /SCRIPT3JMPTBLLADFUNCPARSEHEXD/ ||
     n ~ /LADFUNCPARSEHEXDIGIT/ || n ~ /LADFUNCPARSEHEXDIGI/ || n ~ /LADFUNCPARSEHEXD/) has_call=1
 if (u ~ /^ADD\.L D[0-7],D[0-7]$/ || u ~ /^ADD\.W D[0-7],D[0-7]$/ || u ~ /^OR\.B D[0-7],D[0-7]$/) has_accum=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_CLASSCHECK="has_classcheck; print "HAS_SHIFT4="has_shift4; print "HAS_CALL="has_call; print "HAS_ACCUM="has_accum; print "HAS_RETURN="has_return }

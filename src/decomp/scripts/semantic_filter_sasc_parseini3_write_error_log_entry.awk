BEGIN { has_entry=0; has_guard=0; has_open=0; has_write=0; has_close=0; has_eof_write=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_WRITEERRORLOGENTRY:/ || u ~ /^PARSEINI_WRITEERRORLOGENTR[A-Z0-9_]*:/) has_entry=1
 if (n ~ /NEWGRID2ERRORLOGENTRYPTR/ || u ~ /^TST\.L D[0-7]$/) has_guard=1
 if (n ~ /SCRIPTJMPTBLDISKIOOPENFILEWITHBUFFER/ || n ~ /SCRIPTJMPTBLDISKIOOPENFILEWITHBUFFE/ || n ~ /SCRIPTJMPTBLDISKIOOPENFILEWIT/) has_open=1
 if (n ~ /SCRIPTJMPTBLDISKIOWRITEBUFFEREDBYTES/ || n ~ /SCRIPTJMPTBLDISKIOWRITEBUFFEREDBYTE/ || n ~ /SCRIPTJMPTBLDISKIOWRITEBUFFER/) has_write=1
 if (n ~ /SCRIPTJMPTBLDISKIOCLOSEBUFFEREDFILEANDFLUSH/ || n ~ /SCRIPTJMPTBLDISKIOCLOSEBUFFEREDFILEANDFLUS/ || n ~ /SCRIPTJMPTBLDISKIOCLOSEBUFFER/) has_close=1
 if (u ~ /#1/ || u ~ /\$1/ || n ~ /CLOCKFILEEOFMARKERCTRLZ/) has_eof_write=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_GUARD="has_guard; print "HAS_OPEN="has_open; print "HAS_WRITE="has_write; print "HAS_CLOSE="has_close; print "HAS_EOF_WRITE="has_eof_write; print "HAS_RETURN="has_return }

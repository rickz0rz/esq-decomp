BEGIN { has_entry=0; has_gate=0; has_read5=0; has_ticks=0; has_thresh20=0; has_ext=0; has_entrycount=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^SCRIPT_POLLHANDSHAKEANDAPPLYTIMEOUT:/ || u ~ /^SCRIPT_POLLHANDSHAKEANDAPPLYTIME[A-Z0-9_]*:/) has_entry=1
 if (n ~ /SCRIPTCTRLINTERFACEENABLEDFLAG/ || n ~ /SCRIPTCTRLINTERFACEENABLEDFLA/) has_gate=1
 if (n ~ /SCRIPTREADHANDSHAKEBIT5MASK/ || n ~ /SCRIPTREADHANDSHAKEBIT5MAS/) has_read5=1
 if (n ~ /SCRIPTCTRLLINEASSERTEDTICKS/ || n ~ /SCRIPTCTRLLINEASSERTEDTIC/) has_ticks=1
 if (u ~ /#20/ || u ~ /[^0-9]20[^0-9]/ || u ~ /\$14/) has_thresh20=1
 if (n ~ /ESQIFFEXTERNALASSETFLAGS/ || n ~ /ESQIFFEXTERNALASSETFLAG/) has_ext=1
 if (n ~ /LADFUNCENTRYCOUNT/ || n ~ /LADFUNCENTRYCOUN/) has_entrycount=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_GATE="has_gate; print "HAS_READ5="has_read5; print "HAS_TICKS="has_ticks; print "HAS_THRESH20="has_thresh20; print "HAS_EXT="has_ext; print "HAS_ENTRYCOUNT="has_entrycount; print "HAS_RETURN="has_return }

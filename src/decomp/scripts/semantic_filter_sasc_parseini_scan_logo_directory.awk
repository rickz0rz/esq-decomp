BEGIN { has_entry=0; has_exec=0; has_open=0; has_readline=0; has_findsep=0; has_alloc=0; has_finalize=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_SCANLOGODIRECTORY:/ || u ~ /^PARSEINI_SCANLOGODIRECTOR[A-Z0-9_]*:/) has_entry=1
 if (n ~ /LVOEXECUTE/ || n ~ /GLOBALSTRLISTRAMLOGODIRTXTDH2LOGOSNOHEADQUICK/) has_exec=1
 if (n ~ /PARSEINIJMPTBLHANDLEOPENWITHMODE/ || n ~ /PARSEINIJMPTBLHANDLEOPENWITHM/ || n ~ /PARSEINIPATHDF0COLONLOGODOTLST/ || n ~ /PARSEINIPATHDF0COLONLOGODOT/ || n ~ /PARSEINIPATHRAMCOLONLOGODIRDOTTXT/ || n ~ /PARSEINIPATHRAMCOLONLOGODIR/) has_open=1
 if (n ~ /PARSEINIJMPTBLSTREAMREADLINEWITHLIMIT/ || n ~ /PARSEINIJMPTBLSTREAMREADLINEW/) has_readline=1
 if (n ~ /PARSEINIJMPTBLGCOMMANDFINDPATHSEPARATOR/ || n ~ /PARSEINIJMPTBLGCOMMANDFINDPAT/) has_findsep=1
 if (n ~ /SCRIPTJMPTBLMEMORYALLOCATEMEMORY/ || n ~ /GLOBALSTRPARSEINIC4/ || n ~ /GLOBALSTRPARSEINIC5/) has_alloc=1
 if (n ~ /PARSEINIJMPTBLUNKNOWN36FINALIZEREQUEST/ || n ~ /PARSEINIJMPTBLUNKNOWN36FINALI/) has_finalize=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_EXEC="has_exec; print "HAS_OPEN="has_open; print "HAS_READLINE="has_readline; print "HAS_FINDSEP="has_findsep; print "HAS_ALLOC="has_alloc; print "HAS_FINALIZE="has_finalize; print "HAS_RETURN="has_return }

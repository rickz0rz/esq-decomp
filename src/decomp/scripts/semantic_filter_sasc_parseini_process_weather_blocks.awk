BEGIN { has_entry=0; has_compare=0; has_alloc_brush=0; has_read_long=0; has_alloc_mem=0; has_copy_id=0; has_source_list=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^PARSEINI_PROCESSWEATHERBLOCKS:/ || u ~ /^PARSEINI_PROCESSWEATHERBLOC[A-Z0-9_]*:/) has_entry=1
 if (n ~ /PARSEINIJMPTBLSTRINGCOMPARENOCASE/ || n ~ /PARSEINIJMPTBLSTRINGCOMPARENO/ || n ~ /STRINGCOMPARENOCASE/ || n ~ /PARSEINITAGSOURCE/ || n ~ /PARSEINISTRLOADCOLOR/) has_compare=1
 if (n ~ /PARSEINIJMPTBLBRUSHALLOCBRUSHNODE/ || n ~ /PARSEINIJMPTBLBRUSHALLOCBRUSHNOD/ || n ~ /PARSEINIJMPTBLBRUSHALLOCBRUSH/ || n ~ /BRUSHALLOCBRUSHNODE/) has_alloc_brush=1
 if (n ~ /SCRIPT3JMPTBLPARSEREADSIGNEDLONGSKIPCLASS3ALT/ || n ~ /SCRIPT3JMPTBLPARSEREADSIGNEDLONGSKIPCLASS3AL/ || n ~ /SCRIPT3JMPTBLPARSEREADSIGNEDL/ || n ~ /PARSEREADSIGNEDLONGSKIPCLASS3ALT/ || n ~ /PARSEREADSIGNEDLONGSKIPCLASS3A/) has_read_long=1
 if (n ~ /SCRIPTJMPTBLMEMORYALLOCATEMEMORY/ || n ~ /MEMORYALLOCATEMEMORY/ || n ~ /GLOBALSTRPARSEINIC3/) has_alloc_mem=1
 if (n ~ /SCRIPT3JMPTBLSTRINGCOPYPADNUL/ || n ~ /SCRIPT3JMPTBLSTRINGCOPYPADNU/ || n ~ /STRINGCOPYPADNUL/) has_copy_id=1
 if (n ~ /PARSEINICURRENTWEATHERBLOCKTEMP/ || n ~ /PARSEINICURRENTWEATHERBLOCKPTR/ || n ~ /PARSEINIPARSEDDESCRIPTORLISTHEA/ || n ~ /PARSEINIPARSEDDESCRIPTORLISTHEAD/) has_source_list=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_COMPARE="has_compare; print "HAS_ALLOC_BRUSH="has_alloc_brush; print "HAS_READ_LONG="has_read_long; print "HAS_ALLOC_MEM="has_alloc_mem; print "HAS_COPY_ID="has_copy_id; print "HAS_SOURCE_LIST="has_source_list; print "HAS_RETURN="has_return }

BEGIN { has_entry=0; has_latch=0; has_shadow=0; has_mask3=0; has_maskfc=0; has_write=0; has_return=0 }
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^SCRIPT_UPDATESERIALSHADOWFROMCTRLBYTE:/ || u ~ /^SCRIPT_UPDATESERIALSHADOWFROMCTR[A-Z0-9_]*:/) has_entry=1
 if (n ~ /SCRIPTSERIALINPUTLATCH/ || n ~ /SCRIPTSERIALINPUTLATC/) has_latch=1
 if (n ~ /SCRIPTSERIALSHADOWWORD/ || n ~ /SCRIPTSERIALSHADOWWOR/) has_shadow=1
 if (u ~ /#3/ || u ~ /[^0-9]3[^0-9]/) has_mask3=1
 if (u ~ /\$FC/ || u ~ /#252/ || u ~ /[^0-9]252[^0-9]/ || u ~ /#126/ || u ~ /[^0-9]126[^0-9]/) has_maskfc=1
 if (n ~ /SCRIPTWRITECTRLSHADOWTOSERDAT/ || n ~ /SCRIPTWRITECTRLSHADOWTOSERDA/) has_write=1
 if (u=="RTS") has_return=1
}
END { print "HAS_ENTRY="has_entry; print "HAS_LATCH="has_latch; print "HAS_SHADOW="has_shadow; print "HAS_MASK3="has_mask3; print "HAS_MASKFC="has_maskfc; print "HAS_WRITE="has_write; print "HAS_RETURN="has_return }

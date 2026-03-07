BEGIN{h_entry=0;h_tag=0;h_channel=0;h_loop=0;h_find=0;h_time=0;h_special=0;h_fallback=0;h_selected=0;h_usage=0;h_group=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
 l=t($0); if(l=="")next
 if(l ~ /^TEXTDISP_SELECTBESTMATCHFROMLIST:/ || l ~ /^TEXTDISP_SELECTBESTMATCHFROMLIST[A-Z0-9_]*:/)h_entry=1
 if(l ~ /TAG_SPT_SELECT/ || l ~ /COMPARE_SPT_PREFIX/ || l ~ /-13\(A5\)/)h_tag=1
 if(l ~ /CHANNEL/ || l ~ /GLOBAL_STR_TEXTDISP_C_3/ || l ~ /RETURN_ERROR/)h_channel=1
 if(l ~ /CANDIDATE_LOOP/ || l ~ /ADDQ\.W #1,D5/ || l ~ /ADDQ\.L #1,D5/ || l ~ /ADDQ\.L #\$1,D5/)h_loop=1
 if(l ~ /(JSR|BSR).*FINDENTRYMATCHINDEX/ || l ~ /FINDENTRYMATCHINDEX/)h_find=1
 if(l ~ /(JSR|BSR).*COMPUTETIMEOFFSET/ || l ~ /COMPUTETIMEOFFSET/)h_time=1
 if(l ~ /BANNERSELECTEDISSPECIALFLAG/ || l ~ /BANNERFALLBACKISSPECIALFLAG/ || l ~ /STORE_SPECIAL_FLAG/ || l ~ /BANNERSELECTEDISSPECIAL/ || l ~ /BANNERFALLBACKISSPECIAL/ || l ~ /ISSPECIAL/)h_special=1
 if(l ~ /BANNERFALLBACKVALIDFLAG/ || l ~ /BANNERCHARFALLBACK/ || l ~ /FALLBACK/)h_fallback=1
 if(l ~ /BANNERSELECTEDVALIDFLAG/ || l ~ /BANNERCHARSELECTED/ || l ~ /SELECTED/)h_selected=1
 if(l ~ /\+400/ || l ~ /#\$190/ || l ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || l ~ /ADDQ\.W #1,0\(A0,D2\.L\)/ || l ~ /AFTER_USAGE_TABLE/)h_usage=1
 if(l ~ /PRIMARYTITLEPTRTABLE/ || l ~ /SECONDARYTITLEPTRTABLE/ || l ~ /ACTIVEGROUPID/)h_group=1
 if(l=="RTS")h_rts=1
}
END{
 print "HAS_ENTRY="h_entry
 print "HAS_SPT_TAG_CHECK="h_tag
 print "HAS_CHANNEL_RANGE="h_channel
 print "HAS_CANDIDATE_LOOP="h_loop
 print "HAS_FIND_MATCH_CALLS="h_find
 print "HAS_TIME_OFFSET_CALLS="h_time
 print "HAS_SPECIAL_FLAG_PATH="h_special
 print "HAS_FALLBACK_SELECTION="h_fallback
 print "HAS_SELECTED_SELECTION="h_selected
 print "HAS_USAGE_COUNTER_UPDATE="h_usage
 print "HAS_GROUP_TABLE_SWITCH="h_group
 print "HAS_RTS="h_rts
}

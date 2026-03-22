BEGIN{
 h_entry=0;h_init=0;h_tag=0;h_channel=0;h_loop=0
 h_find=0;h_find_mode1=0;h_find_mode2=0;h_find_mode3=0;h_find_mode0=0
 h_time=0;h_special=0;h_fallback=0;h_selected=0;h_usage=0;h_group=0
 h_findmode_return=0;h_finalize=0;h_return_error=0;h_return_ok=0;h_return_found=0;h_rts=0
 prev=""
 prev2=""
 prev3=""
}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
 l=t($0); if(l=="")next
 if(l ~ /^TEXTDISP_SELECTBESTMATCHFROMLIST:/ || l ~ /^TEXTDISP_SELECTBESTMATCHFROMLIST[A-Z0-9_]*:/)h_entry=1
 if(l ~ /BANNERCHARSELECTED/ && l ~ /#\$64/)h_init=1
 if((l ~ /TAG_SPT_SELECT/ || l ~ /COMPARE_SPT_PREFIX/ || l ~ /CMP\.B .*D1/ || l ~ /MOVE\.B #\$8/) && (l ~ /TAG_SPT_SELECT/ || prev ~ /TAG_SPT_SELECT/ || prev ~ /CMP\.B .*D1/ || prev ~ /TST\.B D0/))h_tag=1
 if(l ~ /GLOBAL_STR_TEXTDISP_C_3/ || l ~ /CLOCK_CURRENTDAYOFWEEKINDEX/ || l ~ /ASL\.L D0,D1/ || l ~ /BSET D0,D2/ || l ~ /MOVEQ\.L #\$30,D6/ || l ~ /MOVEQ #48,D6/ || l ~ /RETURN_ERROR/)h_channel=1
 if(l ~ /CANDIDATE_LOOP/ || l ~ /ADDQ\.W #1,D5/ || l ~ /ADDQ\.L #1,D5/ || l ~ /ADDQ\.L #\$1,D5/)h_loop=1
 if(l ~ /(JSR|BSR).*FINDENTRYMATCHINDEX/ || l ~ /FINDENTRYMATCHINDEX/){
  h_find=1
  if(l ~ /PEA 1\.W/ || l ~ /PEA \(\$1\)\.W/ || prev ~ /PEA 1\.W/ || prev ~ /PEA \(\$1\)\.W/ || prev2 ~ /PEA 1\.W/ || prev2 ~ /PEA \(\$1\)\.W/ || prev3 ~ /PEA 1\.W/ || prev3 ~ /PEA \(\$1\)\.W/)h_find_mode1=1
  if(l ~ /PEA 2\.W/ || l ~ /PEA \(\$2\)\.W/ || prev ~ /PEA 2\.W/ || prev ~ /PEA \(\$2\)\.W/ || prev2 ~ /PEA 2\.W/ || prev2 ~ /PEA \(\$2\)\.W/ || prev3 ~ /PEA 2\.W/ || prev3 ~ /PEA \(\$2\)\.W/)h_find_mode2=1
  if(l ~ /PEA 3\.W/ || l ~ /PEA \(\$3\)\.W/ || prev ~ /PEA 3\.W/ || prev ~ /PEA \(\$3\)\.W/ || prev2 ~ /PEA 3\.W/ || prev2 ~ /PEA \(\$3\)\.W/ || prev3 ~ /PEA 3\.W/ || prev3 ~ /PEA \(\$3\)\.W/)h_find_mode3=1
  if(l ~ /CLR\.L -\(A7\)/ || prev ~ /CLR\.L -\(A7\)/ || prev2 ~ /CLR\.L -\(A7\)/ || prev3 ~ /CLR\.L -\(A7\)/)h_find_mode0=1
 }
 if(l ~ /(JSR|BSR).*COMPUTETIMEOFFSET/ || l ~ /COMPUTETIMEOFFSET/)h_time++
 if(l ~ /BANNERSELECTEDISSPECIALFLAG/ || l ~ /BANNERFALLBACKISSPECIALFLAG/ || l ~ /STORE_SPECIAL_FLAG/ || l ~ /BANNERSELECTEDISSPECIAL/ || l ~ /BANNERFALLBACKISSPECIAL/ || l ~ /ISSPECIAL/)h_special=1
 if(l ~ /BANNERFALLBACKVALIDFLAG/ || l ~ /BANNERCHARFALLBACK/ || l ~ /FALLBACK/)h_fallback=1
 if(l ~ /BANNERSELECTEDVALIDFLAG/ || l ~ /BANNERCHARSELECTED/ || l ~ /SELECTED/)h_selected=1
 if(l ~ /\+400/ || l ~ /#\$190/ || l ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || l ~ /ADDQ\.W #1,0\(A0,D2\.L\)/ || l ~ /AFTER_USAGE_TABLE/)h_usage=1
 if(l ~ /PRIMARYTITLEPTRTABLE/ || l ~ /SECONDARYTITLEPTRTABLE/ || l ~ /ACTIVEGROUPID/)h_group=1
 if((l ~ /MOVEQ\.L #\$2,D0/ || l ~ /MOVEQ #2,D0/) && (prev ~ /FINDMODEACTIVEFLAG/ || prev ~ /SUBQ\.[BW] #1,D[0-7]/))h_findmode_return=1
 if(l ~ /CMPI\.W #\$31/ || l ~ /CMP\.W D0,D1/ || l ~ /CMP\.W D0,D6/ || l ~ /NORMALIZE_CHANNEL_CODE/ || l ~ /SET_DEFAULT_CHANNEL/)h_finalize=1
 if(l ~ /RETURN_ERROR:/ || (!h_loop && (l ~ /MOVEQ\.L #\$1,D0/ || l ~ /MOVEQ #1,D0/)))h_return_error=1
 if(l ~ /MOVEQ\.L #\$0,D0/ || l ~ /MOVEQ #0,D0/)h_return_ok=1
 if((l ~ /MOVEQ\.L #\$2,D0/ || l ~ /MOVEQ #2,D0/) && prev !~ /FINDMODEACTIVEFLAG/)h_return_found=1
 if(l=="RTS")h_rts=1
 prev3=prev2
 prev2=prev
 prev=l
}
END{
 print "HAS_ENTRY="h_entry
 print "HAS_INIT_SENTINELS="h_init
 print "HAS_SPT_TAG_CHECK="h_tag
 print "HAS_CHANNEL_RANGE="h_channel
 print "HAS_CANDIDATE_LOOP="h_loop
 print "HAS_FIND_MATCH_CALLS="h_find
 print "HAS_FIND_MODE1="h_find_mode1
 print "HAS_FIND_MODE2="h_find_mode2
 print "HAS_FIND_MODE3="h_find_mode3
 print "HAS_FIND_MODE0="h_find_mode0
 print "TIME_OFFSET_CALL_COUNT_GE_2="(h_time>=2)
 print "HAS_SPECIAL_FLAG_PATH="h_special
 print "HAS_FALLBACK_SELECTION="h_fallback
 print "HAS_SELECTED_SELECTION="h_selected
 print "HAS_USAGE_COUNTER_UPDATE="h_usage
 print "HAS_GROUP_TABLE_SWITCH="h_group
 print "HAS_FINDMODE_EARLY_RETURN="h_findmode_return
 print "HAS_FINALIZE_BRANCHES="h_finalize
 print "HAS_RETURN_ERROR="h_return_error
 print "HAS_RETURN_OK="h_return_ok
 print "HAS_RETURN_FOUND="h_return_found
 print "HAS_RTS="h_rts
}

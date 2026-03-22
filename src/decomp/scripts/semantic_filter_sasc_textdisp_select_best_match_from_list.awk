BEGIN{
 h_entry=0;h_init=0;h_tag=0;h_channel=0;h_loop=0
 h_find=0;h_find_mode1=0;h_find_mode2=0;h_find_mode3=0;h_find_mode0=0
 h_time=0;h_special=0;h_special_split=0;h_special_gate=0;h_mode3_requery=0;h_mode2_fallback_mark=0
 h_fallback=0;h_selected=0;h_usage=0;h_usage_bump=0;h_group=0
 h_usage_fetch=0;h_usage_cmp=0;h_usage_prefers_lower=0;h_pos_selected_valid=0;h_best_pos_store=0;h_best_neg_store=0;h_prev_usage_store=0;h_final_usage_bump=0
 h_findmode_return=0;h_last_match_store=0;h_finalize=0;h_finalize_sentinel=0;h_channel_default68=0;h_return_error=0;h_return_ok=0;h_return_found=0;h_rts=0
 saw_prev_usage_load=0; saw_usage_increment=0; saw_halfhour_cmp=0; saw_positive_time_test=0
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
  if((l ~ /CLR\.L -\(A7\)/ || prev ~ /CLR\.L -\(A7\)/ || prev2 ~ /CLR\.L -\(A7\)/ || prev3 ~ /CLR\.L -\(A7\)/) &&
     (l ~ /SBEFILTERACTIVEFLAG/ || prev ~ /SBEFILTERACTIVEFLAG/ || prev2 ~ /SBEFILTERACTIVEFLAG/ || prev3 ~ /SBEFILTERACTIVEFLAG/ ||
      l ~ /CMP\.W .*#\$31/ || prev ~ /CMP\.W .*#\$31/ || prev2 ~ /CMP\.W .*#\$31/ || prev3 ~ /CMP\.W .*#\$31/))h_find_mode0=1
 }
 if(l ~ /(JSR|BSR).*COMPUTETIMEOFFSET/ || l ~ /COMPUTETIMEOFFSET/)h_time++
 if(l ~ /BANNERSELECTEDISSPECIALFLAG/ || l ~ /BANNERFALLBACKISSPECIALFLAG/ || l ~ /STORE_SPECIAL_FLAG/ || l ~ /BANNERSELECTEDISSPECIAL/ || l ~ /BANNERFALLBACKISSPECIAL/ || l ~ /ISSPECIAL/)h_special=1
 if((l ~ /ACTIVEGROUPID/ || prev ~ /ACTIVEGROUPID/ || prev2 ~ /ACTIVEGROUPID/) &&
    (l ~ /CLOCK_HALFHOURSLOTINDEX/ || prev ~ /CLOCK_HALFHOURSLOTINDEX/ || prev2 ~ /CLOCK_HALFHOURSLOTINDEX/) &&
    (l ~ /STORE_SPECIAL_FLAG/ || prev ~ /STORE_SPECIAL_FLAG/ || prev2 ~ /STORE_SPECIAL_FLAG/ ||
     l ~ /BANNERSELECTEDISSPECIALFLAG/ || l ~ /BANNERFALLBACKISSPECIALFLAG/))h_special_split=1
 if((l ~ /CLOCK_HALFHOURSLOTINDEX/ || prev ~ /CLOCK_HALFHOURSLOTINDEX/) &&
    (l ~ /CMP\.[WL] D[0-7],D[0-7]/ || prev ~ /CMP\.[WL] D[0-7],D[0-7]/) &&
    (l ~ /TST\.[WL] D0/ || prev ~ /TST\.[WL] D0/) &&
    (l ~ /MOVEQ\.L #\$1,D[0-7]/ || l ~ /MOVEQ #1,D[0-7]/ ||
     prev ~ /MOVEQ\.L #\$1,D[0-7]/ || prev ~ /MOVEQ #1,D[0-7]/))h_special_gate=1
 if(l ~ /BANNERFALLBACKVALIDFLAG/ || l ~ /BANNERCHARFALLBACK/ || l ~ /FALLBACK/)h_fallback=1
 if(l ~ /BANNERSELECTEDVALIDFLAG/ || l ~ /BANNERCHARSELECTED/ || l ~ /SELECTED/)h_selected=1
 if(l ~ /\+400/ || l ~ /#\$190/ || l ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || l ~ /ADDQ\.W #1,0\(A0,D2\.L\)/ || l ~ /AFTER_USAGE_TABLE/)h_usage=1
 if(l ~ /TEXTDISP_GETUSAGECOUNT/ || l ~ /ADDI?\.L #400,D[134]/ || l ~ /ADD\.L #\$190,D[123]/ || l ~ /MOVE\.W \$28\(A7\),D0/)h_usage_fetch=1
 if((l ~ /CMP\.W 0\(A0,D3\.L\),D2/ || l ~ /CMP\.W 0\(A0,D4\.L\),D3/) ||
    ((l ~ /CMP\.W D1,D2/ || l ~ /CMP\.L D1,D0/) &&
     (prev ~ /\$2C\(A7\)/ || prev ~ /\$30\(A7\)/ || prev2 ~ /\$2C\(A7\)/ || prev2 ~ /\$30\(A7\)/)))h_usage_cmp=1
 if(((l ~ /BLS\.[BSWL]?/ || l ~ /BLS /) &&
     (prev ~ /CMP\.W 0\(A0,D3\.L\),D2/ || prev ~ /CMP\.W 0\(A0,D4\.L\),D3/)) ||
    ((l ~ /BCC\.[BSWL]?/ || l ~ /BCC /) &&
     (prev ~ /CMP\.W D1,D2/ || prev ~ /CMP\.L D1,D0/) &&
     ((prev2 ~ /\$2C\(A7\)/ && prev3 ~ /\$28\(A7\)/) ||
      (prev2 ~ /\$30\(A7\)/ && prev3 ~ /\$28\(A7\)/) ||
      (prev3 ~ /\$2C\(A7\)/ && prev2 ~ /\$28\(A7\)/) ||
      (prev3 ~ /\$30\(A7\)/ && prev2 ~ /\$28\(A7\)/))))h_usage_prefers_lower=1
 if(l ~ /MOVE\.B D[0-7],TEXTDISP_BANNERSELECTEDVALIDFLAG/)h_pos_selected_valid=1
 if(l ~ /MOVE\.W D0,-20\(A5\)/ || l ~ /MOVE\.W D0,\$30\(A7\)/)h_best_pos_store=1
 if(l ~ /MOVE\.W D0,-22\(A5\)/ || l ~ /MOVE\.W D0,\$2E\(A7\)/)h_best_neg_store=1
 if(l ~ /MOVE\.W \$28\(A7\),D0/)saw_prev_usage_load=1
 if(l ~ /MOVE\.W 0\(A0,D1\.L\),-12\(A5\)/ ||
    (l ~ /MOVE\.W D0,\$2C\(A7\)/ && saw_prev_usage_load))h_prev_usage_store=1
 if(l ~ /ADDQ\.W #1,D1/ || l ~ /ADDQ\.W #\$1,D1/)saw_usage_increment=1
 if(l ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || l ~ /ADDQ\.W #\$1,0\(A0,D1\.L\)/)h_final_usage_bump=1
 if((l ~ /MOVE\.W D1,0\(A0,D1\.L\)/ ||
     (l ~ /MOVE\.W D1,/ && l ~ /A0,D3\.L\)/) ||
     (l ~ /MOVE\.W D1,/ && l ~ /A0,D1\.L\)/)) && saw_usage_increment)h_final_usage_bump=1
 if((l ~ /BANNERSELECTEDENTRYINDEX/ || prev ~ /BANNERSELECTEDENTRYINDEX/ || prev2 ~ /BANNERSELECTEDENTRYINDEX/) &&
    (l ~ /PRIMARYTITLEPTRTABLE/ || l ~ /SECONDARYTITLEPTRTABLE/ || prev ~ /PRIMARYTITLEPTRTABLE/ || prev ~ /SECONDARYTITLEPTRTABLE/ ||
     prev2 ~ /PRIMARYTITLEPTRTABLE/ || prev2 ~ /SECONDARYTITLEPTRTABLE/) &&
    (l ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || l ~ /ADDQ\.W #1,0\(A0,D0\.L\)/ || l ~ /AFTER_USAGE_TABLE/ ||
     prev ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || prev ~ /ADDQ\.W #1,0\(A0,D0\.L\)/ || prev ~ /AFTER_USAGE_TABLE/ ||
     prev2 ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || prev2 ~ /ADDQ\.W #1,0\(A0,D0\.L\)/ || prev2 ~ /AFTER_USAGE_TABLE/))h_usage_bump=1
 if(l ~ /PRIMARYTITLEPTRTABLE/ || l ~ /SECONDARYTITLEPTRTABLE/ || l ~ /ACTIVEGROUPID/)h_group=1
 if((l ~ /MOVEQ\.L #\$2,D0/ || l ~ /MOVEQ #2,D0/) && (prev ~ /FINDMODEACTIVEFLAG/ || prev ~ /SUBQ\.[BW] #1,D[0-7]/))h_findmode_return=1
 if((l ~ /PEA 3\.W/ || l ~ /PEA \(\$3\)\.W/ || prev ~ /PEA 3\.W/ || prev ~ /PEA \(\$3\)\.W/) &&
    (l ~ /CLOCK_HALFHOURSLOTINDEX/ || prev ~ /CLOCK_HALFHOURSLOTINDEX/ || prev2 ~ /CLOCK_HALFHOURSLOTINDEX/) &&
    (l ~ /TST\.[WL] D0/ || prev ~ /TST\.[WL] D0/ || prev2 ~ /TST\.[WL] D0/))h_mode3_requery=1
 if((l ~ /BANNERFALLBACKVALIDFLAG/ || prev ~ /BANNERFALLBACKVALIDFLAG/) &&
    (l ~ /PEA 2\.W/ || l ~ /PEA \(\$2\)\.W/ || prev ~ /PEA 2\.W/ || prev ~ /PEA \(\$2\)\.W/ ||
     prev2 ~ /PEA 2\.W/ || prev2 ~ /PEA \(\$2\)\.W/))h_mode2_fallback_mark=1
 if(l ~ /MOVE\.W D0,-6\(A5\)/ || l ~ /MOVE\.W D1,\$48\(A7\)/ || l ~ /MOVE\.W D[01],\$48\(A7\)/)h_last_match_store=1
 if(l ~ /CMPI\.W #\$31/ || l ~ /CMP\.W D0,D1/ || l ~ /CMP\.W D0,D6/ || l ~ /NORMALIZE_CHANNEL_CODE/ || l ~ /SET_DEFAULT_CHANNEL/)h_finalize=1
 if((l ~ /CMPI\.W #\$3D/ || l ~ /CMP\.W #\$3D/ || l ~ /CMPI\.W #61/) &&
    (l ~ /BANNERCHARSELECTED/ || prev ~ /BANNERCHARSELECTED/ || prev2 ~ /BANNERCHARSELECTED/))h_finalize_sentinel=1
 if(l ~ /MOVEQ\.L #\$44,D6/ || l ~ /MOVEQ #68,D6/ || l ~ /CHANNELCODE = 68/)h_channel_default68=1
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
 print "HAS_SPECIAL_FLAG_ACTIVEGROUP_SPLIT="h_special_split
 print "HAS_SPECIAL_FLAG_GATE="h_special_gate
 print "HAS_MODE3_REQUERY_GATE="h_mode3_requery
 print "HAS_MODE2_FALLBACK_MARK="h_mode2_fallback_mark
 print "HAS_FALLBACK_SELECTION="h_fallback
 print "HAS_SELECTED_SELECTION="h_selected
 print "HAS_USAGE_COUNTER_UPDATE="h_usage
 print "HAS_USAGE_COUNT_FETCH="h_usage_fetch
 print "HAS_PREVIOUS_USAGE_COMPARE="h_usage_cmp
 print "HAS_USAGE_PREFERS_LOWER_COUNT="h_usage_prefers_lower
 print "HAS_POSITIVE_SELECTED_VALID_FLAG="h_pos_selected_valid
 print "HAS_POSITIVE_BEST_DELTA_STORE="h_best_pos_store
 print "HAS_NEGATIVE_BEST_DELTA_STORE="h_best_neg_store
 print "HAS_PREVIOUS_USAGE_STORE="h_prev_usage_store
 print "HAS_FINAL_SELECTED_USAGE_BUMP="h_final_usage_bump
 print "HAS_SELECTED_USAGE_BUMP="h_usage_bump
 print "HAS_GROUP_TABLE_SWITCH="h_group
 print "HAS_FINDMODE_EARLY_RETURN="h_findmode_return
 print "HAS_LAST_MATCH_STORE="h_last_match_store
 print "HAS_FINALIZE_BRANCHES="h_finalize
 print "HAS_FINALIZE_SENTINEL_RESET="h_finalize_sentinel
 print "HAS_CHANNEL_DEFAULT68_RETURN="h_channel_default68
 print "HAS_RETURN_ERROR="h_return_error
 print "HAS_RETURN_OK="h_return_ok
 print "HAS_RETURN_FOUND="h_return_found
 print "HAS_RTS="h_rts
}

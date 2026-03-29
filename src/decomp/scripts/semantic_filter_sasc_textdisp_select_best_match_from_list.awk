BEGIN{
 h_entry=0;h_init=0;h_tag=0;h_tag_loop_advance=0;h_channel=0;h_channel_default48=0;h_weekday_gate=0;h_loop=0;h_candidate_index_store=0
 h_find=0;h_find_mode1=0;h_find_mode2=0;h_find_mode3=0;h_find_mode0=0
 h_time=0;h_special=0;h_special_split=0;h_special_gate=0;h_mode3_requery=0;h_mode2_fallback_mark=0
 h_fallback=0;h_selected=0;h_usage=0;h_usage_bump=0;h_group=0
 h_usage_fetch=0;h_usage_cmp=0;h_usage_prefers_lower=0;h_pos_selected_valid=0;h_best_pos_store=0;h_best_neg_store=0;h_prev_usage_store=0;h_final_usage_bump=0
 h_findmode_return=0;h_last_match_store=0;h_finalize=0;h_finalize_sentinel=0;h_channel_default68=0;h_finalize_digit_window=0;h_finalize_mid_window=0;h_finalize_high_window=0
 h_finalize_reload_selected=0;h_finalize_usage_slot=0;h_return_error=0;h_return_ok=0;h_return_found=0;h_rts=0
 h_init_best_pos=0;h_init_best_neg=0;h_init_prev_usage=0;h_init_last_match=0
 h_helper_call=0;h_finalize_helper_call=0;h_mode0_fallback_entry_store=0
 saw_prev_usage_load=0; saw_usage_increment=0; saw_halfhour_cmp=0; saw_positive_time_test=0
 saw_finalize_selected_entry=0; saw_finalize_selected_char=0
 saw_mode0_gate=0; saw_mode2_call=0; saw_mode3_call=0; saw_finalize_3d_cmp=0
 saw_special_activegroup=0; saw_special_halfhour=0; saw_special_store=0
 saw_usage_reload_selected=0; saw_usage_table_increment=0
 saw_weekday_table=0; saw_weekday_index=0; saw_weekday_mask=0; saw_weekday_branch=0
 saw_candidate_table=0; saw_candidate_load=0
 prev=""
 prev2=""
 prev3=""
 prev4=""
 prev5=""
}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
 l=t($0); if(l=="")next
 if(l ~ /^TEXTDISP_SELECTBESTMATCHFROMLIST:/ || l ~ /^TEXTDISP_SELECTBESTMATCHFROMLIST[A-Z0-9_]*:/)h_entry=1
 if(l ~ /BANNERCHARSELECTED/ && l ~ /#\$64/)h_init=1
 if(l ~ /(MOVE\.W #\$5A1,|MOVE\.W #1441,)/)h_init_best_pos=1
 if(l ~ /(MOVE\.W #\$[0-9A-F]*FA5F,|MOVE\.W #-1441,)/)h_init_best_neg=1
 if(l ~ /(MOVE\.W #\$[0-9A-F]*FFFA,|MOVE\.W #-6,)/)h_init_prev_usage=1
 if(l ~ /MOVE\.W #\$31,-6\(A5\)/ || l ~ /MOVE\.W #\$31,\$48\(A7\)/ || l ~ /MOVE\.W #49,\$48\(A7\)/ ||
    l ~ /MOVE\.B #\$31,TEXTDISP_BANNERCHARFALLBACK/ || l ~ /MOVE\.B D[0-7],TEXTDISP_BANNERCHARFALLBACK/)h_init_last_match=1
 if((l ~ /TAG_SPT_SELECT/ || l ~ /COMPARE_SPT_PREFIX/ || l ~ /CMP\.B .*D1/ || l ~ /MOVE\.B #\$8/) && (l ~ /TAG_SPT_SELECT/ || prev ~ /TAG_SPT_SELECT/ || prev ~ /CMP\.B .*D1/ || prev ~ /TST\.B D0/))h_tag=1
 if(l ~ /MOVE\.B \(A[01]\)\+,D1/ || l ~ /CMP\.B \(A1\)\+,D1/ ||
    l ~ /ADDQ\.L #\$1,A[012]/ || l ~ /ADDQ\.L #1,A[012]/ || l ~ /ADDQ\.L #\$1,\$4C\(A7\)/ || l ~ /ADDQ\.L #1,\$4C\(A7\)/)h_tag_loop_advance=1
 if(l ~ /GLOBAL_STR_TEXTDISP_C_3/ || l ~ /CLOCK_CURRENTDAYOFWEEKINDEX/ || l ~ /ASL\.L D0,D1/ || l ~ /BSET D0,D2/ || l ~ /MOVEQ\.L #\$30,D6/ || l ~ /MOVEQ #48,D6/ || l ~ /RETURN_ERROR/)h_channel=1
 if((l ~ /MOVEQ(\.L)? #\$30,D6/ || l ~ /MOVEQ(\.L)? #48,D6/) &&
    (prev ~ /TST\.W D6/ || prev2 ~ /TST\.W D6/))h_channel_default48=1
 if(l ~ /GLOBAL_STR_TEXTDISP_C_3/)saw_weekday_table=1
 if(l ~ /CLOCK_CURRENTDAYOFWEEKINDEX/)saw_weekday_index=1
 if(l ~ /AND\.L D[0-7],D[0-7]/)saw_weekday_mask=1
 if((l ~ /TST\.L D[0-7]/ && prev ~ /AND\.L D[0-7],D[0-7]/) ||
    ((l ~ /BNE\.[BSWL]?/ || l ~ /BEQ\.[BSWL]?/) &&
     (prev ~ /TST\.L D[0-7]/ || prev ~ /AND\.L D[0-7],D[0-7]/ || prev2 ~ /AND\.L D[0-7],D[0-7]/)))saw_weekday_branch=1
 if(saw_weekday_table && saw_weekday_index && saw_weekday_mask && saw_weekday_branch)h_weekday_gate=1
 if(l ~ /CANDIDATE_LOOP/ || l ~ /ADDQ\.W #1,D5/ || l ~ /ADDQ\.L #1,D5/ || l ~ /ADDQ\.L #\$1,D5/)h_loop=1
 if(l ~ /TEXTDISP_CANDIDATEINDEXLIST/)saw_candidate_table=1
 if(saw_candidate_table && l ~ /MOVE\.B .*D0/)saw_candidate_load=1
 if(saw_candidate_load && l ~ /MOVE\.W D0,TEXTDISP_CURRENTMATCHINDEX/)h_candidate_index_store=1
 if(l ~ /SBEFILTERACTIVEFLAG/)saw_mode0_gate=1
 if((l ~ /MOVEQ(\.L)? #\$31,D0/ || l ~ /MOVEQ(\.L)? #49,D0/ || l ~ /CMPI?\.W #\$31/ || l ~ /CMP\.W -6\(A5\),D0/ || l ~ /CMP\.W D0,D1/) &&
    (prev ~ /FINDMODEACTIVEFLAG/ || prev2 ~ /FINDMODEACTIVEFLAG/ || prev3 ~ /FINDMODEACTIVEFLAG/ ||
     prev ~ /SUBQ\.[BW] #\$1,D[0-7]/ || prev2 ~ /SUBQ\.[BW] #\$1,D[0-7]/))saw_mode0_gate=1
 if(l ~ /(JSR|BSR).*FINDENTRYMATCHINDEX/ || l ~ /FINDENTRYMATCHINDEX/){
  h_find=1
  if(l ~ /PEA 1\.W/ || l ~ /PEA \(\$1\)\.W/ || prev ~ /PEA 1\.W/ || prev ~ /PEA \(\$1\)\.W/ || prev2 ~ /PEA 1\.W/ || prev2 ~ /PEA \(\$1\)\.W/ || prev3 ~ /PEA 1\.W/ || prev3 ~ /PEA \(\$1\)\.W/)h_find_mode1=1
  if(l ~ /PEA 2\.W/ || l ~ /PEA \(\$2\)\.W/ || prev ~ /PEA 2\.W/ || prev ~ /PEA \(\$2\)\.W/ || prev2 ~ /PEA 2\.W/ || prev2 ~ /PEA \(\$2\)\.W/ || prev3 ~ /PEA 2\.W/ || prev3 ~ /PEA \(\$2\)\.W/)h_find_mode2=1
  if(l ~ /PEA 3\.W/ || l ~ /PEA \(\$3\)\.W/ || prev ~ /PEA 3\.W/ || prev ~ /PEA \(\$3\)\.W/ || prev2 ~ /PEA 3\.W/ || prev2 ~ /PEA \(\$3\)\.W/ || prev3 ~ /PEA 3\.W/ || prev3 ~ /PEA \(\$3\)\.W/)h_find_mode3=1
 if(saw_mode0_gate &&
    ((l ~ /CLR\.L -\(A7\)/) || (prev ~ /CLR\.L -\(A7\)/) || (prev2 ~ /CLR\.L -\(A7\)/) ||
     (l ~ /CLR\.L \(A7\)/) || (prev ~ /CLR\.L \(A7\)/) || (prev2 ~ /CLR\.L \(A7\)/)) &&
    (l ~ /(JSR|BSR).*FINDENTRYMATCHINDEX/ || l ~ /FINDENTRYMATCHINDEX/))h_find_mode0=1
 }
 if(saw_mode0_gate &&
    (l ~ /BANNERFALLBACKENTRYIND/ || prev ~ /BANNERFALLBACKENTRYIND/ || prev2 ~ /BANNERFALLBACKENTRYIND/) &&
    (l ~ /CURRENTMATCHINDEX/ || prev ~ /CURRENTMATCHINDEX/ || prev2 ~ /CURRENTMATCHINDEX/ || prev3 ~ /CURRENTMATCHINDEX/))h_mode0_fallback_entry_store=1
 if(l ~ /(JSR|BSR).*COMPUTETIMEOFFSET/ || l ~ /COMPUTETIMEOFFSET/)h_time++
 if(l ~ /(JSR|BSR).*TEXTDISP_GETACTIVETITLEPTR/ || l ~ /TEXTDISP_GETACTIVETITLEPTR/)h_helper_call=1
 if(l ~ /BANNERSELECTEDISSPECIALFLAG/ || l ~ /BANNERFALLBACKISSPECIALFLAG/ || l ~ /STORE_SPECIAL_FLAG/ || l ~ /BANNERSELECTEDISSPECIAL/ || l ~ /BANNERFALLBACKISSPECIAL/ || l ~ /ISSPECIAL/)h_special=1
 if(l ~ /ACTIVEGROUPID/)saw_special_activegroup=1
 if(l ~ /CLOCK_HALFHOURSLOTINDEX/)saw_special_halfhour=1
 if(l ~ /MOVE\.B D[0-7],-23\(A5\)/ || l ~ /MOVE\.B D[0-7],\$38\(A7\)/ || l ~ /MOVE\.L D[0-7],\$38\(A7\)/ ||
    l ~ /BANNERSELECTEDISSPECIALFLAG/ || l ~ /BANNERFALLBACKISSPECIALFLAG/ ||
    l ~ /BANNERSELECTEDISSPECIAL/ || l ~ /BANNERFALLBACKISSPECIAL/)saw_special_store=1
 if((l ~ /ACTIVEGROUPID/ || prev ~ /ACTIVEGROUPID/ || prev2 ~ /ACTIVEGROUPID/ || prev3 ~ /ACTIVEGROUPID/) &&
    (l ~ /CLOCK_HALFHOURSLOTINDEX/ || prev ~ /CLOCK_HALFHOURSLOTINDEX/ || prev2 ~ /CLOCK_HALFHOURSLOTINDEX/ || prev3 ~ /CLOCK_HALFHOURSLOTINDEX/) &&
    (l ~ /STORE_SPECIAL_FLAG/ || prev ~ /STORE_SPECIAL_FLAG/ || prev2 ~ /STORE_SPECIAL_FLAG/ ||
     l ~ /MOVE\.B D[0-7],-23\(A5\)/ || l ~ /MOVE\.B D[0-7],\$38\(A7\)/ || l ~ /MOVE\.L D[0-7],\$38\(A7\)/ ||
     prev ~ /MOVE\.B D[0-7],-23\(A5\)/ || prev ~ /MOVE\.B D[0-7],\$38\(A7\)/ || prev ~ /MOVE\.L D[0-7],\$38\(A7\)/ ||
     l ~ /BANNERSELECTEDISSPECIALFLAG/ || l ~ /BANNERFALLBACKISSPECIALFLAG/))h_special_split=1
 if(saw_special_activegroup && saw_special_halfhour && saw_special_store)h_special_split=1
 if(l ~ /(TST\.[WL] D0|TST\.[WL] D3|TST\.L D[0-7])/ ||
    ((l ~ /(BGT|BLE)\.[BSWL]?/ || l ~ /(BGT|BLE) /) &&
     (prev ~ /TST\.[WL] D0/ || prev ~ /TST\.[WL] D3/ || prev ~ /TST\.L D[0-7]/)))saw_positive_time_test=1
 if((l ~ /CLOCK_HALFHOURSLOTINDEX/ || prev ~ /CLOCK_HALFHOURSLOTINDEX/ || prev2 ~ /CLOCK_HALFHOURSLOTINDEX/) &&
    (l ~ /CMP\.[WL] D[0-7],D[0-7]/ || prev ~ /CMP\.[WL] D[0-7],D[0-7]/ || prev2 ~ /CMP\.[WL] D[0-7],D[0-7]/) &&
    (l ~ /TST\.[WL] D0/ || l ~ /TST\.[WL] D3/ || prev ~ /TST\.[WL] D0/ || prev ~ /TST\.[WL] D3/ || prev2 ~ /TST\.[WL] D0/ || prev2 ~ /TST\.[WL] D3/) &&
    (l ~ /MOVEQ\.L #\$1,D[0-7]/ || l ~ /MOVEQ #1,D[0-7]/ ||
     prev ~ /MOVEQ\.L #\$1,D[0-7]/ || prev ~ /MOVEQ #1,D[0-7]/ ||
     prev2 ~ /MOVEQ\.L #\$1,D[0-7]/ || prev2 ~ /MOVEQ #1,D[0-7]/ ||
     l ~ /MOVE\.L D[0-7],\$38\(A7\)/ || prev ~ /MOVE\.L D[0-7],\$38\(A7\)/))h_special_gate=1
 if(saw_special_halfhour && saw_positive_time_test && saw_special_store)h_special_gate=1
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
 if(l ~ /BANNERSELECTEDENTRYIND/ &&
    (l ~ /PRIMARYTITLEPTRTABLE/ || l ~ /SECONDARYTITLEPTRTABLE/ || l ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
     prev ~ /PRIMARYTITLEPTRTABLE/ || prev ~ /SECONDARYTITLEPTRTABLE/ || prev ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
     prev2 ~ /PRIMARYTITLEPTRTABLE/ || prev2 ~ /SECONDARYTITLEPTRTABLE/ || prev2 ~ /TEXTDISP_GETACTIVETITLEPTR/))saw_usage_reload_selected=1
 if(l ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || l ~ /ADDQ\.W #1,0\(A0,D0\.L\)/ || l ~ /MOVE\.W D1,\$0\(A0,D3\.L\)/ ||
    l ~ /MOVE\.W D1,0\(A0,D3\.L\)/ || l ~ /AFTER_USAGE_TABLE/)saw_usage_table_increment=1
 if((l ~ /BANNERSELECTEDENTRYIND/ || prev ~ /BANNERSELECTEDENTRYIND/ || prev2 ~ /BANNERSELECTEDENTRYIND/ || prev3 ~ /BANNERSELECTEDENTRYIND/) &&
    (l ~ /PRIMARYTITLEPTRTABLE/ || l ~ /SECONDARYTITLEPTRTABLE/ || l ~ /TEXTDISP_GETACTIVETITLEPTR/ || l ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
     prev ~ /PRIMARYTITLEPTRTABLE/ || prev ~ /SECONDARYTITLEPTRTABLE/ || prev ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
     prev2 ~ /PRIMARYTITLEPTRTABLE/ || prev2 ~ /SECONDARYTITLEPTRTABLE/ || prev2 ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
     prev3 ~ /PRIMARYTITLEPTRTABLE/ || prev3 ~ /SECONDARYTITLEPTRTABLE/ || prev3 ~ /TEXTDISP_GETACTIVETITLEPTR/) &&
    (l ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || l ~ /ADDQ\.W #1,0\(A0,D0\.L\)/ || l ~ /MOVE\.W D1,\$0\(A0,D3\.L\)/ || l ~ /AFTER_USAGE_TABLE/ ||
     prev ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || prev ~ /ADDQ\.W #1,0\(A0,D0\.L\)/ || prev ~ /MOVE\.W D1,\$0\(A0,D3\.L\)/ || prev ~ /AFTER_USAGE_TABLE/ ||
     prev2 ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || prev2 ~ /ADDQ\.W #1,0\(A0,D0\.L\)/ || prev2 ~ /MOVE\.W D1,\$0\(A0,D3\.L\)/ || prev2 ~ /AFTER_USAGE_TABLE/ ||
     prev3 ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || prev3 ~ /ADDQ\.W #1,0\(A0,D0\.L\)/ || prev3 ~ /MOVE\.W D1,\$0\(A0,D3\.L\)/ || prev3 ~ /AFTER_USAGE_TABLE/))h_usage_bump=1
 if(saw_usage_reload_selected && saw_usage_table_increment)h_usage_bump=1
 if(l ~ /PRIMARYTITLEPTRTABLE/ || l ~ /SECONDARYTITLEPTRTABLE/ || l ~ /ACTIVEGROUPID/)h_group=1
 if((l ~ /MOVEQ\.L #\$2,D0/ || l ~ /MOVEQ #2,D0/) &&
    (prev ~ /FINDMODEACTIVEFLAG/ || prev2 ~ /FINDMODEACTIVEFLAG/ ||
     prev ~ /SUBQ\.[BW] #\$1,D[0-7]/ || prev ~ /SUBQ\.[BW] #1,D[0-7]/ ||
     prev2 ~ /SUBQ\.[BW] #\$1,D[0-7]/ || prev2 ~ /SUBQ\.[BW] #1,D[0-7]/))h_findmode_return=1
 if(l ~ /PEA 3\.W/ || l ~ /PEA \(\$3\)\.W/)saw_mode3_call=1
 if(saw_mode3_call && (l ~ /(JSR|BSR).*FINDENTRYMATCHINDEX/ || l ~ /FINDENTRYMATCHINDEX/))h_mode3_requery=1
 if(l ~ /PEA 2\.W/ || l ~ /PEA \(\$2\)\.W/)saw_mode2_call=1
 if(saw_mode2_call &&
    (l ~ /MOVE\.B #\$1,TEXTDISP_BANNERFALLBACKVALIDFLAG/ || l ~ /MOVE\.B D[0-7],TEXTDISP_BANNERFALLBACKVALIDFLAG/ ||
     l ~ /BANNERFALLBACKVALIDFLAG/ && (prev ~ /MOVEQ(\.L)? #\$1,D[0-7]/ || prev ~ /MOVEQ(\.L)? #1,D[0-7]/)))h_mode2_fallback_mark=1
 if(l ~ /MOVE\.W D0,-6\(A5\)/ || l ~ /MOVE\.W D1,\$48\(A7\)/ || l ~ /MOVE\.W D[01],\$48\(A7\)/)h_last_match_store=1
 if(l ~ /CMPI\.W #\$31/ || l ~ /CMP\.W D0,D1/ || l ~ /CMP\.W D0,D6/ || l ~ /NORMALIZE_CHANNEL_CODE/ || l ~ /SET_DEFAULT_CHANNEL/)h_finalize=1
 if(l ~ /CMPI\.W #\$3D/ || l ~ /CMP\.W #\$3D/ || l ~ /CMPI\.W #61/ || l ~ /CMP\.W #61/)saw_finalize_3d_cmp=1
 if(saw_finalize_3d_cmp &&
    (l ~ /MOVEQ\.L #\$64,D[0-7]/ || l ~ /MOVEQ #\$64,D[0-7]/ || l ~ /MOVEQ\.L #100,D[0-7]/ || l ~ /MOVEQ #100,D[0-7]/ ||
     prev ~ /MOVEQ\.L #\$64,D[0-7]/ || prev ~ /MOVEQ #\$64,D[0-7]/ || prev ~ /MOVEQ\.L #100,D[0-7]/ || prev ~ /MOVEQ #100,D[0-7]/) &&
    (l ~ /BANNERCHARSELECTED/ || prev ~ /BANNERCHARSELECTED/ || prev2 ~ /BANNERCHARSELECTED/))h_finalize_sentinel=1
 if(saw_finalize_3d_cmp &&
    (l ~ /MOVE\.B D[0-7],TEXTDISP_BANNERCHARSELECTED/ || prev ~ /MOVE\.B D[0-7],TEXTDISP_BANNERCHARSELECTED/))h_finalize_sentinel=1
 if((l ~ /(BLT|BCS)\.[BSWL]?/ || l ~ /(BLT|BCS) /) &&
    prev ~ /CMP\.W D0,D6/ &&
    (prev2 ~ /MOVEQ\.L #\$3A,D0/ || prev2 ~ /MOVEQ #58,D0/) &&
    (prev5 ~ /MOVEQ\.L #\$30,D0/ || prev5 ~ /MOVEQ #48,D0/))h_finalize_digit_window=1
 if((l ~ /(BLT|BCS)\.[BSWL]?/ || l ~ /(BLT|BCS) /) &&
    prev ~ /CMP\.W D0,D6/ &&
    (prev2 ~ /MOVEQ\.L #\$44,D0/ || prev2 ~ /MOVEQ #68,D0/) &&
    (prev5 ~ /MOVEQ\.L #\$3E,D0/ || prev5 ~ /MOVEQ #62,D0/))h_finalize_mid_window=1
 if((l ~ /(BGE|BCC)\.[BSWL]?/ || l ~ /(BGE|BCC) /) &&
    prev ~ /CMP\.W D0,D6/ &&
    (prev2 ~ /MOVEQ\.L #\$4E,D0/ || prev2 ~ /MOVEQ #78,D0/) &&
    (prev5 ~ /MOVEQ\.L #\$47,D0/ || prev5 ~ /MOVEQ #71,D0/))h_finalize_high_window=1
 if(l ~ /MOVE\.B TEXTDISP_BANNERSELECTEDENTRYIND/)saw_finalize_selected_entry=1
 if((l ~ /BANNERSELECTEDENTRYIND/ || prev ~ /BANNERSELECTEDENTRYIND/ || prev2 ~ /BANNERSELECTEDENTRYIND/) &&
    (l ~ /PRIMARYTITLEPTRTABLE/ || l ~ /SECONDARYTITLEPTRTABLE/ || l ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
     prev ~ /PRIMARYTITLEPTRTABLE/ || prev ~ /SECONDARYTITLEPTRTABLE/ || prev ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
     prev2 ~ /PRIMARYTITLEPTRTABLE/ || prev2 ~ /SECONDARYTITLEPTRTABLE/ || prev2 ~ /TEXTDISP_GETACTIVETITLEPTR/))h_finalize_reload_selected=1
 if(saw_finalize_selected_entry &&
    (l ~ /(JSR|BSR).*TEXTDISP_GETACTIVETITLEPTR/ || l ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
     prev ~ /(JSR|BSR).*TEXTDISP_GETACTIVETITLEPTR/ || prev ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
     prev2 ~ /(JSR|BSR).*TEXTDISP_GETACTIVETITLEPTR/ || prev2 ~ /TEXTDISP_GETACTIVETITLEPTR/))h_finalize_helper_call=1
 if(saw_finalize_selected_entry && (l ~ /PRIMARYTITLEPTRTABLE/ || l ~ /SECONDARYTITLEPTRTABLE/ || l ~ /TEXTDISP_GETACTIVETITLEPTR/))h_finalize_reload_selected=1
 if(h_finalize_reload_selected || h_finalize_helper_call)saw_usage_reload_selected=1
 if(l ~ /MOVE\.B TEXTDISP_BANNERCHARSELECTED/)saw_finalize_selected_char=1
 if(((l ~ /#\$190/ || l ~ /\+400/ || prev ~ /#\$190/ || prev ~ /\+400/ || prev2 ~ /#\$190/ || prev2 ~ /\+400/) &&
     (l ~ /BANNERCHARSELECTED/ || prev ~ /BANNERCHARSELECTED/ || prev2 ~ /BANNERCHARSELECTED/) &&
     (l ~ /ADDQ\.W #1,D[0-7]/ || l ~ /ADDQ\.W #\$1,D[0-7]/ || prev ~ /ADDQ\.W #1,D[0-7]/ || prev ~ /ADDQ\.W #\$1,D[0-7]/) &&
     (l ~ /MOVE\.W D[0-7],0\(A0,D[0-7]\.L\)/ || l ~ /MOVE\.W D[0-7],\$0\(A0,D[0-7]\.L\)/ ||
      prev ~ /MOVE\.W D[0-7],0\(A0,D[0-7]\.L\)/ || prev ~ /MOVE\.W D[0-7],\$0\(A0,D[0-7]\.L\)/)) ||
    (l ~ /TEXTDISP_GETUSAGECOUNT/ && (prev ~ /BANNERCHARSELECTED/ || prev2 ~ /BANNERCHARSELECTED/ || prev3 ~ /BANNERCHARSELECTED/)))h_finalize_usage_slot=1
 if(saw_finalize_selected_char &&
    (l ~ /ADDI?\.L #400,D1/ || l ~ /ADD\.L #\$190,D1/ || l ~ /ADD\.L #\$190,D3/ ||
     l ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || l ~ /MOVE\.W D1,\$0\(A0,D3\.L\)/))h_finalize_usage_slot=1
 if(l ~ /MOVEQ\.L #\$44,D6/ || l ~ /MOVEQ #68,D6/ || l ~ /CHANNELCODE = 68/)h_channel_default68=1
 if(l ~ /RETURN_ERROR:/ || (!h_loop && (l ~ /MOVEQ\.L #\$1,D0/ || l ~ /MOVEQ #1,D0/)))h_return_error=1
 if(l ~ /MOVEQ\.L #\$0,D0/ || l ~ /MOVEQ #0,D0/)h_return_ok=1
 if((l ~ /MOVEQ\.L #\$2,D0/ || l ~ /MOVEQ #2,D0/) && prev !~ /FINDMODEACTIVEFLAG/)h_return_found=1
 if(l=="RTS")h_rts=1
 prev5=prev4
 prev4=prev3
 prev3=prev2
 prev2=prev
 prev=l
}
END{
 print "HAS_ENTRY="h_entry
 print "HAS_INIT_SENTINELS="h_init
 print "HAS_INIT_BEST_POS_SENTINEL="h_init_best_pos
 print "HAS_INIT_BEST_NEG_SENTINEL="h_init_best_neg
 print "HAS_INIT_PREV_USAGE_SENTINEL="h_init_prev_usage
 print "HAS_INIT_LAST_MATCH_SENTINEL="h_init_last_match
 print "HAS_SPT_TAG_CHECK="h_tag
 print "HAS_SPT_TAG_LOOP_ADVANCE="h_tag_loop_advance
 print "HAS_CHANNEL_RANGE="h_channel
 print "HAS_CHANNEL_ZERO_DEFAULT48="h_channel_default48
 print "HAS_WEEKDAY_CHANNEL_GATE="h_weekday_gate
 print "HAS_CANDIDATE_LOOP="h_loop
 print "HAS_CANDIDATE_INDEX_STORE="h_candidate_index_store
 print "HAS_FIND_MATCH_CALLS="h_find
 print "HAS_FIND_MODE1="h_find_mode1
 print "HAS_FIND_MODE2="h_find_mode2
 print "HAS_FIND_MODE3="h_find_mode3
 print "HAS_FIND_MODE0="h_find_mode0
 print "HAS_MODE0_FALLBACK_ENTRY_STORE="h_mode0_fallback_entry_store
 print "TIME_OFFSET_CALL_COUNT_GE_2="(h_time>=2)
 print "HAS_ACTIVE_TITLE_RESOLUTION="(h_helper_call || h_group)
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
 print "HAS_FINALIZE_DIGIT_WINDOW="h_finalize_digit_window
 print "HAS_FINALIZE_MID_WINDOW="h_finalize_mid_window
 print "HAS_FINALIZE_HIGH_WINDOW="h_finalize_high_window
 print "HAS_FINALIZE_SELECTED_ENTRY_RELOAD="h_finalize_reload_selected
 print "HAS_FINALIZE_ACTIVE_TITLE_RESOLUTION="(h_finalize_helper_call || h_finalize_reload_selected)
 print "HAS_FINALIZE_USAGE_SLOT_INCREMENT="h_finalize_usage_slot
 print "HAS_RETURN_ERROR="h_return_error
 print "HAS_RETURN_OK="h_return_ok
 print "HAS_RETURN_FOUND="h_return_found
 print "HAS_RTS="h_rts
}

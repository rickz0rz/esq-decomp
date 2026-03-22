BEGIN {
    has_entry=0
    has_get_entry=0
    has_get_anim=0
    has_test_window=0
    has_format=0
    has_const1440=0
    has_mode_any=0
    has_mode_primary=0
    has_config_window=0
    has_field_5=0
    has_field_4=0
    has_field_3=0
    has_field_2=0
    has_field_1=0
    has_outtext_clear=0
    has_return_true=0
    has_return_false=0
    has_return=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
 line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line); n=u; gsub(/[^A-Z0-9]/,"",n)
 if (u ~ /^TLIBA1_BUILDCLOCKFORMATENTRYIFVISIBLE:/ || u ~ /^TLIBA1_BUILDCLOCKFORMATENTRYIFVISI[A-Z0-9_]*:/ || u ~ /^TLIBA1_BUILDCLOCKFORMATENTRYIFVI[A-Z0-9_]*:/) has_entry=1
 if (n ~ /TLIBA1JMPTBLESQDISPGETENTRYPOINTERBYMODE/ || n ~ /TLIBA1JMPTBLESQDISPGETENTRYAUXPOINTERBYMODE/ || n ~ /TLIBA1JMPTBLESQDISPGETENTRYPOINTERBYMOD/ || n ~ /TLIBA1JMPTBLESQDISPGETENTRYPO/ || n ~ /TLIBA1JMPTBLESQDISPGETENTRYAU/ || n ~ /ESQDISPGETENTRYPOINTERBYMODE/ || n ~ /ESQDISPGETENTRYAUXPOINTERBYMODE/ || n ~ /ESQDISPGETENTRYPOINTERBYMOD/ || n ~ /ESQDISPGETENTRYAUXPOINTERBYMOD/) has_get_entry=1
 if (n ~ /TLIBA1JMPTBLCOIGETANIMFIELDPOINTERBYMODE/ || n ~ /TLIBA1JMPTBLCOIGETANIMFIELDPOINTERBYMOD/ || n ~ /TLIBA1JMPTBLCOIGETANIMFIELDPO/ || n ~ /COIGETANIMFIELDPOINTERBYMODE/ || n ~ /COIGETANIMFIELDPOINTERBYMOD/) has_get_anim=1
 if (n ~ /TLIBA1JMPTBLCOITESTENTRYWITHINTIMEWINDOW/ || n ~ /TLIBA1JMPTBLCOITESTENTRYWITHINTIMEWIND/ || n ~ /TLIBA1JMPTBLCOITESTENTRYWITHI/ || n ~ /COITESTENTRYWITHINTIMEWINDOW/ || n ~ /COITESTENTRYWITHINTIMEWIND/ || n ~ /COITESTENTRYWITHI/) has_test_window=1
 if (n ~ /TLIBA1FORMATCLOCKFORMATENTRY/ || n ~ /TLIBA1FORMATCLOCKFORMATENTR/) has_format=1
 if (u ~ /1440/ || u ~ /#\$5A0/ || u ~ /\(\$5A0\)\.W/) has_const1440=1
 if (u ~ /#-1/ || u ~ /#\$FF/ || u ~ /#\$FFFFFFFF/) has_mode_any=1
 if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || n ~ /MOVEQL1D[0-7]/) has_mode_primary=1
 if (n ~ /CONFIGTIMEWINDOWMINUTES/) has_config_window=1
 if (u ~ /#5([^0-9]|$)/ || u ~ /#\$05/ || u ~ /5\.W/ || u ~ /\(\$5\)\.W/ || n ~ /MOVEQL5D[0-7]/) has_field_5=1
 if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /3\.W/ || u ~ /\(\$3\)\.W/ || n ~ /MOVEQL3D[0-7]/) has_field_3=1
 if (u ~ /#2([^0-9]|$)/ || u ~ /#\$02/ || u ~ /2\.W/ || u ~ /\(\$2\)\.W/ || n ~ /MOVEQL2D[0-7]/) has_field_2=1
 if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /4\.W/ || u ~ /\(\$4\)\.W/ || n ~ /MOVEQL4D[0-7]/) has_field_4=1
 if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /1\.W/ || u ~ /\(\$1\)\.W/ || n ~ /MOVEQL1D[0-7]/) has_field_1=1
 if (n ~ /CLRBA3/ || n ~ /CLRBA5/ || n ~ /MOVEB29A7A5/ || n ~ /MOVEB0A[235]/) has_outtext_clear=1
 if (n ~ /MOVEW1D0/ || n ~ /MOVEQ1D0/ || n ~ /MOVEQL1D0/ || n ~ /MOVEW130A5/) has_return_true=1
 if (n ~ /MOVEQ0D0/ || n ~ /MOVEQL0D0/ || n ~ /MOVEW0D0/ || n ~ /CLRWD0/ || n ~ /MOVEW2AA7D0/) has_return_false=1
 if (u=="RTS") has_return=1
}
END {
    print "HAS_ENTRY="has_entry
    print "HAS_GET_ENTRY="has_get_entry
    print "HAS_GET_ANIM="has_get_anim
    print "HAS_TEST_WINDOW="has_test_window
    print "HAS_FORMAT="has_format
    print "HAS_CONST_1440="has_const1440
    print "HAS_MODE_ANY="has_mode_any
    print "HAS_MODE_PRIMARY="has_mode_primary
    print "HAS_CONFIG_WINDOW="has_config_window
    print "HAS_FIELD_5="has_field_5
    print "HAS_FIELD_3="has_field_3
    print "HAS_FIELD_2="has_field_2
    print "HAS_FIELD_4="has_field_4
    print "HAS_FIELD_1="has_field_1
    print "HAS_OUTTEXT_CLEAR="has_outtext_clear
    print "HAS_RETURN_TRUE="has_return_true
    print "HAS_RETURN_FALSE="has_return_false
    print "HAS_RETURN="has_return
}

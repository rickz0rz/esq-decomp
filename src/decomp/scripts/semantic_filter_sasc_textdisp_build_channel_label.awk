/^TEXTDISP_BuildChannelLabel:$/ {
    print
    next
}

{
    line = $0
    gsub(/TLIBA1_JMPTBL_ESQDISP_GetEntryPo[A-Za-z0-9_]*/, "ESQDISP_GetEntryPointerByMode", line)
    gsub(/TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode/, "ESQDISP_GetEntryPointerByMode", line)

    if (line ~ /ESQDISP_GetEntryPointerByMode/) {
        print "CALL ESQDISP_GetEntryPointerByMode"
    } else if (line ~ /STRING_AppendAtNull/) {
        print "CALL STRING_AppendAtNull"
    } else if (line ~ /Global_STR_ALIGNED_ON/) {
        print "USE Global_STR_ALIGNED_ON"
    } else if (line ~ /Global_STR_ALIGNED_CHANNEL_1/) {
        print "USE Global_STR_ALIGNED_CHANNEL_1"
    } else if (line ~ /TEXTDISP_ChannelLabelReadyFlag/ && line ~ /(CLR|MOVE\.L)/) {
        print "WRITE TEXTDISP_ChannelLabelReadyFlag"
    } else if (line ~ /TEXTDISP_ChannelLabelBufferTermi/) {
        print "WRITE TEXTDISP_ChannelLabelBufferTerminatorByte"
    } else if (line ~ /^RTS$/) {
        print "RTS"
    }
}

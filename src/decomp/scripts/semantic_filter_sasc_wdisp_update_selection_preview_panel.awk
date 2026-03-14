/^WDISP_UpdateSelectionPreviewPane/ { print "ENTRY"; next }
/WDISP_JMPTBL_ESQIFF_RenderWeathe/ { print "CALL RenderWeatherStatusBrushSlice"; next }
/WDISP_JMPTBL_GCOMMAND_ExpandPres/ { print "CALL ExpandPresetBlock"; next }
/WDISP_JMPTBL_NEWGRID_ResetRowTab/ { print "CALL ResetRowTable"; next }
/WDISP_JMPTBL_BRUSH_FreeBrushList/ { print "CALL FreeBrushList"; next }
/WDISP_JMPTBL_ESQIFF_QueueIffBrus/ { print "CALL QueueIffBrushLoad"; next }
/_LVOSetRast/ { print "CALL SetRast"; next }
/MOVE\.L[[:space:]]+D0,TLIBA1_PreviewSlotRenderResult/ { print "SET RenderResult"; next }
/MOVE\.L[[:space:]]+#-1,TLIBA1_PreviewSlotRenderResult/ { print "SET RenderResult"; next }
/CLR\.L[[:space:]]+TLIBA1_PreviewSlotRenderResult/ { print "SET RenderResult"; next }
/MOVE\.L[[:space:]]+#-1,32\(A2\)/ { print "SET PreviewDirty=-1"; next }
/MOVE\.L[[:space:]]+D1,32\(A2\)/ { print "SET PreviewDirty=-1"; next }
/MOVE\.L[[:space:]]+D0,\$20\(A3\)/ { print "SET PreviewDirty=-1"; next }
/RTS/ { print "RTS"; next }

BEGIN {
    has_label = 0
    has_select_buffer = 0
    has_ravesc = 0
    has_select_flag = 0
    has_execute_call = 0
    has_findtask_call = 0
    has_openlibrary_call = 0
    has_openresource_call = 0
    has_override_intuition = 0
    has_openfont_call = 0
    has_opendiskfont_call = 0
    has_allocmem_call = 0
    has_initrastport_call = 0
    has_setfont_call = 0
    has_divs32_call = 0
    has_highlight_bitmap_call = 0
    has_initbitmap_call = 0
    has_allocraster_call = 0
    has_bltclear_call = 0
    has_clockfmt_24 = 0
    has_clockfmt_12 = 0
    has_msgport_alloc = 0
    has_list_init = 0
    has_queue_highlight = 0
    has_copper_off = 0
    has_disk_error_guard = 0
    has_fastmem_check = 0
    has_video_check = 0
    has_topaz_guard = 0
    has_update_clock = 0
    has_dst_refresh = 0
    has_baud_2400 = 0
    has_baud_4800 = 0
    has_baud_9600 = 0
    has_signal_create = 0
    has_open_device = 0
    has_doio = 0
    has_int_rbf = 0
    has_int_aud1 = 0
    has_int_vertb = 0
    has_audio_dma = 0
    has_ctrl_init = 0
    has_kybd_init = 0
    has_line_buffers = 0
    has_load_config = 0
    has_refresh_mode = 0
    has_banner_copper_init = 0
    has_drop_transition = 0
    has_rise_transition = 0
    has_drive_probe = 0
    has_printf = 0
    has_prime_banner = 0
    has_preset_defaults = 0
    has_parse_ini = 0
    has_reset_banner_fade = 0
    has_reload_data = 0
    has_load_source_config = 0
    has_populate_brushes = 0
    has_select_brush = 0
    has_find_type3 = 0
    has_reset_lists = 0
    has_reset_filter = 0
    has_status_refresh = 0
    has_rts = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^ESQ_MAININITANDRUN[A-Z0-9_]*:/) has_label = 1
    if (u ~ /ESQ_SELECTCODEBUFFER/) has_select_buffer = 1
    if (u ~ /GLOBAL_STR_RAVESC/) has_ravesc = 1
    if (u ~ /GLOBAL_WORD_SELECT_CODE_IS_RAVESC/) has_select_flag = 1
    if (u ~ /_LVOEXECUTE/) has_execute_call = 1
    if (u ~ /_LVOFINDTASK/) has_findtask_call = 1
    if (u ~ /_LVOOPENLIBRARY/) has_openlibrary_call = 1
    if (u ~ /_LVOOPENRESOURCE/) has_openresource_call = 1
    if (u ~ /OVERRIDE_INTUITION_FUNCS/) has_override_intuition = 1
    if (u ~ /_LVOOPENFONT/) has_openfont_call = 1
    if (u ~ /_LVOOPENDISKFONT/) has_opendiskfont_call = 1
    if (u ~ /MEMORY_ALLOCATEMEMORY/ || u ~ /MEMORY_ALLOCAT/) has_allocmem_call = 1
    if (u ~ /_LVOINITRASTPORT/) has_initrastport_call = 1
    if (u ~ /_LVOSETFONT/) has_setfont_call = 1
    if (u ~ /MATH_DIVS32/) has_divs32_call = 1
    if (u ~ /ALLOCATEHIGHLIGHTBITMAPS/ || u ~ /ALLOCATEHIGHLIGHTBITMA/) has_highlight_bitmap_call = 1
    if (u ~ /_LVOINITBITMAP/) has_initbitmap_call = 1
    if (u ~ /GRAPHICS_ALLOCRASTER/ || u ~ /GRAPHICS_ALLOC/) has_allocraster_call = 1
    if (u ~ /_LVOBLTCLEAR/) has_bltclear_call = 1
    if (u ~ /24_HR/) has_clockfmt_24 = 1
    if (u ~ /12_HR/) has_clockfmt_12 = 1
    if (u ~ /HIGHLIGHTMSGPORT/ || u ~ /HIGHLIGHTREPLYPORT/ || u ~ /34\.W/) has_msgport_alloc = 1
    if (u ~ /LIST_INITHEADER/ || u ~ /LIST_INITH/) has_list_init = 1
    if (u ~ /QUEUEHIGHLIGHTDRAWMESSAGE/ || u ~ /QUEUEHIGHLIGHTDRAWMES/) has_queue_highlight = 1
    if (u ~ /SETCOPPEREFFECT_OFFDISABLEHIGHLIGHT/ || u ~ /SETCOPPEREFFECT_OFFD/) has_copper_off = 1
    if (u ~ /FORMATDISKERRORMESSAGE/ || u ~ /FORMATDISKERRORMES/) has_disk_error_guard = 1
    if (u ~ /CHECKAVAILABLEFASTMEMORY/ || u ~ /CHECKAVAILABLEFASTM/) has_fastmem_check = 1
    if (u ~ /CHECKCOMPATIBLEVIDEOCHIP/ || u ~ /CHECKCOMPATIBLEVID/) has_video_check = 1
    if (u ~ /CHECKTOPAZFONTGUARD/ || u ~ /CHECKTOPAZFONTGUA/) has_topaz_guard = 1
    if (u ~ /UPDATECLOCKFROMRTC/ || u ~ /UPDATECLOCKFROMR/) has_update_clock = 1
    if (u ~ /DST_REFRESHBANNERBUFFER/ || u ~ /REFRESHBANNERBUFFER/) has_dst_refresh = 1
    if (u ~ /(^|[^0-9])2400([^0-9]|$)|\$960/) has_baud_2400 = 1
    if (u ~ /(^|[^0-9])4800([^0-9]|$)|\$12C0/) has_baud_4800 = 1
    if (u ~ /(^|[^0-9])9600([^0-9]|$)|\$2580/) has_baud_9600 = 1
    if (u ~ /CREATEMSGPORTWITHSIGNAL/ || u ~ /CREATEMSGPORTWITHSIG/) has_signal_create = 1
    if (u ~ /_LVOOPENDEVICE/) has_open_device = 1
    if (u ~ /_LVODOIO/) has_doio = 1
    if (u ~ /SETUP_INTERRUPT_INTB_RBF/) has_int_rbf = 1
    if (u ~ /SETUP_INTERRUPT_INTB_AUD1/) has_int_aud1 = 1
    if (u ~ /SETUP_INTERRUPT_INTB_VERTB/) has_int_vertb = 1
    if (u ~ /INITAUDIO1DMA/ || u ~ /INITAUDIO1DM/) has_audio_dma = 1
    if (u ~ /INITCTRLCONTEXT/ || u ~ /INITCTRLCONTEX/) has_ctrl_init = 1
    if (u ~ /INITIALIZEINPUTDEVICES/ || u ~ /INITIALIZEINPUTDEVI/) has_kybd_init = 1
    if (u ~ /ALLOCATELINETEXTBUFFERS/ || u ~ /ALLOCATELINETEXTBUF/) has_line_buffers = 1
    if (u ~ /LOADCONFIGFROMDISK/ || u ~ /LOADCONFIGFROMDIS/) has_load_config = 1
    if (u ~ /UPDATEREFRESHMODESTATE/ || u ~ /UPDATEREFRESHMODES/) has_refresh_mode = 1
    if (u ~ /INITIALIZEBANNERCOPPERSYSTEM/ || u ~ /INITIALIZEBANNERCOP/) has_banner_copper_init = 1
    if (u ~ /RUNCOPPERDROPTRANSITION/ || u ~ /RUNCOPPERDROPTRAN/) has_drop_transition = 1
    if (u ~ /RUNCOPPERRISETRANSITION/ || u ~ /RUNCOPPERRISETRAN/) has_rise_transition = 1
    if (u ~ /PROBEDRIVESANDASSIGNPATHS/ || u ~ /PROBEDRIVESANDASSI/) has_drive_probe = 1
    if (u ~ /WDISP_SPRINTF/ || u ~ /RAWDOFMT/ || u ~ /SPRINTF/) has_printf = 1
    if (u ~ /PRIMEBANNERTRANSITIONFROMHEXCODE/ || u ~ /PRIMEBANNERTRANSI/) has_prime_banner = 1
    if (u ~ /INITPRESETDEFAULTS/ || u ~ /INITPRESETDEFAUL/) has_preset_defaults = 1
    if (u ~ /PARSEINIBUFFERANDDISPATCH/ || u ~ /PARSEINIBUFFERANDD/) has_parse_ini = 1
    if (u ~ /RESETBANNERFADESTATE/ || u ~ /RESETBANNERFADEST/) has_reset_banner_fade = 1
    if (u ~ /RELOADDATAFILESANDREBUILDINDEX/ || u ~ /RELOADDATAFILESAND/) has_reload_data = 1
    if (u ~ /LOADSOURCECONFIG/ || u ~ /LOADSOURCECONF/) has_load_source_config = 1
    if (u ~ /POPULATEBRUSHLIST/ || u ~ /POPULATEBRUSHLIS/) has_populate_brushes = 1
    if (u ~ /SELECTBRUSHBYLABEL/ || u ~ /SELECTBRUSHBYLAB/) has_select_brush = 1
    if (u ~ /FINDTYPE3BRUSH/ || u ~ /FINDTYPE3BRUS/) has_find_type3 = 1
    if (u ~ /RESETLISTSANDLOADPROMOIDS/ || u ~ /RESETLISTSANDLOAD/) has_reset_lists = 1
    if (u ~ /RESETFILTERSTATESTRUCT/ || u ~ /RESETFILTERSTATEST/) has_reset_filter = 1
    if (u ~ /UPDATESTATUSMASKANDREFRESH/ || u ~ /UPDATESTATUSMASKA/) has_status_refresh = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SELECT_BUFFER=" has_select_buffer
    print "HAS_RAVESC=" has_ravesc
    print "HAS_EXECUTE_CALL=" has_execute_call
    print "HAS_FINDTASK_CALL=" has_findtask_call
    print "HAS_OPENLIBRARY_CALL=" has_openlibrary_call
    print "HAS_OPENRESOURCE_CALL=" has_openresource_call
    print "HAS_OPENFONT_CALL=" has_openfont_call
    print "HAS_OPENDISKFONT_CALL=" has_opendiskfont_call
    print "HAS_ALLOCMEM_CALL=" has_allocmem_call
    print "HAS_INITRASTPORT_CALL=" has_initrastport_call
    print "HAS_SETFONT_CALL=" has_setfont_call
    print "HAS_DIVS32_CALL=" has_divs32_call
    print "HAS_HIGHLIGHT_BITMAP_CALL=" has_highlight_bitmap_call
    print "HAS_INITBITMAP_CALL=" has_initbitmap_call
    print "HAS_ALLOCRASTER_CALL=" has_allocraster_call
    print "HAS_BLTCLEAR_CALL=" has_bltclear_call
    print "HAS_CLOCKFMT_24=" has_clockfmt_24
    print "HAS_CLOCKFMT_12=" has_clockfmt_12
    print "HAS_MSGPORT_ALLOC=" has_msgport_alloc
    print "HAS_LIST_INIT=" has_list_init
    print "HAS_QUEUE_HIGHLIGHT=" has_queue_highlight
    print "HAS_COPPER_OFF=" has_copper_off
    print "HAS_DISK_ERROR_GUARD=" has_disk_error_guard
    print "HAS_FASTMEM_CHECK=" has_fastmem_check
    print "HAS_VIDEO_CHECK=" has_video_check
    print "HAS_TOPAZ_GUARD=" has_topaz_guard
    print "HAS_UPDATE_CLOCK=" has_update_clock
    print "HAS_DST_REFRESH=" has_dst_refresh
    print "HAS_BAUD_2400=" has_baud_2400
    print "HAS_BAUD_4800=" has_baud_4800
    print "HAS_BAUD_9600=" has_baud_9600
    print "HAS_SIGNAL_CREATE=" has_signal_create
    print "HAS_OPEN_DEVICE=" has_open_device
    print "HAS_DOIO=" has_doio
    print "HAS_INT_RBF=" has_int_rbf
    print "HAS_INT_AUD1=" has_int_aud1
    print "HAS_INT_VERTB=" has_int_vertb
    print "HAS_AUDIO_DMA=" has_audio_dma
    print "HAS_CTRL_INIT=" has_ctrl_init
    print "HAS_KYBD_INIT=" has_kybd_init
    print "HAS_LINE_BUFFERS=" has_line_buffers
    print "HAS_LOAD_CONFIG=" has_load_config
    print "HAS_REFRESH_MODE=" has_refresh_mode
    print "HAS_BANNER_COPPER_INIT=" has_banner_copper_init
    print "HAS_DROP_TRANSITION=" has_drop_transition
    print "HAS_RISE_TRANSITION=" has_rise_transition
    print "HAS_PRINTF=" has_printf
    print "HAS_RELOAD_DATA=" has_reload_data
    print "HAS_STATUS_REFRESH=" has_status_refresh
    print "HAS_RTS=" has_rts
}

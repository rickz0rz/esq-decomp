BEGIN {
    has_entry = 0

    cmd_stage = 0
    data_stage = 0
    doio_stage = 0
    dealloc_stage = 0
    close_stage = 0
    cleanup_stage = 0
    free_stage = 0

    has_stack_pop = 0
    has_return = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^CLEANUP_SHUTDOWNINPUTDEVICES[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (cmd_stage == 0 &&
        (n ~ /MOVEALGLOBALREFIOSTDREQSTRUCTINPUTDEVICEA0/ ||
         n ~ /MOVELGLOBALREFIOSTDREQSTRUCTINPUTA4A0/)) {
        cmd_stage = 1
    } else if (cmd_stage == 1 &&
               (n ~ /MOVEW1028A0/ || n ~ /MOVEW1CA0/ || n ~ /MOVEWA28A0/ ||
                n ~ /MOVEWA1CA0/ || n ~ /MOVEW0A1CA0/)) {
        cmd_stage = 2
    }

    if (data_stage == 0 &&
        (n ~ /MOVEALGLOBALREFIOSTDREQSTRUCTINPUTDEVICEA0/ ||
         n ~ /MOVELGLOBALREFIOSTDREQSTRUCTINPUTA4A0/)) {
        data_stage = 1
    } else if (data_stage == 1 &&
               (n ~ /MOVELGLOBALREFDATAINPUTBUFFER40A0/ ||
                n ~ /MOVELGLOBALREFDATAINPUTBUFFERA428A0/)) {
        data_stage = 2
    }

    if (doio_stage == 0 &&
        (n ~ /MOVEALGLOBALREFIOSTDREQSTRUCTINPUTDEVICEA1/ ||
         n ~ /MOVELGLOBALREFIOSTDREQSTRUCTINPUTA1/ ||
         n ~ /MOVELGLOBALREFIOSTDREQSTRUCTINPUTA4A7/)) {
        doio_stage = 1
    } else if (doio_stage == 1 &&
               (n ~ /MOVEALABSEXECBASEA6/ || n ~ /MOVELABSEXECBASEA4A7/)) {
        doio_stage = 2
    } else if (doio_stage == 2 && n ~ /LVODOIO/) {
        doio_stage = 3
    }

    if (dealloc_stage == 0 &&
        (n ~ /PEASTRUCTINPUTEVENTSIZEW/ || n ~ /PEA14W/ || n ~ /PEA14W/ ||
         n ~ /PEA14W/ || n ~ /PEA014W/)) {
        dealloc_stage = 1
    } else if (dealloc_stage == 1 &&
               (n ~ /MOVELGLOBALREFDATAINPUTBUFFERA7/ ||
                n ~ /MOVELGLOBALREFDATAINPUTBUFFERA4A7/)) {
        dealloc_stage = 2
    } else if (dealloc_stage == 2 && (n ~ /PEA127W/ || n ~ /PEA7FW/)) {
        dealloc_stage = 3
    } else if (dealloc_stage == 3 &&
               (n ~ /PEAGLOBALSTRCLEANUPC5/ || n ~ /PEAGLOBALSTRCLEANUPC5A4/)) {
        dealloc_stage = 4
    } else if (dealloc_stage == 4 &&
               (n ~ /MEMORYDEALLOCATEMEMORY/ || n ~ /MEMORYDEALLOCAT/)) {
        dealloc_stage = 5
    }

    if (close_stage == 0 &&
        (n ~ /MOVEALGLOBALREFIOSTDREQSTRUCTINPUTDEVICEA1/ ||
         n ~ /MOVELGLOBALREFIOSTDREQSTRUCTINPUTA7/ ||
         n ~ /MOVELGLOBALREFIOSTDREQSTRUCTINPUTA4A7/)) {
        close_stage = 1
    } else if (close_stage == 1 &&
               (n ~ /MOVEALABSEXECBASEA6/ || n ~ /MOVELABSEXECBASEA4A7/)) {
        close_stage = 2
    } else if (close_stage == 2 && n ~ /LVOCLOSEDEVICE/) {
        close_stage = 3
    } else if (close_stage == 3 &&
               (n ~ /MOVEALGLOBALREFIOSTDREQSTRUCTCONSOLEDEVICEA1/ ||
                n ~ /MOVELGLOBALREFIOSTDREQSTRUCTCONSOA7/ ||
                n ~ /MOVELGLOBALREFIOSTDREQSTRUCTCONSOA4A7/)) {
        close_stage = 4
    } else if (close_stage == 4 &&
               (n ~ /MOVEALABSEXECBASEA6/ || n ~ /MOVELABSEXECBASEA4A7/)) {
        close_stage = 5
    } else if ((close_stage == 4 || close_stage == 5) && n ~ /LVOCLOSEDEVICE/) {
        close_stage = 5
    }

    if (cleanup_stage == 0 &&
        (n ~ /MOVELGLOBALREFINPUTDEVICEMSGPORTA7/ ||
         n ~ /MOVELGLOBALREFINPUTDEVICEMSGPORTA4A7/)) {
        cleanup_stage = 1
    } else if (cleanup_stage == 1 &&
               (n ~ /IOSTDREQCLEANUPSIGNALANDMSGPORT/ ||
                n ~ /IOSTDREQCLEANUPSIGNALANDMSG/ ||
                n ~ /IOSTDREQCLEANUP/)) {
        cleanup_stage = 2
    } else if (cleanup_stage == 2 &&
               (n ~ /MOVELGLOBALREFCONSOLEDEVICEMSGPORTA7/ ||
                n ~ /MOVELGLOBALREFCONSOLEDEVICEMSGPORTA4A7/)) {
        cleanup_stage = 3
    } else if (cleanup_stage == 3 &&
               (n ~ /IOSTDREQCLEANUPSIGNALANDMSGPORT/ ||
                n ~ /IOSTDREQCLEANUPSIGNALANDMSG/ ||
                n ~ /IOSTDREQCLEANUP/)) {
        cleanup_stage = 4
    }

    if (free_stage == 0 &&
        (n ~ /MOVELGLOBALREFIOSTDREQSTRUCTINPUTDEVICEA7/ ||
         n ~ /MOVELGLOBALREFIOSTDREQSTRUCTINPUTA4A7/)) {
        free_stage = 1
    } else if (free_stage == 1 && n ~ /IOSTDREQFREE/) {
        free_stage = 2
    } else if (free_stage == 2 &&
               (n ~ /MOVELGLOBALREFIOSTDREQSTRUCTCONSOLEDEVICEA7/ ||
                n ~ /MOVELGLOBALREFIOSTDREQSTRUCTCONSOA4A7/)) {
        free_stage = 3
    } else if (free_stage == 3 && n ~ /IOSTDREQFREE/) {
        free_stage = 4
    }

    if (n ~ /^LEA[0-9AFA7]+A7$/ || n ~ /^LEA[0-9]+A7A7$/) {
        has_stack_pop = 1
    }
    if (u == "RTS") {
        has_return = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "CMD_STAGE=" cmd_stage
    print "DATA_STAGE=" data_stage
    print "DOIO_STAGE=" doio_stage
    print "DEALLOC_STAGE=" dealloc_stage
    print "CLOSE_STAGE=" close_stage
    print "CLEANUP_STAGE=" cleanup_stage
    print "FREE_STAGE=" free_stage
    print "HAS_STACK_POP=" has_stack_pop
    print "HAS_RETURN=" has_return
}

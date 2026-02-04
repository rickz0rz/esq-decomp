;!======

;------------------------------------------------------------------------------
; FUNC: LAB_0471   (Write disk data file and table entries??)
; ARGS:
;   ??
; RET:
;   D0: 0 on success, -1 on failure ??
; CLOBBERS:
;   D0/D6-D7 ??
; CALLS:
;   DISKIO_OpenFileWithBuffer, LAB_03A0, LAB_03A9, LAB_039A, LAB_052D
; READS:
;   LAB_2230/2231/2247/2248, LAB_2233/2236 tables, LAB_1DD9
; WRITES:
;   LAB_21BE, LAB_1B9F
; DESC:
;   Allocates a staging buffer, opens the output file, and writes header fields
;   followed by per-entry records from the in-memory tables.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_0471:
    LINK.W  A5,#-24
    MOVEM.L D6-D7,-(A7)
    MOVE.W  LAB_2231,D0
    CMPI.W  #$c8,D0
    BLS.S   .loc_0472

    MOVEQ   #0,D0
    BRA.W   .loc_0482

.loc_0472:
    TST.L   LAB_1B9F
    BNE.S   .loc_0473

    MOVEQ   #0,D0
    BRA.W   .loc_0482

.loc_0473:
    CLR.L   LAB_1B9F
    CLR.B   -17(A5)

    ; DISKIO2.C:152 - Allocate 1000 bytes
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     1000.W
    PEA     152.W
    PEA     GLOB_STR_DISKIO2_C_1
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-22(A5)
    BNE.S   .loc_0474

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    MOVEQ   #-1,D0
    BRA.W   .loc_0482

.loc_0474:
    PEA     MODE_NEWFILE.W
    PEA     LAB_1B9B
    JSR     DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_21BE
    TST.L   D0
    BNE.S   .loc_0475

    PEA     1000.W
    MOVE.L  -22(A5),-(A7)
    PEA     176.W
    PEA     GLOB_STR_DISKIO2_C_2
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    MOVEQ   #-1,D0
    BRA.W   .loc_0482

.loc_0475:
    PEA     21.W
    PEA     LAB_1DC8
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    MOVE.W  LAB_2241,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    PEA     7.W
    PEA     GLOB_STR_DREV_5_1
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    LEA     LAB_2245,A0
    MOVEA.L A0,A1

    ; Compute length of header string and write it.
.loc_0476:
    TST.B   (A1)+
    BNE.S   .loc_0476

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    LEA     36(A7),A7
    TST.L   LAB_1DD9
    BNE.S   .loc_0477

    LEA     -17(A5),A0
    MOVE.L  A0,-12(A5)
    BRA.S   .loc_0478

.loc_0477:
    MOVEA.L LAB_1DD9,A0
    MOVE.L  A0,-12(A5)

    ; Compute length of optional string (LAB_1DD9 or empty) and write it.
.loc_0478:
    TST.B   (A0)+
    BNE.S   .loc_0478

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_2230,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_2231,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_2247,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_2248,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D7

    ; For each entry, write the per-record header and fields.
.loc_0479:
    MOVE.W  LAB_2231,D0
    CMP.W   D0,D7
    BGE.W   .loc_0481

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    PEA     48.W
    MOVE.L  -4(A5),-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    MOVEA.L -8(A5),A0

.loc_047A:
    TST.B   (A0)+
    BNE.S   .loc_047A

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D6

    ; Iterate item slots within the entry.
.loc_047B:
    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.W   .loc_0480

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D0.L)
    BEQ.W   .loc_047F

    MOVEA.L -4(A5),A1
    ADDA.W  #$1c,A1
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUP_AH_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .loc_047F

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  7(A0,D6.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #$fc,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #$12d,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #$15e,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    LEA     24(A7),A7
    MOVE.W  LAB_2231,D0
    MOVEQ   #100,D1
    CMP.W   D1,D0
    BLS.S   .loc_047C

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -22(A5),-(A7)
    BSR.W   LAB_052D

    LEA     16(A7),A7
    MOVE.L  D0,-12(A5)
    BRA.S   .loc_047D

.loc_047C:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)

.loc_047D:
    MOVEA.L -12(A5),A0

    ; Emit variable-length string for this slot.
.loc_047E:
    TST.B   (A0)+
    BNE.S   .loc_047E

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

.loc_047F:
    ADDQ.W  #1,D6
    BRA.W   .loc_047B

.loc_0480:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_03A9(PC)

    ADDQ.W  #8,A7
    ADDQ.W  #1,D7
    BRA.W   .loc_0479

.loc_0481:
    MOVE.L  LAB_21BE,-(A7)
    JSR     LAB_039A(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    PEA     1000.W
    MOVE.L  -22(A5),-(A7)
    PEA     275.W
    PEA     GLOB_STR_DISKIO2_C_3
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0

.loc_0482:
    MOVEM.L -32(A5),D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_0483   (Display status line at fixed position.)
; ARGS:
;   stack +4: A3 = message string
; RET:
;   D0: none
; CLOBBERS:
;   D0/A1/A3 ??
; CALLS:
;   DISPLIB_DisplayTextAtPosition
; READS:
;   GLOB_REF_RASTPORT_1
; WRITES:
;   ??
; DESC:
;   Clears a fixed area and renders the supplied text at (40,120).
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_0483:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L GLOB_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    PEA     GLOB_STR_38_SPACES
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  A3,(A7)
    PEA     120.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_0484   (Disk I/O initialization sequence with optional UI.)
; ARGS:
;   stack +4: showMessages?? (D7)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/D7 ??
; CALLS:
;   LAB_053D, LAB_0483, LAB_0535, GROUP_AK_JMPTBL_LAB_0E48, LAB_041A, LAB_0540, LAB_04E6,
;   LAB_07CA, DATETIME_SavePairToFile, LAB_0543, LAB_0541, GCOMMAND_LoadMplexFile,
;   GCOMMAND_LoadPPVTemplate
; READS:
;   LAB_1C47..LAB_1C4F text tables
; WRITES:
;   ??
; DESC:
;   Runs a staged initialization sequence, optionally printing status strings.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_0484:
    LINK.W  A5,#-100
    MOVE.L  D7,-(A7)
    MOVE.L  8(A5),D7

    PEA     1.W
    PEA     256.W
    JSR     LAB_053D(PC)

    ADDQ.W  #8,A7
    LEA     LAB_1C47,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

    ; Copy status string into stack buffer and optionally display it.
.loc_0485:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0485
    TST.L   D7
    BEQ.S   .loc_0486

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

.loc_0486:
    BSR.W   LAB_0535

    LEA     LAB_1C48,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0487:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0487
    TST.L   D7
    BEQ.S   .loc_0488

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

.loc_0488:
    JSR     GROUP_AK_JMPTBL_LAB_0E48(PC)

    LEA     LAB_1C49,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0489:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0489
    TST.L   D7
    BEQ.S   .loc_048A

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

.loc_048A:
    JSR     LAB_041A(PC)

    LEA     LAB_1C4A,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_048B:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_048B
    TST.L   D7
    BEQ.S   .loc_048C

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

.loc_048C:
    PEA     LAB_2324
    PEA     LAB_2321
    JSR     LAB_0540(PC)

    ADDQ.W  #8,A7
    LEA     LAB_1C4B,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_048D:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_048D
    TST.L   D7
    BEQ.S   .loc_048E

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

.loc_048E:
    BSR.W   LAB_04E6

    LEA     LAB_1C4C,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_048F:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_048F
    TST.L   D7
    BEQ.S   .loc_0490

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

.loc_0490:
    JSR     LAB_07CA(PC)

    LEA     LAB_1C4D,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0491:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0491
    TST.L   D7
    BEQ.S   .loc_0492

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

.loc_0492:
    PEA     LAB_21DF
    JSR     DATETIME_SavePairToFile(PC)

    ADDQ.W  #4,A7
    LEA     LAB_1C4E,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0493:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0493
    TST.L   D7
    BEQ.S   .loc_0494

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

.loc_0494:
    JSR     LAB_0543(PC)

    LEA     LAB_1C4F,A0
    LEA     -100(A5),A1
    MOVEQ   #8,D0

.loc_0495:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_0495
    TST.L   D7
    BEQ.S   .loc_0496

    PEA     -100(A5)
    BSR.W   LAB_0483

    ADDQ.W  #4,A7

.loc_0496:
    JSR     LAB_0541(PC)

    JSR     GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile(PC)

    JSR     GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate(PC)

    CLR.L   -(A7)
    PEA     256.W
    JSR     LAB_053D(PC)

    MOVE.L  -104(A5),D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_0497   (Load disk data file and populate entry tables.)
; ARGS:
;   ??
; RET:
;   D0: 0 on success, -1 on failure ??
; CLOBBERS:
;   D0-D7/A2-A3 ??
; CALLS:
;   LAB_03AC/03B2/03B6, GROUP_AH_JMPTBL_ESQ_WildcardMatch,
;   GROUP_AG_JMPTBL_MEMORY_AllocateMemory/DeallocateMemory, LAB_053E,
;   LAB_0345, LAB_146B, LAB_053A, LAB_053C, LAB_0B44
; READS:
;   LAB_1B9B, LAB_21BC, LAB_1C41, LAB_1DD9, LAB_2230, LAB_2233/2236
; WRITES:
;   LAB_2230/2231/2238, LAB_2247/2248/224A-224C, LAB_224F tables, LAB_1DD9
; DESC:
;   Parses the on-disk data file, allocates per-entry structures, and fills
;   the in-memory tables with parsed records.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_0497:
    LINK.W  A5,#-76
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVE.W  #(-1),-28(A5)
    MOVEQ   #0,D7

.loc_0498:
    MOVEQ   #21,D0
    CMP.W   D0,D7
    BGE.S   .loc_0499

    LEA     LAB_1DC8,A0
    ADDA.W  D7,A0
    MOVE.B  (A0),-65(A5,D7.W)
    ADDQ.W  #1,D7
    BRA.S   .loc_0498

.loc_0499:
    PEA     LAB_1B9B
    JSR     LAB_03AC(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .loc_049A

    CLR.W   LAB_2241
    PEA     -65(A5)
    JSR     LAB_053A(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_049A:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,-40(A5)
    MOVE.L  LAB_21BC,-16(A5)
    MOVEQ   #0,D7

    ; Consume header bytes into a local buffer.
.loc_049B:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D0
    TST.L   D0
    BLE.S   .loc_049C

    MOVEQ   #21,D1
    CMP.W   D1,D7
    BGE.S   .loc_049C

    MOVEA.L LAB_21BC,A0
    MOVE.B  (A0)+,-65(A5,D7.W)
    MOVE.L  A0,LAB_21BC
    SUBQ.L  #1,GLOB_REF_LONG_FILE_SCRATCH
    ADDQ.W  #1,D7
    BRA.S   .loc_049B

.loc_049C:
    JSR     LAB_03B6(PC)

    MOVE.W  D0,LAB_2241
    PEA     -65(A5)
    JSR     LAB_053A(PC)

    JSR     LAB_03B2(PC)

    ADDQ.W  #4,A7
    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_049D

    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     520.W
    PEA     GLOB_STR_DISKIO2_C_4
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_049D:
    MOVEA.L D0,A0
    LEA     LAB_2249,A1

    ; Copy NUL-terminated identifier string.
.loc_049E:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_049E

    PEA     LAB_1C51
    PEA     LAB_2249
    JSR     GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_049F

    MOVE.W  #1,LAB_1C41
    MOVEQ   #40,D0
    MOVE.L  D0,-32(A5)
    BRA.W   .loc_04A4

.loc_049F:
    PEA     LAB_1C52
    PEA     LAB_2249
    JSR     GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_04A0

    MOVE.W  #2,LAB_1C41
    MOVEQ   #41,D0
    MOVE.L  D0,-32(A5)
    BRA.W   .loc_04A4

.loc_04A0:
    PEA     LAB_1C53
    PEA     LAB_2249
    JSR     GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_04A1

    MOVE.W  #3,LAB_1C41
    MOVEQ   #46,D0
    MOVE.L  D0,-32(A5)
    BRA.S   .loc_04A4

.loc_04A1:
    PEA     LAB_1C54
    PEA     LAB_2249
    JSR     GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_04A2

    MOVE.W  #4,LAB_1C41
    MOVEQ   #48,D0
    MOVE.L  D0,-32(A5)
    BRA.S   .loc_04A4

.loc_04A2:
    PEA     LAB_1C55
    PEA     LAB_2249
    JSR     GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_04A3

    MOVE.W  #5,LAB_1C41
    MOVEQ   #48,D0
    MOVE.L  D0,-32(A5)
    BRA.S   .loc_04A4

.loc_04A3:
    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     561.W
    PEA     GLOB_STR_DISKIO2_C_5
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_04A4:
    JSR     LAB_03B2(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04A5

    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     570.W
    PEA     GLOB_STR_DISKIO2_C_6
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_04A5:
    MOVEA.L D0,A0
    LEA     LAB_2245,A1

.loc_04A6:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_04A6

    MOVE.W  LAB_1C41,D0
    TST.W   D0
    BLE.S   .loc_04A8

    JSR     LAB_03B2(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04A7

    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     588.W
    PEA     GLOB_STR_DISKIO2_C_7
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_04C0

.loc_04A7:
    MOVE.L  LAB_1DD9,-(A7)
    MOVE.L  D0,-(A7)
    JSR     GROUP_AE_JMPTBL_LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_1DD9

.loc_04A8:
    JSR     LAB_03B6(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    AND.L   D0,D1
    MOVEQ   #0,D7
    MOVE.B  LAB_2230,D0
    MOVE.B  D1,-41(A5)
    CMP.B   D0,D1
    BNE.W   .loc_04BC

    JSR     LAB_03B6(PC)

    MOVE.W  D0,-44(A5)
    JSR     LAB_03B6(PC)

    MOVE.B  D0,LAB_2247
    JSR     LAB_03B6(PC)

    MOVE.W  D0,LAB_2248
    MOVE.B  #$1,LAB_224A
    MOVE.W  #1,LAB_224B
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_224C
    CLR.L   -36(A5)
    MOVE.L  D0,D7

.loc_04A9:
    ; Allocate and populate each entry record.
    CMP.W   -44(A5),D7
    BGE.W   .loc_04BD

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     634.W
    PEA     GLOB_STR_DISKIO2_C_8
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .loc_04AA

    MOVEQ   #-1,D0
    MOVE.L  D0,-36(A5)
    BRA.W   .loc_04BD

.loc_04AA:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     500.W
    PEA     640.W
    PEA     GLOB_STR_DISKIO2_C_9
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BNE.S   .loc_04AB

    MOVEQ   #-1,D0
    MOVE.L  D0,-36(A5)
    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     644.W
    PEA     GLOB_STR_DISKIO2_C_10
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    BRA.W   .loc_04BD

.loc_04AB:
    MOVE.L  A3,-(A7)
    JSR     LAB_053E(PC)

    MOVE.L  A3,(A7)
    JSR     LAB_0345(PC)

    ADDQ.W  #4,A7
    MOVE.L  A3,-20(A5)
    MOVEQ   #0,D6

.loc_04AC:
    ; Copy fixed-length name field from file buffer.
    MOVE.L  D6,D0
    EXT.L   D0
    CMP.L   -32(A5),D0
    BGE.S   .loc_04AD

    MOVEA.L LAB_21BC,A0
    MOVEA.L -20(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.L  A0,LAB_21BC
    SUBQ.L  #1,GLOB_REF_LONG_FILE_SCRATCH
    MOVE.L  A1,-20(A5)
    ADDQ.W  #1,D6
    BRA.S   .loc_04AC

.loc_04AD:
    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ANDI.W  #$ff7f,D0
    MOVE.B  D0,40(A3)
    LEA     1(A3),A0
    MOVEA.L A0,A1

.loc_04AE:
    TST.B   (A1)+
    BNE.S   .loc_04AE

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D5
    MOVE.W  LAB_224C,D0
    CMP.W   D0,D5
    BLE.S   .loc_04AF

    MOVE.W  D5,LAB_224C

.loc_04AF:
    JSR     LAB_03B2(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04B0

    MOVE.L  A0,-36(A5)
    BRA.W   .loc_04BD

.loc_04B0:
    MOVEA.L D0,A0
    MOVEA.L A2,A1

.loc_04B1:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_04B1

    MOVE.W  #(-1),-28(A5)
    MOVEQ   #0,D5

.loc_04B2:
    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.W   .loc_04B9

    MOVE.B  #$1,7(A2,D5.W)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    CLR.L   56(A2,D0.L)
    CMPI.W  #4,LAB_1C41
    BLE.S   .loc_04B5

    MOVE.W  -28(A5),D0
    TST.W   D0
    BPL.S   .loc_04B3

    JSR     LAB_03B6(PC)

    MOVE.W  D0,-28(A5)

.loc_04B3:
    CMP.W   D0,D5
    BGE.S   .loc_04B4

    BRA.W   .loc_04B8

.loc_04B4:
    MOVE.W  #(-1),-28(A5)

.loc_04B5:
    JSR     LAB_03B6(PC)

    MOVE.B  D0,7(A2,D5.W)
    CMPI.W  #1,LAB_1C41
    BLE.S   .loc_04B6

    JSR     LAB_03B6(PC)

    MOVE.L  D5,D1
    ADDI.W  #$fc,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     LAB_03B6(PC)

    MOVE.L  D5,D1
    ADDI.W  #$12d,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     LAB_03B6(PC)

    MOVE.L  D5,D1
    ADDI.W  #$15e,D1
    MOVE.B  D0,0(A2,D1.W)

.loc_04B6:
    JSR     LAB_03B2(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04B7

    MOVE.L  A0,-36(A5)
    BRA.S   .loc_04B9

.loc_04B7:
    MOVEQ   #0,D1
    MOVE.B  27(A3),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_053C(PC)

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  56(A2,D0.L),(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  D0,36(A7)
    JSR     GROUP_AE_JMPTBL_LAB_0B44(PC)

    LEA     12(A7),A7
    MOVE.L  24(A7),D1
    MOVE.L  D0,56(A2,D1.L)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   .loc_04B8

    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ORI.W   #$80,D0
    MOVE.B  D0,40(A3)

.loc_04B8:
    ADDQ.W  #1,D5
    BRA.W   .loc_04B2

.loc_04B9:
    CMPI.W  #4,LAB_1C41
    BLE.S   .loc_04BA

    MOVEQ   #-1,D0
    CMP.W   -28(A5),D0
    BNE.S   .loc_04BA

    JSR     LAB_03B6(PC)

    MOVE.W  D0,-28(A5)

.loc_04BA:
    MOVEQ   #-1,D0
    CMP.L   -36(A5),D0
    BNE.S   .loc_04BB

    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     736.W
    PEA     GLOB_STR_DISKIO2_C_11
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    PEA     500.W
    MOVE.L  A2,-(A7)
    PEA     737.W
    PEA     GLOB_STR_DISKIO2_C_12
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     32(A7),A7
    BRA.S   .loc_04BD

.loc_04BB:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2233,A0
    ADDA.L  D0,A0
    MOVE.L  A3,(A0)
    LEA     LAB_2236,A0
    ADDA.L  D0,A0
    MOVE.L  A2,(A0)
    ADDQ.W  #1,D7
    BRA.W   .loc_04A9

.loc_04BC:
    MOVEQ   #-1,D0
    MOVE.L  D0,-36(A5)

.loc_04BD:
    MOVE.B  -41(A5),LAB_2238
    MOVE.L  D7,D0
    MOVE.W  D0,LAB_2231
    MOVE.L  -40(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     764.W
    PEA     GLOB_STR_DISKIO2_C_13
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0
    MOVE.B  -41(A5),D0
    MOVE.L  D0,(A7)
    JSR     COI_LoadOiDataFile(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BEQ.S   .loc_04BE

    MOVE.B  #$1,LAB_1B8F
    MOVE.B  -41(A5),LAB_1B91
    BRA.S   .loc_04BF

.loc_04BE:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_1B8F
    MOVE.B  D0,LAB_1B91

.loc_04BF:
    MOVE.L  -36(A5),D0

.loc_04C0:
    MOVEM.L -96(A5),D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_04C1   (Write NXTDAY.DAT data file??)
; ARGS:
;   ??
; RET:
;   D0: 0 on success, -1 on failure ??
; CLOBBERS:
;   D0/D6-D7 ??
; CALLS:
;   DISKIO_OpenFileWithBuffer, LAB_03A0, LAB_03A9, LAB_039A, LAB_052D
; READS:
;   LAB_222D/222F/224D/224E, LAB_2235/2237 tables
; WRITES:
;   LAB_21C1, LAB_1B9F
; DESC:
;   Opens NXTDAY.DAT and writes header fields plus per-entry records.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_04C1:
    LINK.W  A5,#-24
    MOVEM.L D6-D7,-(A7)

.offsetAllocatedMemory  = -22
.desiredMemory          = 1000

    MOVE.W  LAB_222F,D0
    CMPI.W  #200,D0
    BLS.S   .loc_04C2

    MOVEQ   #0,D0
    BRA.W   .return

.loc_04C2:
    TST.L   LAB_1B9F
    BNE.S   .loc_04C3

    MOVEQ   #0,D0
    BRA.W   .return

.loc_04C3:
    CLR.L   LAB_1B9F
    CLR.B   -17(A5)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     (.desiredMemory).W
    PEA     817.W
    PEA     GLOB_STR_DISKIO2_C_14
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,.offsetAllocatedMemory(A5)
    BNE.S   .loc_04C4

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    MOVEQ   #-1,D0
    BRA.W   .return

.loc_04C4:
    PEA     (MODE_NEWFILE).W
    PEA     GLOB_STR_DF0_NXTDAY_DAT
    JSR     DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_21C1
    TST.L   D0
    BNE.S   .loc_04C5

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    PEA     (.desiredMemory).W
    MOVE.L  .offsetAllocatedMemory(A5),-(A7)
    PEA     839.W
    PEA     GLOB_STR_DISKIO2_C_15
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .return

.loc_04C5:
    MOVEQ   #0,D0
    MOVE.B  LAB_222D,D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_222F,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVE.B  LAB_224D,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_224E,D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D7

    ; For each entry, write the per-record header and fields.
.loc_04C6:
    MOVE.W  LAB_222F,D0
    CMP.W   D0,D7
    BGE.W   .loc_04CE

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    PEA     48.W
    MOVE.L  -4(A5),-(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A0(PC)

    MOVEA.L -8(A5),A0

.loc_04C7:
    TST.B   (A0)+
    BNE.S   .loc_04C7

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A0(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D6

    ; Iterate item slots within the entry.
.loc_04C8:
    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.W   .loc_04CD

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    TST.L   56(A0,D0.L)
    BEQ.W   .loc_04CC

    MOVEA.L -4(A5),A1
    ADDA.W  #28,A1
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUP_AH_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .loc_04CC

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  7(A0,D6.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #252,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #301,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D6,D1
    ADDI.W  #350,D1
    MOVE.B  0(A0,D1.W),D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    LEA     24(A7),A7
    MOVE.W  LAB_222F,D0
    MOVEQ   #100,D1
    CMP.W   D1,D0
    BLS.S   .loc_04C9

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -22(A5),-(A7)
    BSR.W   LAB_052D

    LEA     16(A7),A7
    MOVE.L  D0,-12(A5)
    BRA.S   .loc_04CA

.loc_04C9:
    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -8(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)

.loc_04CA:
    MOVEA.L -12(A5),A0

    ; Emit variable-length string for this slot.
.loc_04CB:
    TST.B   (A0)+
    BNE.S   .loc_04CB

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7

.loc_04CC:
    ADDQ.W  #1,D6
    BRA.W   .loc_04C8

.loc_04CD:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_03A9(PC)

    ADDQ.W  #8,A7
    ADDQ.W  #1,D7
    BRA.W   .loc_04C6

.loc_04CE:
    MOVE.L  LAB_21C1,-(A7)
    JSR     LAB_039A(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    PEA     (.desiredMemory).W
    MOVE.L  -22(A5),-(A7)
    PEA     901.W
    PEA     GLOB_STR_DISKIO2_C_16
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0

.return:
    MOVEM.L -32(A5),D6-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_04D0   (Load NXTDAY.DAT and populate entry tables.)
; ARGS:
;   ??
; RET:
;   D0: 0 on success, -1 on failure ??
; CLOBBERS:
;   D0/D5-D7/A2-A3 ??
; CALLS:
;   LAB_03AC/03B2/03B6, GROUP_AG_JMPTBL_MEMORY_AllocateMemory/DeallocateMemory,
;   LAB_053E, LAB_0345, LAB_053C, GROUP_AE_JMPTBL_LAB_0B44, COI_LoadOiDataFile
; READS:
;   GLOB_STR_DF0_NXTDAY_DAT, LAB_21BC, LAB_1C41, LAB_222D
; WRITES:
;   LAB_222D/222F/222E, LAB_224D/224E, LAB_2235/2237, LAB_2239, LAB_1B90/1B92
; DESC:
;   Parses NXTDAY.DAT, allocates per-entry records, and fills in-memory tables.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_04D0:
    LINK.W  A5,#-48
    MOVEM.L D5-D7/A2-A3,-(A7)

    PEA     GLOB_STR_DF0_NXTDAY_DAT
    JSR     LAB_03AC(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .loc_04D1

    MOVEQ   #-1,D0
    BRA.W   .loc_04E5

.loc_04D1:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,-36(A5)
    MOVE.L  LAB_21BC,-16(A5)
    JSR     LAB_03B6(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    AND.L   D0,D1
    MOVEQ   #0,D7
    MOVE.B  LAB_222D,D0
    MOVE.B  D1,-37(A5)
    CMP.B   D0,D1
    BNE.W   .loc_04E2

    JSR     LAB_03B6(PC)

    MOVE.W  D0,-40(A5)
    JSR     LAB_03B6(PC)

    MOVE.B  D0,LAB_224D
    JSR     LAB_03B6(PC)

    MOVE.W  D0,LAB_224E
    MOVE.B  #$1,LAB_222E
    CLR.L   -32(A5)
    MOVEQ   #0,D7

    ; Allocate and populate each entry record.
.loc_04D2:
    CMP.W   -40(A5),D7
    BGE.W   .loc_04E2

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     52.W
    PEA     948.W
    PEA     GLOB_STR_DISKIO2_C_17
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BNE.S   .loc_04D3

    MOVEQ   #-1,D0
    MOVE.L  D0,-32(A5)
    BRA.W   .loc_04E2

.loc_04D3:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     500.W
    PEA     954.W
    PEA     GLOB_STR_DISKIO2_C_18
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L D0,A2
    MOVE.L  A2,D0
    BNE.S   .loc_04D4

    MOVEQ   #-1,D0
    MOVE.L  D0,-32(A5)
    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     958.W
    PEA     GLOB_STR_DISKIO2_C_19
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    BRA.W   .loc_04E2

.loc_04D4:
    MOVE.L  A3,-(A7)
    JSR     LAB_053E(PC)

    MOVE.L  A3,(A7)
    JSR     LAB_0345(PC)

    ADDQ.W  #4,A7
    MOVE.L  A3,-20(A5)
    MOVEQ   #0,D6

.loc_04D5:
    ; Copy fixed-length name field from file buffer.
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BCC.S   .loc_04D6

    MOVEA.L LAB_21BC,A0
    MOVEA.L -20(A5),A1
    MOVE.B  (A0)+,(A1)+
    MOVE.L  A0,LAB_21BC
    SUBQ.L  #1,GLOB_REF_LONG_FILE_SCRATCH
    MOVE.L  A1,-20(A5)
    ADDQ.W  #1,D6
    BRA.S   .loc_04D5

.loc_04D6:
    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ANDI.W  #$ff7f,D0
    MOVE.B  D0,40(A3)
    JSR     LAB_03B2(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04D7

    MOVE.L  A0,-32(A5)
    BRA.W   .loc_04E2

.loc_04D7:
    MOVEA.L D0,A0
    MOVEA.L A2,A1

.loc_04D8:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_04D8

    MOVE.W  #(-1),-28(A5)
    MOVEQ   #0,D5

.loc_04D9:
    ; Per-slot parsing loop (flags + optional strings).
    MOVEQ   #49,D0
    CMP.W   D0,D5
    BGE.W   .loc_04DF

    MOVE.B  #$1,7(A2,D5.W)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    CLR.L   56(A2,D0.L)
    CMPI.W  #4,LAB_1C41
    BLE.S   .loc_04DC

    MOVE.W  -28(A5),D0
    TST.W   D0
    BPL.S   .loc_04DA

    JSR     LAB_03B6(PC)

    MOVE.W  D0,-28(A5)

.loc_04DA:
    CMP.W   D0,D5
    BGE.S   .loc_04DB

    BRA.W   .loc_04DE

.loc_04DB:
    MOVE.W  #(-1),-28(A5)

.loc_04DC:
    JSR     LAB_03B6(PC)

    MOVE.B  D0,7(A2,D5.W)
    JSR     LAB_03B6(PC)

    MOVE.L  D5,D1
    ADDI.W  #$fc,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     LAB_03B6(PC)

    MOVE.L  D5,D1
    ADDI.W  #$12d,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     LAB_03B6(PC)

    MOVE.L  D5,D1
    ADDI.W  #$15e,D1
    MOVE.B  D0,0(A2,D1.W)
    JSR     LAB_03B2(PC)

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-12(A5)
    CMP.L   A0,D0
    BNE.S   .loc_04DD

    MOVE.L  A0,-32(A5)
    BRA.S   .loc_04DF

.loc_04DD:
    MOVEQ   #0,D1
    MOVE.B  27(A3),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_053C(PC)

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  56(A2,D0.L),(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  D0,36(A7)
    JSR     GROUP_AE_JMPTBL_LAB_0B44(PC)

    LEA     12(A7),A7
    MOVE.L  24(A7),D1
    MOVE.L  D0,56(A2,D1.L)
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   .loc_04DE

    MOVEQ   #0,D0
    MOVE.B  40(A3),D0
    ORI.W   #$80,D0
    MOVE.B  D0,40(A3)

.loc_04DE:
    ADDQ.W  #1,D5
    BRA.W   .loc_04D9

.loc_04DF:
    CMPI.W  #4,LAB_1C41
    BLE.S   .loc_04E0

    MOVEQ   #-1,D0
    CMP.W   -28(A5),D0
    BNE.S   .loc_04E0

    JSR     LAB_03B6(PC)

    MOVE.W  D0,-28(A5)

.loc_04E0:
    MOVEQ   #-1,D0
    CMP.L   -32(A5),D0
    BNE.S   .loc_04E1

    PEA     52.W
    MOVE.L  A3,-(A7)
    PEA     1027.W
    PEA     GLOB_STR_DISKIO2_C_20
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    PEA     500.W
    MOVE.L  A2,-(A7)
    PEA     1028.W
    PEA     GLOB_STR_DISKIO2_C_21
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     32(A7),A7
    BRA.S   .loc_04E2

.loc_04E1:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2235,A0
    ADDA.L  D0,A0
    MOVE.L  A3,(A0)
    LEA     LAB_2237,A0
    ADDA.L  D0,A0
    MOVE.L  A2,(A0)
    ADDQ.W  #1,D7
    BRA.W   .loc_04D2

.loc_04E2:
    MOVE.B  -37(A5),LAB_2239
    MOVE.L  D7,D0
    MOVE.W  D0,LAB_222F
    MOVE.L  -36(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     1041.W
    PEA     GLOB_STR_DISKIO2_C_22
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0
    MOVE.B  -37(A5),D0
    MOVE.L  D0,(A7)
    JSR     COI_LoadOiDataFile(PC)

    LEA     16(A7),A7
    ADDQ.L  #1,D0
    BEQ.S   .loc_04E3

    MOVE.B  #$1,LAB_1B90
    MOVE.B  -37(A5),LAB_1B92
    BRA.S   .loc_04E4

.loc_04E3:
    MOVEQ   #0,D0
    MOVE.B  D0,LAB_1B90
    MOVE.B  D0,LAB_1B92

.loc_04E4:
    MOVE.L  -32(A5),D0

.loc_04E5:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_04E6   (Write INI-style banner list to disk??)
; ARGS:
;   ??
; RET:
;   D0: -1 on failure, 0 on success ??
; CLOBBERS:
;   D0/D7 ??
; CALLS:
;   DISKIO_OpenFileWithBuffer, LAB_03A0, LAB_039A
; READS:
;   LAB_1DDA, LAB_224F tables
; WRITES:
;   LAB_21BF
; DESC:
;   Writes a banner list file using the current LAB_224F entries.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_04E6:
    LINK.W  A5,#-12
    MOVE.L  D7,-(A7)
    MOVE.L  #LAB_1C68,-4(A5)
    MOVE.W  LAB_1DDA,D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BGE.S   .loc_04E7

    MOVEQ   #-1,D0
    BRA.W   .loc_04EF

.loc_04E7:
    PEA     MODE_NEWFILE.W
    PEA     LAB_1B9C
    JSR     DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_21BF
    TST.L   D0
    BEQ.S   .loc_04E8

    MOVE.W  LAB_1DDA,D0
    BNE.S   .loc_04E9

.loc_04E8:
    MOVEQ   #-1,D0
    BRA.W   .loc_04EF

.loc_04E9:
    MOVEA.L -4(A5),A0

.loc_04EA:
    TST.B   (A0)+
    BNE.S   .loc_04EA

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    PEA     2.W
    PEA     LAB_1C69
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    LEA     24(A7),A7
    MOVEQ   #0,D7

    ; Emit each banner entry with separators.
.loc_04EB:
    MOVE.W  LAB_1DDA,D0
    CMP.W   D0,D7
    BCC.W   .loc_04EE

    MOVEQ   #0,D0
    MOVE.W  D7,D0
    ASL.L   #2,D0
    LEA     LAB_224F,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    MOVEA.L -8(A5),A1
    MOVEA.L (A1),A0

.loc_04EC:
    ; Write first string field.
    TST.B   (A0)+
    BNE.S   .loc_04EC

    SUBQ.L  #1,A0
    SUBA.L  (A1),A0
    MOVE.L  A0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    PEA     1.W
    PEA     LAB_1C6A
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    PEA     1.W
    PEA     LAB_1C6B
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    MOVEA.L -8(A5),A1
    MOVEA.L 4(A1),A0

.loc_04ED:
    ; Write second string field.
    TST.B   (A0)+
    BNE.S   .loc_04ED

    SUBQ.L  #1,A0
    SUBA.L  4(A1),A0
    MOVE.L  A0,(A7)
    MOVE.L  4(A1),-(A7)
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    PEA     1.W
    PEA     LAB_1C6C
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    PEA     2.W
    PEA     LAB_1C6D
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_03A0(PC)

    LEA     68(A7),A7
    ADDQ.W  #1,D7
    BRA.W   .loc_04EB

.loc_04EE:
    MOVE.L  LAB_21BF,-(A7)
    JSR     LAB_039A(PC)

.loc_04EF:
    MOVE.L  -16(A5),D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_04F0   (Parse INI file from disk.)
; ARGS:
;   ??
; RET:
;   D0: ??
; CLOBBERS:
;   D0 ??
; CALLS:
;   GROUP_AH_JMPTBL_LAB_0B34, PARSEINI_ParseConfigBuffer
; READS:
;   LAB_1B9C
; WRITES:
;   ??
; DESC:
;   Invokes the INI parser for the LAB_1B9C file.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_04F0:
    JSR     GROUP_AH_JMPTBL_LAB_0B34(PC)

    PEA     LAB_1B9C
    JSR     GROUP_AK_JMPTBL_PARSEINI_ParseConfigBuffer(PC)

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_04F1   (Write small config file LAB_1B9D.)
; ARGS:
;   ??
; RET:
;   D0: 0 on success, -1 on failure ??
; CLOBBERS:
;   D0/A0 ??
; CALLS:
;   DISKIO_OpenFileWithBuffer, LAB_03A0, LAB_03A9, LAB_039A
; READS:
;   LAB_2230, LAB_1DDB, LAB_1DDC
; WRITES:
;   LAB_21C0
; DESC:
;   Opens LAB_1B9D and writes two optional strings plus a header byte.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_04F1:
    LINK.W  A5,#-8
    PEA     MODE_NEWFILE.W
    PEA     LAB_1B9D
    JSR     DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_21C0
    TST.L   D0
    BNE.S   .loc_04F2

    MOVEQ   #-1,D0
    BRA.W   .loc_04F9

.loc_04F2:
    CLR.B   -5(A5)
    MOVEQ   #0,D0
    MOVE.B  LAB_2230,D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21C0,-(A7)
    JSR     LAB_03A9(PC)

    ADDQ.W  #8,A7
    TST.L   LAB_1DDB
    BNE.S   .loc_04F3

    LEA     -5(A5),A0
    BRA.S   .loc_04F4

.loc_04F3:
    MOVEA.L LAB_1DDB,A0

.loc_04F4:
    MOVEA.L A0,A1

    ; Write first optional string.
.loc_04F5:
    TST.B   (A1)+
    BNE.S   .loc_04F5

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  LAB_21C0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     LAB_03A0(PC)

    LEA     12(A7),A7
    TST.L   LAB_1DDC
    BNE.S   .loc_04F6

    LEA     -5(A5),A0
    BRA.S   .loc_04F7

.loc_04F6:
    MOVEA.L LAB_1DDC,A0

.loc_04F7:
    MOVEA.L A0,A1

    ; Write second optional string.
.loc_04F8:
    TST.B   (A1)+
    BNE.S   .loc_04F8

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  LAB_21C0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     LAB_03A0(PC)

    MOVE.L  LAB_21C0,(A7)
    JSR     LAB_039A(PC)

    MOVEQ   #0,D0

.loc_04F9:
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_04FA   (Read config file LAB_1B9D.)
; ARGS:
;   ??
; RET:
;   D0: 0 on success, -1 on failure ??
; CLOBBERS:
;   D0/D6-D7/A2 ??
; CALLS:
;   LAB_03AC, LAB_03B2, GROUP_AE_JMPTBL_LAB_0B44, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   LAB_1B9D, LAB_2230
; WRITES:
;   LAB_1DDB, LAB_1DDC
; DESC:
;   Parses two strings from LAB_1B9D and stores them in globals.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_04FA:
    LINK.W  A5,#-20
    MOVEM.L D6-D7/A2,-(A7)
    SUBA.L  A0,A0
    PEA     LAB_1B9D
    MOVE.L  A0,-8(A5)
    MOVE.L  A0,-4(A5)
    JSR     LAB_03AC(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .loc_04FB

    MOVEQ   #-1,D0
    BRA.W   .loc_04FE

.loc_04FB:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D6
    MOVE.L  LAB_21BC,-12(A5)
    JSR     LAB_03B6(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    NOT.B   D0
    AND.L   D0,D1
    MOVE.L  D1,D7
    MOVE.B  LAB_2230,D0
    CMP.B   D0,D7
    BNE.S   .loc_04FC

    JSR     LAB_03B2(PC)

    MOVE.L  D0,-4(A5)
    JSR     LAB_03B2(PC)

    MOVE.L  D0,-8(A5)

.loc_04FC:
    MOVEA.W #$ffff,A0
    MOVEA.L -4(A5),A1
    CMPA.L  A1,A0
    BEQ.S   .loc_04FD

    MOVEA.L -8(A5),A2
    CMPA.L  A0,A2
    BEQ.S   .loc_04FD

    MOVE.L  LAB_1DDB,-(A7)
    MOVE.L  A1,-(A7)
    JSR     GROUP_AE_JMPTBL_LAB_0B44(PC)

    MOVE.L  D0,LAB_1DDB
    MOVE.L  LAB_1DDC,(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     GROUP_AE_JMPTBL_LAB_0B44(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_1DDC

.loc_04FD:
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     1191.W
    PEA     GLOB_STR_DISKIO2_C_23
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0

.loc_04FE:
    MOVEM.L -32(A5),D6-D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_04FF   (Interactive file receive/save workflow??)
; ARGS:
;   stack +7: mode flag ?? (D7)
; RET:
;   D0: 0/1 ?? (status)
; CLOBBERS:
;   D0-D7 ??
; CALLS:
;   LAB_053D, LAB_0544, LAB_0549, DISPLIB_DisplayTextAtPosition, LAB_0470,
;   _LVOLock/_LVOUnLock/_LVOOpen/_LVOClose/_LVORead/_LVOWrite/_LVODeleteFile,
;   GROUP_AM_JMPTBL_WDISP_SPrintf, LAB_0546, LAB_053E, LAB_0547, LAB_0548
; READS:
;   LAB_21C2..LAB_21CB, LAB_2252, LAB_21C7, LAB_1B9A
; WRITES:
;   LAB_21C2..LAB_21CC, LAB_21BD/21CB, LAB_1F45
; DESC:
;   Reads a filename and payload, validates/locks the target, and writes the data.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_04FF:
    LINK.W  A5,#-160
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.B  11(A5),D7
    PEA     1.W
    PEA     4.W
    JSR     LAB_053D(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D5
    CLR.B   -17(A5)
    TST.B   D7
    BEQ.S   .loc_0500

    MOVE.B  #$c2,LAB_21C7
    BRA.S   .loc_0501

.loc_0500:
    MOVE.B  #$b7,LAB_21C7

.loc_0501:
    JSR     LAB_0544(PC)

    ; Read filename into LAB_21C2 with checksum.
.loc_0502:
    CMPI.B  #$1f,-17(A5)
    BCC.S   .loc_0503

    JSR     LAB_0549(PC)

    MOVE.B  D0,-18(A5)
    TST.B   D0
    BEQ.S   .loc_0503

    MOVE.B  -17(A5),D1
    ADDQ.B  #1,-17(A5)
    MOVEQ   #0,D2
    MOVE.B  D1,D2
    LEA     LAB_21C2,A0
    ADDA.W  D2,A0
    MOVE.B  D0,(A0)
    MOVE.B  LAB_21C7,D1
    EOR.B   D0,D1
    MOVE.B  D1,LAB_21C7
    JSR     LAB_0544(PC)

    BRA.S   .loc_0502

.loc_0503:
    MOVEQ   #0,D0
    MOVE.B  -17(A5),D0
    LEA     LAB_21C2,A0
    ADDA.W  D0,A0
    CLR.B   (A0)
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BNE.S   .loc_0504

    PEA     LAB_1B9A
    PEA     LAB_21C3
    JSR     GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .loc_0504

    MOVEQ   #0,D5
    TST.W   LAB_2252
    BEQ.S   .loc_0504

    PEA     GLOB_STR_SPECIAL_NGAD
    PEA     240.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7

.loc_0504:
    LEA     LAB_21C2,A0
    LEA     -58(A5),A1

.loc_0505:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_0505

    PEA     4.W
    PEA     GLOB_STR_RAM
    PEA     -58(A5)
    JSR     LAB_0470(PC)

    LEA     12(A7),A7
    TST.W   LAB_2252
    BEQ.S   .loc_0506

    PEA     GLOB_STR_FILENAME
    PEA     180.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     LAB_21C2
    PEA     180.W
    PEA     205.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7

.loc_0506:
    PEA     4.W
    PEA     LAB_21C2
    PEA     -68(A5)
    JSR     LAB_0470(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVE.B  D0,-64(A5)
    TST.B   D7
    BEQ.W   .loc_050D

    MOVE.B  D0,-17(A5)
    JSR     LAB_0544(PC)

    ; Read secondary token into LAB_21C4 with checksum.
.loc_0507:
    CMPI.B  #$8,-17(A5)
    BCC.S   .loc_0508

    JSR     LAB_0549(PC)

    MOVE.B  D0,-18(A5)
    TST.B   D0
    BEQ.S   .loc_0508

    MOVE.B  -17(A5),D1
    ADDQ.B  #1,-17(A5)
    MOVEQ   #0,D2
    MOVE.B  D1,D2
    LEA     LAB_21C4,A0
    ADDA.W  D2,A0
    MOVE.B  D0,(A0)
    MOVE.B  LAB_21C7,D1
    EOR.B   D0,D1
    MOVE.B  D1,LAB_21C7
    JSR     LAB_0544(PC)

    BRA.S   .loc_0507

.loc_0508:
    MOVEQ   #0,D0
    MOVE.B  -17(A5),D0
    LEA     LAB_21C4,A0
    ADDA.W  D0,A0
    CLR.B   (A0)
    LEA     -68(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #-2,D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,-76(A5)
    TST.L   D0
    BEQ.S   .loc_050B

    MOVE.L  #(MEMF_CLEAR),-(A7)
    PEA     Struct_InfoData_Size.W
    PEA     1312.W
    PEA     GLOB_STR_DISKIO2_C_24
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-72(A5)
    TST.L   D0
    BEQ.S   .loc_050A

    MOVE.L  D0,D2
    MOVE.L  -76(A5),D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOInfo(A6)

    TST.L   D0
    BEQ.S   .loc_0509

    MOVE.L  #$6de,D0
    MOVEA.L D2,A0
    SUB.L   16(A0),D0
    ASL.L   #8,D0
    ADD.L   D0,D0
    SUBI.L  #$1000,D0
    MOVE.L  D0,-12(A5)

.loc_0509:
    PEA     Struct_InfoData_Size.W
    MOVE.L  D2,-(A7)
    PEA     1318.W
    PEA     GLOB_STR_DISKIO2_C_25
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.loc_050A:
    MOVE.L  -76(A5),D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOUnLock(A6)

.loc_050B:
    PEA     LAB_21C4
    JSR     LAB_054B(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-16(A5)
    CMP.L   -12(A5),D0
    BLE.S   .loc_050D

    LEA     LAB_21C2,A0
    LEA     BRUSH_SnapshotHeader,A1   ; refresh saved UI header with on-disk metadata

.loc_050C:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_050C

    PEA     2.W
    JSR     LAB_0546(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_21BD
    MOVE.L  D0,(A7)
    PEA     4.W
    JSR     LAB_053D(PC)

    MOVEQ   #-2,D0
    BRA.W   .loc_0519

.loc_050D:
    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,LAB_2253
    MOVE.B  LAB_21C7,D1
    CMP.B   D1,D0
    BNE.W   .loc_0518

    MOVEQ   #1,D0
    CMP.L   D0,D5
    BNE.W   .loc_0518

    PEA     (MODE_NEWFILE).W
    PEA     -58(A5)
    JSR     GROUP_AG_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_21C5
    TST.L   D0
    BNE.S   .loc_050E

    PEA     5.W
    JSR     LAB_03DE(PC)

    CLR.L   (A7)
    PEA     4.W
    JSR     LAB_053D(PC)

    MOVEQ   #-1,D0
    BRA.W   .loc_0519

.loc_050E:
    MOVE.W  LAB_1F45,LAB_21CB
    MOVE.W  #$100,LAB_1F45
    CLR.L   LAB_21CC
    CLR.B   LAB_21C8
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     4352.W
    PEA     1389.W
    PEA     GLOB_STR_DISKIO2_C_26
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,LAB_21C9
    MOVE.W  LAB_21CB,LAB_1F45
    CLR.W   LAB_21CA

.loc_050F:
    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,-18(A5)
    MOVEQ   #85,D0
    CMP.B   -18(A5),D0
    BNE.S   .loc_050F

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-18(A5)
    MOVEQ   #85,D0
    ADD.L   D0,D0
    CMP.L   D0,D1
    BNE.S   .loc_050F

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,-18(A5)
    MOVEQ   #72,D1
    CMP.B   D1,D0
    BEQ.S   .loc_0510

    MOVEQ   #61,D1
    CMP.B   D1,D0
    BNE.S   .loc_0513

.loc_0510:
    MOVEQ   #61,D1
    CMP.B   D1,D0
    BNE.S   .loc_0511

    MOVE.B  #$c2,LAB_21C7
    BRA.S   .loc_0512

.loc_0511:
    MOVE.B  #$b7,LAB_21C7

.loc_0512:
    CMP.B   D1,D0
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   LAB_051A

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .loc_050F

    BRA.S   .loc_0514

.loc_0513:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #68,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.W   .loc_050F

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-18(A5)
    MOVEQ   #68,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.W   .loc_050F

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,-18(A5)
    BNE.W   .loc_050F

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-18(A5)
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.W   .loc_050F

    MOVEQ   #4,D6

.loc_0514:
    MOVE.W  LAB_1F45,LAB_21CB
    MOVE.W  #$100,LAB_1F45
    MOVE.L  LAB_21C5,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    PEA     4352.W
    MOVE.L  LAB_21C9,-(A7)
    PEA     1499.W
    PEA     GLOB_STR_DISKIO2_C_27
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    TST.W   LAB_2252
    BEQ.S   .loc_0515

    PEA     LAB_1C76
    PEA     210.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    PEA     LAB_1C77
    PEA     240.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7

.loc_0515:
    MOVEQ   #-1,D0
    CMP.L   D0,D6

    BNE.W   .loc_0516

    LEA     LAB_21C2,A0
    MOVE.L  A0,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVODeleteFile(A6)

    JSR     LAB_03CB(PC)

    LEA     GLOB_STR_COPY_NIL,A0
    LEA     -156(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    PEA     -58(A5)
    PEA     -156(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    PEA     LAB_1C79
    PEA     -156(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    PEA     LAB_21C2
    PEA     -156(A5)
    JSR     GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     -156(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    LEA     -58(A5),A0
    MOVE.L  A0,D1
    JSR     _LVODeleteFile(A6)

    JSR     LAB_03CD(PC)

    LEA     24(A7),A7
    TST.W   LAB_2252
    BEQ.S   .loc_0517

    PEA     GLOB_STR_STORED
    PEA     180.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    BRA.S   .loc_0517

.loc_0516:
    MOVE.L  D6,-(A7)
    JSR     LAB_03DE(PC)

    ADDQ.W  #4,A7
    LEA     -58(A5),A0
    MOVE.L  A0,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVODeleteFile(A6)

.loc_0517:
    MOVE.W  LAB_21CB,LAB_1F45

.loc_0518:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_21BD
    MOVE.L  D0,-(A7)
    PEA     4.W
    JSR     LAB_053D(PC)

    ADDQ.W  #8,A7
    TST.W   LAB_2252
    BEQ.S   .loc_0519

    PEA     LAB_1C7C
    JSR     LAB_03C0(PC)

    PEA     LAB_1C7D
    MOVE.L  D0,28(A7)
    JSR     LAB_03C4(PC)

    MOVE.L  D0,(A7)
    MOVE.L  28(A7),-(A7)
    PEA     GLOB_STR_DISK_0_IS_FULL_WITH_ERRORS_FORMATTED
    PEA     -58(A5)
    JSR     GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -58(A5)
    PEA     90.W
    PEA     40.W
    MOVE.L  GLOB_REF_RASTPORT_1,-(A7)
    JSR     DISPLIB_DisplayTextAtPosition(PC)

    LEA     36(A7),A7

.loc_0519:
    MOVEM.L -180(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_051A   (Receive data block and write to disk??)
; ARGS:
;   stack +7: mode flag ?? (D7)
; RET:
;   D0: status code ??
; CLOBBERS:
;   D0-D7 ??
; CALLS:
;   LAB_0544, LAB_0549, LAB_03C8, LAB_0546, LAB_03DE, _LVODeleteFile
; READS:
;   LAB_21C6..LAB_21CC, LAB_2285, LAB_21C7
; WRITES:
;   LAB_21C6..LAB_21CC, LAB_2285
; DESC:
;   Reads a variable-length data stream with checksum tracking and writes it out.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_051A:
    LINK.W  A5,#-1040
    MOVEM.L D2-D7,-(A7)

    MOVE.B  11(A5),D7
    MOVEQ   #-1,D0
    MOVE.L  D0,-10(A5)
    CLR.L   -14(A5)
    CLR.B   -16(A5)
    LEA     LAB_1C7E,A0
    LEA     -1040(A5),A1
    MOVE.W  #$ff,D0

.loc_051B:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.loc_051B

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.L  D0,D4
    MOVE.W  LAB_2285,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2285
    MOVE.B  LAB_21C8,D0
    CMP.B   D0,D4
    BNE.W   .loc_0529

    MOVE.B  LAB_21C7,D1
    EOR.B   D0,D1
    MOVE.B  D1,LAB_21C7
    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,LAB_21C6
    TST.B   D0
    BEQ.W   .loc_0524

    MOVE.B  LAB_21C7,D1
    EOR.B   D0,D1
    MOVE.B  D1,LAB_21C7
    MOVE.W  LAB_21CA,D5
    MOVEQ   #0,D6

    ; Stream in payload bytes and fold into checksum.
.loc_051C:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  LAB_21C6,D1
    CMP.L   D1,D0
    BEQ.S   .loc_051D

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.L  D0,D4
    MOVE.B  LAB_21C7,D0
    EOR.B   D4,D0
    MOVE.B  D0,LAB_21C7
    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVE.L  -10(A5),D1
    EOR.L   D1,D0
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D0
    ASL.L   #2,D0
    LEA     -1040(A5),A0
    ADDA.L  D0,A0
    LSR.L   #8,D1
    MOVE.L  (A0),D0
    EOR.L   D1,D0
    MOVE.L  D5,D1
    ADDQ.W  #1,D5
    MOVEA.L LAB_21C9,A0
    ADDA.W  D1,A0
    MOVE.B  D4,(A0)
    MOVE.L  D0,-10(A5)
    ADDQ.W  #1,D6
    BRA.S   .loc_051C

.loc_051D:
    TST.B   D7
    BEQ.S   .loc_0520

    CLR.L   -14(A5)
    MOVEQ   #0,D6

.loc_051E:
    MOVEQ   #4,D0
    CMP.W   D0,D6
    BGE.S   .loc_051F

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  LAB_21C7,D1
    EOR.B   D0,D1
    MOVE.B  D1,LAB_21C7
    MOVE.L  -14(A5),D1
    ASL.L   #8,D1
    MOVEQ   #0,D2
    MOVE.B  D0,D2
    MOVEQ   #0,D3
    NOT.B   D3
    AND.L   D3,D2
    OR.L    D2,D1
    MOVE.B  D0,-15(A5)
    MOVE.L  D1,-14(A5)
    ADDQ.W  #1,D6
    BRA.S   .loc_051E

.loc_051F:
    MOVE.L  -10(A5),D0
    CMP.L   -14(A5),D0
    BEQ.S   .loc_0520

    MOVEQ   #1,D0
    MOVE.B  D0,-16(A5)

.loc_0520:
    TST.B   -16(A5)
    BNE.S   .loc_0523

    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,LAB_2253
    MOVE.B  LAB_21C7,D1
    CMP.B   D1,D0
    BNE.W   .loc_0528

    MOVE.W  D5,LAB_21CA
    CMPI.W  #$1000,D5
    BLT.S   .loc_0522

    MOVE.L  D5,D0
    MOVE.W  D0,LAB_21CA
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21C9,-(A7)
    JSR     LAB_03C8(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .loc_0521

    MOVEQ   #2,D0
    BRA.W   .loc_052C

.loc_0521:
    CLR.W   LAB_21CA

.loc_0522:
    MOVE.B  LAB_21C8,D0
    MOVE.L  D0,D1
    ADDQ.B  #1,D1
    MOVE.B  D1,LAB_21C8
    MOVEQ   #0,D0
    MOVE.B  D1,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.B  D0,LAB_21C8
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_21CC
    BRA.S   .loc_0528

.loc_0523:
    CLR.B   -16(A5)
    ADDQ.L  #1,LAB_21CC
    BRA.S   .loc_0528

.loc_0524:
    JSR     LAB_0544(PC)

    JSR     LAB_0549(PC)

    MOVE.B  D0,LAB_2253
    MOVE.B  LAB_21C7,D1
    CMP.B   D1,D0
    BNE.S   .loc_0527

    MOVE.W  LAB_21CA,D0
    BLE.S   .loc_0526

    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_21C9,-(A7)
    JSR     LAB_03C8(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .loc_0525

    MOVEQ   #3,D0
    BRA.S   .loc_052C

.loc_0525:
    CLR.W   LAB_21CA

.loc_0526:
    MOVEQ   #-1,D0
    BRA.S   .loc_052C

.loc_0527:
    MOVE.B  #$1,-16(A5)
    ADDQ.L  #1,LAB_21CC

.loc_0528:
    MOVEQ   #0,D0
    BRA.S   .loc_052C

.loc_0529:
    MOVEQ   #0,D0
    MOVE.B  D4,D0
    ADDQ.L  #1,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  LAB_21C8,D1
    CMP.L   D1,D0
    BNE.S   .loc_052A

    MOVEQ   #0,D0
    BRA.S   .loc_052C

.loc_052A:
    LEA     LAB_21C2,A0
    LEA     BRUSH_SnapshotHeader,A1   ; keep error dialog text in sync with disk state

.loc_052B:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_052B

    PEA     1.W
    JSR     LAB_0546(PC)

    MOVEQ   #1,D0

.loc_052C:
    MOVEM.L -1064(A5),D2-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_052D   (Copy and sanitize slot string.)
; ARGS:
;   stack +8: dest buffer (A3)
;   stack +12: entry struct (A2)
;   stack +16: table base ??
;   stack +22: slot index (D7)
; RET:
;   D0: dest pointer (or 0 if not copied)
; CLOBBERS:
;   D0/D7/A2-A3 ??
; CALLS:
;   LAB_05C1, LAB_0547
; READS:
;   7(A0,D7), 27(A2)
; WRITES:
;   dest buffer
; DESC:
;   Copies a slot string to the destination, trims/normalizes, and terminates it.
; NOTES:
;   Skips copy when flags indicate the slot should be hidden.
;------------------------------------------------------------------------------
LAB_052D:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  22(A5),D7
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 16(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)
    MOVE.L  A2,D0
    BEQ.W   .loc_0534

    TST.L   16(A5)
    BEQ.W   .loc_0534

    TST.W   D7
    BLE.W   .loc_0534

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.W   .loc_0534

    MOVE.L  A0,D0
    BEQ.W   .loc_0534

    TST.B   (A0)
    BEQ.W   .loc_0534

    MOVEA.L 16(A5),A0
    BTST    #1,7(A0,D7.W)
    BNE.S   .loc_052E

    BTST    #4,27(A2)
    BEQ.S   .loc_0534

.loc_052E:
    MOVEA.L -12(A5),A0
    MOVEA.L A3,A1

    ; Copy source string into destination buffer.
.loc_052F:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loc_052F

    PEA     34.W
    MOVE.L  A3,-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BEQ.S   .loc_0530

    ADDQ.L  #1,-4(A5)
    PEA     34.W
    MOVE.L  -4(A5),-(A7)
    JSR     LAB_05C1(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)

.loc_0530:
    TST.L   D0
    BEQ.S   .loc_0533

    PEA     LAB_2018
    MOVE.L  D0,-(A7)
    JSR     LAB_0547(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .loc_0531

    MOVE.L  D0,-4(A5)

.loc_0531:
    ; Skip leading spaces after expansion.
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .loc_0532

    MOVEQ   #32,D0
    CMP.B   (A0),D0
    BEQ.S   .loc_0532

    ADDQ.L  #1,-4(A5)
    BRA.S   .loc_0531

.loc_0532:
    MOVEA.L -4(A5),A0
    CLR.B   (A0)

.loc_0533:
    MOVEA.L A3,A0
    MOVE.L  A0,-12(A5)

.loc_0534:
    MOVE.L  -12(A5),D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_0535   (Flush disk data files if needed.)
; ARGS:
;   ??
; RET:
;   D0: none
; CLOBBERS:
;   D0 ??
; CALLS:
;   LAB_0471, LAB_04C1, LAB_04F1, COI_WriteOiDataFile
; READS:
;   LAB_1C7F, LAB_2231, LAB_1B8F/1B90
; WRITES:
;   LAB_1C7F
; DESC:
;   Guards against reentry and writes disk-related data files when eligible.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_0535:
    TST.W   LAB_1C7F
    BNE.S   .loc_0538

    MOVE.W  #1,LAB_1C7F
    MOVE.W  LAB_2231,D0
    CMPI.W  #$c9,D0
    BCC.S   .loc_0537

    BSR.W   LAB_0471

    BSR.W   LAB_04C1

    BSR.W   LAB_04F1

    TST.B   LAB_1B8F
    BEQ.S   .loc_0536

    MOVEQ   #0,D0
    MOVE.B  LAB_1B91,D0
    MOVE.L  D0,-(A7)
    JSR     COI_WriteOiDataFile(PC)

    ADDQ.W  #4,A7

.loc_0536:
    TST.B   LAB_1B90
    BEQ.S   .loc_0537

    MOVEQ   #0,D0
    MOVE.B  LAB_1B92,D0
    MOVE.L  D0,-(A7)
    JSR     COI_WriteOiDataFile(PC)

    ADDQ.W  #4,A7

.loc_0537:
    CLR.W   LAB_1C7F

.loc_0538:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LAB_0539   (Load disk data files and refresh state.)
; ARGS:
;   ??
; RET:
;   D0: none
; CLOBBERS:
;   D0 ??
; CALLS:
;   LAB_0497, LAB_04D0, LAB_04FA, LAB_053B
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Wrapper that reloads multiple disk data files and applies updates.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_0539:
    BSR.W   LAB_0497

    BSR.W   LAB_04D0

    BSR.W   LAB_04FA

    JSR     LAB_053B(PC)

    RTS

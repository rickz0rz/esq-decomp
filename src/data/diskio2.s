; ========== DISKIO2.c ==========

Global_STR_DISKIO2_C_1:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_2:
    NStr    "DISKIO2.c"
Global_STR_DREV_5_1:
    NStr    "DREV 5"
Global_STR_DISKIO2_C_3:
    NStr    "DISKIO2.c"
Global_STR_38_SPACES:
    NStr    "                                      "
DISKIO2_STR_SAVING_PROGRAMMING_DATA_DOT:
    NStr    "Saving programming data.           "
DISKIO2_STR_SAVING_TEXT_ADS_DOT:
    NStr    "Saving Text Ads.                   "
DISKIO2_STR_SAVING_CONFIGURATION_FILE_DOT:
    NStr    "Saving configuration file.         "
DISKIO2_STR_SAVING_LOCAL_AVAIL_CFG_DOT:
    NStr    "Saving Local Avail Cfg.            "
DISKIO2_STR_SAVING_QTABLE_DOT:
    NStr    "Saving QTABLE.                     "
DISKIO2_STR_SAVING_ERROR_LOG_DOT:
    NStr    "Saving Error Log.                  "
DISKIO2_STR_SAVING_DST_DATA_DOT:
    NStr    "Saving DST data.                   "
DISKIO2_STR_SAVING_PROMO_TYPES:
    NStr    "Saving Promo Types                 "
DISKIO2_STR_SAVING_DATA_VIEW_CONFIG:
    NStr    "Saving Data View config            "
Global_STR_DISKIO2_C_4:
    NStr    "DISKIO2.c"
DISKIO2_STR_DREV_1:
    NStr    "DREV 1"
DISKIO2_STR_DREV_2:
    NStr    "DREV 2"
DISKIO2_STR_DREV_3:
    NStr    "DREV 3"
DISKIO2_STR_DREV_4:
    NStr    "DREV 4"
DISKIO2_STR_DREV_5:
    NStr    "DREV 5"
Global_STR_DISKIO2_C_5:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_6:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_7:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_8:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_9:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_10:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_11:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_12:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_13:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_14:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_15:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_16:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_17:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_18:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_19:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_20:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_21:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_22:
    NStr    "DISKIO2.c"
DISKIO2_STR_QTABLE:
    NStr    "[Qtable]"
DISKIO2_STR_QTableLineBreakAfterHeader:
    NStr2   TextCarriageReturn,TextLineFeed
DISKIO2_STR_QTableEquals:
    NStr    "="
DISKIO2_STR_QTableValueQuoteOpen:
    NStr    """" ; escaped quote
DISKIO2_STR_QTableValueQuoteClose:
    NStr    """" ; escaped quote
DISKIO2_STR_QTableLineBreakAfterEntry:
    NStr2   TextCarriageReturn,TextLineFeed
Global_STR_DISKIO2_C_23:
    NStr    "DISKIO2.c"
Global_STR_SPECIAL_NGAD:
    NStr    "Special NGAD"
Global_STR_RAM:
    NStr    "RAM:"
Global_STR_FILENAME:
    NStr    "Filename:                            "
Global_STR_DISKIO2_C_24:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_25:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_26:
    NStr    "DISKIO2.c"
Global_STR_DISKIO2_C_27:
    NStr    "DISKIO2.c"
DISKIO2_STR_DiagTransferStatusClearLine210:
    NStr    "                                      "
DISKIO2_STR_DiagTransferStatusClearLine240:
    NStr    "                                      "
Global_STR_COPY_NIL:
    NStr    "Copy >nil: "
DISKIO2_STR_ShellCommandArgSeparator:
    NStr    " "
Global_STR_STORED:
    NStr    "Stored:   "
Global_STR_DISK_0_IS_FULL_WITH_ERRORS_FORMATTED:
    NStr    "Disk 0 is %ld%% full with %ld Errors"
DISKIO2_DiagnosticsDiskUsagePercentBuffer:
    DS.W    1
DISKIO2_DiagnosticsSoftErrorCountBuffer:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: DISKIO2_TransferCrc32Table   (serial transfer CRC32 lookup table)
; TYPE: u32[256]
; PURPOSE: Lookup table for per-byte CRC update in transfer block receiver.
; USED BY: DISKIO2_ReceiveTransferBlocksToFile
; NOTES:
;   First entry is zero (stored via DS.L 1), followed by reflected CRC-32
;   polynomial table constants (`0x77073096` ...).
;------------------------------------------------------------------------------
DISKIO2_TransferCrc32Table:
    DC.L    $00000000,$77073096,$ee0e612c,$990951ba,$076dc419,$706af48f,$e963a535,$9e6495a3
    DC.L    $0edb8832,$79dcb8a4,$e0d5e91e,$97d2d988,$09b64c2b,$7eb17cbd,$e7b82d07,$90bf1d91
    DC.L    $1db71064,$6ab020f2,$f3b97148,$84be41de,$1adad47d,$6ddde4eb,$f4d4b551,$83d385c7
    DC.L    $136c9856,$646ba8c0,$fd62f97a,$8a65c9ec,$14015c4f,$63066cd9,$fa0f3d63,$8d080df5
    DC.L    $3b6e20c8,$4c69105e,$d56041e4,$a2677172,$3c03e4d1,$4b04d447,$d20d85fd,$a50ab56b
    DC.L    $35b5a8fa,$42b2986c,$dbbbc9d6,$acbcf940,$32d86ce3,$45df5c75,$dcd60dcf,$abd13d59
    DC.L    $26d930ac,$51de003a,$c8d75180,$bfd06116,$21b4f4b5,$56b3c423,$cfba9599,$b8bda50f
    DC.L    $2802b89e,$5f058808,$c60cd9b2,$b10be924,$2f6f7c87,$58684c11,$c1611dab,$b6662d3d
    DC.L    $76dc4190,$01db7106,$98d220bc,$efd5102a,$71b18589,$06b6b51f,$9fbfe4a5,$e8b8d433
    DC.L    $7807c9a2,$0f00f934,$9609a88e,$e10e9818,$7f6a0dbb,$086d3d2d,$91646c97,$e6635c01
    DC.L    $6b6b51f4,$1c6c6162,$856530d8,$f262004e,$6c0695ed,$1b01a57b,$8208f4c1,$f50fc457
    DC.L    $65b0d9c6,$12b7e950,$8bbeb8ea,$fcb9887c,$62dd1ddf,$15da2d49,$8cd37cf3,$fbd44c65
    DC.L    $4db26158,$3ab551ce,$a3bc0074,$d4bb30e2,$4adfa541,$3dd895d7,$a4d1c46d,$d3d6f4fb
    DC.L    $4369e96a,$346ed9fc,$ad678846,$da60b8d0,$44042d73,$33031de5,$aa0a4c5f,$dd0d7cc9
    DC.L    $5005713c,$270241aa,$be0b1010,$c90c2086,$5768b525,$206f85b3,$b966d409,$ce61e49f
    DC.L    $5edef90e,$29d9c998,$b0d09822,$c7d7a8b4,$59b33d17,$2eb40d81,$b7bd5c3b,$c0ba6cad
    DC.L    $edb88320,$9abfb3b6,$03b6e20c,$74b1d29a,$ead54739,$9dd277af,$04db2615,$73dc1683
    DC.L    $e3630b12,$94643b84,$0d6d6a3e,$7a6a5aa8,$e40ecf0b,$9309ff9d,$0a00ae27,$7d079eb1
    DC.L    $f00f9344,$8708a3d2,$1e01f268,$6906c2fe,$f762575d,$806567cb,$196c3671,$6e6b06e7
    DC.L    $fed41b76,$89d32be0,$10da7a5a,$67dd4acc,$f9b9df6f,$8ebeeff9,$17b7be43,$60b08ed5
    DC.L    $d6d6a3e8,$a1d1937e,$38d8c2c4,$4fdff252,$d1bb67f1,$a6bc5767,$3fb506dd,$48b2364b
    DC.L    $d80d2bda,$af0a1b4c,$36034af6,$41047a60,$df60efc3,$a867df55,$316e8eef,$4669be79
    DC.L    $cb61b38c,$bc66831a,$256fd2a0,$5268e236,$cc0c7795,$bb0b4703,$220216b9,$5505262f
    DC.L    $c5ba3bbe,$b2bd0b28,$2bb45a92,$5cb36a04,$c2d7ffa7,$b5d0cf31,$2cd99e8b,$5bdeae1d
    DC.L    $9b64c2b0,$ec63f226,$756aa39c,$026d930a,$9c0906a9,$eb0e363f,$72076785,$05005713
    DC.L    $95bf4a82,$e2b87a14,$7bb12bae,$0cb61b38,$92d28e9b,$e5d5be0d,$7cdcefb7,$0bdbdf21
    DC.L    $86d3d2d4,$f1d4e242,$68ddb3f8,$1fda836e,$81be16cd,$f6b9265b,$6fb077e1,$18b74777
    DC.L    $88085ae6,$ff0f6a70,$66063bca,$11010b5c,$8f659eff,$f862ae69,$616bffd3,$166ccf45
    DC.L    $a00ae278,$d70dd2ee,$4e048354,$3903b3c2,$a7672661,$d06016f7,$4969474d,$3e6e77db
    DC.L    $aed16a4a,$d9d65adc,$40df0b66,$37d83bf0,$a9bcae53,$debb9ec5,$47b2cf7f,$30b5ffe9
    DC.L    $bdbdf21c,$cabac28a,$53b39330,$24b4a3a6,$bad03605,$cdd70693,$54de5729,$23d967bf
    DC.L    $b3667a2e,$c4614ab8,$5d681b02,$2a6f2b94,$b40bbe37,$c30c8ea1,$5a05df1b,$2d02ef8d
DISKIO2_FlushDataFilesGuardFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: CLOCK_HalfHourLabelEmpty12Hr   (half-hour 12h table slot-0 empty label)
; TYPE: u16 (NUL string sentinel)
; PURPOSE: Empty string entry at table index 0 for 12-hour half-hour labels.
; USED BY: Global_JMPTBL_HALF_HOURS_12_HR_FMT
; NOTES: Keeps 1-based half-hour index lookups from requiring a pointer adjustment.
;------------------------------------------------------------------------------
CLOCK_HalfHourLabelEmpty12Hr:
    DS.W    1
DISKIO2_STR_5_COLON_00_AM:
    NStr    " 5:00 AM"
DISKIO2_STR_5_COLON_30_AM:
    NStr    " 5:30 AM"
DISKIO2_STR_6_COLON_00_AM:
    NStr    " 6:00 AM"
DISKIO2_STR_6_COLON_30_AM:
    NStr    " 6:30 AM"
DISKIO2_STR_7_COLON_00_AM:
    NStr    " 7:00 AM"
DISKIO2_STR_7_COLON_30_AM:
    NStr    " 7:30 AM"
DISKIO2_STR_8_COLON_00_AM:
    NStr    " 8:00 AM"
DISKIO2_STR_8_COLON_30_AM:
    NStr    " 8:30 AM"
DISKIO2_STR_9_COLON_00_AM:
    NStr    " 9:00 AM"
DISKIO2_STR_9_COLON_30_AM:
    NStr    " 9:30 AM"
DISKIO2_STR_10_COLON_00_AM:
    NStr    "10:00 AM"
DISKIO2_STR_10_COLON_30_AM:
    NStr    "10:30 AM"
DISKIO2_STR_11_COLON_00_AM:
    NStr    "11:00 AM"
DISKIO2_STR_11_COLON_30_AM:
    NStr    "11:30 AM"
DISKIO2_STR_12_COLON_00_PM:
    NStr    "12:00 PM"
DISKIO2_STR_12_COLON_30_PM:
    NStr    "12:30 PM"
DISKIO2_STR_1_COLON_00_PM:
    NStr    " 1:00 PM"
DISKIO2_STR_1_COLON_30_PM:
    NStr    " 1:30 PM"
DISKIO2_STR_2_COLON_00_PM:
    NStr    " 2:00 PM"
DISKIO2_STR_2_COLON_30_PM:
    NStr    " 2:30 PM"
DISKIO2_STR_3_COLON_00_PM:
    NStr    " 3:00 PM"
DISKIO2_STR_3_COLON_30_PM:
    NStr    " 3:30 PM"
DISKIO2_STR_4_COLON_00_PM:
    NStr    " 4:00 PM"
DISKIO2_STR_4_COLON_30_PM:
    NStr    " 4:30 PM"
DISKIO2_STR_5_COLON_00_PM:
    NStr    " 5:00 PM"
DISKIO2_STR_5_COLON_30_PM:
    NStr    " 5:30 PM"
DISKIO2_STR_6_COLON_00_PM:
    NStr    " 6:00 PM"
DISKIO2_STR_6_COLON_30_PM:
    NStr    " 6:30 PM"
DISKIO2_STR_7_COLON_00_PM:
    NStr    " 7:00 PM"
DISKIO2_STR_7_COLON_30_PM:
    NStr    " 7:30 PM"
DISKIO2_STR_8_COLON_00_PM:
    NStr    " 8:00 PM"
DISKIO2_STR_8_COLON_30_PM:
    NStr    " 8:30 PM"
DISKIO2_STR_9_COLON_00_PM:
    NStr    " 9:00 PM"
DISKIO2_STR_9_COLON_30_PM:
    NStr    " 9:30 PM"
DISKIO2_STR_10_COLON_00_PM:
    NStr    "10:00 PM"
DISKIO2_STR_10_COLON_30_PM:
    NStr    "10:30 PM"
DISKIO2_STR_11_COLON_00_PM:
    NStr    "11:00 PM"
DISKIO2_STR_11_COLON_30_PM:
    NStr    "11:30 PM"
DISKIO2_STR_12_COLON_00_AM:
    NStr    "12:00 AM"
DISKIO2_STR_12_COLON_30_AM:
    NStr    "12:30 AM"
DISKIO2_STR_1_COLON_00_AM:
    NStr    " 1:00 AM"
DISKIO2_STR_1_COLON_30_AM:
    NStr    " 1:30 AM"
DISKIO2_STR_2_COLON_00_AM:
    NStr    " 2:00 AM"
DISKIO2_STR_2_COLON_30_AM:
    NStr    " 2:30 AM"
DISKIO2_STR_3_COLON_00_AM:
    NStr    " 3:00 AM"
DISKIO2_STR_3_COLON_30_AM:
    NStr    " 3:30 AM"
DISKIO2_STR_4_COLON_00_AM:
    NStr    " 4:00 AM"
DISKIO2_STR_4_COLON_30_AM:
    NStr    " 4:30 AM"
Global_JMPTBL_HALF_HOURS_12_HR_FMT:
    DC.L    CLOCK_HalfHourLabelEmpty12Hr
    DC.L    DISKIO2_STR_5_COLON_00_AM
    DC.L    DISKIO2_STR_5_COLON_30_AM
    DC.L    DISKIO2_STR_6_COLON_00_AM
    DC.L    DISKIO2_STR_6_COLON_30_AM
    DC.L    DISKIO2_STR_7_COLON_00_AM
    DC.L    DISKIO2_STR_7_COLON_30_AM
    DC.L    DISKIO2_STR_8_COLON_00_AM
    DC.L    DISKIO2_STR_8_COLON_30_AM
    DC.L    DISKIO2_STR_9_COLON_00_AM
    DC.L    DISKIO2_STR_9_COLON_30_AM
    DC.L    DISKIO2_STR_10_COLON_00_AM
    DC.L    DISKIO2_STR_10_COLON_30_AM
    DC.L    DISKIO2_STR_11_COLON_00_AM
    DC.L    DISKIO2_STR_11_COLON_30_AM
    DC.L    DISKIO2_STR_12_COLON_00_PM
    DC.L    DISKIO2_STR_12_COLON_30_PM
    DC.L    DISKIO2_STR_1_COLON_00_PM
    DC.L    DISKIO2_STR_1_COLON_30_PM
    DC.L    DISKIO2_STR_2_COLON_00_PM
    DC.L    DISKIO2_STR_2_COLON_30_PM
    DC.L    DISKIO2_STR_3_COLON_00_PM
    DC.L    DISKIO2_STR_3_COLON_30_PM
    DC.L    DISKIO2_STR_4_COLON_00_PM
    DC.L    DISKIO2_STR_4_COLON_30_PM
    DC.L    DISKIO2_STR_5_COLON_00_PM
    DC.L    DISKIO2_STR_5_COLON_30_PM
    DC.L    DISKIO2_STR_6_COLON_00_PM
    DC.L    DISKIO2_STR_6_COLON_30_PM
    DC.L    DISKIO2_STR_7_COLON_00_PM
    DC.L    DISKIO2_STR_7_COLON_30_PM
    DC.L    DISKIO2_STR_8_COLON_00_PM
    DC.L    DISKIO2_STR_8_COLON_30_PM
    DC.L    DISKIO2_STR_9_COLON_00_PM
    DC.L    DISKIO2_STR_9_COLON_30_PM
    DC.L    DISKIO2_STR_10_COLON_00_PM
    DC.L    DISKIO2_STR_10_COLON_30_PM
    DC.L    DISKIO2_STR_11_COLON_00_PM
    DC.L    DISKIO2_STR_11_COLON_30_PM
    DC.L    DISKIO2_STR_12_COLON_00_AM
    DC.L    DISKIO2_STR_12_COLON_30_AM
    DC.L    DISKIO2_STR_1_COLON_00_AM
    DC.L    DISKIO2_STR_1_COLON_30_AM
    DC.L    DISKIO2_STR_2_COLON_00_AM
    DC.L    DISKIO2_STR_2_COLON_30_AM
    DC.L    DISKIO2_STR_3_COLON_00_AM
    DC.L    DISKIO2_STR_3_COLON_30_AM
    DC.L    DISKIO2_STR_4_COLON_00_AM
    DC.L    DISKIO2_STR_4_COLON_30_AM
;------------------------------------------------------------------------------
; SYM: CLOCK_HalfHourLabelEmpty24Hr   (half-hour 24h table slot-0 empty label)
; TYPE: u16 (NUL string sentinel)
; PURPOSE: Empty string entry at table index 0 for 24-hour half-hour labels.
; USED BY: Global_JMPTBL_HALF_HOURS_24_HR_FMT
; NOTES: Keeps 1-based half-hour index lookups from requiring a pointer adjustment.
;------------------------------------------------------------------------------
CLOCK_HalfHourLabelEmpty24Hr:
    DS.W    1
DISKIO2_STR_5_COLON_00:
    NStr    " 5:00"
DISKIO2_STR_5_COLON_30:
    NStr    " 5:30"
DISKIO2_STR_6_COLON_00:
    NStr    " 6:00"
DISKIO2_STR_6_COLON_30:
    NStr    " 6:30"
DISKIO2_STR_7_COLON_00:
    NStr    " 7:00"
DISKIO2_STR_7_COLON_30:
    NStr    " 7:30"
DISKIO2_STR_8_COLON_00:
    NStr    " 8:00"
DISKIO2_STR_8_COLON_30:
    NStr    " 8:30"
DISKIO2_STR_9_COLON_00:
    NStr    " 9:00"
DISKIO2_STR_9_COLON_30:
    NStr    " 9:30"
DISKIO2_STR_10_COLON_00:
    NStr    "10:00"
DISKIO2_STR_10_COLON_30:
    NStr    "10:30"
DISKIO2_STR_11_COLON_00:
    NStr    "11:00"
DISKIO2_STR_11_COLON_30:
    NStr    "11:30"
DISKIO2_STR_12_COLON_00:
    NStr    "12:00"
DISKIO2_STR_12_COLON_30:
    NStr    "12:30"
DISKIO2_STR_13_COLON_00:
    NStr    "13:00"
DISKIO2_STR_13_COLON_30:
    NStr    "13:30"
DISKIO2_STR_14_COLON_00:
    NStr    "14:00"
DISKIO2_STR_14_COLON_30:
    NStr    "14:30"
DISKIO2_STR_15_COLON_00:
    NStr    "15:00"
DISKIO2_STR_15_COLON_30:
    NStr    "15:30"
DISKIO2_STR_16_COLON_00:
    NStr    "16:00"
DISKIO2_STR_16_COLON_30:
    NStr    "16:30"
DISKIO2_STR_17_COLON_00:
    NStr    "17:00"
DISKIO2_STR_17_COLON_30:
    NStr    "17:30"
DISKIO2_STR_18_COLON_00:
    NStr    "18:00"
DISKIO2_STR_18_COLON_30:
    NStr    "18:30"
DISKIO2_STR_19_COLON_00:
    NStr    "19:00"
DISKIO2_STR_19_COLON_30:
    NStr    "19:30"
DISKIO2_STR_20_COLON_00:
    NStr    "20:00"
DISKIO2_STR_20_COLON_30:
    NStr    "20:30"
DISKIO2_STR_21_COLON_00:
    NStr    "21:00"
DISKIO2_STR_21_COLON_30:
    NStr    "21:30"
DISKIO2_STR_22_COLON_00:
    NStr    "22:00"
DISKIO2_STR_22_COLON_30:
    NStr    "22:30"
DISKIO2_STR_23_COLON_00:
    NStr    "23:00"
DISKIO2_STR_23_COLON_30:
    NStr    "23:30"
DISKIO2_STR_0_COLON_00:
    NStr    " 0:00"
DISKIO2_STR_0_COLON_30:
    NStr    " 0:30"
DISKIO2_STR_1_COLON_00:
    NStr    " 1:00"
DISKIO2_STR_1_COLON_30:
    NStr    " 1:30"
DISKIO2_STR_2_COLON_00:
    NStr    " 2:00"
DISKIO2_STR_2_COLON_30:
    NStr    " 2:30"
DISKIO2_STR_3_COLON_00:
    NStr    " 3:00"
DISKIO2_STR_3_COLON_30:
    NStr    " 3:30"
DISKIO2_STR_4_COLON_00:
    NStr    " 4:00"
DISKIO2_STR_4_COLON_30:
    NStr    " 4:30"
Global_JMPTBL_HALF_HOURS_24_HR_FMT:
    DC.L    CLOCK_HalfHourLabelEmpty24Hr
    DC.L    DISKIO2_STR_5_COLON_00
    DC.L    DISKIO2_STR_5_COLON_30
    DC.L    DISKIO2_STR_6_COLON_00
    DC.L    DISKIO2_STR_6_COLON_30
    DC.L    DISKIO2_STR_7_COLON_00
    DC.L    DISKIO2_STR_7_COLON_30
    DC.L    DISKIO2_STR_8_COLON_00
    DC.L    DISKIO2_STR_8_COLON_30
    DC.L    DISKIO2_STR_9_COLON_00
    DC.L    DISKIO2_STR_9_COLON_30
    DC.L    DISKIO2_STR_10_COLON_00
    DC.L    DISKIO2_STR_10_COLON_30
    DC.L    DISKIO2_STR_11_COLON_00
    DC.L    DISKIO2_STR_11_COLON_30
    DC.L    DISKIO2_STR_12_COLON_00
    DC.L    DISKIO2_STR_12_COLON_30
    DC.L    DISKIO2_STR_13_COLON_00
    DC.L    DISKIO2_STR_13_COLON_30
    DC.L    DISKIO2_STR_14_COLON_00
    DC.L    DISKIO2_STR_14_COLON_30
    DC.L    DISKIO2_STR_15_COLON_00
    DC.L    DISKIO2_STR_15_COLON_30
    DC.L    DISKIO2_STR_16_COLON_00
    DC.L    DISKIO2_STR_16_COLON_30
    DC.L    DISKIO2_STR_17_COLON_00
    DC.L    DISKIO2_STR_17_COLON_30
    DC.L    DISKIO2_STR_18_COLON_00
    DC.L    DISKIO2_STR_18_COLON_30
    DC.L    DISKIO2_STR_19_COLON_00
    DC.L    DISKIO2_STR_19_COLON_30
    DC.L    DISKIO2_STR_20_COLON_00
    DC.L    DISKIO2_STR_20_COLON_30
    DC.L    DISKIO2_STR_21_COLON_00
    DC.L    DISKIO2_STR_21_COLON_30
    DC.L    DISKIO2_STR_22_COLON_00
    DC.L    DISKIO2_STR_22_COLON_30
    DC.L    DISKIO2_STR_23_COLON_00
    DC.L    DISKIO2_STR_23_COLON_30
    DC.L    DISKIO2_STR_0_COLON_00
    DC.L    DISKIO2_STR_0_COLON_30
    DC.L    DISKIO2_STR_1_COLON_00
    DC.L    DISKIO2_STR_1_COLON_30
    DC.L    DISKIO2_STR_2_COLON_00
    DC.L    DISKIO2_STR_2_COLON_30
    DC.L    DISKIO2_STR_3_COLON_00
    DC.L    DISKIO2_STR_3_COLON_30
    DC.L    DISKIO2_STR_4_COLON_00
    DC.L    DISKIO2_STR_4_COLON_30
DISPLIB_STR_InlineAlignPadCharCenter:
    NStr    " "
DISPLIB_STR_InlineAlignPadCharRight:
    NStr    " "

typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern UBYTE GCOMMAND_PpvParseScratchSeedLong[];
extern UBYTE WDISP_CharClassTable[];
extern UBYTE GCOMMAND_DigitalPpvEnabledFlag[];
extern LONG GCOMMAND_PpvModeCycleCount;
extern LONG GCOMMAND_PpvSelectionWindowMinutes;
extern LONG GCOMMAND_PpvSelectionToleranceMinutes;
extern LONG GCOMMAND_PpvMessageTextPen;
extern LONG GCOMMAND_PpvMessageFramePen;
extern LONG GCOMMAND_PpvEditorLayoutPen;
extern LONG GCOMMAND_PpvEditorRowPen;
extern LONG GCOMMAND_PpvShowtimesLayoutPen;
extern LONG GCOMMAND_PpvShowtimesInitialLineIndex;
extern LONG GCOMMAND_PpvShowtimesRowPen;
extern UBYTE GCOMMAND_PpvShowtimesWorkflowMode;
extern UBYTE GCOMMAND_PpvDetailLayoutFlag;
extern LONG GCOMMAND_PpvShowtimesRowSpan;
extern char *GCOMMAND_PPVListingsTemplatePtr;
extern char *GCOMMAND_PPVPeriodTemplatePtr;

extern void FLIB2_LoadDigitalPpvDefaults(void);
extern char *GROUP_AW_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG n);
extern LONG ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *text);
extern LONG LADFUNC_ParseHexDigit(LONG c);
extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(const char *text, LONG ch);
extern char *ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);
extern LONG GCOMMAND_LoadPPVTemplate(void);

static LONG parse_pen_1_to_3(UBYTE c)
{
    LONG v;

    v = (LONG)c - (LONG)'0';
    if (v < 1 || v > 3) {
        return -1;
    }
    return v;
}

static UBYTE fold_upper_if_alpha(UBYTE c)
{
    if ((WDISP_CharClassTable[c] & 0x02U) != 0) {
        return (UBYTE)(c - 32);
    }
    return c;
}

static LONG parse_valid_digits_value(const char *p, LONG n, LONG max)
{
    char tmp[4];
    LONG i;
    LONG v;

    for (i = 0; i < n; i++) {
        if ((WDISP_CharClassTable[(UBYTE)p[i]] & 0x04U) == 0) {
            return -1;
        }
        tmp[i] = p[i];
    }
    tmp[n] = 0;

    v = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(tmp);
    if (v < 0 || v > max) {
        return -1;
    }
    return v;
}

LONG GCOMMAND_ParsePPVCommand(char *cmd)
{
    char scratch[4];
    LONG parsed;
    LONG tailIndex;
    LONG idx;
    LONG v;
    UBYTE c;
    UBYTE uc;
    char *tail;
    char *split;

    scratch[0] = (char)GCOMMAND_PpvParseScratchSeedLong[0];
    scratch[1] = (char)GCOMMAND_PpvParseScratchSeedLong[1];
    scratch[2] = (char)GCOMMAND_PpvParseScratchSeedLong[2];
    scratch[3] = (char)GCOMMAND_PpvParseScratchSeedLong[3];

    FLIB2_LoadDigitalPpvDefaults();

    if (cmd == (char *)0 || *cmd == 0) {
        return GCOMMAND_LoadPPVTemplate();
    }

    GROUP_AW_JMPTBL_STRING_CopyPadNul(scratch, cmd, 2);
    scratch[2] = 0;

    parsed = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch);
    tailIndex = parsed + 2;
    idx = 2;

    if (idx < tailIndex) {
        uc = fold_upper_if_alpha((UBYTE)cmd[idx]);
        if (uc == 'Y' || uc == 'N') {
            GCOMMAND_DigitalPpvEnabledFlag[0] = uc;
        }
        idx++;
    }

    if (idx < tailIndex) {
        v = (LONG)(UBYTE)cmd[idx] - (LONG)'0';
        if (v >= 0 && v <= 9) {
            GCOMMAND_PpvModeCycleCount = v;
        }
        idx++;
    }

    if ((idx + 2) < tailIndex) {
        v = parse_valid_digits_value(cmd + idx, 3, 999);
        if (v >= 0) {
            GCOMMAND_PpvSelectionWindowMinutes = v;
        }
        idx += 3;
    }

    if ((idx + 2) < tailIndex) {
        v = parse_valid_digits_value(cmd + idx, 3, 999);
        if (v >= 0) {
            GCOMMAND_PpvSelectionToleranceMinutes = v;
        }
        idx += 3;
    }

    if (idx < tailIndex) {
        v = parse_pen_1_to_3((UBYTE)cmd[idx]);
        if (v >= 0) {
            GCOMMAND_PpvMessageTextPen = v;
        }
        idx++;
    }

    if (idx < tailIndex) {
        c = (UBYTE)cmd[idx];
        if ((WDISP_CharClassTable[c] & 0x80U) != 0) {
            GCOMMAND_PpvMessageFramePen = (LONG)(UBYTE)LADFUNC_ParseHexDigit((LONG)c);
        }
        idx++;
    }

    if (idx < tailIndex) {
        v = parse_pen_1_to_3((UBYTE)cmd[idx]);
        if (v >= 0) {
            GCOMMAND_PpvEditorLayoutPen = v;
        }
        idx++;
    }

    if (idx < tailIndex) {
        c = (UBYTE)cmd[idx];
        if ((WDISP_CharClassTable[c] & 0x80U) != 0) {
            GCOMMAND_PpvEditorRowPen = (LONG)(UBYTE)LADFUNC_ParseHexDigit((LONG)c);
        }
        idx++;
    }

    if (idx < tailIndex) {
        v = parse_pen_1_to_3((UBYTE)cmd[idx]);
        if (v >= 0) {
            GCOMMAND_PpvShowtimesLayoutPen = v;
        }
        idx++;
    }

    if (idx < tailIndex) {
        v = parse_pen_1_to_3((UBYTE)cmd[idx]);
        if (v >= 0) {
            GCOMMAND_PpvShowtimesInitialLineIndex = v;
        }
        idx++;
    }

    if (idx < tailIndex) {
        c = (UBYTE)cmd[idx];
        if ((WDISP_CharClassTable[c] & 0x80U) != 0) {
            GCOMMAND_PpvShowtimesRowPen = (LONG)(UBYTE)LADFUNC_ParseHexDigit((LONG)c);
        }
        idx++;
    }

    if (idx < tailIndex) {
        uc = fold_upper_if_alpha((UBYTE)cmd[idx]);
        if (uc == 'F' || uc == 'B' || uc == 'L' || uc == 'N') {
            GCOMMAND_PpvShowtimesWorkflowMode = uc;
        }
        idx++;
    }

    if (idx < tailIndex) {
        uc = fold_upper_if_alpha((UBYTE)cmd[idx]);
        if (uc == 'Y' || uc == 'N') {
            GCOMMAND_PpvDetailLayoutFlag = uc;
        }
        idx++;
    }

    if ((idx + 1) < tailIndex) {
        GROUP_AW_JMPTBL_STRING_CopyPadNul(scratch, cmd + idx, 2);
        scratch[2] = 0;
        GCOMMAND_PpvShowtimesRowSpan = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch);
        idx += 2;
    }

    if (idx > tailIndex) {
        tailIndex = idx;
    }

    tail = cmd + tailIndex;
    if (*tail != 0) {
        split = GROUP_AS_JMPTBL_STR_FindCharPtr(tail, 18);
        if (split != (char *)0 && *split == 18) {
            *split = 0;
            split++;

            if ((LONG)(split - tail) > 127) {
                tail[127] = 0;
            }

            if (*tail != 0) {
                GCOMMAND_PPVPeriodTemplatePtr = ESQPARS_ReplaceOwnedString(
                    tail,
                    GCOMMAND_PPVPeriodTemplatePtr);
            }
            if (*split != 0) {
                GCOMMAND_PPVListingsTemplatePtr = ESQPARS_ReplaceOwnedString(
                    split,
                    GCOMMAND_PPVListingsTemplatePtr);
            }
        } else {
            GCOMMAND_PPVPeriodTemplatePtr = ESQPARS_ReplaceOwnedString(
                cmd + idx,
                GCOMMAND_PPVPeriodTemplatePtr);
        }
    }

    return GCOMMAND_LoadPPVTemplate();
}

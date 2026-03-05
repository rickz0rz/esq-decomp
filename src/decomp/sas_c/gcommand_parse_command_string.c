typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE GCOMMAND_MplexParseScratchSeedWord[];
extern UBYTE WDISP_CharClassTable[];
extern UBYTE GCOMMAND_DigitalMplexEnabledFlag[];
extern LONG GCOMMAND_MplexModeCycleCount;
extern LONG GCOMMAND_MplexSearchRowLimit;
extern LONG GCOMMAND_MplexClockOffsetMinutes;
extern LONG GCOMMAND_MplexMessageTextPen;
extern LONG GCOMMAND_MplexMessageFramePen;
extern LONG GCOMMAND_MplexEditorLayoutPen;
extern LONG GCOMMAND_MplexEditorRowPen;
extern LONG GCOMMAND_MplexDetailLayoutPen;
extern LONG GCOMMAND_MplexDetailInitialLineIndex;
extern LONG GCOMMAND_MplexDetailRowPen;
extern UBYTE GCOMMAND_MplexWorkflowMode;
extern UBYTE GCOMMAND_MplexDetailLayoutFlag;
extern char *GCOMMAND_MplexListingsTemplatePtr;
extern char *GCOMMAND_MplexAtTemplatePtr;

extern const char GCOMMAND_FMT_PCT_T_MplexTemplateParse[];

extern void FLIB2_LoadDigitalMplexDefaults(void);
extern void GROUP_AW_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, LONG n);
extern LONG ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *text);
extern LONG LADFUNC_ParseHexDigit(LONG c);
extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(char *text, LONG ch);
extern char *GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(const char *text, const char *needle);
extern char *ESQPARS_ReplaceOwnedString(char *oldText, const char *newText);
extern LONG GCOMMAND_LoadMplexFile(void);

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

LONG GCOMMAND_ParseCommandString(char *cmd)
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
    char *fmtSlot;

    scratch[0] = (char)GCOMMAND_MplexParseScratchSeedWord[0];
    scratch[1] = (char)GCOMMAND_MplexParseScratchSeedWord[1];
    scratch[2] = (char)GCOMMAND_MplexParseScratchSeedWord[2];
    scratch[3] = (char)GCOMMAND_MplexParseScratchSeedWord[3];

    FLIB2_LoadDigitalMplexDefaults();

    if (cmd == (char *)0 || *cmd == 0) {
        return GCOMMAND_LoadMplexFile();
    }

    GROUP_AW_JMPTBL_STRING_CopyPadNul(scratch, cmd, 2);
    scratch[2] = 0;

    parsed = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch);
    tailIndex = parsed + 2;
    idx = 2;

    if (idx < tailIndex) {
        uc = fold_upper_if_alpha((UBYTE)cmd[idx]);
        if (uc == 'Y' || uc == 'N') {
            GCOMMAND_DigitalMplexEnabledFlag[0] = uc;
        }
        idx++;
    }

    if (idx < tailIndex) {
        v = (LONG)(UBYTE)cmd[idx] - (LONG)'0';
        if (v >= 0 && v <= 9) {
            GCOMMAND_MplexModeCycleCount = v;
        }
        idx++;
    }

    if ((idx + 1) < tailIndex) {
        scratch[0] = cmd[idx];
        scratch[1] = cmd[idx + 1];
        scratch[2] = 0;
        v = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch);
        if (v >= 0 && v <= 99) {
            GCOMMAND_MplexSearchRowLimit = v;
        }
        idx += 2;
    }

    if ((idx + 1) < tailIndex) {
        scratch[0] = cmd[idx];
        scratch[1] = cmd[idx + 1];
        scratch[2] = 0;
        v = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch);
        if (v >= 0 && v <= 29) {
            GCOMMAND_MplexClockOffsetMinutes = v;
        }
        idx += 2;
    }

    if (idx < tailIndex) {
        v = parse_pen_1_to_3((UBYTE)cmd[idx]);
        if (v >= 0) {
            GCOMMAND_MplexMessageTextPen = v;
        }
        idx++;
    }

    if (idx < tailIndex) {
        c = (UBYTE)cmd[idx];
        if ((WDISP_CharClassTable[c] & 0x80U) != 0) {
            GCOMMAND_MplexMessageFramePen = (LONG)(UBYTE)LADFUNC_ParseHexDigit((LONG)c);
        }
        idx++;
    }

    if (idx < tailIndex) {
        v = parse_pen_1_to_3((UBYTE)cmd[idx]);
        if (v >= 0) {
            GCOMMAND_MplexEditorLayoutPen = v;
        }
        idx++;
    }

    if (idx < tailIndex) {
        c = (UBYTE)cmd[idx];
        if ((WDISP_CharClassTable[c] & 0x80U) != 0) {
            GCOMMAND_MplexEditorRowPen = (LONG)(UBYTE)LADFUNC_ParseHexDigit((LONG)c);
        }
        idx++;
    }

    if (idx < tailIndex) {
        v = parse_pen_1_to_3((UBYTE)cmd[idx]);
        if (v >= 0) {
            GCOMMAND_MplexDetailLayoutPen = v;
        }
        idx++;
    }

    if (idx < tailIndex) {
        v = parse_pen_1_to_3((UBYTE)cmd[idx]);
        if (v >= 0) {
            GCOMMAND_MplexDetailInitialLineIndex = v;
        }
        idx++;
    }

    if (idx < tailIndex) {
        c = (UBYTE)cmd[idx];
        if ((WDISP_CharClassTable[c] & 0x80U) != 0) {
            GCOMMAND_MplexDetailRowPen = (LONG)(UBYTE)LADFUNC_ParseHexDigit((LONG)c);
        }
        idx++;
    }

    if (idx < tailIndex) {
        uc = fold_upper_if_alpha((UBYTE)cmd[idx]);
        if (uc == 'F' || uc == 'B' || uc == 'L' || uc == 'N') {
            GCOMMAND_MplexWorkflowMode = uc;
        }
        idx++;
    }

    if (idx < tailIndex) {
        uc = fold_upper_if_alpha((UBYTE)cmd[idx]);
        if (uc == 'Y' || uc == 'N') {
            GCOMMAND_MplexDetailLayoutFlag = uc;
        }
        idx++;
    }

    if (idx > tailIndex) {
        tailIndex = idx;
    }

    tail = cmd + tailIndex;
    if (*tail != 0) {
        split = GROUP_AS_JMPTBL_STR_FindCharPtr(tail, 18);
        if (split != (char *)0 && *split != 0) {
            *split = 0;
            split++;

            if ((LONG)(split - tail) > 127) {
                tail[127] = 0;
            }

            if (*tail != 0) {
                GCOMMAND_MplexAtTemplatePtr = ESQPARS_ReplaceOwnedString(
                    GCOMMAND_MplexAtTemplatePtr,
                    tail);
            }
            if (*split != 0) {
                GCOMMAND_MplexListingsTemplatePtr = ESQPARS_ReplaceOwnedString(
                    GCOMMAND_MplexListingsTemplatePtr,
                    split);
            }
        } else {
            GCOMMAND_MplexAtTemplatePtr = ESQPARS_ReplaceOwnedString(
                GCOMMAND_MplexAtTemplatePtr,
                tail);
        }
    }

    fmtSlot = (char *)0;
    if (GCOMMAND_MplexAtTemplatePtr != (char *)0 && *GCOMMAND_MplexAtTemplatePtr != 0) {
        fmtSlot = GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(
            GCOMMAND_MplexAtTemplatePtr,
            GCOMMAND_FMT_PCT_T_MplexTemplateParse);
    }
    if (fmtSlot != (char *)0 && *fmtSlot != 0) {
        fmtSlot[1] = 's';
    }

    return GCOMMAND_LoadMplexFile();
}

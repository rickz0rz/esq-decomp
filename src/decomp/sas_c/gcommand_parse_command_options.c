typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern UBYTE GCOMMAND_NicheParseScratchSeedWord[];
extern const UBYTE WDISP_CharClassTable[];
extern UBYTE GCOMMAND_DigitalNicheEnabledFlag[];
extern LONG GCOMMAND_NicheTextPen;
extern LONG GCOMMAND_NicheFramePen;
extern LONG GCOMMAND_NicheEditorLayoutPen;
extern LONG GCOMMAND_NicheEditorRowPen;
extern LONG GCOMMAND_NicheModeCycleCount;
extern LONG GCOMMAND_NicheForceMode5Flag;
extern UBYTE GCOMMAND_NicheWorkflowMode;
extern char *GCOMMAND_DigitalNicheListingsTemplatePtr;

extern void FLIB2_LoadDigitalNicheDefaults(void);
extern char *GROUP_AW_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG n);
extern LONG ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *text);
extern LONG LADFUNC_ParseHexDigit(LONG c);
extern char *ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);
extern LONG GCOMMAND_LoadCommandFile(void);

static LONG parse_pen_1_to_3(UBYTE c)
{
    LONG v = (LONG)c - (LONG)'0';
    if (v < 1 || v > 3) {
        return -1;
    }
    return v;
}

LONG GCOMMAND_ParseCommandOptions(char *cmd)
{
    char scratch[4];
    LONG parsed;
    LONG tailIndex;
    LONG idx;
    LONG v;
    UBYTE c;
    UBYTE uc;
    const char *tail;

    scratch[0] = (char)GCOMMAND_NicheParseScratchSeedWord[0];
    scratch[1] = (char)GCOMMAND_NicheParseScratchSeedWord[1];
    scratch[2] = (char)GCOMMAND_NicheParseScratchSeedWord[2];
    scratch[3] = (char)GCOMMAND_NicheParseScratchSeedWord[3];

    FLIB2_LoadDigitalNicheDefaults();

    if (cmd == (char *)0 || *cmd == 0) {
        return GCOMMAND_LoadCommandFile();
    }

    GROUP_AW_JMPTBL_STRING_CopyPadNul(scratch, cmd, 2);
    scratch[2] = 0;

    parsed = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch);
    tailIndex = parsed + 2;
    idx = 2;

    if (idx < tailIndex) {
        c = (UBYTE)cmd[idx];
        uc = (WDISP_CharClassTable[c] & 0x02U) ? (UBYTE)(c - 32) : c;
        if (uc == 'Y' || uc == 'N') {
            GCOMMAND_DigitalNicheEnabledFlag[0] = uc;
        }
        idx++;
    }

    if (idx < tailIndex) {
        v = parse_pen_1_to_3((UBYTE)cmd[idx]);
        if (v >= 0) {
            GCOMMAND_NicheTextPen = v;
        }
        idx++;
    }

    if (idx < tailIndex) {
        c = (UBYTE)cmd[idx];
        if ((WDISP_CharClassTable[c] & 0x80U) != 0) {
            GCOMMAND_NicheFramePen = (LONG)(UBYTE)LADFUNC_ParseHexDigit((LONG)c);
        }
        idx++;
    }

    if (idx < tailIndex) {
        v = parse_pen_1_to_3((UBYTE)cmd[idx]);
        if (v >= 0) {
            GCOMMAND_NicheEditorLayoutPen = v;
        }
        idx++;
    }

    if (idx < tailIndex) {
        c = (UBYTE)cmd[idx];
        if ((WDISP_CharClassTable[c] & 0x80U) != 0) {
            GCOMMAND_NicheEditorRowPen = (LONG)(UBYTE)LADFUNC_ParseHexDigit((LONG)c);
        }
        idx++;
    }

    if (idx < tailIndex) {
        c = (UBYTE)cmd[idx];
        uc = (WDISP_CharClassTable[c] & 0x02U) ? (UBYTE)(c - 32) : c;
        if (uc == 'F' || uc == 'B' || uc == 'L' || uc == 'N') {
            GCOMMAND_NicheWorkflowMode = uc;
        }
        idx++;
    }

    if (idx < tailIndex) {
        v = (LONG)(UBYTE)cmd[idx] - (LONG)'0';
        if (v == 1) {
            GCOMMAND_NicheModeCycleCount = 0;
            GCOMMAND_NicheForceMode5Flag = 1;
        } else if (v >= 0 && v <= 9) {
            GCOMMAND_NicheModeCycleCount = v;
            GCOMMAND_NicheForceMode5Flag = 0;
        }
        idx++;
    }

    if (idx > tailIndex) {
        tailIndex = idx;
    }

    tail = cmd + tailIndex;
    if (*tail != 0) {
        GCOMMAND_DigitalNicheListingsTemplatePtr = ESQPARS_ReplaceOwnedString(
            tail,
            GCOMMAND_DigitalNicheListingsTemplatePtr);
    }

    return GCOMMAND_LoadCommandFile();
}

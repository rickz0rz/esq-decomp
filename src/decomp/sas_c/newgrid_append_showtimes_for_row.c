typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NewgridCtx {
    char *coi;
    char *entries;
    LONG preset;
    UWORD row;
} NewgridCtx;

typedef struct NEWGRID_Entry {
    UBYTE pad0[28];
    UBYTE selectionBits[1];
} NEWGRID_Entry;

typedef struct NEWGRID_AuxData {
    UBYTE pad0[7];
    UBYTE rowFlags[49];
} NEWGRID_AuxData;

extern const char Global_STR_SHOWTIMES_AND_SINGLE_SPACE[];
extern const char Global_STR_SHOWING_AT_AND_SINGLE_SPACE[];
extern const char NEWGRID_ShowtimeListSeparator[];

extern const char *NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(const void *entry, LONG row, LONG field);
extern LONG TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(const char *entries, LONG row);
extern void TEXTDISP_FormatEntryTimeForIndex(char *out, LONG row, char *entries);
extern void NEWGRID_UpdatePresetEntry(char **entryPtr, char **auxPtr, LONG row, LONG preset);
extern LONG NEWGRID2_JMPTBL_ESQ_TestBit1Based(UBYTE *bitsetBase, LONG bitIndex);
extern char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(const char *s);
extern char *PARSEINI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);

static int str_eq_nullable(const char *a, const char *b)
{
    if (a == b) {
        return 1;
    }
    if (a == 0 || b == 0) {
        return 0;
    }
    while (*a == *b) {
        if (*a == 0) {
            return 1;
        }
        a++;
        b++;
    }
    return 0;
}

void NEWGRID_AppendShowtimesForRow(NewgridCtx *ctx, char *out, LONG modeFlag)
{
    UWORD row;
    UWORD rowEnd;
    LONG srcIdx;
    char scratchTime[32];
    const char *title0;
    const char *titleN;
    const char *f1_0;
    const char *f1_n;
    const char *f2_0;
    const char *f2_n;
    const char *f3_0;
    const char *f3_n;
    UBYTE mode0;
    UBYTE modeN;
    NEWGRID_Entry *entryCur;
    NEWGRID_AuxData *auxCur;

    out[0] = 0;

    if (!ctx || !ctx->coi || !ctx->entries) {
        return;
    }
    entryCur = (NEWGRID_Entry *)ctx->coi;
    auxCur = (NEWGRID_AuxData *)ctx->entries;

    row = ctx->row;
    if (row <= 0 || row >= 97) {
        return;
    }

    if (row > 48) {
        row = (UWORD)(row - 48);
    }

    title0 = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entryCur, (LONG)row, 1);
    f1_0 = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entryCur, (LONG)row, 2);
    f2_0 = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entryCur, (LONG)row, 6);
    f3_0 = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entryCur, (LONG)row, 7);
    if (!title0 || title0[0] == 0) {
        return;
    }

    mode0 = 0;
    if (modeFlag == 1 && TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility((const char *)auxCur, (LONG)row) != 0) {
        mode0 = 1;
    }

    TEXTDISP_FormatEntryTimeForIndex(scratchTime, (LONG)row, (char *)auxCur);

    rowEnd = (UWORD)(ctx->row + 33);
    if (rowEnd > 96) {
        rowEnd = 96;
    }
    rowEnd = (UWORD)(rowEnd + 1);

    for (row = (UWORD)(ctx->row + 1); row < rowEnd; row++) {
        if (row == 49) {
            NEWGRID_UpdatePresetEntry((char **)&entryCur, (char **)&auxCur, (LONG)row, ctx->preset);
        }

        srcIdx = (row > 48) ? (LONG)(row - 48) : (LONG)row;
        if (!entryCur || !auxCur) {
            continue;
        }

        if (NEWGRID2_JMPTBL_ESQ_TestBit1Based(entryCur->selectionBits, srcIdx) != -1) {
            continue;
        }

        if (auxCur->rowFlags[srcIdx] & 0x20) {
            continue;
        }

        titleN = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entryCur, srcIdx, 1);
        f1_n = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entryCur, srcIdx, 2);
        f2_n = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entryCur, srcIdx, 6);
        f3_n = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entryCur, srcIdx, 7);

        modeN = 0;
        if (modeFlag == 1 && TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility((const char *)auxCur, srcIdx) != 0) {
            modeN = 1;
        }

        if (!titleN || titleN == title0) {
            continue;
        }

        if (!str_eq_nullable(title0, titleN) ||
            !str_eq_nullable(f1_0, f1_n) ||
            !str_eq_nullable(f2_0, f2_n) ||
            !str_eq_nullable(f3_0, f3_n) ||
            mode0 != modeN) {
            continue;
        }

        if (out[0] == 0) {
            PARSEINI_JMPTBL_STRING_AppendAtNull(out, Global_STR_SHOWTIMES_AND_SINGLE_SPACE);
            PARSEINI_JMPTBL_STRING_AppendAtNull(out, NEWGRID2_JMPTBL_STR_SkipClass3Chars(scratchTime));
        }

        TEXTDISP_FormatEntryTimeForIndex(scratchTime, srcIdx, (char *)auxCur);
        PARSEINI_JMPTBL_STRING_AppendAtNull(out, NEWGRID_ShowtimeListSeparator);
        PARSEINI_JMPTBL_STRING_AppendAtNull(out, NEWGRID2_JMPTBL_STR_SkipClass3Chars(scratchTime));

        auxCur->rowFlags[srcIdx] |= 0x20;
    }

    if (out[0] == 0) {
        PARSEINI_JMPTBL_STRING_AppendAtNull(out, Global_STR_SHOWING_AT_AND_SINGLE_SPACE);
        PARSEINI_JMPTBL_STRING_AppendAtNull(out, NEWGRID2_JMPTBL_STR_SkipClass3Chars(scratchTime));
    }
}

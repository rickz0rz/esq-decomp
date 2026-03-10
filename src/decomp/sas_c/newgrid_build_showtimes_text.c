typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NewgridCtx {
    char *coi;
    char *entries;
    LONG startCol;
    LONG endCol;
    UWORD startRow;
    UWORD focusRow;
    LONG preset;
} NewgridCtx;

typedef struct NEWGRID_CoiHeader {
    UBYTE pad0[47];
    UBYTE flags47;
} NEWGRID_CoiHeader;

typedef struct NEWGRID_Entry {
    UBYTE pad0[28];
    UBYTE selectionBits[1];
} NEWGRID_Entry;

typedef struct NEWGRID_AuxData {
    UBYTE pad0[7];
    UBYTE rowFlags[49];
} NEWGRID_AuxData;

extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern LONG GCOMMAND_PpvShowtimesRowSpan;
extern LONG GCOMMAND_PpvSelectionToleranceMinutes;
extern LONG GCOMMAND_PpvSelectionWindowMinutes;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern const char Global_STR_SHOWTIMES_AND_SINGLE_SPACE[];
extern const char Global_STR_SHOWING_AT_AND_SINGLE_SPACE[];
extern const char NEWGRID_ShowtimeGenreSpacer[];

extern LONG _LVOTextLength(void *gfxBase, char *rp, const char *text, LONG len);
extern const char *NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(const void *entry, LONG row, LONG field);
extern void TEXTDISP_FormatEntryTimeForIndex(char *out, LONG row, char *entries);
extern void NEWGRID_ResetShowtimeBuckets(void);
extern LONG NEWGRID_UpdatePresetEntry(char **entryPtr, char **coiPtr, LONG row, LONG col);
extern LONG NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(const char *entry, const char *coi, LONG idx);
extern LONG NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState(char *entry, char *coi, LONG idx, LONG winMins, LONG tolMins);
extern LONG NEWGRID2_JMPTBL_ESQ_TestBit1Based(const UBYTE *bitsetBase, LONG bitIdx);
extern char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(const char *s);
extern LONG NEWGRID_AddShowtimeBucketEntry(const char *text, LONG row);
extern void NEWGRID_AppendShowtimeBuckets(char *out);
extern char *PARSEINI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);

static int str_eq_nullable(const char *a, const char *b)
{
    if (a == b) return 1;
    if (!a || !b) return 0;
    while (*a == *b) {
        if (*a == 0) return 1;
        a++;
        b++;
    }
    return 0;
}

void NEWGRID_BuildShowtimesText(char *gridCtx, char *entryState, char *out)
{
    NewgridCtx *ctx;
    char baseTime[50];
    char tempTime[50];
    const char *baseTitle;
    const char *baseF1;
    const char *baseF2;
    const char *baseF3;
    LONG widthBudget;
    LONG commaWidth;
    UWORD row;

    ctx = (NewgridCtx *)entryState;
    if (!ctx || !ctx->coi || !ctx->entries || !out) return;
    if ((((NEWGRID_CoiHeader *)ctx->coi)->flags47 & 0x10) == 0) return;
    if (!TEXTDISP_PrimaryGroupPresentFlag) return;

    out[0] = 0;

    row = ctx->focusRow;
    if (row > 48) row = (UWORD)(row - 48);

    baseTitle = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(ctx->coi, row, 1);
    baseF1 = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(ctx->coi, row, 2);
    baseF2 = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(ctx->coi, row, 6);
    baseF3 = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(ctx->coi, row, 7);
    TEXTDISP_FormatEntryTimeForIndex(baseTime, row, ctx->entries);

    if (!baseTitle || !baseTitle[0]) return;

    widthBudget = 0x264;
    if (baseF2 && baseF2[0]) {
        widthBudget -= _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, gridCtx, baseF2, 0x7fffffff);
        widthBudget -= _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, gridCtx, " ", 1);
    }
    commaWidth = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, gridCtx, ", ", 2);

    NEWGRID_ResetShowtimeBuckets();

    if (ctx->startCol < 0 || ctx->startCol > TEXTDISP_PrimaryGroupEntryCount) {
        ctx->startCol = (LONG)TEXTDISP_PrimaryGroupEntryCount;
    }
    if (ctx->endCol < 0 || ctx->endCol > TEXTDISP_PrimaryGroupEntryCount) {
        ctx->endCol = (LONG)TEXTDISP_PrimaryGroupEntryCount;
    }

    {
        UWORD rowEnd = (UWORD)(ctx->startRow + GCOMMAND_PpvShowtimesRowSpan + 1);
        if (rowEnd > 97) rowEnd = 97;

        for (row = ctx->startRow; row < rowEnd; row++) {
                LONG col = ctx->startCol;
                while (col < ctx->endCol) {
                NEWGRID_Entry *entryMut = 0;
                NEWGRID_AuxData *coiMut = 0;
                const NEWGRID_Entry *entry = 0;
                const NEWGRID_AuxData *coi = 0;
                LONG idx;
                const char *t;
                const char *f1;
                const char *f2;
                const char *f3;

                idx = NEWGRID_UpdatePresetEntry((char **)&entryMut, (char **)&coiMut, row, col);
                entry = entryMut;
                coi = coiMut;
                if (!entry || !coi) {
                    col++;
                    continue;
                }

                if (row == ctx->startRow) {
                    LONG prev = NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex((const char *)entry, (const char *)coi, idx);
                    if (NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState((char *)entryMut, (char *)coiMut, prev,
                        GCOMMAND_PpvSelectionWindowMinutes, GCOMMAND_PpvSelectionToleranceMinutes) == 0) {
                        col++;
                        continue;
                    }
                }

                if (NEWGRID2_JMPTBL_ESQ_TestBit1Based(entry->selectionBits, idx) != -1) {
                    col++;
                    continue;
                }

                t = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entry, idx, 1);
                f1 = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entry, idx, 2);
                f2 = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entry, idx, 6);
                f3 = NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(entry, idx, 7);

                if (!str_eq_nullable(baseTitle, t) ||
                    !str_eq_nullable(baseF1, f1) ||
                    !str_eq_nullable(baseF2, f2) ||
                    !str_eq_nullable(baseF3, f3)) {
                    col++;
                    continue;
                }

                coiMut->rowFlags[idx] |= 0x20;

                if (out[0] == 0) {
                    PARSEINI_JMPTBL_STRING_AppendAtNull(out, Global_STR_SHOWTIMES_AND_SINGLE_SPACE);
                    NEWGRID_AddShowtimeBucketEntry(NEWGRID2_JMPTBL_STR_SkipClass3Chars(baseTime), row);
                    widthBudget -= _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, gridCtx,
                                                  Global_STR_SHOWTIMES_AND_SINGLE_SPACE, 0x7fffffff);
                }

                TEXTDISP_FormatEntryTimeForIndex(tempTime, idx, (char *)coiMut);
                if (NEWGRID_AddShowtimeBucketEntry(NEWGRID2_JMPTBL_STR_SkipClass3Chars(tempTime), idx) == 0) {
                    LONG w = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, gridCtx,
                                            NEWGRID2_JMPTBL_STR_SkipClass3Chars(tempTime), 0x7fffffff);
                    widthBudget -= (commaWidth + w);
                }

                col++;
            }

            if (widthBudget < 0 && row >= ctx->focusRow) {
                break;
            }
        }
    }

    if (out[0] == 0) {
        PARSEINI_JMPTBL_STRING_AppendAtNull(out, Global_STR_SHOWING_AT_AND_SINGLE_SPACE);
        PARSEINI_JMPTBL_STRING_AppendAtNull(out, NEWGRID2_JMPTBL_STR_SkipClass3Chars(baseTime));
    } else {
        NEWGRID_AppendShowtimeBuckets(out);
    }

    if (baseF2 && baseF2[0]) {
        PARSEINI_JMPTBL_STRING_AppendAtNull(out, NEWGRID_ShowtimeGenreSpacer);
        PARSEINI_JMPTBL_STRING_AppendAtNull(out, baseF2);
    }
}

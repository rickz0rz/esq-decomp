typedef unsigned char UBYTE;
typedef signed short WORD;
typedef signed long LONG;
typedef unsigned long ULONG;

enum {
    ESQFUNC_FALSE = 0,
    ESQFUNC_TRUE = 1,
    ESQFUNC_ENTRY_TITLE_OFFSET = 12,
    ESQFUNC_ENTRY_FLAGS_OFFSET = 27,
    ESQFUNC_ENTRY_TAG_OFFSET = 0x2b,
    ESQFUNC_ENTRY_FLAG_TYPE3_BIT = 4,
    ESQFUNC_TAG_COMPARE_LEN = 2,
    ESQFUNC_MATCH_PRIMARY_GROUP = 1,
    ESQFUNC_MATCH_SECONDARY_GROUP = 2,
    ESQFUNC_RAST_CLEAR_PEN = 31,
    ESQFUNC_BRUSH_LABEL_OFFSET = 0x21,
    ESQFUNC_BRUSH_DEPTH_OFFSET = 184,
    ESQFUNC_BRUSH_PALETTE_MODE_OFFSET = 328,
    ESQFUNC_BRUSH_WILDCARD_LIST_OFFSET = 364,
    ESQFUNC_BRUSH_NEXT_OFFSET = 368,
    ESQFUNC_BRUSH_PALETTE_BYTES_OFFSET = 0xe8,
    ESQFUNC_BASE_PALETTE_PRESERVE_BYTES = 12
};

typedef struct ESQFUNC_DisplayContext {
    UBYTE pad0[2];
    WORD width;
    WORD height;
} ESQFUNC_DisplayContext;

typedef struct ESQFUNC_BrushWildcardNode {
    UBYTE pad0[8];
    struct ESQFUNC_BrushWildcardNode *next;
} ESQFUNC_BrushWildcardNode;

typedef struct ESQFUNC_BrushNode {
    UBYTE pad0[ESQFUNC_BRUSH_DEPTH_OFFSET];
    UBYTE planeDepth;
    UBYTE padB9[ESQFUNC_BRUSH_PALETTE_MODE_OFFSET - ESQFUNC_BRUSH_DEPTH_OFFSET - 1];
    LONG paletteMode;
    UBYTE pad14C[ESQFUNC_BRUSH_WILDCARD_LIST_OFFSET - ESQFUNC_BRUSH_PALETTE_MODE_OFFSET - 4];
    ESQFUNC_BrushWildcardNode *wildcardList;
    struct ESQFUNC_BrushNode *next;
} ESQFUNC_BrushNode;

extern WORD TEXTDISP_ActiveGroupId;
extern WORD TEXTDISP_CurrentMatchIndex;
extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern void *TEXTDISP_SecondaryEntryPtrTable[];
extern ESQFUNC_BrushNode *ESQIFF_BrushIniListHead;
extern ESQFUNC_BrushNode *BRUSH_SelectedNode;
extern ESQFUNC_BrushNode *BRUSH_ScriptPrimarySelection;
extern ESQFUNC_BrushNode *BRUSH_ScriptSecondarySelection;
extern ESQFUNC_BrushNode *ESQFUNC_FallbackType3BrushNode;
extern char *Global_REF_RASTPORT_2;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern LONG WDISP_DisplayContextBase;
extern UBYTE WDISP_PaletteTriplesRBase[];
extern UBYTE ESQFUNC_BasePaletteRgbTriples[];
extern const char ESQFUNC_TAG_00[];
extern const char ESQFUNC_TAG_11[];

extern LONG ESQIFF_JMPTBL_STRING_CompareN(const char *lhs, const char *rhs, LONG n);
extern UBYTE ESQSHARED_JMPTBL_ESQ_WildcardMatch(const char *text, const char *pattern);
extern LONG ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(
    UBYTE *brush,
    LONG srcX0,
    LONG srcY0,
    LONG srcX1,
    LONG srcY1,
    char *dstRp,
    LONG forcedDstY);
extern ULONG ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(LONG planeIndex);
extern void ESQIFF_RestoreBasePaletteTriples(void);
extern void _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);

LONG ESQFUNC_SelectAndApplyBrushForCurrentEntry(WORD useSecondarySelection)
{
    ESQFUNC_BrushNode *brushNode;
    ESQFUNC_BrushNode *scriptSelectedBrush;
    const UBYTE *entry;
    LONG foundBrush;
    ESQFUNC_DisplayContext *displayContext;

    brushNode = ESQIFF_BrushIniListHead;
    foundBrush = ESQFUNC_FALSE;

    if (useSecondarySelection == 0) {
        scriptSelectedBrush = BRUSH_ScriptPrimarySelection;
    } else {
        scriptSelectedBrush = BRUSH_ScriptSecondarySelection;
    }

    if (scriptSelectedBrush != (ESQFUNC_BrushNode *)0) {
        foundBrush = ESQFUNC_TRUE;
        brushNode = scriptSelectedBrush;
    } else {
        if (TEXTDISP_ActiveGroupId == ESQFUNC_MATCH_PRIMARY_GROUP) {
            entry = (const UBYTE *)TEXTDISP_PrimaryEntryPtrTable[(LONG)TEXTDISP_CurrentMatchIndex];
        } else {
            entry = (const UBYTE *)TEXTDISP_SecondaryEntryPtrTable[(LONG)TEXTDISP_CurrentMatchIndex];
        }

        if (ESQIFF_JMPTBL_STRING_CompareN(
                (const char *)(entry + ESQFUNC_ENTRY_TAG_OFFSET),
                ESQFUNC_TAG_00,
                ESQFUNC_TAG_COMPARE_LEN) == 0) {
            brushNode = BRUSH_SelectedNode;
            foundBrush = ESQFUNC_TRUE;
        } else if (ESQIFF_JMPTBL_STRING_CompareN(
                       (const char *)(entry + ESQFUNC_ENTRY_TAG_OFFSET),
                       ESQFUNC_TAG_11,
                       ESQFUNC_TAG_COMPARE_LEN) == 0) {
            while (brushNode != (ESQFUNC_BrushNode *)0 && foundBrush == ESQFUNC_FALSE) {
                ESQFUNC_BrushWildcardNode *wildcardNode = brushNode->wildcardList;

                while (wildcardNode != (ESQFUNC_BrushWildcardNode *)0 &&
                       foundBrush == ESQFUNC_FALSE) {
                    if ((UBYTE)ESQSHARED_JMPTBL_ESQ_WildcardMatch(
                            (const char *)(entry + ESQFUNC_ENTRY_TITLE_OFFSET),
                            (const char *)wildcardNode) == 0) {
                        foundBrush = ESQFUNC_TRUE;
                    }

                    wildcardNode = wildcardNode->next;
                }

                if (foundBrush == ESQFUNC_FALSE) {
                    brushNode = brushNode->next;
                }
            }

            if (foundBrush == ESQFUNC_FALSE &&
                (((UBYTE)entry[ESQFUNC_ENTRY_FLAGS_OFFSET] >> ESQFUNC_ENTRY_FLAG_TYPE3_BIT) & 1U) != 0 &&
                ESQFUNC_FallbackType3BrushNode != (ESQFUNC_BrushNode *)0) {
                foundBrush = ESQFUNC_TRUE;
                brushNode = ESQFUNC_FallbackType3BrushNode;
            }
        } else {
            while (brushNode != (ESQFUNC_BrushNode *)0 && foundBrush == ESQFUNC_FALSE) {
                if (ESQIFF_JMPTBL_STRING_CompareN(
                        (const char *)(entry + ESQFUNC_ENTRY_TAG_OFFSET),
                        (const char *)((UBYTE *)brushNode + ESQFUNC_BRUSH_LABEL_OFFSET),
                        ESQFUNC_TAG_COMPARE_LEN) == 0) {
                    foundBrush = ESQFUNC_TRUE;
                } else {
                    brushNode = brushNode->next;
                }
            }
        }
    }

    if (foundBrush == ESQFUNC_FALSE) {
        brushNode = BRUSH_SelectedNode;
    }

    displayContext = (ESQFUNC_DisplayContext *)WDISP_DisplayContextBase;

    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, ESQFUNC_RAST_CLEAR_PEN);
    _LVOSetRast(
        Global_REF_GRAPHICS_LIBRARY,
        (char *)&displayContext->width,
        ESQFUNC_RAST_CLEAR_PEN);

    if (brushNode != (ESQFUNC_BrushNode *)0 &&
        (BRUSH_SelectedNode != (ESQFUNC_BrushNode *)0 || foundBrush != ESQFUNC_FALSE)) {
        ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(
            (UBYTE *)brushNode,
            0,
            0,
            (LONG)displayContext->width - 1,
            (LONG)displayContext->height - 1,
            Global_REF_RASTPORT_2,
            0);
    }

    if (brushNode != (ESQFUNC_BrushNode *)0) {
        LONG paletteMode = *(LONG *)((UBYTE *)brushNode + ESQFUNC_BRUSH_PALETTE_MODE_OFFSET);

        if (paletteMode == 0 || paletteMode == 1 || paletteMode == 3) {
            LONG copyLimit = (LONG)(ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(5) * 3UL);
            LONG brushLimit = (LONG)(ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(
                (LONG)*(UBYTE *)((UBYTE *)brushNode + ESQFUNC_BRUSH_DEPTH_OFFSET)) * 3UL);
            LONG copyCount = 0;

            while (copyCount < brushLimit && copyCount < copyLimit) {
                WDISP_PaletteTriplesRBase[copyCount] =
                    *(((UBYTE *)brushNode + ESQFUNC_BRUSH_PALETTE_BYTES_OFFSET) + copyCount);
                copyCount++;
            }
        }

        if (paletteMode == 1) {
            ESQIFF_RestoreBasePaletteTriples();
        } else if (paletteMode == 3) {
            LONG i;

            for (i = 0; i < ESQFUNC_BASE_PALETTE_PRESERVE_BYTES; i++) {
                WDISP_PaletteTriplesRBase[i] = ESQFUNC_BasePaletteRgbTriples[i];
            }
        }
    } else {
        ESQIFF_RestoreBasePaletteTriples();
    }

    return ESQFUNC_TRUE;
}

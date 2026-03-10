typedef signed long LONG;
typedef signed short WORD;
typedef signed char BYTE;
typedef unsigned char UBYTE;

typedef struct ESQIFF_PendingBrushNode {
    char pathText[190];
    UBYTE sourceType190;
} ESQIFF_PendingBrushNode;

#define ESQIFF_PATH_BUFFER_CHARS 41
#define ESQIFF_WILDCARD_SCAN_LIMIT 40
#define ESQIFF_DF0_PREFIX_LEN 4
#define ESQIFF_RAM_LOGOS_PREFIX_LEN 11

extern WORD CTASKS_IffTaskDoneFlag;
extern LONG CTASKS_PendingLogoBrushDescriptor;
extern LONG CTASKS_PendingGAdsBrushDescriptor;

extern LONG ESQIFF_LogoBrushListCount;
extern LONG ESQIFF_GAdsBrushListCount;
extern WORD ESQIFF_LogoListLineIndex;
extern WORD ESQIFF_AssetSourceSelect;
extern WORD ESQIFF_ExternalAssetPathCommaFlag;
extern WORD ESQIFF_ExternalAssetStateTable;
extern LONG ESQIFF_LogoBrushListHead;
extern LONG ESQIFF_GAdsBrushListHead;
extern LONG ESQIFF_PendingExternalBrushNode;

extern WORD TEXTDISP_CurrentMatchIndex;

extern LONG Global_REF_LONG_DF0_LOGO_LST_DATA;
extern LONG Global_REF_LONG_GFX_G_ADS_DATA;

extern const char ESQIFF_PATH_DF0_COLON[];
extern const char ESQIFF_PATH_RAM_COLON_LOGOS_SLASH[];

extern void _LVOForbid(void);
extern void _LVOPermit(void);

extern void ESQDISP_ProcessGridMessagesIfIdle(void);
extern LONG ESQIFF_ReadNextExternalAssetPathEntry(BYTE *out);
extern char *GCOMMAND_FindPathSeparator(const char *path);
extern WORD ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard(char *path);
extern LONG ESQIFF_JMPTBL_STRING_CompareNoCaseN(const char *lhs, const char *rhs, LONG n);
extern void *ESQIFF_JMPTBL_BRUSH_AllocBrushNode(const char *label, LONG flags);
extern void ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess(void);

WORD ESQIFF_QueueNextExternalAssetIffJob(void)
{
    const WORD SOURCE_SELECT_GADS = 0;
    const WORD SOURCE_SELECT_LOGO = 1;
    const WORD RESULT_REJECTED = 0;
    const WORD RESULT_ACCEPTED = 1;
    const LONG LOGO_LIST_MAX_COUNT = 1;
    const LONG GADS_LIST_MAX_COUNT = 2;
    const WORD RESULT_NO_CANDIDATE = -1;
    const WORD RESULT_PENDING = 1;
    const UBYTE SOURCE_TYPE_LOGO = 4;
    const UBYTE SOURCE_TYPE_GADS = 5;
    char candidate[ESQIFF_PATH_BUFFER_CHARS];
    char wildcardProbe[ESQIFF_PATH_BUFFER_CHARS];
    char snapshot[ESQIFF_PATH_BUFFER_CHARS];
    WORD initialLineIndex;
    WORD accepted;
    WORD savedMatchIndex;
    WORD timeoutState;
    WORD sourceSelect;
    volatile LONG pollLimit;
    LONG duplicateHeadPath;
    const ESQIFF_PendingBrushNode *headNode;
    const char *headPath;
    ESQIFF_PendingBrushNode *pendingNode;

    duplicateHeadPath = 0;

    _LVOForbid();
    if (CTASKS_IffTaskDoneFlag == 0) {
        _LVOPermit();
        return 0;
    }

    if (ESQIFF_AssetSourceSelect != 0) {
        if (ESQIFF_LogoBrushListCount >= LOGO_LIST_MAX_COUNT) {
            _LVOPermit();
            return RESULT_REJECTED;
        }
    }

    if (ESQIFF_AssetSourceSelect == SOURCE_SELECT_GADS) {
        if (ESQIFF_GAdsBrushListCount >= GADS_LIST_MAX_COUNT) {
            _LVOPermit();
            return RESULT_REJECTED;
        }
    }

    _LVOPermit();

    candidate[0] = 0;
    initialLineIndex = ESQIFF_LogoListLineIndex;
    accepted = RESULT_REJECTED;

    if (Global_REF_LONG_DF0_LOGO_LST_DATA != 0 && ESQIFF_AssetSourceSelect == SOURCE_SELECT_LOGO) {
        /* candidate source is usable */
    } else if (Global_REF_LONG_GFX_G_ADS_DATA != 0 && ESQIFF_AssetSourceSelect == SOURCE_SELECT_GADS) {
        /* candidate source is usable */
    } else {
        goto finalize_no_candidate;
    }

    wildcardProbe[0] = 0;
    savedMatchIndex = TEXTDISP_CurrentMatchIndex;

    for (;;) {
        WORD i;
        const char *measure;
        LONG pathLen;

        ESQIFF_ReadNextExternalAssetPathEntry((BYTE *)candidate);

        measure = candidate;
        while (*measure != 0) {
            ++measure;
        }
        pathLen = (LONG)(measure - candidate);
        if (pathLen != 0) {
            sourceSelect = ESQIFF_AssetSourceSelect;
            if (sourceSelect == SOURCE_SELECT_LOGO) {
                if (ESQIFF_ExternalAssetPathCommaFlag != 0) {
                    accepted = RESULT_ACCEPTED;
                } else {
                    for (i = 0; i < ESQIFF_WILDCARD_SCAN_LIMIT; ++i) {
                        wildcardProbe[i] = candidate[i];
                        if (wildcardProbe[i] == 0) {
                            break;
                        }
                        if (wildcardProbe[i] == '!') {
                            wildcardProbe[i] = '*';
                            wildcardProbe[i + 1] = 0;
                            break;
                        }
                    }

                    if (ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard(
                            GCOMMAND_FindPathSeparator(wildcardProbe)) == 1) {
                        accepted = RESULT_ACCEPTED;
                        ESQIFF_ExternalAssetStateTable = TEXTDISP_CurrentMatchIndex;
                    } else {
                        ESQDISP_ProcessGridMessagesIfIdle();
                    }
                }
            } else {
                if (ESQIFF_JMPTBL_STRING_CompareNoCaseN(
                        ESQIFF_PATH_DF0_COLON, candidate, ESQIFF_DF0_PREFIX_LEN) == 0) {
                    /* rejected prefix */
                } else if (ESQIFF_JMPTBL_STRING_CompareNoCaseN(
                               ESQIFF_PATH_RAM_COLON_LOGOS_SLASH, candidate, ESQIFF_RAM_LOGOS_PREFIX_LEN) == 0) {
                    /* rejected prefix */
                } else {
                    accepted = RESULT_ACCEPTED;
                }
            }
        }

        if (accepted != RESULT_REJECTED) {
            break;
        }

        if (ESQIFF_LogoListLineIndex == initialLineIndex) {
            break;
        }
    }

    TEXTDISP_CurrentMatchIndex = savedMatchIndex;

    if (accepted == 0) {
        goto finalize_no_candidate;
    }

    if (ESQIFF_AssetSourceSelect != 0) {
        pollLimit = 0xFA00;
    } else {
        pollLimit = 0x13880;
    }

    {
        const char *src = candidate;
        char *dst = snapshot;
        do {
            *dst++ = *src;
        } while (*src++ != 0);
    }

    for (;;) {
        const char *p0;
        const char *p1;
        char ch;

        timeoutState = RESULT_PENDING;
        ESQDISP_ProcessGridMessagesIfIdle();

        if (ESQIFF_AssetSourceSelect == SOURCE_SELECT_LOGO) {
            headNode = (const ESQIFF_PendingBrushNode *)ESQIFF_LogoBrushListHead;
        } else {
            headNode = (const ESQIFF_PendingBrushNode *)ESQIFF_GAdsBrushListHead;
        }
        headPath = (headNode != 0) ? headNode->pathText : 0;

        duplicateHeadPath = 0;
        if (headPath != 0) {
            p0 = candidate;
            p1 = headPath;
            for (;;) {
                ch = *p0++;
                if (*p1++ != ch) {
                    break;
                }
                if (ch == 0) {
                    duplicateHeadPath = 1;
                    break;
                }
            }
        }

        if (duplicateHeadPath == 0) {
            pendingNode = (ESQIFF_PendingBrushNode *)ESQIFF_JMPTBL_BRUSH_AllocBrushNode(candidate, 0);
            ESQIFF_PendingExternalBrushNode = (LONG)pendingNode;
            if (ESQIFF_AssetSourceSelect == SOURCE_SELECT_LOGO) {
                pendingNode->sourceType190 = SOURCE_TYPE_LOGO;
                CTASKS_PendingLogoBrushDescriptor = (LONG)pendingNode;
            } else {
                pendingNode->sourceType190 = SOURCE_TYPE_GADS;
                CTASKS_PendingGAdsBrushDescriptor = (LONG)pendingNode;
            }
            ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess();
        }

        ESQDISP_ProcessGridMessagesIfIdle();
        if (timeoutState == RESULT_NO_CANDIDATE) {
            ESQIFF_ReadNextExternalAssetPathEntry((BYTE *)candidate);
        }

        p0 = snapshot;
        p1 = candidate;
        for (;;) {
            ch = *p0++;
            if (*p1++ != ch) {
                break;
            }
            if (ch == 0) {
                goto finalize_no_candidate;
            }
        }

        if (timeoutState == RESULT_NO_CANDIDATE) {
            continue;
        }
        break;
    }

finalize_no_candidate:
    if (accepted == RESULT_REJECTED) {
        timeoutState = RESULT_NO_CANDIDATE;
    }

    return timeoutState;
}

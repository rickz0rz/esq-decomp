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
    const WORD RESULT_NO_CANDIDATE = -1;
    const WORD RESULT_PENDING = 1;
    const UBYTE SOURCE_TYPE_LOGO = 4;
    const UBYTE SOURCE_TYPE_GADS = 5;
    BYTE candidate[ESQIFF_PATH_BUFFER_CHARS];
    BYTE wildcardProbe[ESQIFF_PATH_BUFFER_CHARS];
    BYTE snapshot[ESQIFF_PATH_BUFFER_CHARS];
    WORD initialLineIndex;
    WORD accepted;
    WORD savedMatchIndex;
    WORD timeoutState;
    WORD sourceSelect;
    volatile LONG pollLimit;
    LONG duplicateHeadPath;
    LONG headNodeLong;
    const char *headPath;
    ESQIFF_PendingBrushNode *pendingNode;

    duplicateHeadPath = 0;

    _LVOForbid();
    if (CTASKS_IffTaskDoneFlag == 0) {
        _LVOPermit();
        return 0;
    }

    if (ESQIFF_AssetSourceSelect != 0) {
        if (ESQIFF_LogoBrushListCount >= 1) {
            _LVOPermit();
            return 0;
        }
    }

    if (ESQIFF_AssetSourceSelect == 0) {
        if (ESQIFF_GAdsBrushListCount >= 2) {
            _LVOPermit();
            return 0;
        }
    }

    _LVOPermit();

    candidate[0] = 0;
    initialLineIndex = ESQIFF_LogoListLineIndex;
    accepted = 0;

    if (Global_REF_LONG_DF0_LOGO_LST_DATA != 0 && ESQIFF_AssetSourceSelect != 0) {
        /* candidate source is usable */
    } else if (Global_REF_LONG_GFX_G_ADS_DATA != 0 && ESQIFF_AssetSourceSelect == 0) {
        /* candidate source is usable */
    } else {
        goto finalize_no_candidate;
    }

    wildcardProbe[0] = 0;
    savedMatchIndex = TEXTDISP_CurrentMatchIndex;

    for (;;) {
        WORD i;
        BYTE *measure;
        LONG pathLen;

        ESQIFF_ReadNextExternalAssetPathEntry(candidate);

        measure = candidate;
        while (*measure != 0) {
            ++measure;
        }
        pathLen = (LONG)(measure - candidate);
        if (pathLen != 0) {
            sourceSelect = ESQIFF_AssetSourceSelect;
            if (sourceSelect != 0) {
                if (ESQIFF_ExternalAssetPathCommaFlag != 0) {
                    accepted = 1;
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
                        accepted = 1;
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
                    accepted = 1;
                }
            }
        }

        if (accepted != 0) {
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
        BYTE *src = candidate;
        BYTE *dst = snapshot;
        do {
            *dst++ = *src;
        } while (*src++ != 0);
    }

    for (;;) {
        BYTE *p0;
        BYTE *p1;
        BYTE ch;

        timeoutState = RESULT_PENDING;
        ESQDISP_ProcessGridMessagesIfIdle();

        if (ESQIFF_AssetSourceSelect != 0) {
            headNodeLong = ESQIFF_LogoBrushListHead;
        } else {
            headNodeLong = ESQIFF_GAdsBrushListHead;
        }
        headPath = (headNodeLong != 0) ? ((const ESQIFF_PendingBrushNode *)headNodeLong)->pathText : 0;

        duplicateHeadPath = 0;
        if (headPath != 0) {
            p0 = candidate;
            p1 = (BYTE *)headPath;
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
            if (ESQIFF_AssetSourceSelect != 0) {
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
            ESQIFF_ReadNextExternalAssetPathEntry(candidate);
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
    if (accepted == 0) {
        timeoutState = RESULT_NO_CANDIDATE;
    }

    return timeoutState;
}

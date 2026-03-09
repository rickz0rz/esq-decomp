typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_SelectionEntry {
    char shortName[10];
    char longName[200];
    LONG mode;
    LONG groupIndex;
    unsigned short selectionIndex;
    char detailLine[524];
} TEXTDISP_SelectionEntry;

#define MEMF_PUBLIC 0x00000001L
#define MEMF_CLEAR  0x00010000L

extern TEXTDISP_SelectionEntry *TEXTDISP_CommandBufferPtr;
extern WORD TEXTDISP_StatusGroupId;
extern WORD TEXTDISP_LastDispatchMatchIndex;
extern WORD TEXTDISP_LastDispatchGroupId;
extern WORD TEXTDISP_ActiveGroupId;
extern WORD TEXTDISP_CurrentMatchIndex;
extern WORD TEXTDISP_PrimaryFirstMatchIndex;
extern WORD TEXTDISP_SecondaryFirstMatchIndex;
extern WORD TEXTDISP_PrimaryChannelCode;
extern char TEXTDISP_PrimarySearchText[];
extern char TEXTDISP_DefaultSpacePad[];

extern const char Global_STR_TEXTDISP_C_1[];
extern const char Global_STR_TEXTDISP_C_2[];
extern const char TEXTDISP_CommandPrefixFormat[];

extern void *MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern void WDISP_SPrintf(char *dst, const char *fmt, const char *arg);
extern LONG TEXTDISP_SelectGroupAndEntry(char *cmd, char *primarySearch, LONG channelCode);
extern UBYTE SCRIPT_GetBannerCharOrFallback(void);
extern void TEXTDISP_BuildNowShowingStatusLine(LONG group, LONG match, LONG bannerChar);
extern void SCRIPT_ResetBannerCharDefaults(void);
extern void TEXTDISP_BuildEntryPairStatusLine(LONG group, LONG match, LONG bannerChar);
extern void TEXTDISP_SetEntryTextFields(TEXTDISP_SelectionEntry *entry, const char *shortText, const char *longText);
extern LONG TEXTDISP_FilterAndSelectEntry(TEXTDISP_SelectionEntry *entry, LONG mode);
extern void TEXTDISP_DrawHighlightFrame(TEXTDISP_SelectionEntry *entry);

LONG TEXTDISP_HandleScriptCommand(UBYTE scriptType, UBYTE command, const char *arg)
{
    const UBYTE CMD_CHANNEL = 'C';
    const UBYTE CMD_JOIN = 'J';
    const UBYTE SCRIPT_FILTER = 'F';
    const LONG MODE_FILTER = 70;
    const LONG MODE_EXACT = 88;
    const LONG FLAG_FALSE = 0;
    const LONG INDEX_NOT_FOUND = -1;
    const LONG GROUP_PRIMARY = 1;
    const LONG GROUP_SECONDARY = 0;
    const LONG BANNER_UNKNOWN = -1;
    const WORD DISPATCH_DEFAULT_BANNER = 0x31;
    const LONG BUFFER_ALLOC_LINE = 1084;
    const LONG BUFFER_FREE_LINE = 1106;
    const LONG BUFFER_SIZE = 732;
    const UBYTE CH_NUL = 0;
    LONG doFinalize = 1;
    LONG doCleanup = 1;
    char scratch[200];

    if (command != (UBYTE)0xffu) {
        if (command == CMD_CHANNEL) {
            WDISP_SPrintf(scratch, TEXTDISP_CommandPrefixFormat, arg);

            if (TEXTDISP_SelectGroupAndEntry(
                    (char *)arg, TEXTDISP_PrimarySearchText, (LONG)(WORD)TEXTDISP_PrimaryChannelCode) == 0) {
                TEXTDISP_StatusGroupId = TEXTDISP_ActiveGroupId;
                TEXTDISP_LastDispatchMatchIndex = TEXTDISP_CurrentMatchIndex;
                TEXTDISP_LastDispatchGroupId = (WORD)SCRIPT_GetBannerCharOrFallback();
            } else if ((WORD)(TEXTDISP_PrimaryFirstMatchIndex + 1) != 0) {
                TEXTDISP_StatusGroupId = GROUP_PRIMARY;
                TEXTDISP_LastDispatchMatchIndex = TEXTDISP_PrimaryFirstMatchIndex;
                TEXTDISP_LastDispatchGroupId = BANNER_UNKNOWN;
            } else if ((WORD)(TEXTDISP_SecondaryFirstMatchIndex + 1) != 0) {
                TEXTDISP_StatusGroupId = GROUP_SECONDARY;
                TEXTDISP_LastDispatchMatchIndex = TEXTDISP_SecondaryFirstMatchIndex;
                TEXTDISP_LastDispatchGroupId = BANNER_UNKNOWN;
            } else {
                TEXTDISP_StatusGroupId = INDEX_NOT_FOUND;
                TEXTDISP_LastDispatchMatchIndex = INDEX_NOT_FOUND;
                TEXTDISP_LastDispatchGroupId = BANNER_UNKNOWN;
            }

            TEXTDISP_BuildNowShowingStatusLine(
                (LONG)TEXTDISP_StatusGroupId,
                (LONG)TEXTDISP_LastDispatchMatchIndex,
                (LONG)TEXTDISP_LastDispatchGroupId
            );
            SCRIPT_ResetBannerCharDefaults();
            doFinalize = FLAG_FALSE;
        } else if (command == CMD_JOIN) {
            TEXTDISP_BuildEntryPairStatusLine(
                (LONG)TEXTDISP_StatusGroupId,
                (LONG)TEXTDISP_LastDispatchMatchIndex,
                (LONG)TEXTDISP_LastDispatchGroupId
            );
            doFinalize = FLAG_FALSE;
        } else {
            if (scriptType == SCRIPT_FILTER) {
                if (TEXTDISP_CommandBufferPtr == (TEXTDISP_SelectionEntry *)0) {
                    TEXTDISP_CommandBufferPtr = (TEXTDISP_SelectionEntry *)MEMORY_AllocateMemory(
                        Global_STR_TEXTDISP_C_1,
                        BUFFER_ALLOC_LINE,
                        BUFFER_SIZE,
                        (MEMF_PUBLIC + MEMF_CLEAR)
                    );
                }

                if (TEXTDISP_CommandBufferPtr != (TEXTDISP_SelectionEntry *)0) {
                    TEXTDISP_SetEntryTextFields(TEXTDISP_CommandBufferPtr, arg, TEXTDISP_PrimarySearchText);

                    if (TEXTDISP_FilterAndSelectEntry(TEXTDISP_CommandBufferPtr, MODE_FILTER) == 0) {
                        char *dst = (char *)TEXTDISP_CommandBufferPtr->detailLine;
                        char *src = TEXTDISP_DefaultSpacePad;
                        while ((*dst++ = *src++) != CH_NUL) {
                        }
                    }
                }
            }

            if (TEXTDISP_CommandBufferPtr != (TEXTDISP_SelectionEntry *)0) {
                TEXTDISP_DrawHighlightFrame(TEXTDISP_CommandBufferPtr);
                TEXTDISP_FilterAndSelectEntry(TEXTDISP_CommandBufferPtr, MODE_EXACT);
            }

            doCleanup = FLAG_FALSE;
        }
    }

    if (doFinalize != 0) {
        TEXTDISP_LastDispatchMatchIndex = INDEX_NOT_FOUND;
        TEXTDISP_LastDispatchGroupId = DISPATCH_DEFAULT_BANNER;
    }

    if (doCleanup != 0) {
        TEXTDISP_FilterAndSelectEntry((TEXTDISP_SelectionEntry *)0, 0);
        if (TEXTDISP_CommandBufferPtr != (TEXTDISP_SelectionEntry *)0) {
            MEMORY_DeallocateMemory(Global_STR_TEXTDISP_C_2, BUFFER_FREE_LINE, TEXTDISP_CommandBufferPtr, BUFFER_SIZE);
            TEXTDISP_CommandBufferPtr = (TEXTDISP_SelectionEntry *)0;
        }
    }

    return FLAG_FALSE;
}

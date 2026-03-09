typedef signed long LONG;
typedef signed short WORD;

typedef struct TEXTDISP_CandidateEntry {
    char pad0[1];
    char text[1];
} TEXTDISP_CandidateEntry;

extern WORD TEXTDISP_CurrentMatchIndex;
extern WORD TEXTDISP_ActiveGroupId;
extern LONG TEXTDISP_ChannelLabelReadyFlag;
extern char TEXTDISP_ChannelLabelBuffer[];
extern char TEXTDISP_ChannelLabelBufferTerminatorByte[];
extern const char Global_STR_ALIGNED_ON[];
extern const char Global_STR_ALIGNED_CHANNEL_1[];

extern char *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern char *STRING_AppendAtNull(char *dst, const char *src);

void TEXTDISP_BuildChannelLabel(WORD includeOnPrefix)
{
    char entryName[17];
    TEXTDISP_CandidateEntry *entry;
    LONG mode;
    LONG len;

    mode = (TEXTDISP_ActiveGroupId == 0) ? 2 : 1;
    entry = (TEXTDISP_CandidateEntry *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode((LONG)TEXTDISP_CurrentMatchIndex, mode);

    if (entry != (TEXTDISP_CandidateEntry *)0) {
        char *src = entry->text;
        char *dst = entryName;
        do {
            *dst++ = *src;
        } while (*src++ != 0);
    } else {
        entryName[0] = 0;
    }

    len = 0;
    while (entryName[len] != 0) {
        ++len;
    }

    TEXTDISP_ChannelLabelReadyFlag = 0;
    if (len <= 1) {
        return;
    }

    if (entryName[len - 2] == ' ') {
        return;
    }

    if (includeOnPrefix != 0) {
        STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer, Global_STR_ALIGNED_ON);
    }

    STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer, Global_STR_ALIGNED_CHANNEL_1);
    STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer, entry->text);

    len = 0;
    while (TEXTDISP_ChannelLabelBuffer[len] != 0) {
        ++len;
    }
    TEXTDISP_ChannelLabelBufferTerminatorByte[len] = 0;
    TEXTDISP_ChannelLabelReadyFlag = 1;
}

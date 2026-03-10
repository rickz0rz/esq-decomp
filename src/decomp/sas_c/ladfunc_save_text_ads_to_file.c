typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct LadfuncEntry {
    UWORD startSlot;
    UWORD endSlot;
    UWORD isHighlighted;
    char *textPtr;
    UBYTE *attrPtr;
} LadfuncEntry;

extern LONG DISKIO_SaveOperationReadyFlag;
extern LONG LADFUNC_SaveAdsFileHandle;

extern const char KYBD_PATH_DF0_LOCAL_ADS[];
extern const char LADFUNC_FMT_AttrEscapePrefixCharHex[];
extern const UBYTE LADFUNC_TextAdLineBreakBuffer[];

extern LadfuncEntry *LADFUNC_EntryPtrTable[];

extern LONG LADFUNC_ComposePackedPenByte(UBYTE highNibble, UBYTE lowNibble);
extern LONG GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(const char *path, LONG mode);
extern void GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(LONG fileHandle, LONG value);
extern LONG GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(LONG fileHandle, const void *data, LONG size);
extern LONG GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(LONG fileHandle);
extern LONG GROUP_AW_JMPTBL_WDISP_SPrintf(char *out, const char *fmt, LONG argCount, LONG value);

#ifndef MODE_NEWFILE
#define MODE_NEWFILE 1006
#endif

LONG LADFUNC_SaveTextAdsToFile(void)
{
    const UBYTE DEFAULT_PEN_HIGH_NIBBLE = 2;
    const UBYTE DEFAULT_PEN_LOW_NIBBLE = 1;
    LONG entryIndex;
    UBYTE currentAttr;
    UBYTE empty = 0;

    currentAttr = (UBYTE)LADFUNC_ComposePackedPenByte(DEFAULT_PEN_HIGH_NIBBLE, DEFAULT_PEN_LOW_NIBBLE);

    if (DISKIO_SaveOperationReadyFlag == 0) {
        return 0;
    }

    DISKIO_SaveOperationReadyFlag = 0;
    LADFUNC_SaveAdsFileHandle = GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(KYBD_PATH_DF0_LOCAL_ADS, MODE_NEWFILE);
    if (LADFUNC_SaveAdsFileHandle == 0) {
        DISKIO_SaveOperationReadyFlag = 1;
        return -1;
    }

    for (entryIndex = 0; entryIndex <= 46; ++entryIndex) {
        LadfuncEntry *entry = LADFUNC_EntryPtrTable[entryIndex];
        char *text = entry->textPtr ? entry->textPtr : (char *)&empty;
        LONG textLen = 0;
        LONG i = 0;
        LONG segmentStart = 0;

        GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(LADFUNC_SaveAdsFileHandle, (LONG)entry->startSlot);
        GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(LADFUNC_SaveAdsFileHandle, (LONG)entry->endSlot);

        while (text[textLen] != 0) {
            ++textLen;
        }

        while (i <= textLen) {
            if (i == textLen || entry->attrPtr[i] != currentAttr) {
                if (i > 0) {
                    char fmtBuf[32];
                    LONG fmtLen = 0;

                    GROUP_AW_JMPTBL_WDISP_SPrintf(fmtBuf, LADFUNC_FMT_AttrEscapePrefixCharHex, 3, (LONG)currentAttr);
                    while (fmtBuf[fmtLen] != 0) {
                        ++fmtLen;
                    }

                    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(LADFUNC_SaveAdsFileHandle, fmtBuf, fmtLen);
                    GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(LADFUNC_SaveAdsFileHandle, text + segmentStart, i - segmentStart);
                    segmentStart = i;
                }

                if (segmentStart < textLen) {
                    currentAttr = entry->attrPtr[i];
                }
            }
            ++i;
        }

        GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(LADFUNC_SaveAdsFileHandle, LADFUNC_TextAdLineBreakBuffer, 1);
    }

    GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(LADFUNC_SaveAdsFileHandle);
    DISKIO_SaveOperationReadyFlag = 1;
    return 0;
}

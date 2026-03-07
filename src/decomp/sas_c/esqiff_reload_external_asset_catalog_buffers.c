typedef signed long LONG;
typedef signed short WORD;
typedef signed char BYTE;
typedef unsigned long ULONG;

typedef struct MinList MinList;

#ifndef MODE_OLDFILE
#define MODE_OLDFILE 1005
#endif

#ifndef MEMF_PUBLIC
#define MEMF_PUBLIC 1UL
#endif

extern WORD CTASKS_IffTaskDoneFlag;
extern BYTE ED_DiagGraphModeChar;
extern LONG DISKIO_DriveWriteProtectStatusCodeDrive1;
extern LONG DISKIO_Drive0WriteProtectedCode;
extern LONG ESQIFF_GAdsBrushListCount;
extern WORD ESQIFF_GAdsListLineIndex;
extern LONG ESQIFF_LogoBrushListCount;
extern WORD ESQIFF_LogoListLineIndex;
extern LONG Global_REF_LONG_GFX_G_ADS_DATA;
extern LONG Global_REF_LONG_GFX_G_ADS_FILESIZE;
extern LONG Global_REF_LONG_DF0_LOGO_LST_DATA;
extern LONG Global_REF_LONG_DF0_LOGO_LST_FILESIZE;
extern WORD ESQIFF_ExternalAssetFlags;
extern WORD SCRIPT_CtrlInterfaceEnabledFlag;
extern BYTE *Global_PTR_STR_GFX_G_ADS;
extern BYTE *Global_PTR_STR_DF0_LOGO_LST;
extern BYTE Global_STR_ESQIFF_C_3;
extern BYTE Global_STR_ESQIFF_C_4;
extern BYTE Global_STR_ESQIFF_C_5;
extern BYTE Global_STR_ESQIFF_C_6;
extern void *Global_REF_DOS_LIBRARY_2;
extern MinList ESQIFF_GAdsBrushListHead;
extern MinList ESQIFF_LogoBrushListHead;

extern void _LVOForbid(void);
extern void _LVOPermit(void);
extern LONG _LVORead(void *dosBase, LONG fileHandle, void *buffer, LONG length);
extern LONG _LVOClose(void *dosBase, LONG fileHandle);

extern void ESQIFF_JMPTBL_BRUSH_FreeBrushList(MinList *head, LONG freePayload);
extern void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG size);
extern void *ESQIFF_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, ULONG bytes, ULONG flags);
extern LONG ESQIFF_JMPTBL_DOS_OpenFileWithMode(BYTE *name, LONG mode);
extern LONG ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(LONG fileHandle);

void ESQIFF_ReloadExternalAssetCatalogBuffers(LONG mode)
{
    LONG fh;
    LONG size;
    void *data;

    if (CTASKS_IffTaskDoneFlag == 0) {
        return;
    }

    if (mode == 1 && ED_DiagGraphModeChar != 'N' && DISKIO_DriveWriteProtectStatusCodeDrive1 == 0) {
        _LVOForbid();
        ESQIFF_JMPTBL_BRUSH_FreeBrushList(&ESQIFF_GAdsBrushListHead, 0);
        ESQIFF_GAdsBrushListCount = 0;
        ESQIFF_GAdsListLineIndex = 0;
        _LVOPermit();

        if (Global_REF_LONG_GFX_G_ADS_DATA != 0 && Global_REF_LONG_GFX_G_ADS_FILESIZE != 0) {
            ESQIFF_JMPTBL_MEMORY_DeallocateMemory(
                &Global_STR_ESQIFF_C_3,
                882,
                (void *)Global_REF_LONG_GFX_G_ADS_DATA,
                Global_REF_LONG_GFX_G_ADS_FILESIZE + 1);
        }

        Global_REF_LONG_GFX_G_ADS_DATA = 0;
        Global_REF_LONG_GFX_G_ADS_FILESIZE = 0;

        fh = ESQIFF_JMPTBL_DOS_OpenFileWithMode(Global_PTR_STR_GFX_G_ADS, MODE_OLDFILE);
        if (fh > 0) {
            size = ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(fh);
            Global_REF_LONG_GFX_G_ADS_FILESIZE = size;
            if (size > 0) {
                data = ESQIFF_JMPTBL_MEMORY_AllocateMemory(
                    &Global_STR_ESQIFF_C_4,
                    898,
                    (ULONG)(size + 1),
                    MEMF_PUBLIC);
                Global_REF_LONG_GFX_G_ADS_DATA = (LONG)data;

                if (_LVORead(Global_REF_DOS_LIBRARY_2, fh, data, size) == size) {
                    ESQIFF_ExternalAssetFlags = (WORD)(ESQIFF_ExternalAssetFlags | 1);
                }
            }

            _LVOClose(Global_REF_DOS_LIBRARY_2, fh);
        }

        if (SCRIPT_CtrlInterfaceEnabledFlag != 0) {
            ESQIFF_GAdsListLineIndex = 1;
        } else {
            ESQIFF_GAdsListLineIndex = 0;
        }
    }

    if (mode != 0 || DISKIO_Drive0WriteProtectedCode != 0) {
        return;
    }

    _LVOForbid();
    ESQIFF_JMPTBL_BRUSH_FreeBrushList(&ESQIFF_LogoBrushListHead, 0);
    ESQIFF_LogoBrushListCount = 0;
    ESQIFF_LogoListLineIndex = 0;
    _LVOPermit();

    if (Global_REF_LONG_DF0_LOGO_LST_DATA != 0 && Global_REF_LONG_DF0_LOGO_LST_FILESIZE != 0) {
        ESQIFF_JMPTBL_MEMORY_DeallocateMemory(
            &Global_STR_ESQIFF_C_5,
            963,
            (void *)Global_REF_LONG_DF0_LOGO_LST_DATA,
            Global_REF_LONG_DF0_LOGO_LST_FILESIZE + 1);
    }

    Global_REF_LONG_DF0_LOGO_LST_DATA = 0;
    Global_REF_LONG_DF0_LOGO_LST_FILESIZE = 0;

    fh = ESQIFF_JMPTBL_DOS_OpenFileWithMode(Global_PTR_STR_DF0_LOGO_LST, MODE_OLDFILE);
    if (fh <= 0) {
        return;
    }

    size = ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(fh);
    Global_REF_LONG_DF0_LOGO_LST_FILESIZE = size;
    if (size > 0) {
        data = ESQIFF_JMPTBL_MEMORY_AllocateMemory(
            &Global_STR_ESQIFF_C_6,
            979,
            (ULONG)(size + 1),
            MEMF_PUBLIC);
        Global_REF_LONG_DF0_LOGO_LST_DATA = (LONG)data;

        if (_LVORead(Global_REF_DOS_LIBRARY_2, fh, data, size) == size) {
            ESQIFF_ExternalAssetFlags = (WORD)(ESQIFF_ExternalAssetFlags | 2);
        }
    }

    _LVOClose(Global_REF_DOS_LIBRARY_2, fh);
}

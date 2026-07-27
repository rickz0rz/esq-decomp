/* RESTORES: ESQIFF_ReloadExternalAssetCatalogBuffers
 * MODULE:   modules/groups/a/n/esqiff.s
 * STATUS:   behavioural
 *
 * Reloads one of the two external asset catalogues from disk -- the G_ADS
 * graphics list when mode is 1, the DF0 logo list when mode is 0 -- by dropping
 * the parsed brush list, freeing the old file image, and reading the file back in
 * whole. A successful read sets the catalogue's bit in ESQIFF_ExternalAssetFlags.
 *
 * The two halves are near-identical and are written out longhand, because the
 * original is: different globals, different line numbers in the allocator calls,
 * different flag bits, and only the G_ADS half touches the list line index.
 *
 * Two details worth not tidying:
 *   - The brush list teardown runs inside Forbid()/Permit(); the file I/O does
 *     not. Only the list is shared with the IFF task.
 *   - When the file fails to OPEN, the G_ADS half still runs its line-index
 *     update -- the failure branch jumps past the Close, not past that. A `return`
 *     there would be wrong.
 *
 * 564 bytes in the original, 540 emitted. The -24 is -12 in each half, the same
 * five items both times, which is itself confirmation that the two halves really
 * are the same code with different symbols. All five are classes already on
 * record; nothing new and nothing unattributed.
 *
 * SASC-MISMATCH: zero-store-via-register
 *   ref:     7000 23c0000001b4    MOVEQ #0,D0 / MOVE.L D0,(abs).L
 *   got:     42b900000000        CLR.L (abs).L
 *   summary: The brush-list count. -2 per half. Sixth and seventh sightings; see
 *            ed1_clear_esc_menu_mode.c, which lists them all and asserts no rule.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     2c780004            MOVEA.L AbsExecBase,A6 again before Permit
 *            2f3900005ae0        the data pointer re-read for the free argument
 *   got:     (neither)           A6 still holds SysBase; the pointer is in D0
 *                                from the test that just read it
 *   summary: -4 and -4 per half. Same class and direction as
 *            cleanup_clear_rbf_interrupt_and_serial.c.
 *
 * SASC-MISMATCH: alloc-result-store-order
 *   ref:     JSR / MOVE.L D0,(abs).L / TST.L D0
 *   got:     BSR / MOVE.L D0,(abs).L emitted before the pop
 *   summary: The +6/-6 and +6/-8 pairs. Same instructions in a different order,
 *            first recorded in esqiff_handle_brush_ini_reload_hotkey.c and now
 *            seen in six functions.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the ten cross-unit calls.
 */
#include <proto/dos.h>
#include <proto/exec.h>

extern void ESQIFF_JMPTBL_BRUSH_FreeBrushList(void *head, long flags);
extern void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, void *p,
                                                  long size);
extern void *ESQIFF_JMPTBL_MEMORY_AllocateMemory(char *who, long line, long size,
                                                 long flags);
extern long ESQIFF_JMPTBL_DOS_OpenFileWithMode(char *name, long mode);
extern long ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(long fh);

extern short CTASKS_IffTaskDoneFlag;
extern unsigned char ED_DiagGraphModeChar;
extern long DISKIO_DriveWriteProtectStatusCodeDrive1;
extern long DISKIO_Drive0WriteProtectedCode;
extern void *ESQIFF_GAdsBrushListHead;
extern void *ESQIFF_LogoBrushListHead;
extern long ESQIFF_GAdsBrushListCount;
extern long ESQIFF_LogoBrushListCount;
extern short ESQIFF_GAdsListLineIndex;
extern short ESQIFF_LogoListLineIndex;
extern short ESQIFF_ExternalAssetFlags;
extern short SCRIPT_CtrlInterfaceEnabledFlag;
extern char *Global_REF_LONG_GFX_G_ADS_DATA;
extern long Global_REF_LONG_GFX_G_ADS_FILESIZE;
extern char *Global_REF_LONG_DF0_LOGO_LST_DATA;
extern long Global_REF_LONG_DF0_LOGO_LST_FILESIZE;
extern char *Global_PTR_STR_GFX_G_ADS;
extern char *Global_PTR_STR_DF0_LOGO_LST;
extern char Global_STR_ESQIFF_C_3[];
extern char Global_STR_ESQIFF_C_4[];
extern char Global_STR_ESQIFF_C_5[];
extern char Global_STR_ESQIFF_C_6[];

void ESQIFF_ReloadExternalAssetCatalogBuffers(long mode)
{
    long fh;

    if (CTASKS_IffTaskDoneFlag == 0)
        return;

    if (mode == 1 && ED_DiagGraphModeChar != 78
        && DISKIO_DriveWriteProtectStatusCodeDrive1 == 0) {
        Forbid();
        ESQIFF_JMPTBL_BRUSH_FreeBrushList(&ESQIFF_GAdsBrushListHead, 0L);
        ESQIFF_GAdsBrushListCount = 0;
        ESQIFF_GAdsListLineIndex = 0;
        Permit();

        if (Global_REF_LONG_GFX_G_ADS_DATA && Global_REF_LONG_GFX_G_ADS_FILESIZE) {
            ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQIFF_C_3, 882L,
                                                  Global_REF_LONG_GFX_G_ADS_DATA,
                                                  Global_REF_LONG_GFX_G_ADS_FILESIZE + 1);
            Global_REF_LONG_GFX_G_ADS_DATA = 0;
            Global_REF_LONG_GFX_G_ADS_FILESIZE = 0;
        }

        fh = ESQIFF_JMPTBL_DOS_OpenFileWithMode(Global_PTR_STR_GFX_G_ADS, 1005L);
        if (fh > 0) {
            Global_REF_LONG_GFX_G_ADS_FILESIZE =
                ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(fh);
            if (Global_REF_LONG_GFX_G_ADS_FILESIZE > 0) {
                Global_REF_LONG_GFX_G_ADS_DATA = (char *)
                    ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_STR_ESQIFF_C_4, 898L,
                                                        Global_REF_LONG_GFX_G_ADS_FILESIZE + 1,
                                                        1L);
                if (Read(fh, Global_REF_LONG_GFX_G_ADS_DATA,
                         Global_REF_LONG_GFX_G_ADS_FILESIZE)
                    == Global_REF_LONG_GFX_G_ADS_FILESIZE)
                    ESQIFF_ExternalAssetFlags = ESQIFF_ExternalAssetFlags | 1;
            }
            Close(fh);
        }

        if (SCRIPT_CtrlInterfaceEnabledFlag)
            ESQIFF_GAdsListLineIndex = 1;
        else
            ESQIFF_GAdsListLineIndex = 0;
    }

    if (mode == 0 && DISKIO_Drive0WriteProtectedCode == 0) {
        Forbid();
        ESQIFF_JMPTBL_BRUSH_FreeBrushList(&ESQIFF_LogoBrushListHead, 0L);
        ESQIFF_LogoBrushListCount = 0;
        ESQIFF_LogoListLineIndex = 0;
        Permit();

        if (Global_REF_LONG_DF0_LOGO_LST_DATA && Global_REF_LONG_DF0_LOGO_LST_FILESIZE) {
            ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQIFF_C_5, 963L,
                                                  Global_REF_LONG_DF0_LOGO_LST_DATA,
                                                  Global_REF_LONG_DF0_LOGO_LST_FILESIZE + 1);
            Global_REF_LONG_DF0_LOGO_LST_DATA = 0;
            Global_REF_LONG_DF0_LOGO_LST_FILESIZE = 0;
        }

        fh = ESQIFF_JMPTBL_DOS_OpenFileWithMode(Global_PTR_STR_DF0_LOGO_LST, 1005L);
        if (fh > 0) {
            Global_REF_LONG_DF0_LOGO_LST_FILESIZE =
                ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(fh);
            if (Global_REF_LONG_DF0_LOGO_LST_FILESIZE > 0) {
                Global_REF_LONG_DF0_LOGO_LST_DATA = (char *)
                    ESQIFF_JMPTBL_MEMORY_AllocateMemory(Global_STR_ESQIFF_C_6, 979L,
                                                        Global_REF_LONG_DF0_LOGO_LST_FILESIZE + 1,
                                                        1L);
                if (Read(fh, Global_REF_LONG_DF0_LOGO_LST_DATA,
                         Global_REF_LONG_DF0_LOGO_LST_FILESIZE)
                    == Global_REF_LONG_DF0_LOGO_LST_FILESIZE)
                    ESQIFF_ExternalAssetFlags = ESQIFF_ExternalAssetFlags | 2;
            }
            Close(fh);
        }
    }
}

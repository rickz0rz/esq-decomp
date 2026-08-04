/* RESTORES: _LADFUNC_SaveTextAdsToFile
 * MODULE:   modules/groups/a/w/ladfunc_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-cursor
 *   ref:     4e55ffdc48e70f004878000148780002610011fa504f1b40ffe74ab9000005e4660670006000016c42b9000005e4422dfff1487803ee4879000069444eba23ba504f23c00000b3c84a80660e700123c0000005e470ff6000013a7c00702ebc406c00011e200648c0e58041f900009fc4d1c02b50fffc206dfffc301048c02f002f390000b3c84eba2346206dfffc3028000248c02e802f390000b3c84eba23304fef000c206dfffc4aa80006660a43edfff12b49fff86008206800062b48fff8206dfff84a1866fc538891edfff82e0878002a04ba876c00008abe846714226dfffc2069000ad1c41010122dffe7b001676a4a846f547000102dffe72f00487800034879000069c2486dffdd4eba11b841edffdd22484a1966fc538993c82e892f082f390000b3c84eba22aa206dfff8d1c5200490852e802f082f390000b3c84eba22924fef00202a04ba876c0e226dfffc2069000ad1c41b50ffe752846000ff74487800014879000069ca2f390000b3c84eba22604fef000c52466000fede2f390000b3c84eba2252700123c0000005e44ced00f0ffcc4e5d4e75
 *   got:     9efc002448e70f14487800014878000261000000504f2e002039000000006700014e42b900000000422f0018487803ee4879000000006100000023c000000000504f660e700123c00000000070ff6000011e7c00702ebc806c0000fe2006e58041f900000000d1c02a50301548c02f002f390000000061000000302d000248c02e802f3900000000610000004fef000c202d000467042640600447ef0018204b4a1866fc538891cb7a0028052f480038202f0038b8806c000082b0856714206d0008d1c51010488048c072001207b08167624a856f4e700010072f0048780003487900000000486f002e6100000041ef003222484a1966fc538993c82e892f082f390000000061000000204bd1c4200590842e802f082f3900000000610000004fef00202805b8af00386c08206d0008d1c51e1052856000ff78487800014879000000002f3900000000610000004fef000c52866000fefe2f390000000061000000700123c000000000584f70014cdf28f0defc00244e75
 *   summary: 376 got vs 412 ref, 36 bytes short. The original keeps the entry pointer and the text pointer in A5 frame slots and reloads each before every field read -- eight sites; 6.51 holds them in address registers across the segment loop. The packed-pen seed, the ready-flag handshake with its two failure returns, the 46-entry loop, both decimal fields, the empty-string substitute when an entry has no text, the run-length segmentation that emits an escape prefix only after the first character, and the per-entry line break match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

struct LadEntry {
    short  flags0;              /* +0 */
    short  flags2;              /* +2 */
    char  *text;                /* +6 */
    char  *attr;                /* +10 */
};

extern struct LadEntry *LADFUNC_EntryPtrTable[];
extern long LADFUNC_SaveAdsFileHandle;
extern long DISKIO_SaveOperationReadyFlag;
extern char KYBD_PATH_DF0_LOCAL_ADS[];
extern char LADFUNC_FMT_AttrEscapePrefixCharHex[];
extern char LADFUNC_TextAdLineBreakBuffer[];

extern long LADFUNC_ComposePackedPenByte(long hi, long lo);
extern long DISKIO_OpenFileWithBuffer(char *path, long mode);
extern void DISKIO_WriteDecimalField(long fh, long value);
extern void DISKIO_WriteBufferedBytes(long fh, char *buf, long n);
extern void DISKIO_CloseBufferedFileAndFlush(long fh);
extern void WDISP_SPrintf(char *buf, char *fmt, long width,
                                          long value);

long LADFUNC_SaveTextAdsToFile(void)
{
    char  escape[22];
    char  empty[10];
    unsigned char pen;
    struct LadEntry *entry;
    char *text;
    long  row;
    long  pos;
    long  seg;
    long  len;

    pen = LADFUNC_ComposePackedPenByte(2, 1);

    if (DISKIO_SaveOperationReadyFlag == 0)
        return 0;
    DISKIO_SaveOperationReadyFlag = 0;
    empty[0] = 0;

    LADFUNC_SaveAdsFileHandle = DISKIO_OpenFileWithBuffer(
        KYBD_PATH_DF0_LOCAL_ADS, 1006);
    if (LADFUNC_SaveAdsFileHandle == 0) {
        DISKIO_SaveOperationReadyFlag = 1;
        return -1;
    }

    row = 0;
    while (row < 46) {
        entry = LADFUNC_EntryPtrTable[row];

        DISKIO_WriteDecimalField(LADFUNC_SaveAdsFileHandle,
                                                 (long)entry->flags0);
        DISKIO_WriteDecimalField(LADFUNC_SaveAdsFileHandle,
                                                 (long)entry->flags2);

        if (entry->text != 0)
            text = entry->text;
        else
            text = empty;

        len = strlen(text);
        pos = 0;
        seg = pos;

        while (seg < len) {
            if (len == pos || entry->attr[pos] != pen) {
                if (pos > 0) {
                    WDISP_SPrintf(escape,
                        LADFUNC_FMT_AttrEscapePrefixCharHex, 3, (long)pen);
                    DISKIO_WriteBufferedBytes(
                        LADFUNC_SaveAdsFileHandle, escape, strlen(escape));
                    DISKIO_WriteBufferedBytes(
                        LADFUNC_SaveAdsFileHandle, text + seg, pos - seg);
                }
                seg = pos;
                if (seg < len)
                    pen = entry->attr[pos];
            }
            pos++;
        }

        DISKIO_WriteBufferedBytes(LADFUNC_SaveAdsFileHandle,
            LADFUNC_TextAdLineBreakBuffer, 1);
        row++;
    }

    DISKIO_CloseBufferedFileAndFlush(LADFUNC_SaveAdsFileHandle);
    DISKIO_SaveOperationReadyFlag = 1;
    return 1;
}

/* RESTORES: _ESQPARS_RemoveGroupEntryAndReleaseStrings
 * MODULE:   modules/groups/a/o/esqpars.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a7-frame-and-table-base
 *   ref:     4e55fff048e707203e2d000a4eba1a82200748c02f006100f2c6584f7002be40661c3039000087b82a005345700033c0000087b8720013c1000087b760163039000087bc2a0053454279000087bc423900009afb4a456b00010e7002be40662e200548c0e58041f900008c782248d3c02b51fffcd1c093c9208941f9000095e82448d5c02b52fff8d1c02089602c200548c0e58041f9000087c02248d3c02b51fffcd1c093c9208941f9000091302448d5c02b52fff8d1c020897c004aadfff867547031bc406c4e200648c0e580206dfff8207008382b48fff4200867344a1866fc538891edfff4200852802f002f2dfff448780401487900005cc64ebaf01a4fef0010200648c0e580206dfff842b00838524660a64aadfff8671a487801f42f2dfff848780407487900005cd04ebaefe84fef00102f2dfffc4eba1984584f4aadfffc671a487800342f2dfffc48780410487900005cda4ebaefbe4fef001053456000fef0
 *   got:     48e707343e2f001e61000000300748c02f0061000000584f2007554066183039000000003c00534642790000000042390000000060163039000000003c0053464279000000004239000000004a466b0000e820075540662848c62006e58041f9000000002248d3c02a51d1c0429041f9000000002248d3c02651d1c04290602648c62006e58041f9000000002248d3c02a51d1c0429041f9000000002248d3c02651d1c042907a00200b67467031ba406c4048c52005e58024730838200a672e204a4a1866fc538891ca200852802f002f0a48780401487900000000610000004fef001048c52005e58042b30838524560b6200b6718487801f42f0b48780407487900000000610000004fef00102f0d61000000584f200d6718487800342f0d48780410487900000000610000004fef001053466000ff164cdf2ce04e754e71
 *   summary: 320 got vs 358 ref, 38 bytes short. The original rebuilds LEA table,A0 / MOVEA.L A0,A1 / ADDA.L D0,A1 for each of the four table slots on both arms -- eight bytes a site where 6.51 emits a single indexed store. Both group arms, the count and present-flag clears, the 49-slot title release with its inlined strlen and its per-slot NUL, the two record deallocations with their distinct line numbers and the free-resources call all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

struct TitleRec {
    char  pad0[56];
    char *slots[49];            /* +56 */
};

extern unsigned short TEXTDISP_SecondaryGroupEntryCount;
extern unsigned short TEXTDISP_PrimaryGroupEntryCount;
extern char  TEXTDISP_SecondaryGroupPresentFlag;
extern char  TEXTDISP_PrimaryGroupPresentFlag;
extern char *TEXTDISP_SecondaryEntryPtrTable[];
extern char *TEXTDISP_PrimaryEntryPtrTable[];
extern struct TitleRec *TEXTDISP_SecondaryTitlePtrTable[];
extern struct TitleRec *TEXTDISP_PrimaryTitlePtrTable[];
extern char  Global_STR_ESQPARS_C_2[];
extern char  Global_STR_ESQPARS_C_3[];
extern char  Global_STR_ESQPARS_C_4[];

extern void ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine(void);
extern void ESQIFF2_ClearLineHeadTailByMode(long mode);
extern void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                  void *ptr, long size);
extern void ESQPARS_JMPTBL_COI_FreeEntryResources(char *entry);

void ESQPARS_RemoveGroupEntryAndReleaseStrings(short mode)
{
    char            *entry;
    struct TitleRec *title;
    char            *str;
    short            i;
    short            j;

    ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine();
    ESQIFF2_ClearLineHeadTailByMode((long)mode);

    if (mode == 2) {
        i = TEXTDISP_SecondaryGroupEntryCount - 1;
        TEXTDISP_SecondaryGroupEntryCount = 0;
        TEXTDISP_SecondaryGroupPresentFlag = 0;
    } else {
        i = TEXTDISP_PrimaryGroupEntryCount - 1;
        TEXTDISP_PrimaryGroupEntryCount = 0;
        TEXTDISP_PrimaryGroupPresentFlag = 0;
    }

    while (i >= 0) {
        if (mode == 2) {
            entry = TEXTDISP_SecondaryEntryPtrTable[i];
            TEXTDISP_SecondaryEntryPtrTable[i] = 0;
            title = TEXTDISP_SecondaryTitlePtrTable[i];
            TEXTDISP_SecondaryTitlePtrTable[i] = 0;
        } else {
            entry = TEXTDISP_PrimaryEntryPtrTable[i];
            TEXTDISP_PrimaryEntryPtrTable[i] = 0;
            title = TEXTDISP_PrimaryTitlePtrTable[i];
            TEXTDISP_PrimaryTitlePtrTable[i] = 0;
        }

        j = 0;
        while (title != 0 && j < 49) {
            str = title->slots[j];
            if (str != 0) {
                ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQPARS_C_2,
                    1025, str, (long)strlen(str) + 1);
                title->slots[j] = 0;
            }
            j++;
        }

        if (title != 0)
            ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQPARS_C_3, 1031,
                                                  title, 500);
        ESQPARS_JMPTBL_COI_FreeEntryResources(entry);
        if (entry != 0)
            ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQPARS_C_4, 1040,
                                                  entry, 52);
        i--;
    }
}

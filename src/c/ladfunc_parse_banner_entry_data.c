/* RESTORES: LADFUNC_ParseBannerEntryData
 * MODULE:   modules/groups/a/w/ladfunc_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55fe6048e70f301e2d000b266d000c487800014878000261001472504f1a1b720012051b40fe637049d080b280663c704cbe0067067074be00662a30390000a3ba5340662010390000061b488048c02f004879000069924ebadd3a504f4a8067046100fc1670006000020e704cbe0067067074be00665610390000061b488048c02f004879000069964ebadd08504f4a80671c702eba00641630390000a3522200524133c10000a352702eb2406d067000600001c4530570001005220048c1e58141f900009fc4d1c1245060067000600001a634bc0001357c003000027c002f3c00010001487801304878016f48790000699a4eba38a84fef00102b40fe6467000170181b4a04670000d60c4601906c0000ce7003b800666a101b488048c02f006100fe78584f28007000b800651e7007b8006218700010047200122dfe632f012f006100136a504f1b40fe63101b488048c02f006100fe44584f28007000b80065a07007b800629a7000102dfe63720012042f012f006100135a504f1b40fe6360807014b800663c7000101b34807200121b354100023012488048c02f004eba85b4120048813481302a0002488048c02e804eba85a0584f12004881354100026000ff40206dfe6411adfe6360002006524641edfe69d0c010846000ff2641edfe692248d2c642112f2a00062f084eba940c504f254000064aaa000a671a487801302f2a000a4878019c4879000069a44eba37724fef0010200648c02f3c000100012f004878019d4879000069ae4eba376c4fef00102540000a4a806712220648c1206dfe642240600212d8538164fa487801302f2dfe64487801a04879000069b84eba37206100f8184fef001060047000600270014cdf0cf04e5d4e75
 *   got:     9efc019c48e72f341e2f01c32a6f01c4487800014878000261000000504f2c001a1d700010057249d281b081663c704cbe0067067074be00662a30390000000053406620103900000000488048c02f0048790000000061000000504f4a80670461000000700060000208704cbe00670c7074be0067067000600001f6103900000000488048c02f0048790000000061000000504f4a80670001d8702eba0065067000600001cc3039000000003200524133c100000000702eb2406d067000600001b053057000100548c02200e58141f900000000d1c1245034bc0001357c0030000278002f3c00010001487801304878016f4879000000006100000026404a804fef00106606700060000166101d488048c048ef000101b8670000d00c4401906c0000c857006668101d488048c02f0061000000584f2f4001b87200b001651a7207b001621472001200700010062f002f0161000000504f2c00101d488048c02f0061000000584f2f4001b87200b001659a7207b001629472001206740014002f022f0161000000504f2c006000ff7e202f01b87214b001663c101d720012003481101d7400140035420002301248c02f0061000000120048813481302a000248c02e8061000000584f12004881354100026000ff38100617804000222f01b81f81402152446000ff24423740212f2a0004486f00256100000025400004504f202a00086718487801302f004878019c487900000000610000004fef0010300448c02f3c000100012f004878019d48790000000061000000254000084fef00106710320448c1204b2240600212d8538164fa487801302f0b487801a048790000000061000000610000004fef001070014cdf2cf4defc019c4e754e71
 *   summary: 636 got vs 640 ref, four bytes short -- one of the closest large restorations in the tree. The original keeps the running pen byte and the scratch attribute pointer at negative A5 displacements and reloads each before use; 6.51 addresses the same two from A7 and folds one reload. The 146 reset opcode with its two accepted kinds, the allowed-set gate, the 46-entry bound checked twice, the one-based entry index, the escape sequence that folds a high and a low nibble into the pen with its 0..7 range guard, the 20-opcode that rewrites both header fields through the numeric validator, the 400-character cap, the owned-string replace and the reallocate-and-copy of the attribute run all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

struct LadEntry {
    short  flags0;
    short  flags2;
    char  *text;                /* +6 */
    char  *attr;                /* +10 */
};

extern struct LadEntry *LADFUNC_EntryPtrTable[];
extern short LADFUNC_ParsedEntryCount;
extern short ESQIFF_StatusPacketReadyFlag;
extern char  ED_DiagTextModeChar;
extern char  LADFUNC_TAG_RS_ResetTriggerSet[];
extern char  LADFUNC_TAG_RS_ParseAllowedSet[];
extern char  Global_STR_LADFUNC_C_5[];
extern char  Global_STR_LADFUNC_C_6[];
extern char  Global_STR_LADFUNC_C_7[];
extern char  Global_STR_LADFUNC_C_8[];

extern long  LADFUNC_ComposePackedPenByte(long hi, long lo);
extern char *STR_FindCharPtr(char *s, long c);
extern void  LADFUNC_ResetEntryTextBuffers(void);
extern char *MEMORY_AllocateMemory(char *who, long line,
                                                  long size, long flags);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                    char *ptr, long size);
extern long  LADFUNC_ParseHexDigit(long c);
extern long  LADFUNC_SetPackedPenHighNibble(long nibble, long pen);
extern long  LADFUNC_SetPackedPenLowNibble(long pen, long nibble);
extern char  ESQIFF2_ValidateAsciiNumericByte(long value);
extern char *ESQPARS_ReplaceOwnedString(char *src, char *owned);
extern void  LADFUNC_UpdateHighlightState(void);

long LADFUNC_ParseBannerEntryData(char kind, char *data)
{
    char  text[407];
    unsigned char pen;
    char *attrs;
    struct LadEntry *entry;
    unsigned char index;
    short pos;
    long  c;

    pen = LADFUNC_ComposePackedPenByte(2, 1);
    index = *data++;

    if ((long)index == 146) {
        if (kind == 76 || kind == 116) {
            if (ESQIFF_StatusPacketReadyFlag == 1
                && STR_FindCharPtr(
                       LADFUNC_TAG_RS_ResetTriggerSet,
                       (long)ED_DiagTextModeChar) != 0)
                LADFUNC_ResetEntryTextBuffers();
        }
        return 0;
    }

    if (kind != 76 && kind != 116)
        return 0;

    if (STR_FindCharPtr(LADFUNC_TAG_RS_ParseAllowedSet,
            (long)ED_DiagTextModeChar) == 0)
        return 0;
    if (index >= 46)
        return 0;

    LADFUNC_ParsedEntryCount = LADFUNC_ParsedEntryCount + 1;
    if (LADFUNC_ParsedEntryCount >= 46)
        return 0;

    index--;
    entry = LADFUNC_EntryPtrTable[index];

    entry->flags0 = 1;
    entry->flags2 = 0x30;
    pos = 0;

    attrs = MEMORY_AllocateMemory(Global_STR_LADFUNC_C_5, 367,
                304, MEMF_PUBLIC + MEMF_CLEAR);
    if (attrs == 0)
        return 0;

    for (;;) {
        c = *data++;
        if (c == 0)
            break;
        if (pos >= 400)
            break;

        if ((char)c == 3) {
            c = LADFUNC_ParseHexDigit((long)*data++);
            if ((unsigned char)c >= 0 && (unsigned char)c <= 7)
                pen = LADFUNC_SetPackedPenHighNibble((long)(unsigned char)c,
                                                     (long)pen);
            c = LADFUNC_ParseHexDigit((long)*data++);
            if ((unsigned char)c >= 0 && (unsigned char)c <= 7)
                pen = LADFUNC_SetPackedPenLowNibble((long)pen,
                                                    (long)(unsigned char)c);
        } else if ((char)c == 20) {
            entry->flags0 = (unsigned char)*data++;
            entry->flags2 = (unsigned char)*data++;
            entry->flags0 = ESQIFF2_ValidateAsciiNumericByte((long)entry->flags0);
            entry->flags2 = ESQIFF2_ValidateAsciiNumericByte((long)entry->flags2);
        } else {
            attrs[pos] = pen;
            text[pos] = c;
            pos++;
        }
    }

    text[pos] = 0;
    entry->text = ESQPARS_ReplaceOwnedString(text, entry->text);

    if (entry->attr != 0)
        MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_6, 412,
                                               entry->attr, 304);

    entry->attr = MEMORY_AllocateMemory(Global_STR_LADFUNC_C_7,
                      413, (long)pos, MEMF_PUBLIC + MEMF_CLEAR);
    if (entry->attr != 0)
        memcpy(entry->attr, attrs, (long)pos);

    MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_8, 416, attrs,
                                           304);
    LADFUNC_UpdateHighlightState();
    return 1;
}

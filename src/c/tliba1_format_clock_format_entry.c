/* RESTORES: TLIBA1_FormatClockFormatEntry
 * MODULE:   modules/groups/b/a/tliba1_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55fde048e72730266d0008246d000c3e2d002241f90000776d43edfdec303c01ff12d851c8fffc200a67087000102a00026002704141f900007c11d1c0081000016714200a67087000102a00026002704172209081600e200a67087000102a0002600270412c002006040000412a0052054a4766247000ba00651e7202ba01641872001205240148c2e58241f9000076f6d1c22b50fffc60082b79000076f6fffc4aad001c6706206d001c600641f9000077702b48ffec4aad00106706206d0010600641f9000077722b48fff04aad00186706206d0018600641f9000077742b48fff44aad00146706206d0014600641f9000077762b48fff8421342adfde6202dfde67204b0816c72e580207508ec4a1866fc538891f508ec2b48fde26f5620080c80000002006c4c204b4a1866fc538891cb2208d0810c80000002006c36422dfdec7000206dfffc222dfde610301800e5812f3518ec2f00487900007778486dfdec4eba3922486dfdec2f0b4eba36684fef001852adfde660844cdf0ce44e5d4e75
 *   got:     9efc021848e727343e2f0252246f0240266f023c2a6f0238303c01ff41f90000000043ef003412d851c8fffc200b670a102b00021f40001f600670411f40001f7200120041f900000000d0c1081000016718200b670c70e0d02b00021f40001f601c1f7c0021001f6014200b670a102b00021f40001f600670411f40001f70c0d02f001f1f40001e4a4766247200b001651e7402b00264187400140048c22002e58041f900000000d1c02f50002060082f79000000000020202f024c67062f40002460082f7c000000000024200a67062f4a002860082f7c000000000028202f024867062f40002c60082f7c00000000002c202f024467062f40003060082f7c00000000003042157c007004bc806c722206e5812077182420084a1866fc538891c02a084a856f560c85000002006c4e204d4a1866fc538891cd20082205d2800c81000002006c36422f0034206f002010306800720012002006e5802f3708242f01487900000000486f004061000000486f00442f0d610000004fef0018528660884cdf2ce4defc02184e75
 *   summary: 396 got vs 388 ref, eight bytes over. The reference was 524 bytes until an unlabelled debug-dump block after the RTS was given the label TLIBA1_DumpFormatStruct; that is byte-neutral and both gates stay green. 6.51 keeps the field array at A7 displacements where the original uses A5, which costs two bytes at four of the eight indexed accesses. The 512-byte fallback copy inlines to the original's MOVE.B/DBF loop, the lowercase fold on the kind character, the mode-0 slot window of 0 to 1 with its dead lower bound, all four null-means-default field selections, and the length guards that keep the accumulated line under 512 all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

extern char *TEXTDISP_FormatEntryFallbackTable[];
extern char  TLIBA1_FormatFallbackBuffer[];
extern char  TLIBA1_FormatFallbackFieldPtr0[];
extern char  TLIBA1_FormatFallbackFieldPtr1[];
extern char  TLIBA1_FormatFallbackFieldPtr2[];
extern char  TLIBA1_FormatFallbackFieldPtr3[];
extern char  TLIBA1_FMT_PCT_C_PCT_S[];
extern unsigned char WDISP_CharClassTable[];

extern void WDISP_SPrintf(char *buf, char *fmt, long c, char *text);
extern void STRING_AppendAtNull(char *dst, char *src);

void TLIBA1_FormatClockFormatEntry(char *out, char *kindRec, char *field1,
                                   char *field3, char *field2, char *field0,
                                   short mode)
{
    char  scratch[512];
    char *fields[4];
    char *table;
    long  i;
    long  len;
    unsigned char kind;
    unsigned char slot;

    memcpy(scratch, TLIBA1_FormatFallbackBuffer, 512);

    if (kindRec != 0)
        kind = kindRec[2];
    else
        kind = 65;

    if (WDISP_CharClassTable[kind] & 2) {
        if (kindRec != 0)
            kind = kindRec[2] - 32;
        else
            kind = 65 - 32;
    } else {
        if (kindRec != 0)
            kind = kindRec[2];
        else
            kind = 65;
    }

    slot = kind - 65 + 1;

    if (mode == 0 && slot >= 0 && slot < 2)
        table = TEXTDISP_FormatEntryFallbackTable[slot];
    else
        table = TEXTDISP_FormatEntryFallbackTable[0];

    if (field0 != 0)
        fields[0] = field0;
    else
        fields[0] = TLIBA1_FormatFallbackFieldPtr0;

    if (field1 != 0)
        fields[1] = field1;
    else
        fields[1] = TLIBA1_FormatFallbackFieldPtr1;

    if (field2 != 0)
        fields[2] = field2;
    else
        fields[2] = TLIBA1_FormatFallbackFieldPtr2;

    if (field3 != 0)
        fields[3] = field3;
    else
        fields[3] = TLIBA1_FormatFallbackFieldPtr3;

    *out = 0;

    i = 0;
    while (i < 4) {
        len = strlen(fields[i]);
        if (len > 0 && len < 512 && len + (long)strlen(out) < 512) {
            scratch[0] = 0;
            WDISP_SPrintf(scratch, TLIBA1_FMT_PCT_C_PCT_S,
                          (long)(unsigned char)table[i], fields[i]);
            STRING_AppendAtNull(out, scratch);
        }
        i++;
    }
}

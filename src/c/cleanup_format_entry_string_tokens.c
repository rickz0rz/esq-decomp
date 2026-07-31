/* RESTORES: _CLEANUP_FormatEntryStringTokens
 * MODULE:   modules/groups/a/e/cleanup4_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-cursor
 *   ref:     4e55ffe048e70132266d0008246d000c4aad00106700020e206d00104a10670002044878003a2f084eba6cee504f2b40ffe64a80670001ee41f9000003a443edffea22d822d832d0421141f9000003b043edfff512d866fc7e007005be806c16703a206d0010b0307800670a1bb0780078f5528760e4423578f52f13486dfff54eba21e4504f268041f9000003b243edfff512d866fc52adffe67e00700abe806c000172206dffe64a3078006700016620070c800000000964000154d040303b00064efb00040010001000100010001000100070007000a2206dffe610307800488048c02f004879000003be4eba6c2a504f4a806738206dffe610307800488048c043f900007c11d3c008110001670e10307800488048c072209081600810307800488048c01b8078f5600000e21bb578ea78f5600000d8206dffe610307800488048c041f900007c11d1c008100007670e206dffe61bb0780078f5600000b01bb578ea78f5600000a6206dffe610307800488048c043f900007c112c49ddc07007c0164a00676e10307801488048c02c49ddc07007c0164a00675a10307800488048c02c49ddc008160001670e10307800488048c072209081600810307800488048c01b8078f5528710307800488048c0d3c008110001670e10307800488048c072209081600810307800488048c01b8078f5601841edfff52248d3c72c475287200e12b508ea1bb578ea78f552876000fe8a2f12486dfff54eba204a504f2480601c2f1342a74eba203c26802e924879000003c44eba202e4fef000c24804cdf4c804e5d4e75
 *   got:     9efc001c48e70136246f003c266f00382a6f0034200a670001d04a12670001ca4878003a2f0a61000000504f2f40002c4a80670001b441f90000000043ef002122d822d832d8422f002b41f90000000043ef001512d866fc7e007005be806c12703ab0327800670a1fb278007815528760e8423778152f15486f0019610000002a80504f41f90000000043ef001512d866fc52af002c7e00700abe806c00013a206f002c4a3078006700012e20070c80000000096400011cd040303b00064efb0004001000100010001000100010006600660090206f002c10307800488048c02f0048790000000061000000504f4a80672e206f002c10307800488043f900000000d2c008110001670c040000201f807815600000be1fb078007815600000b41fb778217815600000aa206f002c10307800488041f900000000d0c00810000767081f8078156000008a1fb77821781560000080206f002c10307800488043f9000000002c49dcc07007c0164a0067541030780148802c49dcc07007c0164a0067421030780048802c49dcc008160001670a040000201f80781560061fb0780078155287103078004880d2c008110001670a040000201f80781560161fb078007815600e1fb77821781552871fb77821781552876000fec22f13486f0019610000002680504f601c2f1542a7610000002a802e934879000000006100000026804fef000c4cdf6c80defc001c4e754e71
 *   summary: 528 got vs 584 ref, 56 bytes short. The original keeps the body cursor in an A5 frame slot and rebuilds MOVEA.L -26(A5),A0 before every one of the twelve character reads inside the dispatch; 6.51 holds it in an address register across each arm. The nine-entry jump table has the same shape -- six entries sharing the boolean arm, two sharing the hex arm, one for the digit pair -- and the pair arm consumes two positions exactly as the original does, with the loop's own increment supplying the second. The colon split, the ten-byte defaults copy through a struct assignment, the five-character prefix scan, the lowercase-to-uppercase fold by subtracting 32, and both empty-input replacements match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

struct TokenDefaults { long a; long b; short c; };   /* ten bytes */

extern struct TokenDefaults CLOCK_STR_TOKEN_PAIR_DEFAULTS;
extern char CLEANUP_TokenPairScratch[];
extern char CLOCK_STR_TOKEN_OUTPUT_TEMPLATE[];
extern char CLOCK_STR_BOOL_CHARS_YyNn[];
extern char CLOCK_STR_EMPTY_TOKEN_TEMPLATE[];
extern unsigned char WDISP_CharClassTable[];

extern char *GROUP_AI_JMPTBL_STR_FindCharPtr(char *s, long c);
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(char *src, char *owned);

void CLEANUP_FormatEntryStringTokens(char **first, char **second, char *src)
{
    char  defaults[11];
    char  work[11];
    char *body;
    long  i;

    if (src != 0 && *src != 0
        && (body = GROUP_AI_JMPTBL_STR_FindCharPtr(src, 58)) != 0) {

        *(struct TokenDefaults *)defaults = CLOCK_STR_TOKEN_PAIR_DEFAULTS;
        defaults[10] = 0;
        strcpy(work, CLEANUP_TokenPairScratch);

        i = 0;
        while (i < 5 && src[i] != 58) {
            work[i] = src[i];
            i++;
        }
        work[i] = 0;

        *first = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(work, *first);

        strcpy(work, CLOCK_STR_TOKEN_OUTPUT_TEMPLATE);
        body++;

        i = 0;
        while (i < 10 && body[i] != 0) {
            switch (i) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
                if (GROUP_AI_JMPTBL_STR_FindCharPtr(CLOCK_STR_BOOL_CHARS_YyNn,
                        (long)body[i]) != 0) {
                    if (WDISP_CharClassTable[body[i]] & 2)
                        work[i] = body[i] - 32;
                    else
                        work[i] = body[i];
                } else {
                    work[i] = defaults[i];
                }
                break;

            case 6:
            case 7:
                if (WDISP_CharClassTable[body[i]] & 0x80)
                    work[i] = body[i];
                else
                    work[i] = defaults[i];
                break;

            case 8:
                if ((7 & WDISP_CharClassTable[body[i]]) != 0
                    && (7 & WDISP_CharClassTable[body[i + 1]]) != 0) {
                    if (WDISP_CharClassTable[body[i]] & 2)
                        work[i] = body[i] - 32;
                    else
                        work[i] = body[i];
                    i++;
                    if (WDISP_CharClassTable[body[i]] & 2)
                        work[i] = body[i] - 32;
                    else
                        work[i] = body[i];
                } else {
                    work[i] = defaults[i];
                    i++;
                    work[i] = defaults[i];
                }
                break;

            default:
                break;
            }
            i++;
        }

        *second = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(work, *second);
        return;
    }

    *first = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(0, *first);
    *second = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                  CLOCK_STR_EMPTY_TOKEN_TEMPLATE, *second);
}

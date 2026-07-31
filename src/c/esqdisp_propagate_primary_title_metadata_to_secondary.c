/* RESTORES: _ESQDISP_PropagatePrimaryTitleMetadataToSecondary
 * MODULE:   modules/groups/a/n/esqdispb_p0_p1_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: index-rematerialisation
 *   ref:     4e55ffd848e73f323039000087bc7200b041630001d23039000087b8b041630001c67e0070003039000087b8be806c0001b62007e58041f9000095e8d1c022504aa9003c6600019a41f900008c78d1c0225041e9001c487800012f084eba61fa504f52806600017a78007c0070003039000087bcbc806c0001684a84660001622007e58041f9000095e8d1c022502006e58041f900009130d1c024502f0a2f094eba61aa504f4a00660001307a302006e58041f9000087c0d1c0225008290005001b670470006002702c2b40ffecbaadffec6f0001064a84660001002006e58041f9000087c0d1c0225041e9001c2f052f084eba6164504f5280660000d82006e58041f9000091302248d3c024512205e581d5c14aaa0038670000ba2407e58243f9000095e82449d5c226522448d5c02c52ddc57600162e000700430080174300082449d5c22652d1c02450d5c1d3c220512f28003c2f2a00382f4b003c4eba3b30504f206f00342140003c2007e58041f9000095e82248d3c024512206e58143f9000091302649d7c12c53ddc5156e00fc00fd2448d5c026522449d5c12c52ddc5176e012d012ed1c02450d3c12051d1c51568015e015f41f900008c78d1c0225070001029002822000041008013410028780153856000fef652866000fe8e52876000fe40
 *   got:     594f48e72f34303900000000670001ee303900000000670001e47e007000303900000000be806c0001d42007e58041f900000000d1c02250d2fc003c4a91660001b641f900000000d1c02250d2fc001c487800012f0961000000504f52806600019642af00207c007000303900000000bc806c0001824aaf00206600017a2007e58041f900000000d1c02006e58043f900000000d3c02f112f1061000000504f4a006600014c7a302006e58041f900000000d1c02250d2fc001b08110005670478006002782cba846f0001264aaf00206600011e2006e58041f900000000d1c02250d2fc001c2f052f0961000000504f5280660000f62006e58041f9000000002248d3c02005e5802451d5c043ea00384a91670000d62007e58043f9000000002449d5c02652508b2206e5812448d5c12a52dbc5142d0007488248c20042008016822449d5c02652d6fc003cd1c12205e5812450d5c141ea0038d3c02451d4fc003c2f122f1061000000504f26802007e58041f9000000002248d3c02451d4fc00fd2206e58143f9000000002649d7c12a53dbc514ad00fc2448d5c02652d6fc012e2449d5c12a52dbc516ad012dd1c02450d4fc015fd3c12051d1c514a8015e41f9000000002248d3c02451d4fc0028d1c02250d2fc002810117200120000410080148170012f40002053856000fed852866000fe7452876000fe224cdf2cf4584f4e75
 *   summary: 516 got vs 486 ref. Both streams rebuild the scaled table index before every lookup -- the original does it eleven times -- but 6.51 reloads the table base as well at six of them where the original keeps it in A0 or A1 across a pair of accesses. The two count guards, the already-populated skip, the bit-1 eligibility test, the wildcard match, the descending slot scan whose floor is 0 or 44 depending on entry flag bit 5, the four metadata byte copies at +8, +253, +302 and +351, the owned-string replace and the 0x80 marker on the secondary entry all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned short TEXTDISP_PrimaryGroupEntryCount;
extern unsigned short TEXTDISP_SecondaryGroupEntryCount;
extern char *TEXTDISP_PrimaryEntryPtrTable[];
extern char *TEXTDISP_SecondaryEntryPtrTable[];
extern char *TEXTDISP_PrimaryTitlePtrTable[];
extern char *TEXTDISP_SecondaryTitlePtrTable[];

extern long  ESQSHARED_JMPTBL_ESQ_TestBit1Based(char *bits, long slot);
extern char  ESQSHARED_JMPTBL_ESQ_WildcardMatch(char *pattern, char *text);
extern char *ESQPARS_ReplaceOwnedString(char *src, char *owned);

void ESQDISP_PropagatePrimaryTitleMetadataToSecondary(void)
{
    long sec;
    long pri;
    long slot;
    long floor;
    long done;

    if (TEXTDISP_PrimaryGroupEntryCount == 0)
        return;
    if (TEXTDISP_SecondaryGroupEntryCount == 0)
        return;

    sec = 0;
    while (sec < (long)TEXTDISP_SecondaryGroupEntryCount) {
        if (*(long *)(TEXTDISP_SecondaryTitlePtrTable[sec] + 60) == 0
            && ESQSHARED_JMPTBL_ESQ_TestBit1Based(
                   TEXTDISP_SecondaryEntryPtrTable[sec] + 28, 1) == -1) {
            done = 0;
            pri = 0;
            while (pri < (long)TEXTDISP_PrimaryGroupEntryCount && done == 0) {
                if (ESQSHARED_JMPTBL_ESQ_WildcardMatch(
                        TEXTDISP_SecondaryTitlePtrTable[sec],
                        TEXTDISP_PrimaryTitlePtrTable[pri]) == 0) {
                    slot = 48;
                    if (TEXTDISP_PrimaryEntryPtrTable[pri][27] & 32)
                        floor = 0;
                    else
                        floor = 44;

                    while (slot > floor && done == 0) {
                        if (ESQSHARED_JMPTBL_ESQ_TestBit1Based(
                                TEXTDISP_PrimaryEntryPtrTable[pri] + 28, slot) == -1
                            && *(long *)(TEXTDISP_PrimaryTitlePtrTable[pri]
                                         + slot * 4 + 56) != 0) {

                            TEXTDISP_SecondaryTitlePtrTable[sec][8] =
                                (TEXTDISP_PrimaryTitlePtrTable[pri] + slot)[7] | 0x80;

                            *(char **)(TEXTDISP_SecondaryTitlePtrTable[sec] + 60) =
                                ESQPARS_ReplaceOwnedString(
                                    *(char **)(TEXTDISP_PrimaryTitlePtrTable[pri]
                                               + slot * 4 + 56),
                                    *(char **)(TEXTDISP_SecondaryTitlePtrTable[sec] + 60));

                            TEXTDISP_SecondaryTitlePtrTable[sec][253] =
                                (TEXTDISP_PrimaryTitlePtrTable[pri] + slot)[252];
                            TEXTDISP_SecondaryTitlePtrTable[sec][302] =
                                (TEXTDISP_PrimaryTitlePtrTable[pri] + slot)[301];
                            TEXTDISP_SecondaryTitlePtrTable[sec][351] =
                                (TEXTDISP_PrimaryTitlePtrTable[pri] + slot)[350];

                            TEXTDISP_SecondaryEntryPtrTable[sec][40] =
                                (unsigned char)TEXTDISP_SecondaryEntryPtrTable[sec][40]
                                | 0x80;
                            done = 1;
                        }
                        slot--;
                    }
                }
                pri++;
            }
        }
        sec++;
    }
}

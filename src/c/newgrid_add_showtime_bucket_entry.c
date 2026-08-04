/* RESTORES: _NEWGRID_AddShowtimeBucketEntry
 * MODULE:   modules/groups/b/a/newgrid1bb.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: reserved-a5-frame-and-arg-block-reuse
 *   ref:     4e55ffe448e70f10266d00082e2d000c42adffec4878003a2f0b4eba3932204043e800012e892b49fffc4eba59a8504f2c002007e180dc8020390000b4d4720ab0816c0000b8e78041f90000b45c2248d3c022862248d3c0d1c02f2800042f0b2f4900204eba396c504f206f0018214000042a390000b4d44a856f162005e58041f90000b4a8d1c02250bc916c04538560e64a8567122005e58041f90000b4a8d1c02250bc91675428390000b4d4b8856f1e2004e58041f90000b4acd1c02004e58043f90000b4a8d3c02091538460de2005e58041f90000b4acd1c020390000b4d42200e78143f90000b45cd3c1208952b90000b4d470012b40ffec202dffec4cdf08f04e5d4e75
 *   got:     9efc000c48e70f142e2f002c2a6f002842af00204878003a2f0d61000000204047e800014878003a2f0b610000004fef00102207e181d0812c00203900000000720ab0816d08202f0020600000c22039000000002200e78141f9000000002248d3c122862248d3c1d1c12f2800042f0d2f49002461000000504f206f001c214000042a39000000004a856f162005e58041f9fffffffcd1c02250bc916c04538560e64a8567182005e58041f9fffffffcd1c02250bc916606202f00206050283900000000b8856f1e2004e58041f900000000d1c02004e58043f9fffffffcd3c02091538460de2005e58041f900000000d1c02039000000002200e78143f900000000d3c1208952b90000000070014cdf28f0defc000c4e75
 *   summary: 280 got vs 264 ref, two attributable regions. The original reuses one pushed argument block for both parse calls -- MOVE.L A1,(A7) overwrites the first argument in place and the shared 58 stays put -- where 6.51 pushes a fresh pair, +6. The rest is the frame register: LINK.W A5,#-28 against SUBA.W #12,A7, with the result flag held in a frame slot either way. The insertion scan reads NEWGRID_ShowtimeBucketPtrTable[slot-1] and 6.51 folds the -1 into the symbol exactly as the original does, which is why the original has a separate PadLong label at the same address minus four.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct ShowtimeBucket {
    long  key;
    char *text;
};

extern struct ShowtimeBucket  NEWGRID_ShowtimeBucketEntryTable[];
extern struct ShowtimeBucket *NEWGRID_ShowtimeBucketPtrTable[];
extern long                   NEWGRID_ShowtimeBucketCount;

extern char *STR_FindCharPtr(char *s, long c);
extern long  PARSE_ReadSignedLongSkipClass3_Alt(char *s, long c);
extern char *ESQPARS_ReplaceOwnedString(char *src, char *owned);

long NEWGRID_AddShowtimeBucketEntry(char *text, long hour)
{
    char *value;
    long  key;
    long  slot;
    long  i;
    long  result;

    result = 0;
    value = STR_FindCharPtr(text, 58) + 1;
    key = PARSE_ReadSignedLongSkipClass3_Alt(value, 58)
          + (hour << 8);

    if (NEWGRID_ShowtimeBucketCount >= 10)
        return result;

    NEWGRID_ShowtimeBucketEntryTable[NEWGRID_ShowtimeBucketCount].key = key;
    NEWGRID_ShowtimeBucketEntryTable[NEWGRID_ShowtimeBucketCount].text =
        ESQPARS_ReplaceOwnedString(text,
            NEWGRID_ShowtimeBucketEntryTable[NEWGRID_ShowtimeBucketCount].text);

    slot = NEWGRID_ShowtimeBucketCount;
    while (slot > 0 && key < NEWGRID_ShowtimeBucketPtrTable[slot - 1]->key)
        slot--;

    if (slot != 0 && key == NEWGRID_ShowtimeBucketPtrTable[slot - 1]->key)
        return result;

    for (i = NEWGRID_ShowtimeBucketCount; i > slot; i--)
        NEWGRID_ShowtimeBucketPtrTable[i] = NEWGRID_ShowtimeBucketPtrTable[i - 1];

    NEWGRID_ShowtimeBucketPtrTable[slot] =
        &NEWGRID_ShowtimeBucketEntryTable[NEWGRID_ShowtimeBucketCount];
    NEWGRID_ShowtimeBucketCount++;
    result = 1;
    return result;
}

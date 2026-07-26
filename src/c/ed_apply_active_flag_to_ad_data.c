/* RESTORES: ED_ApplyActiveFlagToAdData
 * MODULE:   modules/groups/a/l/ed3b.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     48e720204ab900008188662620390000860a2200e58141f900009fc02248d3c12451740034822248d3c1245135420002602220390000860ae58041f900009fc02248d3c0245134bc0001d1c02250337c003000024cdf04044e75
 *   got:     48e701202e39000000004ab90000000067222007e58041f9000000002248d3c0245134bc00012248d3c02451357c00300002601a2007e58041f9000000002248d3c024514252d1c02250426900024cdf04804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct EdAdRecord { short active; short pen; };
extern struct EdAdRecord *ED_AdRecordPtrTable[];
extern long ED_AdActiveFlag;
extern long Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;

void ED_ApplyActiveFlagToAdData(void)
{
    long n = Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;

    if (ED_AdActiveFlag != 0) {
        ED_AdRecordPtrTable[n]->active = 1;
        ED_AdRecordPtrTable[n]->pen = 0x30;
    } else {
        ED_AdRecordPtrTable[n]->active = 0;
        ED_AdRecordPtrTable[n]->pen = 0;
    }
}

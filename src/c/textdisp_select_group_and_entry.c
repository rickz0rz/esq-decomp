/* RESTORES: _TEXTDISP_SelectGroupAndEntry
 * MODULE:   modules/groups/b/a/textdisp3_p1_p4.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-and-tail-order
 *   ref:     48e70730266f0018246f001c3e2f002270ff33c00000c74c33c00000c74e42790000cc6433fc0001000076e8200748c02f002f0b610000de504f2c004a466728200648c0220748c12f0b2f012f002f0a610002544fef00102a00700010390000cc6833c00000c74c4a4667044a45664e303900009b027200b041634233c1000076e8200748c02f002f0b61000088504f2c004a466728200648c0220748c12f0b2f012f002f0a610001fe4fef00102a00700010390000cc6833c00000c74e4a4667044a45660c700133c0000076e87000603c7002ba40662610390000cd9b7264b001660a700010390000cd966008700010390000cd9a33c00000c758600e700010390000cc6833c00000c75870014cdf0ce04e75
 *   got:     48e707143e2f0022266f001c2a6f001870ff33c00000000033c00000000042790000000033fc000100000000300748c02f002f0d610000002c00504f4a466728300648c0320748c12f0d2f012f002f0b610000002a004fef0010700010390000000033c0000000004a4667044a45664e3039000000007200b041634233c100000000300748c02f002f0d610000002c00504f4a466728300648c0320748c12f0d2f012f002f0b610000002a004fef0010700010390000000033c0000000004a4667044a45660c33fc0001000000007000604220055540662c1039000000007264b0016610700010390000000033c000000000601e700010390000000033c000000000600e700010390000000033c00000000070014cdf28e04e754e71
 *   summary: 284 got vs 276 ref, first divergence at byte 3 -- the two pointer arguments land in different address registers. Two real regions: 6.51 writes TEXTDISP_ActiveGroupId with an immediate MOVE.W #1 on the no-match path where the original loads MOVEQ #1 first, and it tests best==2 with SUBQ.W #2 against the original's MOVEQ #2 / CMP.W, which also reorders the two banner-index arms. Both BuildMatchIndexList calls, both SelectBestMatchFromList calls with their four arguments, the -1 pair initialisation and the secondary-group retry gate all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short TEXTDISP_PrimaryFirstMatchIndex;
extern short TEXTDISP_SecondaryFirstMatchIndex;
extern short TEXTDISP_SbeFilterActiveFlag;
extern short TEXTDISP_ActiveGroupId;
extern short TEXTDISP_CurrentMatchIndex;
extern unsigned short TEXTDISP_SecondaryGroupRecordLength;
extern unsigned char  TEXTDISP_CandidateIndexList[];
extern unsigned char  TEXTDISP_BannerFallbackEntryIndex[];
extern unsigned char  TEXTDISP_BannerSelectedEntryIndex[];
extern unsigned char  TEXTDISP_BannerCharSelected;

extern short TEXTDISP_BuildMatchIndexList(char *source, long mode);
extern short TEXTDISP_SelectBestMatchFromList(char *out, long count, long mode,
                                              char *source);

long TEXTDISP_SelectGroupAndEntry(char *source, char *out, short mode)
{
    short count;
    short best;

    TEXTDISP_PrimaryFirstMatchIndex = TEXTDISP_SecondaryFirstMatchIndex = -1;
    TEXTDISP_SbeFilterActiveFlag = 0;
    TEXTDISP_ActiveGroupId = 1;

    count = TEXTDISP_BuildMatchIndexList(source, (long)mode);
    if (count != 0) {
        best = TEXTDISP_SelectBestMatchFromList(out, (long)count, (long)mode,
                                                source);
        TEXTDISP_PrimaryFirstMatchIndex = TEXTDISP_CandidateIndexList[0];
    }

    if ((count == 0 || best == 0) && TEXTDISP_SecondaryGroupRecordLength > 0) {
        TEXTDISP_ActiveGroupId = 0;
        count = TEXTDISP_BuildMatchIndexList(source, (long)mode);
        if (count != 0) {
            best = TEXTDISP_SelectBestMatchFromList(out, (long)count, (long)mode,
                                                    source);
            TEXTDISP_SecondaryFirstMatchIndex = TEXTDISP_CandidateIndexList[0];
        }
    }

    if (count == 0 || best == 0) {
        TEXTDISP_ActiveGroupId = 1;
        return 0;
    }

    if (best == 2) {
        if (TEXTDISP_BannerCharSelected == 100)
            TEXTDISP_CurrentMatchIndex = TEXTDISP_BannerFallbackEntryIndex[0];
        else
            TEXTDISP_CurrentMatchIndex = TEXTDISP_BannerSelectedEntryIndex[0];
    } else {
        TEXTDISP_CurrentMatchIndex = TEXTDISP_CandidateIndexList[0];
    }
    return 1;
}

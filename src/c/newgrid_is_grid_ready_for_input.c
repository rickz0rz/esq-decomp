/* RESTORES: NEWGRID_IsGridReadyForInput
 * MODULE:   modules/groups/b/a/newgrid.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     48e703002e2f000c7001be8066144a39000087b767243039000087b87200b04163184a3900009afb67103039000087bc7200b04163047000600270012c0020064cdf00c04e75
 *   got:     48e733002e2f00147001be80662e1239000000004a0167243239000000007400b24263181239000000004a01670e363900000000b64263047c00602222075381671a1239000000004a0167103239000000007400b24263047c0060022c0020064cdf00cc4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned char TEXTDISP_SecondaryGroupPresentFlag;
extern unsigned char TEXTDISP_PrimaryGroupPresentFlag;
extern short TEXTDISP_SecondaryGroupEntryCount;
extern short TEXTDISP_PrimaryGroupEntryCount;

long NEWGRID_IsGridReadyForInput(long which)
{
    long ready;

    if (which == 1
        && TEXTDISP_SecondaryGroupPresentFlag != 0
        && (unsigned short)TEXTDISP_SecondaryGroupEntryCount > 0
        && TEXTDISP_PrimaryGroupPresentFlag != 0
        && (unsigned short)TEXTDISP_PrimaryGroupEntryCount > 0)
        ready = 0;
    else if (which != 1
        && TEXTDISP_PrimaryGroupPresentFlag != 0
        && (unsigned short)TEXTDISP_PrimaryGroupEntryCount > 0)
        ready = 0;
    else
        ready = 1;
    return ready;
}

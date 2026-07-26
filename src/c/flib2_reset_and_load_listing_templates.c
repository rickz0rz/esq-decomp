/* RESTORES: FLIB2_ResetAndLoadListingTemplates
 * MODULE:   modules/groups/a/s/flib2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: global-store-order
 *   ref:     91c823c80000a9dc23c80000aa0c23c80000aa1023c80000aa4023c80000aa446100fe546100fea46100ff386100000c6100031e610009384e75
 *   got:     42b90000000042b90000000042b90000000042b900000000610000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void *GCOMMAND_DigitalNicheListingsTemplatePtr;
extern void *GCOMMAND_MplexListingsTemplatePtr;
extern void *GCOMMAND_MplexAtTemplatePtr;
extern void *GCOMMAND_PPVListingsTemplatePtr;
extern void  FLIB2_LoadListingTemplates(void);
void FLIB2_ResetAndLoadListingTemplates(void)
{
    GCOMMAND_DigitalNicheListingsTemplatePtr = 0;
    GCOMMAND_MplexListingsTemplatePtr = 0;
    GCOMMAND_MplexAtTemplatePtr = 0;
    GCOMMAND_PPVListingsTemplatePtr = 0;
    FLIB2_LoadListingTemplates();
}

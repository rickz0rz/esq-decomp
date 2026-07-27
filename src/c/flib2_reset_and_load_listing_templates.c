/* RESTORES: FLIB2_ResetAndLoadListingTemplates
 * MODULE:   modules/groups/a/s/flib2.s
 * STATUS:   behavioural
 *
 * CORRECTED 2026-07-27. This restoration was wrong, and the whole-program link
 * is what found it -- it called FLIB2_LoadListingTemplates(), a function that
 * does not exist anywhere in the program, and zeroed four template pointers where
 * the original zeroes five. Byte comparison alone had not caught it because the
 * file was filed as behavioural and nobody had ever tried to resolve the symbol.
 *
 * The original zeroes all five pointers from one register and then calls SIX
 * loaders in order: the three FLIB2 defaults and the three GCOMMAND templates.
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
extern void *GCOMMAND_PPVPeriodTemplatePtr;

extern void FLIB2_LoadDigitalNicheDefaults(void);
extern void FLIB2_LoadDigitalMplexDefaults(void);
extern void FLIB2_LoadDigitalPpvDefaults(void);
extern void GCOMMAND_LoadDefaultTable(void);
extern void GCOMMAND_LoadMplexTemplate(void);
extern void GCOMMAND_LoadPPV3Template(void);

void FLIB2_ResetAndLoadListingTemplates(void)
{
    GCOMMAND_PPVPeriodTemplatePtr = GCOMMAND_PPVListingsTemplatePtr =
        GCOMMAND_MplexAtTemplatePtr = GCOMMAND_MplexListingsTemplatePtr =
        GCOMMAND_DigitalNicheListingsTemplatePtr = 0;

    FLIB2_LoadDigitalNicheDefaults();
    FLIB2_LoadDigitalMplexDefaults();
    FLIB2_LoadDigitalPpvDefaults();
    GCOMMAND_LoadDefaultTable();
    GCOMMAND_LoadMplexTemplate();
    GCOMMAND_LoadPPV3Template();
}

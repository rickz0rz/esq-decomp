/* RESTORES: GCOMMAND_ParseCommandOptions
 * MODULE:   modules/groups/a/s/gcommand.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: index-rematerialisation
 *   ref:     4e55ffec48e70f10266d00087c0041f90000602843edfff412d812d812d812d87a0078006100fd22200b670001ea4a13670001e4487800022f0b486dfff44eba4612422dfff6486dfff44ebadfea4fef00102e0054877c02bc876c4610336800488048c041f900007c112248d3c008110001670e10336800488048c072209081600810336800488048c02a007059ba006706704eba006608200513c00000a9c05286bc876c2210336800488048c02800723098817001b8806d0c7203b8816e0623c40000a9c25286bc876c321a3368002005488048c041f900007c11d1c00810000767182005488048c02f004eba2faa584f7200120023c10000a9c65286bc876c2210336800488048c02800723098817001b8806d0c7203b8816e0623c40000a9ca5286bc876c321a3368002005488048c041f900007c11d1c00810000767182005488048c02f004eba2f4e584f7200120023c10000a9ce5286bc876c5010336800488048c041f900007c11d1c008100001670e10336800488048c072209081600810336800488048c02a007046ba0067127042ba00670c704cba006706704eba006608200513c00000a9da5286bc876c3c10336800488048c02800723098817001b8806610720023c10000a9d223c00000a9d660164a846b127209b8816e0c23c40000a9d242b90000a9d65286bc876f042006600220072e00204bd1c74a1067142f390000a9dc2f084ebac4ee504f23c00000a9dc6100fd704cdf08f04e5d4e75
 *   got:     514f48e70f042a6f00207e00700341f90000000043ef001412d851c8fffc7a00780061000000200d670001ca4a15670001c4487800022f0d486f001c61000000422f0022486f0020610000004fef00102c0054867e02be866c4010357800488041f9000000002248d2c008110001670c488048c02a0072209a8160081a357800488548c520057259b0016706724eb001660613c0000000005287be866c2210357800488048c02800723098817001b8806d0c7203b8816e0623c4000000005287be866c2a1a357800488548c541f900000000d1c50810000767122f0561000000584f7200120023c1000000005287be866c2210357800488048c02800723098817001b8806d0c7203b8816e0623c4000000005287be866c2a1a357800488548c541f900000000d1c50810000767122f0561000000584f7200120023c1000000005287be866c4a10357800488041f900000000d0c008100001670c488048c02a0072209a8160081a357800488548c520057246b00167127242b001670c724cb0016706724eb001660613c0000000005287be866c3a10357800488048c02800723098817001b880660e42b90000000023c00000000060164a846b127209b8816e0c23c40000000042b9000000005287be866f022c07204dd1c64a1067182f39000000002f086100000023c00000000061000000504f4cdf20f0504f4e75
 *   summary: 508 got vs 546 ref, 38 bytes short. The original rebuilds MOVE.B 0(A3,D6.L),D0 / EXT.W / EXT.L before each use of the current option character -- twice per case-folding arm, six arms -- where 6.51 keeps the widened value in a register across the fold. The four-byte seed copy, the two-digit length prefix parse, all seven option positions in their original order with their own guards (the Y/N flag, the 1..3 pen, the hex nibble, the second 1..3 pen, the second hex nibble, the F/B/L/N workflow letter and the mode-cycle count with its special case for 1), the end-index correction and the trailing template capture match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <string.h>

extern char GCOMMAND_NicheParseScratchSeedWord[];
extern unsigned char WDISP_CharClassTable[];
extern char GCOMMAND_DigitalNicheEnabledFlag;
extern long GCOMMAND_NicheTextPen;
extern long GCOMMAND_NicheFramePen;
extern long GCOMMAND_NicheEditorLayoutPen;
extern long GCOMMAND_NicheEditorRowPen;
extern char GCOMMAND_NicheWorkflowMode;
extern long GCOMMAND_NicheModeCycleCount;
extern long GCOMMAND_NicheForceMode5Flag;
extern char *GCOMMAND_DigitalNicheListingsTemplatePtr;

extern void  FLIB2_LoadDigitalNicheDefaults(void);
extern void  GROUP_AW_JMPTBL_STRING_CopyPadNul(char *dst, char *src, long n);
extern long  ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern long  LADFUNC_ParseHexDigit(long c);
extern char *ESQPARS_ReplaceOwnedString(char *src, char *owned);
extern void  GCOMMAND_LoadCommandFile(void);

void GCOMMAND_ParseCommandOptions(char *cmd)
{
    char scratch[8];
    long i;
    long end;
    long c;
    long n;

    i = 0;
    memcpy(scratch, GCOMMAND_NicheParseScratchSeedWord, 4);
    c = 0;
    n = 0;

    FLIB2_LoadDigitalNicheDefaults();

    if (cmd == 0)
        return;
    if (*cmd == 0)
        return;

    GROUP_AW_JMPTBL_STRING_CopyPadNul(scratch, cmd, 2);
    scratch[2] = 0;
    end = ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(scratch) + 2;

    i = 2;
    if (i < end) {
        if (WDISP_CharClassTable[cmd[i]] & 2)
            c = cmd[i] - 32;
        else
            c = cmd[i];
        if ((char)c == 89 || (char)c == 78)
            GCOMMAND_DigitalNicheEnabledFlag = c;
        i++;
    }

    if (i < end) {
        n = cmd[i] - 48;
        if (n >= 1 && n <= 3)
            GCOMMAND_NicheTextPen = n;
        i++;
    }

    if (i < end) {
        c = cmd[i];
        if (WDISP_CharClassTable[c] & 0x80)
            GCOMMAND_NicheFramePen = (unsigned char)LADFUNC_ParseHexDigit(c);
        i++;
    }

    if (i < end) {
        n = cmd[i] - 48;
        if (n >= 1 && n <= 3)
            GCOMMAND_NicheEditorLayoutPen = n;
        i++;
    }

    if (i < end) {
        c = cmd[i];
        if (WDISP_CharClassTable[c] & 0x80)
            GCOMMAND_NicheEditorRowPen = (unsigned char)LADFUNC_ParseHexDigit(c);
        i++;
    }

    if (i < end) {
        if (WDISP_CharClassTable[cmd[i]] & 2)
            c = cmd[i] - 32;
        else
            c = cmd[i];
        if ((char)c == 70 || (char)c == 66 || (char)c == 76 || (char)c == 78)
            GCOMMAND_NicheWorkflowMode = c;
        i++;
    }

    if (i < end) {
        n = cmd[i] - 48;
        if (n == 1) {
            GCOMMAND_NicheModeCycleCount = 0;
            GCOMMAND_NicheForceMode5Flag = 1;
        } else if (n >= 0 && n <= 9) {
            GCOMMAND_NicheModeCycleCount = n;
            GCOMMAND_NicheForceMode5Flag = 0;
        }
        i++;
    }

    if (i > end)
        end = i;

    if (cmd[end] != 0) {
        GCOMMAND_DigitalNicheListingsTemplatePtr = ESQPARS_ReplaceOwnedString(
            cmd + end, GCOMMAND_DigitalNicheListingsTemplatePtr);
        GCOMMAND_LoadCommandFile();
    }
}

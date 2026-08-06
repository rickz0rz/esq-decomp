/* RESTORES: _NEWGRID_ValidateSelectionCode
 * MODULE:   modules/groups/b/a/newgrid1_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: jump-table-versus-subtract-chain
 *   ref:     48e70110266f000c2e2f00107000102b0036b0876c000160200772109081676e72109081670000805380670000aa5380670000dc5380670000f4538067000102538067000110720b9081677253806700009e5380670000b85380670000d05380670000de5380670000ec720b9081670000f85380670000f25380670000ec5380670000e65380670000e0600000e41039000006147259b001660000e6200717400036600000dc1039000006007259b001660000ce200717400036600000c41039000006077259b001660000b6200717400036600000ac10390000a9c07259b0016600009e200717400036600000941039000006077259b0016600008610390000a9c0b001667a20071740003660721039000005fc7259b001670a1039000005ffb001665c20071740003660541039000005fd7259b0016648200717400036604010390000a9e07259b0016634200717400036602c10390000aa147259b001662020071740003660182007174000366010422b0036600a4a8766062007174000364cdf08804e75
 *   got:     48e701042e2f00102a6f000c7000102d0036b0876d104a876600017820071b4000366000016e2007721090816d0001600c80000000356c000156d040303b00064efb00040068014801480148014801480148014801480148014801480148014801480148008000b000e601040118012c0148014801480148014801480148014801480148009800c800e601040118012c0148014801480148014801480148014801480148014001400140014001401039000000007259b001660000d820071b400036600000ce1039000000007259b001660000c020071b400036600000b61039000000007259b001660000a820071b4000366000009e1039000000007259b0016600009020071b400036600000861039000000007259b0016678103900000000b001666e20071b40003660661039000000007259b001670a103900000000b001665020071b40003660481039000000007259b001663c20071b40003660341039000000007259b001662820071b40003660201039000000007259b001661420071b400036600c20071b4000366004422d00364cdf20804e75
 *   summary: 408 got vs 390 ref, first divergence at byte 3. The original dispatches with a chained SUBQ/SUBI over the sixteen live codes; 6.51 builds a 53-entry PC-relative jump table spanning 16 to 68 instead. That is the whole delta -- every arm body is the same shape and the arm ORDER matches the original (16, 32, 48, 33, 49, then the 34/50, 35/51, 36/52 and 37/53 pairs, then 64 to 68, then the clear), which is what the body layout in the reference shows. The already-selected guard with its zero special case, all nine 89-flag tests including the two-term arm for 49 and the two-arm OR for 34, and the CLR.B default match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct GridPanel {
    char          pad0[54];
    unsigned char selection;        /* +54 */
};

extern unsigned char CONFIG_NewgridSelectionCode16EnabledFlag;
extern unsigned char CONFIG_NewgridSelectionCode32EnabledFlag;
extern unsigned char CONFIG_NewgridSelectionCode48_49EnabledFlag;
extern unsigned char CONFIG_NewgridSelectionCode34PrimaryEnabledFlag;
extern unsigned char CONFIG_NewgridSelectionCode34AltEnabledFlag;
extern unsigned char CONFIG_NewgridSelectionCode35EnabledFlag;
extern unsigned char GCOMMAND_DigitalNicheEnabledFlag;
extern unsigned char GCOMMAND_DigitalMplexEnabledFlag;
extern unsigned char GCOMMAND_DigitalPpvEnabledFlag;

void NEWGRID_ValidateSelectionCode(struct GridPanel *panel, long code)
{
    if ((long)panel->selection >= code) {
        if (code == 0)
            panel->selection = code;
        return;
    }

    switch (code) {
    case 16:
        if (CONFIG_NewgridSelectionCode16EnabledFlag == 'Y')
            panel->selection = code;
        break;

    case 32:
        if (CONFIG_NewgridSelectionCode32EnabledFlag == 'Y')
            panel->selection = code;
        break;

    case 48:
        if (CONFIG_NewgridSelectionCode48_49EnabledFlag == 'Y')
            panel->selection = code;
        break;

    case 33:
        if (GCOMMAND_DigitalNicheEnabledFlag == 'Y')
            panel->selection = code;
        break;

    case 49:
        if (CONFIG_NewgridSelectionCode48_49EnabledFlag == 'Y'
            && GCOMMAND_DigitalNicheEnabledFlag == 'Y')
            panel->selection = code;
        break;

    case 34:
    case 50:
        if (CONFIG_NewgridSelectionCode34PrimaryEnabledFlag == 'Y'
            || CONFIG_NewgridSelectionCode34AltEnabledFlag == 'Y')
            panel->selection = code;
        break;

    case 35:
    case 51:
        if (CONFIG_NewgridSelectionCode35EnabledFlag == 'Y')
            panel->selection = code;
        break;

    case 36:
    case 52:
        if (GCOMMAND_DigitalMplexEnabledFlag == 'Y')
            panel->selection = code;
        break;

    case 37:
    case 53:
        if (GCOMMAND_DigitalPpvEnabledFlag == 'Y')
            panel->selection = code;
        break;

    case 64:
    case 65:
    case 66:
    case 67:
    case 68:
        panel->selection = code;
        break;

    default:
        panel->selection = 0;
        break;
    }
}

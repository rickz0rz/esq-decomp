/* RESTORES: _ESQIFF_ReadNextExternalAssetPathEntry
 * MODULE:   modules/groups/a/n/esqiff_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: frame-local-source-cursor
 *   ref:     4e55fff048e70f10266d00084ebad13e30390000a8b8671e283900005ae42b7900005ae8fff23c390000a82a700033c00000a910602430390000a8ba6716283900005adc2b7900005ae0fff23c390000a82c60067000600000a67e00be466c1a4a846f16206dfff21a182b48fff2700aba0066025247538460e24a84662a30390000a8b86710283900005ae42b7900005ae8fff2600e283900005adc2b7900005ae0fff27c016002524630390000a8b8670833c60000a82a600633c60000a82c206dfff21a182b48fff2700aba00672a700dba0067247020ba00671e200453844a806f16702cba00660c421333fc00010000a910600416c560c6421370014cdf08f04e5d4e75
 *   got:     48e70f142a6f001c61000000303900000000671a2e39000000002679000000003c3900000000427900000000602030390000000066067000600000a42e39000000002679000000003c39000000007a00ba466c124a876f0e181b700ab80066025245538760ea4a876626303900000000670e2e3900000000267900000000600c2e39000000002679000000007c0160025246303900000000670833c600000000600633c600000000181b700ab800672a700db80067247020b800671e200753874a806f16702cb800660c421533fc00010000000060041ac460ce421570014cdf28f04e75
 *   summary: 228 got vs 262 ref, and the whole 34-byte deficit is one variable. The original keeps the read cursor in the A5 frame and reloads it around every byte: MOVEA.L -14(A5),A0 / MOVE.B (A0)+,D5 / MOVE.L A0,-14(A5), ten bytes a site against MOVE.B (A3)+,D4. Two read sites cost 16, the four cursor assignments cost 2 each, and the LINK.W/UNLK the original needs for that local costs 6. 6.51 keeps the cursor in an address register throughout. Every test, both catalogue selections, the line seek, the wrap-and-reload, the line-index writeback and the four terminator tests match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void ESQDISP_ProcessGridMessagesIfIdle(void);

extern short ESQIFF_AssetSourceSelect;
extern short ESQIFF_GAdsSourceEnabled;
extern short ESQIFF_LogoListLineIndex;
extern short ESQIFF_GAdsListLineIndex;
extern short ESQIFF_ExternalAssetPathCommaFlag;

extern long  Global_REF_LONG_DF0_LOGO_LST_FILESIZE;
extern char *Global_REF_LONG_DF0_LOGO_LST_DATA;
extern long  Global_REF_LONG_GFX_G_ADS_FILESIZE;
extern char *Global_REF_LONG_GFX_G_ADS_DATA;

long ESQIFF_ReadNextExternalAssetPathEntry(char *dst)
{
    char *p;
    long  left;
    short line;
    short seen;
    char  ch;

    ESQDISP_ProcessGridMessagesIfIdle();

    if (ESQIFF_AssetSourceSelect != 0) {
        left = Global_REF_LONG_DF0_LOGO_LST_FILESIZE;
        p    = Global_REF_LONG_DF0_LOGO_LST_DATA;
        line = ESQIFF_LogoListLineIndex;
        ESQIFF_ExternalAssetPathCommaFlag = 0;
    } else {
        if (ESQIFF_GAdsSourceEnabled == 0)
            return 0;
        left = Global_REF_LONG_GFX_G_ADS_FILESIZE;
        p    = Global_REF_LONG_GFX_G_ADS_DATA;
        line = ESQIFF_GAdsListLineIndex;
    }

    seen = 0;
    while (seen < line && left > 0) {
        ch = *p++;
        if (ch == 10)
            seen++;
        left--;
    }

    if (left == 0) {
        if (ESQIFF_AssetSourceSelect != 0) {
            left = Global_REF_LONG_DF0_LOGO_LST_FILESIZE;
            p    = Global_REF_LONG_DF0_LOGO_LST_DATA;
        } else {
            left = Global_REF_LONG_GFX_G_ADS_FILESIZE;
            p    = Global_REF_LONG_GFX_G_ADS_DATA;
        }
        line = 1;
    } else {
        line++;
    }

    if (ESQIFF_AssetSourceSelect != 0)
        ESQIFF_LogoListLineIndex = line;
    else
        ESQIFF_GAdsListLineIndex = line;

    for (;;) {
        ch = *p++;
        if (ch == 10)
            break;
        if (ch == 13)
            break;
        if (ch == 32)
            break;
        if (left-- <= 0)
            break;
        if (ch == 44) {
            *dst = 0;
            ESQIFF_ExternalAssetPathCommaFlag = 1;
            break;
        }
        *dst++ = ch;
    }

    *dst = 0;
    return 1;
}

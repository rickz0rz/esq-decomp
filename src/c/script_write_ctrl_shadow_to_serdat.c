/* RESTORES: _SCRIPT_WriteCtrlShadowToSerdat
 * MODULE:   modules/groups/b/a/script2.s
 * STATUS:   exact
 *
 * Writes a CTRL byte to the serial data register and keeps a shadow copy.
 *
 * NOTE: the in-place updates are load-bearing. Introducing a temporary makes
 * SAS/C round-trip through D0 and emit ORI.W #$100 instead of BSET #8, which
 * costs 4 bytes. Two separate statements keep the value in D7 throughout.
 * SERDAT comes from the absolute-symbol object (see src/modules/c-exports.s).
 */
extern volatile unsigned short SERDAT;
extern unsigned short SCRIPT_SerialShadowWord;

void SCRIPT_WriteCtrlShadowToSerdat(unsigned short value)
{
    value &= 0xFF;
    value |= 0x100;
    SERDAT = value;
    SCRIPT_SerialShadowWord = value;
}

/* RESTORES: ESQSHARED4_ProgramDisplayWindowAndCopper
 * MODULE:   modules/groups/a/q/esqshared4_p3.s
 * STATUS:   behavioural
 *
 * Programs the display window and modulos, patches the four copper-list
 * pointers into their own lists, and starts the copper.
 *
 * THIS IS THE ONE PLACE A CUSTOM-CHIP POINTER IS RIGHT, and it is worth saying
 * why, because AGENTS.md says the opposite for the general case. The rule there
 * is that a hardware register must be an extern rather than a pointer cast,
 * because `*(volatile UWORD *)0xDFF004` makes SAS/C emit MOVEA.L #imm,An plus
 * an indirect access instead of the absolute the stock binary uses.
 *
 * That reasoning does not apply here. The original itself opens
 * `LEA BLTDDAT,A0` and then reaches EVERY register as a displacement off A0
 * (317c...008e for DIWSTRT, 0090 for DIWSTOP, and so on). A base register with
 * (d16,An) displacements is exactly what a struct pointer produces, and an
 * extern per register would produce eleven absolutes instead. So the pointer is
 * the faithful form for this function specifically.
 *
 * The four pointer patches all follow the same shape: LEA the list, store the
 * LOW word, SWAP, store the HIGH word -- so the two halves of each 32-bit
 * address live in separate, non-adjacent copper words.
 *
 * The list choice at the end reads VPOSR and branches on its SIGN (BPL), which
 * is the long-frame bit, so it picks list A or B by field.
 *
 * The two DMACON writes are deliberate and ordered: 0x0020 clears, then 0x8180
 * sets. Collapsing them would leave the copper enabled through the reprogram.
 *
 * 174 ref vs 196 got. All six display-window constants, both copper-list
 * addresses, all eight pointer-word stores with their SWAPs, the VPOSR sign
 * test, the COP1LC store, the COPJMP1 read and both DMACON writes are present
 * and in the same order.
 *
 * THE `volatile` ON THE CUSTOM POINTER IS LOAD-BEARING, and finding out cost a
 * compile. Without it SAS/C DELETED the COPJMP1 read entirely, because nothing
 * uses the value -- and that read is not a read, it is the strobe that makes
 * the copper jump to the list just installed. The restoration compiled clean,
 * compared sanely, and would have left the copper running the old list. The
 * read is now assigned to a local so it cannot be discarded, and the emitted
 * code carries it again (3c280088, MOVE.W $88(A0),D6).
 *
 * This is the same class of hazard as the A6 caching that esq-libbase.md
 * documents: a correctness property that no byte gate can see, because the
 * function looks fine on its own.
 *
 * SASC-MISMATCH: base-register-materialisation
 *   ref:     41f900dff000     LEA BLTDDAT,A0      loaded ONCE
 *   got:     207c00dff000     MOVEA.L #$dff000,A0 loaded TWICE
 *   summary: same six bytes for the load, but 6.51 reloads the base before the
 *            VPOSR read rather than keeping A0 live across the pointer patches.
 *            It also stores the two modulos through a shared MOVEQ #88 register
 *            (7058 / 31400108 / 3140010a) where the original emits two
 *            immediates (317c00580108 / 317c0058010a). Both are register
 *            allocation, not addressing: every access is still a (d16,An)
 *            displacement off the custom base, which is what makes the pointer
 *            form correct here at all.
 *   tried:   nothing further. An extern per register is the AGENTS.md default
 *            and is WRONG for this function -- it would emit eleven absolute
 *            accesses where the original emits one LEA and eleven
 *            displacements.
 *   scope:   any function that touches several custom registers through one
 *            base. Most hardware touches in this program are single absolutes
 *            and still want the extern form.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <hardware/custom.h>

#define CUSTOM ((volatile struct Custom *)0xdff000L)

extern void ESQSHARED4_LoadDefaultPaletteToCopper_NoOp(void);

extern unsigned short ESQ_CopperEffectListA[];
extern unsigned short ESQ_CopperEffectListB[];
extern unsigned short ESQ_CopperEffectSwitchWaitWordA[];
extern unsigned short ESQ_CopperEffectSwitchWaitWordB[];

extern unsigned short ESQ_CopperEffectListA_PtrLoWord;
extern unsigned short ESQ_CopperEffectListA_PtrHiWord;
extern unsigned short ESQ_CopperEffectListB_PtrLoWord;
extern unsigned short ESQ_CopperEffectListB_PtrHiWord;
extern unsigned short ESQ_CopperEffectJumpTargetA_LoWord;
extern unsigned short ESQ_CopperEffectJumpTargetA_HiWord;
extern unsigned short ESQ_CopperEffectJumpTargetB_LoWord;
extern unsigned short ESQ_CopperEffectJumpTargetB_HiWord;

void ESQSHARED4_ProgramDisplayWindowAndCopper(void)
{
    unsigned long addr;
    unsigned short *list;
    unsigned short trigger;

    CUSTOM->diwstrt = 0x1761;
    CUSTOM->diwstop = 0xffc5;
    CUSTOM->ddfstrt = 0x0030;
    CUSTOM->ddfstop = 0x00d8;
    CUSTOM->bpl1mod = 0x0058;
    CUSTOM->bpl2mod = 0x0058;

    ESQSHARED4_LoadDefaultPaletteToCopper_NoOp();

    addr = (unsigned long)ESQ_CopperEffectListB;
    ESQ_CopperEffectListB_PtrLoWord = (unsigned short)addr;
    ESQ_CopperEffectListB_PtrHiWord = (unsigned short)(addr >> 16);

    addr = (unsigned long)ESQ_CopperEffectListA;
    ESQ_CopperEffectListA_PtrLoWord = (unsigned short)addr;
    ESQ_CopperEffectListA_PtrHiWord = (unsigned short)(addr >> 16);

    addr = (unsigned long)ESQ_CopperEffectSwitchWaitWordA;
    ESQ_CopperEffectJumpTargetA_LoWord = (unsigned short)addr;
    ESQ_CopperEffectJumpTargetA_HiWord = (unsigned short)(addr >> 16);

    addr = (unsigned long)ESQ_CopperEffectSwitchWaitWordB;
    ESQ_CopperEffectJumpTargetB_LoWord = (unsigned short)addr;
    ESQ_CopperEffectJumpTargetB_HiWord = (unsigned short)(addr >> 16);

    list = ESQ_CopperEffectListB;
    if ((short)CUSTOM->vposr < 0)
        list = ESQ_CopperEffectListA;

    CUSTOM->cop1lc = (unsigned long)list;
    trigger = CUSTOM->copjmp1;

    CUSTOM->dmacon = 0x0020;
    CUSTOM->dmacon = 0x8180;
}

/* RESTORES: BRUSH_PopulateBrushList
 * MODULE:   modules/groups/a/a/brush_p2.s
 * STATUS:   behavioural
 *
 * Walks a descriptor list, loads each brush, links the successful ones onto the
 * caller's list, and FREES EVERY DESCRIPTOR as it goes.
 *
 * The descriptor's next pointer is read at +234 and saved BEFORE the descriptor
 * is freed -- the original stores 234(A3) into a frame slot, frees, and then
 * reloads A3 from that slot. Freeing first and reading after would walk into
 * released memory.
 *
 * The load result is likewise parked in a frame slot ACROSS the free, because
 * the free clobbers D0.
 *
 * The list link on a brush node is at +368, which is a different field from the
 * +234 the descriptor uses. Two different record types, and confusing them
 * would corrupt the list.
 *
 * The in-progress flag is raised and lowered under Forbid/Permit at both ends,
 * so a task that samples it never sees a torn value.
 *
 * The two frame slots are zeroed from ONE cleared address register
 * (SUBA.L A0,A0 then two stores), which is the chained pointer-assignment
 * idiom. They are written as two statements here rather than chained, because
 * the two locals have DIFFERENT pointer types and a chain would be a constraint
 * violation. 6.51 shares the register anyway.
 *
 * 174 ref vs 172 got. Both Forbid/Permit pairs with their LVO offsets, the
 * PEA 238 / PEA 845, the LEA 20(A7),A7 cleanup, the +234 next read, the +368
 * link store and the descriptor-list head clear all match in kind and size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fff4 ... 2b6b00eafff4 ... 266dfff4 ... 4e5d
 *            LINK.W A5,#-12 / spill the next pointer / reload it / UNLK
 *   got:     514f ... 246d00ea ... 2a4a ... 504f
 *            SUBQ.W #8,A7 / MOVEA.L 234(A5),A2 / MOVEA.L A2,A5
 *   summary: the frame class -- the original spills both the next pointer and
 *            the load result across the free where 6.51 keeps them in address
 *            registers, and takes 8 bytes of stack where the original takes 12.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-exec.h"

struct BrushListNode {
    char pad0[368];
    struct BrushListNode *link368;      /* +368 */
};

struct BrushDescriptor {
    char pad0[234];
    struct BrushDescriptor *next234;    /* +234, record is 238 bytes */
};

extern struct BrushListNode *BRUSH_LoadBrushAsset(struct BrushDescriptor *d);
extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line,
                                                    void *p, long size);
extern void BRUSH_NormalizeBrushNames(struct BrushListNode **head);

extern long BRUSH_LoadInProgressFlag;
extern long PARSEINI_ParsedDescriptorListHead;
extern char Global_STR_BRUSH_C_8[];

void BRUSH_PopulateBrushList(struct BrushDescriptor *desc,
                             struct BrushListNode **head)
{
    struct BrushDescriptor *next;
    struct BrushListNode   *tail;
    struct BrushListNode   *node;

    next = 0;
    tail = 0;

    Forbid();
    BRUSH_LoadInProgressFlag = 1;
    Permit();

    *head = 0;

    while (desc != 0) {
        node = BRUSH_LoadBrushAsset(desc);
        next = desc->next234;

        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_8, 845L,
                                                desc, 238L);
        desc = next;

        if (node != 0) {
            if (*head == 0)
                *head = node;
            else
                tail->link368 = node;
            tail = node;
        }
    }

    PARSEINI_ParsedDescriptorListHead = 0;
    BRUSH_NormalizeBrushNames(head);

    Forbid();
    BRUSH_LoadInProgressFlag = 0;
    Permit();
}

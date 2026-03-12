typedef struct ESQ_CopperWordSlot {
    unsigned short color;
    unsigned short pad2;
} ESQ_CopperWordSlot;

typedef struct ESQ_CopperWordTable {
    ESQ_CopperWordSlot slots[32];
} ESQ_CopperWordTable;

extern unsigned char WDISP_PaletteTriplesRBase[];
extern ESQ_CopperWordTable ESQ_CopperStatusDigitsA;
extern ESQ_CopperWordTable ESQ_CopperStatusDigitsB;
extern unsigned short ESQ_BumpColorTowardTargets(unsigned short color, const unsigned char *targets);

void ESQ_IncCopperListsTowardsTargets(void)
{
    ESQ_CopperWordSlot *slotA;
    ESQ_CopperWordSlot *slotB;
    unsigned char *targets = WDISP_PaletteTriplesRBase;
    short i;

    slotA = &ESQ_CopperStatusDigitsA.slots[0];
    slotB = &ESQ_CopperStatusDigitsB.slots[0];
    for (i = 0; i <= 7; ++i) {
        slotB->color = slotA->color = ESQ_BumpColorTowardTargets(slotA->color, targets);
        ++slotA;
        ++slotB;
        targets += 3;
    }

    for (i = 0; i <= 23; ++i) {
        slotA->color = ESQ_BumpColorTowardTargets(slotA->color, targets);
        ++slotA;
        targets += 3;
    }
}

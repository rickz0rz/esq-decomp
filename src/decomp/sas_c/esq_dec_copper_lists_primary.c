typedef struct ESQ_CopperWordSlot {
    unsigned short color;
    unsigned short pad2;
} ESQ_CopperWordSlot;

typedef struct ESQ_CopperWordTable {
    ESQ_CopperWordSlot slots[32];
} ESQ_CopperWordTable;

extern ESQ_CopperWordTable ESQ_CopperStatusDigitsA;
extern ESQ_CopperWordTable ESQ_CopperStatusDigitsB;
extern unsigned short ESQ_DecColorStep(unsigned short color);

void ESQ_DecCopperListsPrimary(void)
{
    ESQ_CopperWordSlot *slotA;
    ESQ_CopperWordSlot *slotB;
    short i;

    slotA = &ESQ_CopperStatusDigitsA.slots[0];
    slotB = &ESQ_CopperStatusDigitsB.slots[0];
    for (i = 0; i <= 7; ++i) {
        slotB->color = slotA->color = ESQ_DecColorStep(slotA->color);
        ++slotA;
        ++slotB;
    }

    for (i = 0; i <= 23; ++i) {
        slotA->color = ESQ_DecColorStep(slotA->color);
        ++slotA;
    }
}

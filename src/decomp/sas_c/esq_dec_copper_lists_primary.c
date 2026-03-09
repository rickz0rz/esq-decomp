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
    short i;

    for (i = 0; i <= 7; ++i) {
        unsigned short v = ESQ_CopperStatusDigitsA.slots[i].color;
        v = ESQ_DecColorStep(v);
        ESQ_CopperStatusDigitsA.slots[i].color = v;
        ESQ_CopperStatusDigitsB.slots[i].color = v;
    }

    for (i = 0; i <= 23; ++i) {
        unsigned short v = ESQ_CopperStatusDigitsA.slots[i + 8].color;
        v = ESQ_DecColorStep(v);
        ESQ_CopperStatusDigitsA.slots[i + 8].color = v;
    }
}

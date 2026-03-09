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
    unsigned char *targets = WDISP_PaletteTriplesRBase;
    short i;

    for (i = 0; i <= 7; ++i) {
        unsigned short v = ESQ_CopperStatusDigitsA.slots[i].color;
        v = ESQ_BumpColorTowardTargets(v, targets);
        ESQ_CopperStatusDigitsA.slots[i].color = v;
        ESQ_CopperStatusDigitsB.slots[i].color = v;
        targets += 3;
    }

    for (i = 0; i <= 23; ++i) {
        unsigned short v = ESQ_CopperStatusDigitsA.slots[i + 8].color;
        v = ESQ_BumpColorTowardTargets(v, targets);
        ESQ_CopperStatusDigitsA.slots[i + 8].color = v;
        targets += 3;
    }
}

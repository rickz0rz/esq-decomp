extern void ESQ_IncCopperListsTowardsTargets(void);
extern void ESQ_DecCopperListsPrimary(void);
extern long BRUSH_SelectBrushSlot(unsigned char *brush, long srcX0, long srcY0, long srcX1, long srcY1, char *dstRp, long forcedDstY);
extern void BRUSH_SelectBrushByLabel(void);

void ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets(void){ESQ_IncCopperListsTowardsTargets();}
void ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary(void){ESQ_DecCopperListsPrimary();}
long ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(unsigned char *brush, long srcX0, long srcY0, long srcX1, long srcY1, char *dstRp, long forcedDstY){return BRUSH_SelectBrushSlot(brush, srcX0, srcY0, srcX1, srcY1, dstRp, forcedDstY);}
void ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel(void){BRUSH_SelectBrushByLabel();}

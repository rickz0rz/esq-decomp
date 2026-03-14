#include <exec/types.h>
extern void DISPTEXT_ComputeMarkerWidths(char *rp, LONG a, LONG b);

void NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths(char *rp, LONG a, LONG b){DISPTEXT_ComputeMarkerWidths(rp, a, b);}

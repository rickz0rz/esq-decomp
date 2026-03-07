typedef long LONG;

enum {
    BRUSH_NULL = 0,
    BRUSH_NODE_NEXT_OFFSET = 368
};

LONG GROUP_AA_JMPTBL_STRING_CompareNoCase(void *a, void *b);

void *BRUSH_FindBrushByPredicate(void *key, void *list_head_ptr)
{
    unsigned char *cur;

    cur = *(unsigned char **)list_head_ptr;
    while (cur != (unsigned char *)BRUSH_NULL) {
        if (GROUP_AA_JMPTBL_STRING_CompareNoCase((void *)cur, key) == BRUSH_NULL) {
            return (void *)cur;
        }
        cur = *(unsigned char **)(cur + BRUSH_NODE_NEXT_OFFSET);
    }

    return (void *)BRUSH_NULL;
}

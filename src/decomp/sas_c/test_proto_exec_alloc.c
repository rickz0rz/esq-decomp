#include <proto/exec.h>

int main(int argc, char **argv)
{
    struct Library *SysBase;
    SysBase = *((struct Library **)4UL);

    AllocMem(5000, 5);
    return 0;
}

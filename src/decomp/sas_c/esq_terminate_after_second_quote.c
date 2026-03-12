void ESQ_TerminateAfterSecondQuote(char *text)
{
    char c;

    for (;;) {
        c = *text++;
        if (!c) {
            return;
        }
        if (c == '"') {
            break;
        }
    }

    for (;;) {
        c = *text++;
        if (!c) {
            return;
        }
        if (c == '"') {
            break;
        }
    }

    *text = '\0';
}

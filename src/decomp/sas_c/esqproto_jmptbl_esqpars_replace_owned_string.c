void *ESQPARS_ReplaceOwnedString(void *newValue, void *oldValue);

void *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(void *newValue, void *oldValue)
{
    return ESQPARS_ReplaceOwnedString(newValue, oldValue);
}

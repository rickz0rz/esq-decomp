BEGIN {
    has_entry = 0
    has_phase = 0
    has_bit_reader = 0
    has_delay_counter = 0
    has_sample_slot = 0
    has_sample_scratch = 0
    has_entry_scratch = 0
    has_store_entry = 0
    has_count = 0
    has_assemble_loop = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /CTRL_BIT3CAPTUREPHASE/) has_phase = 1
    if (l ~ /GET_BIT_3_OF_CIAB_PRA_INTO_D1/) has_bit_reader = 1
    if (l ~ /CTRL_BIT3CAPTUREDELAYCOUNTER/) has_delay_counter = 1
    if (l ~ /CTRL_BIT3SAMPLESLOTINDEX/) has_sample_slot = 1
    if (l ~ /CTRL_BIT3SAMPLESCRATCH/) has_sample_scratch = 1
    if (l ~ /CTRL_SAMPLEENTRYSCRATCH/) has_entry_scratch = 1
    if (l ~ /ESQ_STORECTRLSAMPLEENTRY/) has_store_entry = 1
    if (l ~ /CTRL_SAMPLEENTRYCOUNT/) has_count = 1
    if (l ~ /BSET / || l ~ /BCLR / || l ~ /LSL\./ || l ~ /ASL\./ || l ~ /OR\./ || l ~ /AND\./) has_assemble_loop = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PHASE=" has_phase
    print "HAS_BIT_READER=" has_bit_reader
    print "HAS_DELAY_COUNTER=" has_delay_counter
    print "HAS_SAMPLE_SLOT=" has_sample_slot
    print "HAS_SAMPLE_SCRATCH=" has_sample_scratch
    print "HAS_ENTRY_SCRATCH=" has_entry_scratch
    print "HAS_STORE_ENTRY=" has_store_entry
    print "HAS_COUNT=" has_count
    print "HAS_ASSEMBLE_LOOP=" has_assemble_loop
}

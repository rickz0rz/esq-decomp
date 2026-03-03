BEGIN {
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

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /CTRL_BIT3CAPTUREPHASE/) has_phase = 1
    if (uline ~ /GET_BIT_3_OF_CIAB_PRA_INTO_D1/) has_bit_reader = 1
    if (uline ~ /CTRL_BIT3CAPTUREDELAYCOUNTER/) has_delay_counter = 1
    if (uline ~ /CTRL_BIT3SAMPLESLOTINDEX/) has_sample_slot = 1
    if (uline ~ /CTRL_BIT3SAMPLESCRATCH/) has_sample_scratch = 1
    if (uline ~ /CTRL_SAMPLEENTRYSCRATCH/) has_entry_scratch = 1
    if (uline ~ /ESQ_STORECTRLSAMPLEENTRY/) has_store_entry = 1
    if (uline ~ /CTRL_SAMPLEENTRYCOUNT/) has_count = 1
    if (uline ~ /BSET / || uline ~ /BCLR /) has_assemble_loop = 1
}

END {
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

#!/bin/bash
UUID=$(uuidgen)
FILENAME="ESQ-3-$UUID.bin"

~/Downloads/vasm/vasmm68k_mot -Fhunkexe -o "$FILENAME" -nosym ESQ-3-Test.asm
shasum -a 256 "$FILENAME"
echo "f0ac65c8a01a96281b16e2a053b9e6b15d5cc507356856acffe4b671472de045 [Should be this]"
rm "$FILENAME"
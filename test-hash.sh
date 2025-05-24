#!/bin/bash
UUID=$(uuidgen)
FILENAME="ESQ-3-$UUID.bin"

~/Downloads/vasm/vasmm68k_mot -Fhunkexe -o "$FILENAME" -nosym ESQ-3-Test.asm
shasum -a 256 "$FILENAME"
echo "672f35c879ce24e0f66c57e74a3b6bc9e0e30c4b6156b52285dafeb94092473b [Should be this]"
rm "$FILENAME"

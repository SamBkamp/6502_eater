DEVICE := AT28C256
BIN_FILE := rom.bin

rom.bin:blink.s
	vasm -Fbin -dotdir -o $@ $^
upload:rom.bin
	minipro -p ${DEVICE} -w ${BIN_FILE} -u


.PHONY: upload

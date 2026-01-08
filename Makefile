DEVICE := AT28C256
BIN_FILE := rom.bin

run:
	./make_rom.py

upload:run
	minipro -p ${DEVICE} -w ${BIN_FILE} -u


.PHONY: upload run

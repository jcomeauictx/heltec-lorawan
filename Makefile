DOWNLOADS ?= $(HOME)/Downloads
ZIPFILE ?= $(wildcard $(DOWNLOADS)/firmware-*.zip)
FIRMWARE_DIR := $(ZIPFILE:.zip=)
BROWSER ?= xdg-open
ifeq ($(SHOWENV),)
 export
endif
id:
	python3 -m esptool --chip auto chip_id
install:
	sudo apt install python3
	# don't use Bullseye esptool, it's too old
	pip3 install --user --upgrade --break-system-packages esptool
env:
ifneq ($(SHOWENV),)
	$@
else
	$(MAKE) SHOWENV=1 $@
endif

DOWNLOADS ?= $(HOME)/Downloads
ZIPFILE ?= $(wildcard $(DOWNLOADS)/firmware-*.zip)
FIRMWARE_DIR := $(ZIPFILE:.zip=)
BROWSER ?= xdg-open
MESHTASTIC := https://meshtastic.org/downloads
ifeq ($(SHOWENV),)
 export
endif
zipfile_downloaded: $(ZIPFILE)
	if [ -z "$<" ]; then \
	 @echo 'Launching browser to download latest "stable" firmware' >&2; \
	 $(BROWSER) $(MESHTASTIC); \
	fi
	touch $@
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

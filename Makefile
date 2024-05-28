DOWNLOADS ?= $(HOME)/Downloads
ZIPFILE = $(wildcard $(DOWNLOADS)/firmware-*.zip)
FIRMWARE_DIR = $(ZIPFILE:.zip=)
UPDATE = $(wildcard $(FIRMWARE_DIR)/firmware-heltec-v3-*-update.bin)
FIRMWARE = $(UPDATE:-update.bin=.bin)
BROWSER ?= xdg-open
MESHTASTIC := https://meshtastic.org/downloads
ifeq ($(SHOWENV),)
 export
endif
all: zipfile_downloaded firmware_installed
zipfile_downloaded: $(ZIPFILE)
	if [ -z "$<" ]; then \
	 @echo 'Launching browser to download latest "stable" firmware' >&2; \
	 $(BROWSER) $(MESHTASTIC); \
	fi
	touch $@
id:
	python3 -m esptool --chip auto chip_id
firmware_installed: $(FIRMWARE_DIR)/device-install.sh $(FIRMWARE)
	if [ -z "$<" ]; then \
	 $(MAKE) zipfile_downloaded; \
	fi
	cd $(<D) && $+
	cd $(<D) && ./device-update.sh $(UPDATE)
	touch $@
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
clean:
	rm -f firmware_installed
distclean: clean
	rm -f zipfile_downloaded

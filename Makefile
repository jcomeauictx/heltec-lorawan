# contains bashisms, make sure of shell
SHELL := /bin/bash
DOWNLOADS ?= $(HOME)/Downloads
ZIPFILE = $(wildcard $(DOWNLOADS)/firmware-*.zip)
FIRMWARE_DIR = $(ZIPFILE:.zip=)
UPDATE = $(wildcard $(FIRMWARE_DIR)/firmware-heltec-v3-*-update.bin)
FIRMWARE = $(UPDATE:-update.bin=.bin)
BROWSER ?= xdg-open
MESHTASTIC := https://meshtastic.org/downloads
TEST_ONLY ?= # set to `echo` for testing problems with `make config`
PORT ?= /dev/ttyUSB0
# WEB and WEB_OFFSET are for using the web UI from a connected computer browser
# NOTE: version 2.7+ no longer supports web interface
WEB ?= $(wildcard $(FIRMWARE_DIR)/littlefs-heltec-v3-*.bin)
WEB_OFFSET ?= 0x00670000
WEBUI := https://client.meshtastic.org/
ifeq ($(SHOWENV),)
 export
endif
all: zipfile_downloaded firmware_installed config
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
	cd $(<D) && $< -p $(PORT) -f $(notdir $(word 2, $+))
	cd $(<D) && ./device-update.sh $(UPDATE)
	touch $@
$(FIRMWARE_DIR)/device-install.sh $(FIRMWARE): $(ZIPFILE)
	[ -d $(@D) ] || mkdir $(@D)
	[ -e $@ ] || (cd $(@D) && unzip $<)
# this is (or should be) done automatically by firmware_installed
web_installed: $(WEB)
	if [ -e "$(WEB)" ]; then \
	 cd $(<D) && esptool --port $(PORT) write-flash $(WEB_OFFSET) $(<F); \
	 touch $@; \
	fi
webui: $(word 1, $(shell which chromium chrome))
	[ -e "$<" ] && chromium $(WEBUI) >> /var/tmp/meshtastic-web.log 2>&1
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
config:  $(wildcard $(HOME)/etc/meshtastic.conf)
	# NOTE: version 2.7+ of software NO LONGER INCLUDES web interface
	# connect to https://client.meshtastic.org/ with Chromium instead
	# first reset config to factory defaults
	# allow 15 seconds after each setting for reboot
	meshtastic --factory-reset; sleep 15; \
	args=(); \
	posargs=(); \
	if [ -e "$<" ]; then \
	 while IFS="=" read key value; do \
	  case $$key in \
	   position.latitude) posargs+=(--setlat "$$value");; \
	   position.longitude) posargs+=(--setlon "$$value");; \
	   position.elevation) posargs+=(--setalt "$$value");; \
	   user.longName) args+=(--set-owner "$$value");; \
	   *) args+=(--set $$key "$$value");; \
	  esac; \
	 done < "$<" && \
	 $(TEST_ONLY) meshtastic "$${args[@]}"; sleep 15; \
	 $(TEST_ONLY) meshtastic "$${posargs[@]}"; sleep 15; \
	 echo configuration complete. >&2; \
	fi

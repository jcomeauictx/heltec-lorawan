id:
	python3 -m esptool --chip auto chip_id
install:
	sudo apt install python3
	# don't use Bullseye esptool, it's too old
	pip3 install --user --upgrade --break-system-packages esptool

# Heltec LoraWan

I bought a couple of Heltec devices from `flyfun_diymall` on ebay, and want
to experiment with them. They communicate over 2 bands: the 2.4 GHz wifi
frequencies, and the 900MHz band formerly used for wireless telephones back
in the 80s (?). But no instructions came with these, and the seller just
sent me some links, so I'll try to document my progress here.

## Quick start

This will launch a browser to download the latest firmware, then automatically
install it. If it fails, see the references below.

* `make`
* set region: <https://meshtastic.org/docs/getting-started/initial-config/>
* other configuration: <https://meshtastic.org/docs/configuration/>

## References
* <https://docs.heltec.org/en/node/esp32/wifi_lora_32/index.html>
* <https://docs.heltec.org/en/node/esp32/quick_start.html>
* [command-line meshtastic install](https://blog.habets.se/2024/01/Meshtastic-quick-setup.html)
* [`esptool chip_id` error](https://github.com/espressif/esptool/issues/784) and [here](https://bugzilla.redhat.com/show_bug.cgi?id=1955097)
* to save the original Heltec firmware before flashing Meshtastic,
  `pip3 install --break-system-packages esptool`, then
  `esptool --port /dev/ttyUSB0 read_flash 0 ALL heltec_v3_original.bin`
* after flashing a second Heltec device, set the region and channel the same as   the first:
  ```
  sudo apt update
  sudo apt install python3-meshtastic
  meshtastic --port /dev/ttyUSB0 --set lora.region US
  ```
  now you need to go to the Android app to which your first device is connected.
  the 4th icon from the left should look something like ')))' inside a circle.
  click that, and you should see a QR code and, underneath, an URL pointing
  to meshtastic.org with a very long identifier string following it. copy that
  URL by clicking the icon to the right of the URL, which looks something like
  a clipboard. then open Termux, ssh to the computer from which you just flashed
  the Heltec, and `meshtastic --port /dev/ttyUSB0 --ch-set-url '<PASTE>'`,
  where `<PASTE>` means you paste the clipboard contents (the URL) into the
  Termux window at that point in the command line. make sure to encase the URL
  in single quotes, as shown, because it contains a `#` which would otherwise
  signal a comment to Bash, hiding the identifier and breaking the URL.
* at that point you should be able to
  `meshstastic --sendtext "hello, world!"` and receive it both on the Android
  app and on the LCD screen of the first Heltec. you are connected!
* claude explained to me today (2026-05-11) why all my previous attempts at
  communicating with my Heltec V3 failed: the Android (or iPhone, presumably)
  app *is*, effectively, the Heltec device; sending something with it will
  not show up on the connected device itself. you need a second device to
  accomplish that.
* to turn off the 1Hz heartbeat LED:
  `meshtastic --set device.led_heartbeat_disabled true`
  but first you may need to update the firmware. 2026-05-15 I upgraded from
  version 2.3 to 2.7.

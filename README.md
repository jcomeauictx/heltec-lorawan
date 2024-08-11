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

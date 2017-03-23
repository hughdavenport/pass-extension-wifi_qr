# pass-wifi_qr

A [pass](https://www.passwordstore.org/) extension for generating
WiFi QR codes based on name and stored password.

## Usage

```
Usage:
    pass wifi_qr [--type,-t WEP,WPA,WPA2] [--ssid,-s SSID] [--hidden] pass-name
            Generate a QR code for the wifi 
	    If type is not given, defaults to WPA2 (who would use anything less!)
	    If ssid is not given, defaults to the pass-name (minus the folder)
```

## Example

Generate a WiFi QR code:

```
$ pass insert wifi/mysecretwifi
Enter password for wifi/mysecretwifi: [test]
Retype password for wifi/mysecretwifi: [test]
[master 2571ca8] Add given password for wifi/mysecretwifi to store.
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 wifi/mysecretwifi.gpg

$ pass wifi_qr wifi/mysecretwifi
Generating and displaying WiFi QR code for SSID "mysecretwifi" using stored password. Type is WPA2.
```

Generate a WiFi QR code for a hidden SSID:

```
$ pass wifi_qr --hidden wifi/mysecretwifi
Generating and displaying WiFi QR code for *hidden* SSID "mysecretwifi" using stored password. Type is WPA2.
```

Generate a WiFi QR code, specifying the SSID:

```
$ pass wifi_qr -s differentssid wifi/mysecretwifi
Generating and displaying WiFi QR code for SSID "differentssid" using stored password. Type is WPA2.
```

Generate a WiFi QR code, specifiying the type:

```
$ pass wifi_qr -t WEP wifi/mysecretwifi
Generating and displaying WiFi QR code for SSID "mysecretwifi" using stored password. Type is WEP.
```

## Installation

````
- Enable password-store extensions by setting ``PASSWORD_STORE_ENABLE_EXTENSIONS=true``
- Clone this repo and create a symlink (or just download the raw file) to `wifi_qr.bash` in `~/password-store/.extensions`
```

## Requirements

- `pass` 1.7.0 or later for extenstion support
- `qrencode` for generating QR code images

## License

```
Copyright (C) 2017 Hugh Davenport

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```

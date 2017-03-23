#!/usr/bin/env bash
# pass wifi_qr - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2017 Hugh Davenport
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
# []

wifi_qr_escape() {
	local text=$1
	text=${text//\\/\\\\}
	text=${text//,/\\,}
	text=${text//;/\\;}
	text=${text//:/\\:}
	echo $text
}

cmd_wifi_qr_usage() {
	cat <<-_EOF
	Usage:
	    $PROGRAM wifi_qr [--type,-t WEP,WPA] [--ssid,-s SSID] [--hidden] pass-name
	            Generate a QR code for the wifi
	            If type is not given, defaults to WPA (who would use anything less!)
	            If ssid is not given, defaults to the pass-name (minus the folder)
	_EOF
	exit 0
}

cmd_wifi_qr_show() {
	local types=("WEP" "WPA") type="WPA" ssid hidden="" pass wifi_qrcode
	opts="$($GETOPT -o t:s:h -l type:,ssid:,hidden -n "$PROGRAM" -- "$@")"
	local err=$?
	eval set -- "$opts"
	while true; do case $1 in
		-t|--type) type="$2"; shift 2 ;;
		-s|--ssid) ssid="$2"; shift 2 ;;
		--hidden) hidden="H:true"; shift ;;
		--) shift; break ;;
	esac done

	typegood=0
	for test in "${types[@]}"; do if [ "$type" == "$test" ]; then typegood=1; break; fi; done
	[[ $err -ne 0 || $# -ne 1 || $typegood -ne 1 ]] && die "Usage: $PROGRAM $COMMAND [--type,-t WEP,WPA,WPA2] [--ssid,-s SSID] [--hidden] pass-name"

	local path="${1%/}"
	local passfile="$PREFIX/$path.gpg"
	check_sneaky_paths "$path"
	[[ ! -f $passfile ]] && die "Passfile not found"

	if [ ! -v ssid ]; then
		ssid=$(basename "$path")
	fi

	pass=$($GPG -d "${GPG_OPTS[@]}" "$passfile" | head -n 1)
	[[ -n $pass ]] || die "There is no password to put in the QR code"

	ssid=$(wifi_qr_escape "$ssid")
	pass=$(wifi_qr_escape "$pass")
	# TODO test whether we can have ssid/pass that *looks* like hex, might have to surround in quotes?

	wifi_qrcode="WIFI:T:$type;S:$ssid;P:$pass;$hidden;"
	if [ -n "$hidden" ]; then
		hidden="*hidden*"
	fi
	echo "Generating and displaying WiFi QR code for $hidden SSID \"$ssid\" using stored password. Type is $type."
	qrcode "$wifi_qrcode" "$path"
}

case "$1" in
	help|--help|-h) shift;	cmd_wifi_qr_usage "$@" ;;
	*)			cmd_wifi_qr_show "$@" ;;
esac
exit 0

#!/bin/bash
# author:   IFC3 /joni
# script:   g4mLogAnalyser.sh
# date:     2024-09-23
# purpose:  parse log file for sensitive data.

if [ -z "$1" ]; then
  echo $(tput setaf 2)"No logfile supplied"$(tput sgr 0)
  exit 1
fi

output=report_$1

cat <<'eof' >$output

g4mLogAnalyser.sh launches a bunch of commands to find sensitive data in g4m logfiles.
Hereafter, the commands appear in green and corresponding answers, if any, in white.

eof

cat <<'eof' >>$output
Private IP-ranges
RFC 1918 name   IP address range                Classful description
24-bit block    10.0.0.0 – 10.255.255.255       single class A network
20-bit block    172.16.0.0 – 172.31.255.255     16 contiguous class B networks
16-bit block    192.168.0.0 – 192.168.255.255   256 contiguous class C networks

IPS:
eof
tput sgr 0
echo $(tput setaf 2)"grep -Po \"((\d{1,3}\.){3}(\d{1,3}))\" log.txt | sort | uniq -c | sort -nr"$(tput sgr 0) >>$output
grep -Po "((\d{1,3}\.){3}(\d{1,3}))" $1 | sort | uniq -c | sort -nr >>$output

echo $(tput setaf 2)"grep -Po \"((\d{1,3}\.){3})\" log.txt | sort | uniq -c | sort -nr"$(tput sgr 0) >>$output
grep -Po "((\d{1,3}\.){3})" $1 | sort | uniq -c | sort -nr >>$output

cat <<'eof' >>$output

-------------------------------------------------------------------------
WWW. AND 1 MORE CHARACTER:
eof
echo $(tput setaf 2)"grep -Pn \"www\..\" log.txt | wc -l"$(tput sgr 0) >>$output
grep -Pn "www\.." $1 | wc -l >>$output

cat <<'eof' >>$output

increase by n(char) to get an overview:
eof
echo $(tput setaf 2)"grep -Pno \"www\..{10}\" log.txt"$(tput sgr 0) >>$output
grep -Pno "www\..{10}" $1 >>$output

cat <<'eof' >>$output

-------------------------------------------------------------------------
TELEPHONE NUMBERS:
- match optional + and at least 11 numbers.
eof
echo $(tput setaf 2)"grep -Po \"(\+)*(\d{11,})\" log.txt | sort | uniq -c | sort -nr"$(tput sgr 0) >>$output
grep -Po "(\+)*(\d{11,})" $1 | sort | uniq -c | sort -nr >>$output

cat <<'eof' >>$output

A bit more restrictive with numbers begining with 41:
eof
echo $(tput setaf 2)"grep -Po \"(\+)*41(\d{9,})\" log.txt | sort | uniq -c | sort -nr"$(tput sgr 0) >>$output
grep -Po "(\+)*41(\d{9,})" $1 | sort | uniq -c | sort -nr >>$output

cat <<'eof' >>$output

-------------------------------------------------------------------------
IMEIS:
Literal:
eof
echo $(tput setaf 2)"grep -Pi \"imei|IMEI\" log.txt"$(tput sgr 0) >>$output
grep -Pi "imei|IMEI" $1 >>$output

cat <<'eof' >>$output

Numeric:
eof
echo $(tput setaf 2)"grep -P \"(3\d{13,15})\" log.txt"$(tput sgr 0) >>$output
grep -P "(3\d{13,15})" $1 >>$output

cat <<'eof' >>$output

-------------------------------------------------------------------------
FOR CHECKING PURPOSE, GO TO:
https://regex101.com/

Template:
http://172.18.45.2:5000
www.rts.ch
www.some_domains.dumb.org
https://something/
http://anotherthing
https://123.456.789.123
http://123.456.789.123/whatelse
+41793339990
+41793339990123456
41763339990
244546967
0041245577021
0244546967
35123456789234
351234567892345
3512345678923456
32345678901234567
1234567894112545

Note that imei numbers may also start with numbers other than 3.
eof

cat $output

# telly-testing
These are some simple test scripts I use for [telly](https://github.com/tellytv/telly). They are pretty braindead, but do what I wanted done.

## Setup
`config.example`

make a copy of this file, called `config`, fill in details as required and uncomment one of the provider sections.  There are skeletons for Iris, Area51, Vaders, Custom.

You'll note that they all use placeholders for the username and password in the URLs.
```
# # Iris
export PROVIDER=Iris
export PROVIDER_NAME=Iris
export IPTVUSER=USERNAME_HERE
export IPTVPASS=PASSWORD_HERE
export M3U_URL="http://irislinks.net:83/get.php?username=${IPTVUSER}&password=${IPTVPASS}&type=m3u_plus&output=ts"
export XML_URL="http://irislinks.net:83/xmltv.php?username=${IPTVUSER}&password=${IPTVPASS}"
```
Use those placeholders when you edit, or at least uncomment the username and password.  The config will error and quit if IPTVUSER or IPTVPASS are not set.  In future, those variables may be used in other contexts than the M3U_URL and XML_URL.

You will want to edit at least the first two of these:
```
export MYIP=0.0.0.0
export FILTER="GROUP|GROUP"
export USE_FILE=false
```

The IP should be the IP of the machine where you're running these scripts.

The filter is the default filter that will be used if another is not is specified.

If `USE_FILE` is `true`, the config will be set up to read M3U and XML from files rather than letting telly retrieve them from the internet.  Those files will be retrieved before the docker container is launched.  The rationale there is to allow testing to see if something is related to the content of the M3U or telly's retrieval of it.  The files will be named using the configured provider name.

Some entries are not used for anything yet [Schedules-Direct, the EPG URLs].

The build-in `sed` command on Mac OS X doesn't support the "-i" option, `gsed` does.  The config script will automagically select one or the other based on the platform you're on.

This file is executed by the other scripts and accepts one parameter, a filter string.  If the filter string is the empty string, the default filter will be used.  If you want to use a filter to include everything, use `.`.

Here, `show_config.sh` with and without a filter specified on the command line: [note, those credentials were randomly generated just now; they are not real]
```
> ./show_config.sh
reading config:
========================================
PROVIDER......... area51
PROVIDER_NAME.... area51
IPTVUSER......... 8UCiNYzugjSV
IPTVPASS......... W46bMsYnm2IY
M3U_URL.......... http://iptv-area-51.tv:2095/get.php?username=8UCiNYzugjSV&password=W46bMsYnm2IY&output=ts&type=m3u_plus
XML_URL.......... http://iptv-area-51.tv:2095/xmltv.php?username=8UCiNYzugjSV&password=W46bMsYnm2IY&output=ts&type=m3u_plus
SEDCMD........... gsed
MYIP............. 192.168.1.61
DEFAULT_FILTER... USA MOVIE
USE_FILE......... false
M3U_PATH......... /Users/chazlarson/dev/github/telly-testing/area51.m3u
XML_PATH......... /Users/chazlarson/dev/github/telly-testing/area51.xml
M3U_URL_ESC...... http:\/\/iptv-area-51.tv:2095\/get.php?username=8UCiNYzugjSV\&password=W46bMsYnm2IY\&output=ts\&type=m3u_plus
XML_URL_ESC...... http:\/\/iptv-area-51.tv:2095\/xmltv.php?username=8UCiNYzugjSV\&password=W46bMsYnm2IY\&output=ts\&type=m3u_plus
M3U_PATH_ESC..... \/Users\/chazlarson\/dev\/github\/telly-testing\/area51.m3u
XML_PATH_ESC..... \/Users\/chazlarson\/dev\/github\/telly-testing\/area51.xml

> ./show_config.sh TEST_FILTER
reading config:
========================================
PROVIDER......... area51
PROVIDER_NAME.... area51
IPTVUSER......... 8UCiNYzugjSV
IPTVPASS......... W46bMsYnm2IY
M3U_URL.......... http://iptv-area-51.tv:2095/get.php?username=8UCiNYzugjSV&password=W46bMsYnm2IY&output=ts&type=m3u_plus
XML_URL.......... http://iptv-area-51.tv:2095/xmltv.php?username=8UCiNYzugjSV&password=W46bMsYnm2IY&output=ts&type=m3u_plus
SEDCMD........... gsed
MYIP............. 192.168.1.61
DEFAULT_FILTER... TEST_FILTER
USE_FILE......... false
M3U_PATH......... /Users/chazlarson/dev/github/telly-testing/area51.m3u
XML_PATH......... /Users/chazlarson/dev/github/telly-testing/area51.xml
M3U_URL_ESC...... http:\/\/iptv-area-51.tv:2095\/get.php?username=8UCiNYzugjSV\&password=W46bMsYnm2IY\&output=ts\&type=m3u_plus
XML_URL_ESC...... http:\/\/iptv-area-51.tv:2095\/xmltv.php?username=8UCiNYzugjSV\&password=W46bMsYnm2IY\&output=ts\&type=m3u_plus
M3U_PATH_ESC..... \/Users\/chazlarson\/dev\/github\/telly-testing\/area51.m3u
XML_PATH_ESC..... \/Users\/chazlarson\/dev\/github\/telly-testing\/area51.xml
```

## Usage

>NOTE: These scripts are using egrep or sed to process the regex.  telly uses go regex, so there may be differences in the regex processing.  Typically, the regex being used in telly are pretty simple [this OR that OR the other] so this works well enough.

At initial commit all of these count and list scripts are configured only for filtering on "group-title", telly's default.   A filter string can be provided as a parameter; if it's not provided the filter in the config file will be used.  If that filter contains anything besides letters [spaces, |], it must be wrapped in quotes.
  
`channel_count.sh`

Applies a filter to your M3U and reports the channel count.

```
➜  ./channel_count.sh
Platform: darwin17
SEDCMD: gsed
Using default filter: USA|UK
    1139
    
➜  ./channel_count.sh IRISH
Platform: darwin17
SEDCMD: gsed
Using filter: IRISH
      14
```

`channel_list.sh`

Applies a filter to your M3U and reports the channel list.  Each line contains the channel and the group it came from, tab-separated if you want to copy-paste it into Excel or the like.

```
➜  ./channel_list.sh | head
Platform: darwin17
SEDCMD: gsed
Using default filter: USA
A&E	USA ENTERTAINMENT
A&E low bandwith	USA ENTERTAINMENT
ABC	USA ENTERTAINMENT
ABC News	USA NEWS NETWORKS
ABC West	USA ENTERTAINMENT
AL JAZEERA NEWS ENGLISH	USA NEWS NETWORKS
AMC	USA ENTERTAINMENT
AMC Low Bandwith	USA ENTERTAINMENT
Adult Swim	USA ENTERTAINMENT

➜  ./channel_list.sh IRISH | head
Platform: darwin17
SEDCMD: gsed
Using filter: IRISH
IRE: AT THE RACES SD	IRISH
IRE: EIR SPORTS 1 FHD	IRISH
IRE: EIR SPORTS 1 SD	IRISH
IRE: EIR SPORTS 2 FHD	IRISH
IRE: EIR SPORTS 2 SD	IRISH
IRE: OIREACHTAS SD	IRISH
IRE: PBS America	IRISH
IRE: PREMIER SPORTS HD	IRISH
IRE: RACING UK SD	IRISH
```

`channels.sh`

Just runs the previous two scripts:

```
➜  ./channels.sh | head
Platform: darwin17
SEDCMD: gsed
Using default filter: USA
     618
A&E	USA ENTERTAINMENT
A&E low bandwith	USA ENTERTAINMENT
ABC	USA ENTERTAINMENT
ABC News	USA NEWS NETWORKS
ABC West	USA ENTERTAINMENT
AL JAZEERA NEWS ENGLISH	USA NEWS NETWORKS
AMC	USA ENTERTAINMENT
AMC Low Bandwith	USA ENTERTAINMENT

➜  ./channels.sh IRISH | head
Platform: darwin17
SEDCMD: gsed
Using filter: IRISH
      20
IRE: AT THE RACES SD	IRISH
IRE: EIR SPORTS 1 FHD	IRISH
IRE: EIR SPORTS 1 SD	IRISH
IRE: EIR SPORTS 2 FHD	IRISH
IRE: EIR SPORTS 2 SD	IRISH
IRE: OIREACHTAS SD	IRISH
IRE: PBS America	IRISH
IRE: PREMIER SPORTS HD	IRISH
```

`group_count.sh`

Applies a filter to your M3U and reports the group count.

```
➜  ./group_count.sh
Platform: darwin17
SEDCMD: gsed
Using default filter: USA|UK
      17
      
➜  ./group_count.sh IRISH
Platform: darwin17
SEDCMD: gsed
Using filter: IRISH
       1
```

`group_list.sh`

Applies a filter to your M3U and reports the group list.

```
➜  ./group_list.sh | head
Platform: darwin17
SEDCMD: gsed
Using default filter: USA|UK
PREMIUM USA NETWORKS
PREMIUM USA SPORTS NETWORKS
UK DOCUMENTARIES
UK ENTERTAINMENT
UK KIDS NETWORKS
UK MOVIE NETWORKS
UK NEWS NETWORKS
UK SPORTS NETWORKS
UK VIP HD/FHD

➜  ./group_list.sh IRISH | head
Platform: darwin17
SEDCMD: gsed
Using filter: IRISH
IRISH
```

`groups.sh`

Runs the previous two scripts:

```
➜  ./groups.sh
Platform: darwin17
SEDCMD: gsed
Using default filter: USA
       9
PREMIUM HD USA NETWORKS
PREMIUM USA SPORTS NETWORKS
USA & CANADA SPORTS
USA ENTERTAINMENT
USA KIDS NETWORKS
USA MOVIE NETWORKS
USA NEWS NETWORKS
VIP USA ENTERTAINMENT
VIP USA SPORTS NETWORKS

➜  ./groups.sh IRISH
Platform: darwin17
SEDCMD: gsed
Using filter: IRISH
       1
IRISH
```

`m3u.sh`

Convenience script to retrieve the m3u; it redacts the username and password in the output.

```
➜  ./m3u.sh | head
Platform: darwin17
SEDCMD: gsed
Using default filter: USA|UK
#EXTM3U
#EXTINF:-1 tvg-id="btsport1.uk" tvg-name="VIP BT Sports 1 HD" tvg-logo="http://picon.helixhosting.ninja/30926.png" group-title="UK VIP HD/FHD",VIP BT Sports 1 HD
http://irislinks.net:83/live/REDACTED/REDACTED/303855.ts
#EXTINF:-1 tvg-id="btsport1.uk" tvg-name="VIP BT Sports 1 FHD" tvg-logo="http://picon.helixhosting.ninja/30929.png" group-title="UK VIP HD/FHD",VIP BT Sports 1 FHD
http://irislinks.net:83/live/REDACTED/REDACTED/303858.ts
#EXTINF:-1 tvg-id="btsport2.uk" tvg-name="VIP BT Sports 2 HD" tvg-logo="http://picon.helixhosting.ninja/30925.png" group-title="UK VIP HD/FHD",VIP BT Sports 2 HD
http://irislinks.net:83/live/REDACTED/REDACTED/303854.ts
#EXTINF:-1 tvg-id="btsport2.uk" tvg-name="VIP BT Sports  2 FHD" tvg-logo="http://picon.helixhosting.ninja/30930.png" group-title="UK VIP HD/FHD",VIP BT Sports  2 FHD
http://irislinks.net:83/live/REDACTED/REDACTED/303859.ts
```

`m3u-stock.sh`

Convenience script to retrieve the m3u; it DOES NOT REDACT the username and password in the output.

Used to retrieve this data to a file if `USE_FILE=true`.

`xml-stock.sh`

Convenience script to retrieve the epg xml.

Used to retrieve this data to a file if `USE_FILE=true`.

`show-config.sh`

Convenience script to echo the config.  It will load the config before displaying it.

```
➜  ./show_config.sh
PROVIDER......... Custom
PROVIDER_NAME.... Iris-Custom
USER............. 11111111
PASS............. 22222222
M3U_URL.......... http://irislinks.net:83/gets.php?username=11111111&password=22222222&type=m3u_plus&output=ts
XML_URL.......... http://irislinks.net:83/xmltv.php?username=11111111&password=22222222
SEDCMD........... gsed
MYIP............. 192.168.1.61
DEFAULT_FILTER... US|PPV|HBO|NBA|MLB|NFL|NHL|SPORTS|ESPN
USE_FILE......... true
M3U_PATH......... /Users/USER/dev/github/telly-testing/Iris.m3u
XML_PATH......... /Users/USER/dev/github/telly-testing/Iris.xml
M3U_URL_ESC...... http:\/\/irislinks.net:83\/gets.php?username=11111111\&password=22222222\&type=m3u_plus\&output=ts
XML_URL_ESC...... http:\/\/irislinks.net:83\/xmltv.php?username=11111111\&password=22222222
M3U_PATH_ESC..... \/Users\/USER\/dev\/github\/telly-testing\/Iris.m3u
XML_PATH_ESC..... \/Users\/USER\/dev\/github\/telly-testing\/Iris.xml
```

`go.sh`

Reads config, cleans out existing telly docker containers, build up docker.sh and telly.config.toml from the templates, and starts the docker container.
As above, a filter string can be provided as a parameter; if it's not provided the filter in the config file will be used.

```
➜  telly-testing git:(master) ✗ ./go.sh .
reading config:
========================================
PROVIDER......... Custom
PROVIDER_NAME.... Iris-Custom
USER............. 11111111
PASS............. 
M3U_URL.......... http://irislinks.net:83/gets.php?username=11111111&password=22222222&type=m3u_plus&output=ts
XML_URL.......... http://irislinks.net:83/xmltv.php?username=11111111&password=22222222
SEDCMD........... gsed
MYIP............. 192.168.1.61
DEFAULT_FILTER... .
USE_FILE......... true
M3U_PATH......... /Users/USER/dev/github/telly-testing/Iris.m3u
XML_PATH......... /Users/USER/dev/github/telly-testing/Iris.xml
M3U_URL_ESC...... http:\/\/irislinks.net:83\/gets.php?username=11111111\&password=22222222\&type=m3u_plus\&output=ts
XML_URL_ESC...... http:\/\/irislinks.net:83\/xmltv.php?username=11111111\&password=22222222
M3U_PATH_ESC..... \/Users\/USER\/dev\/github\/telly-testing\/Iris.m3u
XML_PATH_ESC..... \/Users\/USER\/dev\/github\/telly-testing\/Iris.xml


cleaning up existing telly dockers:
========================================
a4d128dc32b3
Deleted Containers:
a4d128dc32b3798b0d678d069be7c67f34e32dc9ecebc83c218a9558edc3a316

Total reclaimed space: 0B


setting up config files and scripts...


cleaning up and retrieving data files:
========================================


building and running docker container:
========================================
c13ce0ce488bde70ff3db6d78ef7a7b6b4ea70598a5eef6b3ab2ce72d5fd1397
time="2018-12-07T20:08:24Z" level=info msg="telly is preparing to go live (version=, branch=, revision=)"
time="2018-12-07T20:08:24Z" level=debug msg="Build context (go=go1.11, user=, date=)"
time="2018-12-07T20:08:24Z" level=debug msg="Loaded configuration {\n    \"config\": {\n        \"file\": \"\"\n    },\n    \"discovery\": {\n        \"device-auth\": \"telly123\",\n        \"device-firmware-name\": \"hdhomeruntc_atsc\",\n        \"device-firmware-version\": \"20150826\",\n        \"device-friendly-name\": \"HDHomerun (telly)\",\n        \"device-id\": 12345678,\n        \"device-manufacturer\": \"Silicondust\",\n        \"device-model-number\": \"HDTC-2US\",\n        \"device-uuid\": \"12345678-AE2A-4E54-BBC9-33AF7D5D6A92\",\n        \"ssdp\": true\n    },\n    \"filter\": {\n        \"regex\": \".*\",\n        \"regex-inclusive\": false\n    },\n    \"iptv\": {\n        \"ffmpeg\": true,\n        \"playlist\": \"\",\n        \"starting-channel\": 10000,\n        \"streams\": 1,\n        \"xmltv-channels\": true\n    },\n    \"log\": {\n        \"level\": \"debug\",\n        \"requests\": true\n    },\n    \"source\": [\n        {\n            \"EPG\": \"/etc/telly/Iris-Custom.xml\",\n            \"Filter\": \".\",\n            \"FilterKey\": \"group-title\",\n            \"FilterRaw\": false,\n            \"M3U\": \"/etc/telly/Iris-Custom.m3u\",\n            \"Name\": \"Iris-Custom\",\n            \"Password\": \"22222222\",\n            \"Provider\": \"Custom\",\n            \"Sort\": \"group-title\",\n            \"Username\": \"11111111\"\n        }\n    ],\n    \"version\": false,\n    \"web\": {\n        \"base-address\": \"192.168.1.61:6077\",\n        \"listen-address\": \"0.0.0.0:6077\"\n    }\n}"
time="2018-12-07T20:08:24Z" level=info msg="Loading M3U from /etc/telly/Iris-Custom.m3u"
time="2018-12-07T20:08:24Z" level=info msg="Loading XMLTV from /etc/telly/Iris-Custom.xml"

MUCH DEBUG CHANNEL PROCESSING DELETED

time="2018-12-07T20:08:51Z" level=info msg="Loaded 15995 channels into the lineup from Iris-Custom"
time="2018-12-07T20:08:51Z" level=panic msg="telly has loaded more than 420 channels (15995) into the lineup. Plex does not deal well with more than this amount and will more than likely hang when trying to fetch channels. You must use regular expressions to filter out channels. You can also start another Telly instance."
panic: (*logrus.Entry) (0xbfaf80,0xc004122c30)

goroutine 1 [running]:
github.com/tellytv/telly/vendor/github.com/sirupsen/logrus.Entry.log(0x127f3e0, 0xc0156ca6f0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, ...)
	/go/src/github.com/tellytv/telly/vendor/github.com/sirupsen/logrus/entry.go:126 +0x2a7
github.com/tellytv/telly/vendor/github.com/sirupsen/logrus.(*Entry).Panic(0xc00a7b3db0, 0xc0199efb98, 0x1, 0x1)
	/go/src/github.com/tellytv/telly/vendor/github.com/sirupsen/logrus/entry.go:194 +0xb2
github.com/tellytv/telly/vendor/github.com/sirupsen/logrus.(*Entry).Panicf(0xc00a7b3db0, 0xc386b6, 0x112, 0xc0199efc58, 0x1, 0x1)
	/go/src/github.com/tellytv/telly/vendor/github.com/sirupsen/logrus/entry.go:242 +0xed
github.com/tellytv/telly/vendor/github.com/sirupsen/logrus.(*Logger).Panicf(0x127f3e0, 0xc386b6, 0x112, 0xc0199efc58, 0x1, 0x1)
	/go/src/github.com/tellytv/telly/vendor/github.com/sirupsen/logrus/logger.go:181 +0x85
main.(*lineup).Scan(0xc0002551c0, 0xc1e55f, 0x17)
	/go/src/github.com/tellytv/telly/lineup.go:141 +0x15e
main.main()
	/go/src/github.com/tellytv/telly/main.go:169 +0xbe7
```

You can often find me in the [telly discord](https://discord.gg/BSYY97X).

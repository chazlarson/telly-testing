# telly-testing
These are some simple test scripts I use for [telly](https://github.com/tellytv/telly). They are pretty braindead, but do what I wanted done.

`config.example`

make a copy of this file, called `config`, fill in details as required and uncomment one of the provider sections.  There are skeletons for Iris, Area51, Vaders.

Some entries are not used for anything yet.

The build-in sed command on Mac OS X doesn't support the "-i" option, `gsed` does.

This file is `source`ed by the other scripts and accepts two parameters. The first is a filter string, the second can be anything and just quiets the report of what filter is being used.

`channel_count.sh`

Applies a filter to your M3U and reports the channel count.  At initial commit it's configured only for filtering on "group-title".
A filter string can be provided as a parameter; if it's not provided the filter in the config file will be used.

```
➜  ./channel_count.sh
Using default filter: USA|UK
    1139
➜  ./channel_count.sh IRISH
Using filter: IRISH
      14
```

`channel_list.sh`

Applies a filter to your M3U and reports the channel list.  At initial commit it's configured only for filtering on "group-title".
As above, a filter string can be provided as a parameter; if it's not provided the filter in the config file will be used.

```
➜  ./channel_list.sh | head
Using default filter: USA|UK
A&E
A&E Backup
ABC
ABC News
ABC West
AL JAZEERA NEWS ENGLISH
AMC
AMC Low Bandwith
Adult Swim
➜  ./channel_list.sh IRISH | head
Using filter: IRISH
3E UK
EIR 3p0rt1 2 HD
IR: EIR Sports 1
IRISH: PBS America
IRISH: RTE 1 HD
IRISH: RTE 2 HD
IRISH: Sony Crime
IRISH: TG4
IRISH: TV 3 HD
```

`group_count.sh`

Applies a filter to your M3U and reports the group count.  At initial commit it's configured only for filtering on "group-title".
As above, a filter string can be provided as a parameter; if it's not provided the filter in the config file will be used.

```
➜  ./group_count.sh
Using default filter: USA|UK
      17
➜  ./group_count.sh IRISH
Using filter: IRISH
       1
```
`group_list.sh`

Applies a filter to your M3U and reports the group list.  At initial commit it's configured only for filtering on "group-title".
As above, a filter string can be provided as a parameter; if it's not provided the filter in the config file will be used.

```
➜  ./group_list.sh | head
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
Using filter: IRISH
IRISH
```

`m3u.sh`

Convenience script to retrieve the m3u; it redacts the username and password in the output.

```
➜  telly-test-harness ./m3u.sh | head
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

`go.sh`

Reads config, cleans out existing telly docker containers, build up docker.sh and telly.config.toml from the templates, and starts the docker container.
As above, a filter string can be provided as a parameter; if it's not provided the filter in the config file will be used.

```
➜  telly-test-harness ./go.sh
reading config:
========================================
Using default filter: USA|UK


cleaning up existing telly dockers:
========================================
780c4080a2b7
Deleted Containers:
780c4080a2b7ffab3beac9e4ddd110912234b884e0389936ee4c776ffa923712

Total reclaimed space: 0B


setting up config files and scripts...


preflighting filters:
========================================
group count:         17
channel count:     1139


building and running docker container:
========================================
0bae26a798cf75fe42d647448fd8ffd5cc8e308b3042cf947ed6fcbc12898262
time="2018-10-19T16:56:20Z" level=info msg="telly is preparing to go live (version=, branch=, revision=)"
time="2018-10-19T16:56:20Z" level=info msg="Loading M3U from http://irislinks.net:83/get.php?username=REDACTED&password=REDACTED&type=m3u_plus&output=ts"
time="2018-10-19T16:56:21Z" level=info msg="Loading XMLTV from http://irislinks.net:83/xmltv.php?username=REDACTED&password=REDACTED"
time="2018-10-19T16:56:30Z" level=info msg="Loaded 1139 channels into the lineup from Iris"
time="2018-10-19T16:56:30Z" level=panic msg="telly has loaded more than 420 channels (1139) into the lineup. Plex does not deal well with more than this amount and will more than likely hang when trying to fetch channels. You must use regular expressions to filter out channels. You can also start another Telly instance."
panic: (*logrus.Entry) (0xbfaf80,0xc0005be000)

goroutine 1 [running]:
github.com/tellytv/telly/vendor/github.com/sirupsen/logrus.Entry.log(0x127f3e0, 0xc0003011d0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, ...)
	/go/src/github.com/tellytv/telly/vendor/github.com/sirupsen/logrus/entry.go:126 +0x2a7
github.com/tellytv/telly/vendor/github.com/sirupsen/logrus.(*Entry).Panic(0xc00165df40, 0xc013505b98, 0x1, 0x1)
	/go/src/github.com/tellytv/telly/vendor/github.com/sirupsen/logrus/entry.go:194 +0xb2
github.com/tellytv/telly/vendor/github.com/sirupsen/logrus.(*Entry).Panicf(0xc00165df40, 0xc386b6, 0x112, 0xc013505c58, 0x1, 0x1)
	/go/src/github.com/tellytv/telly/vendor/github.com/sirupsen/logrus/entry.go:242 +0xed
github.com/tellytv/telly/vendor/github.com/sirupsen/logrus.(*Logger).Panicf(0x127f3e0, 0xc386b6, 0x112, 0xc013505c58, 0x1, 0x1)
	/go/src/github.com/tellytv/telly/vendor/github.com/sirupsen/logrus/logger.go:181 +0x85
main.(*lineup).Scan(0xc0000bb680, 0x15, 0xae1700)
	/go/src/github.com/tellytv/telly/lineup.go:141 +0x15e
main.main()
	/go/src/github.com/tellytv/telly/main.go:169 +0xbe7
```

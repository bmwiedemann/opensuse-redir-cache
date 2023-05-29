# Why

Speed up openSUSE downloads,
similar to https://github.com/Firstyear/opensuse-proxy-cache

# Assumtions

* traffic is plenty and cheap - e.g. you run this in your LAN

# How

* keep alive HTTP connections to relevant servers to allow to fetch small files in 1 RTT
* avoid added latency from external MirrorCache redirectors - instead we do a quick on-the-fly mirror scan ourselves
* avoid added latency from round-trips to Nuremberg main server - we only ever talk to closeby mirrors - except at start to find these mirrors
* cache files smaller than N KiB ; e.g. 70% of Tumbleweed rpms are below 200 KiB and together only take up 2 GiB of storage. This helps, if you have multiple openSUSE machines

Requests go zypper -> cache -> redirector -> mirrors|download.o.o

This redirector needs to
* fetch a list of closeby mirrors once from regional mirrorcache
* do parallel GET+HEAD requests to different mirrors
* optional: parse primary.xml to know which files are small and get these from CDN directly (if faster than mirrors)
* optional: track file-availability and performance of mirrors to send more GET requests to the best one and fewer HEAD requests overall if everything works fine

# Usage

    http_proxy=http://localhost:8000/ zypper up



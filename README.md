# Why

Speed up openSUSE downloads,
similar to https://github.com/Firstyear/opensuse-proxy-cache

# Assumtions

* traffic is plenty and cheap - e.g. you run this in your LAN

# How

* keep alive HTTP connections to relevant servers to allow to fetch small files in 1 RTT
* avoid added latency from external MirrorCache redirectors - instead we do a quick on-the-fly mirror scan ourselves
* cache files smaller than N KiB ; e.g. 70% of Tumbleweed rpms are below 200 KiB and together only take up 2 GiB of storage. This helps, if you have multiple openSUSE machines

# Usage

    http_proxy=http://localhost:8000/ zypper up



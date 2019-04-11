# oxlade39/piattransmissionportwatch

Watch the files produced by [oxlade39/piaportforward](https://github.com/oxlade39/piaportforward) for a change in the forwarded port. Update [Trasmission](https://transmissionbt.com/) with the new port automatically.

[![](https://images.microbadger.com/badges/image/oxlade39/piattransmissionportwatch.svg)](https://microbadger.com/images/oxlade39/piattransmissionportwatch "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/oxlade39/piattransmissionportwatch.svg)](https://microbadger.com/images/oxlade39/piattransmissionportwatch "Get your own version badge on microbadger.com")

[![Docker Build Status](https://img.shields.io/docker/cloud/build/oxlade39/piattransmissionportwatch.svg)](https://hub.docker.com/r/oxlade39/piattransmissionportwatch)

[![GitHub last commit](https://img.shields.io/github/last-commit/oxlade39/piattransmissionportwatch.svg)](https://github.com/oxlade39/piattransmissionportwatch/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/oxlade39/piattransmissionportwatch.svg)](https://github.com/oxlade39/piattransmissionportwatch/issues)
[![GitHub issues](https://img.shields.io/github/issues/oxlade39/piattransmissionportwatch.svg)](https://github.com/oxlade39/piattransmissionportwatch/issues)

[![Docker Pulls](https://img.shields.io/docker/pulls/oxlade39/piattransmissionportwatch.svg)](https://hub.docker.com/r/oxlade39/piattransmissionportwatch)
[![Docker Stars](https://img.shields.io/docker/stars/oxlade39/piattransmissionportwatch.svg)](https://hub.docker.com/r/oxlade39/piattransmissionportwatch)
[![Docker Automated](https://img.shields.io/docker/cloud/automated/oxlade39/piattransmissionportwatch.svg)](https://hub.docker.com/r/oxlade39/piattransmissionportwatch)

## Getting Started

Combined with [oxlade39/piaportforward](https://github.com/oxlade39/piaportforward) this will automatically update your transmission port for best download/upload speeds.

### Prerequisities

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Usage

#### docker

```shell
docker run --rm -e "TRANSMISSION=transmission-docker:9091" -v /config/pia:/config:ro --name portwatch oxlade39/piattransmissionportwatch
```

#### docker-compose

```yaml
version: '3'

networks:
    pia:
      driver: bridge
      ipam:
        config:
          - subnet: 172.20.0.0/24

services:
  portwatch:
    image: oxlade39/piattransmissionportwatch
    container_name: portwatch
    environment:
      - TRANSMISSION=transmission-host:9091
    volumes:
      - /config/pia:/config

  pia:
    image: oxlade39/piaportforward
    container_name: pia
    environment:
      - REGION=France
    networks:
      pia:
        ipv4_address: 172.20.0.5
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun
    volumes:
      - /config/pia/.credentials:/etc/openvpn/pia/pass:ro
      - /config/pia:/config
    restart: unless-stopped

```
#### Environment Variables

* `TRANSMISSION` - The hostname:port of the transmission service.

#### Volumes

* `/config` - The location of the files written to by oxlade39/piaportforward. Can be readonly.

#### Useful File Locations

* `/config/vpnportfw` - The exoected location of the file containing the opened port available for port forwarding.

## Find Us

* [GitHub](https://github.com/oxlade39/piattransmissionportwatch)

## How it works

This image is a companion to [oxlade39/piaportforward](https://github.com/oxlade39/piaportforward). Relying on an overlapping mounted volume.
[oxlade39/piaportforward](https://github.com/oxlade39/piaportforward) will write to `/config/vpnportfw` when it successfully establishs a VPN connection with port forwarding.

This image will watch for changes to that file and use [transmission-remote](https://linux.die.net/man/1/transmission-remote) to update the port.

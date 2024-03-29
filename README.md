# Docker container for ps3netsrv
[![Docker Automated build](https://img.shields.io/docker/automated/akit042/ps3netsrv.svg)](https://hub.docker.com/r/akit042/ps3netsrv/) [![Docker Image](https://images.microbadger.com/badges/image/akit042/ps3netsrv.svg)](http://microbadger.com/#/images/akit042/ps3netsrv)

This is a Docker container for ps3netsrv.

---

[![ps3netsrv logo](https://images.weserv.nl/?url=raw.githubusercontent.com/DisasteR/docker-ps3netsrv/master/ps3netsrv-icon.png&w=200)](https://github.com/aldostools/webMAN-MOD)[![ps3netsrv](https://dummyimage.com/400x110/ffffff/575757&text=ps3netsrv)](https://github.com/aldostools/webMAN-MOD)

ps3netsrv for WebMAN-MOD

---
## Table of Content

   * [Docker container for ps3netsrv](#docker-container-for-ps3netsrv)
      * [Table of Content](#table-of-content)
      * [Quick Start](#quick-start)
      * [Usage](#usage)
         * [Environment Variables](#environment-variables)
         * [Data Volumes](#data-volumes)
         * [Ports](#ports)
      * [User/Group IDs](#usergroup-ids)
      * [Support or Contact](#support-or-contact)

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example
and parameters should be adjusted to your need.

Launch the ps3netsrv docker container with the following command:
```
docker run -d \
    --name=ps3netsrv \
    -p 38008:38008 \
    -v $PWD:/games:rw \
    akit042/ps3netsrv
```

Where:
  - `$PWD`: This location contains files from your host that need to be accessible by the application.


## Usage

```
docker run [-d] \
    --name=ps3netsrv \
    [-e <VARIABLE_NAME>=<VALUE>]... \
    [-v <HOST_DIR>:<CONTAINER_DIR>[:PERMISSIONS]]... \
    [-p <HOST_PORT>:<CONTAINER_PORT>]... \
    akit042/ps3netsrv
```
| Parameter | Description |
|-----------|-------------|
| -d        | Run the container in background.  If not set, the container runs in foreground. |
| -e        | Pass an environment variable to the container.  See the [Environment Variables](#environment-variables) section for more details. |
| -v        | Set a volume mapping (allows to share a folder/file between the host and the container).  See the [Data Volumes](#data-volumes) section for more details. |
| -p        | Set a network port mapping (exposes an internal container port to the host).  See the [Ports](#ports) section for more details. |

### Environment Variables

To customize some properties of the container, the following environment
variables can be passed via the `-e` parameter (one for each variable).  Value
of this parameter has the format `<VARIABLE_NAME>=<VALUE>`.

| Variable       | Description                                  | Default |
|----------------|----------------------------------------------|---------|
|`PUID`| ID of the user the application runs as.  See [User/Group IDs](#usergroup-ids) to better understand when this should be set. | `911` |
|`PGID`| ID of the group the application runs as.  See [User/Group IDs](#usergroup-ids) to better understand when this should be set. | `911` |
|`TZ`| [TimeZone] of the container.  Timezone can also be set by mapping `/etc/localtime` between the host and the container. | `Etc/UTC` |

### Data Volumes

The following table describes data volumes used by the container.  The mappings
are set via the `-v` parameter.  Each mapping is specified with the following
format: `<HOST_DIR>:<CONTAINER_DIR>[:PERMISSIONS]`.

| Container path  | Permissions | Description |
|-----------------|-------------|-------------|
|`/games`| rw | This is the path ps3netsrv will serve to clients. |

### Ports

Here is the list of ports used by the container.  They can be mapped to the host
via the `-p` parameter (one per port mapping).  Each mapping is defined in the
following format: `<HOST_PORT>:<CONTAINER_PORT>`.  The port number inside the
container cannot be changed, but you are free to use any port on the host side.

| Port | Mapping to host | Description |
|------|-----------------|-------------|
| 38008 | Mandatory | Port used for ps3netsrv. |

## User/Group IDs

When using data volumes (`-v` flags), permissions issues can occur between the
host and the container.  For example, the user within the container may not
exists on the host.  This could prevent the host from properly accessing files
and folders on the shared volume.

To avoid any problem, you can specify the user the application should run as.

This is done by passing the user ID and group ID to the container via the
`PUID` and `PGID` environment variables.

To find the right IDs to use, issue the following command on the host, with the
user owning the data volume on the host:

    id <username>

Which gives an output like this one:
```
uid=1000(myuser) gid=1000(myuser) groups=1000(myuser),4(adm),24(cdrom),27(sudo),46(plugdev),113(lpadmin)
```

The value of `uid` (user ID) and `gid` (group ID) are the ones that you should
be given the container.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

[create a new issue]: https://github.com/akit042/docker-ps3netsrv/issues

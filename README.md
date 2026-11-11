<div align="center">

<img src="snap/gui/sftpgo.png" alt="SFTPGo logo" width="128" />

# SFTPGo

**Transfer files over SFTP, HTTP/S, FTP/S and WebDAV.**

[![sftpgo](https://snapcraft.io/sftpgo/badge.svg)](https://snapcraft.io/sftpgo)
[![Base: core26](https://img.shields.io/badge/Base-core26-2C8C3C?logo=canonical&logoColor=white)](https://snapcraft.io/core26)
![Confinement: strict](https://img.shields.io/badge/Confinement-strict-2C8C3C)
[![Maintainer: sidaliteir](https://img.shields.io/badge/Maintainer-sidaliteir-2C8C3C?logo=snapcraft&logoColor=white)](https://snapcraft.io/publisher/sidaliteir)
![Architectures: amd64 and arm64](https://img.shields.io/badge/Architectures-amd64%20%7C%20arm64-2C8C3C?logo=linux&logoColor=white)

[Getting Started](#getting-started) · [Configure](#configure) · [Limitations](#limitations) · [Build](#build) · [Support](#support) · [License](#license)

Unofficial snap packaging for [SFTPGo](https://github.com/drakkan/sftpgo), a file transfer server with local and cloud storage, a web administration interface, a web client and a REST API.

</div>

---

## Getting Started

<a href="https://snapcraft.io/sftpgo"><img alt="Get it from the Snap Store" src="https://snapcraft.io/en/dark/install.svg" width="180"></a>

```bash
sudo snap install sftpgo
sudo cat /var/snap/sftpgo/common/credentials/installation-code
```

The service starts automatically. Open [http://127.0.0.1:8080/web/admin](http://127.0.0.1:8080/web/admin) and create the first administrator with that installation code. For a remote server, run `ssh -L 8080:127.0.0.1:8080 user@server` and open the same URL.

Add users in the web admin, then connect with any SFTP client:

```bash
sftp -P 2022 alice@server
```

SFTP listens on all interfaces from the start; nobody can sign in until you create a user. The web admin, the web client (`/web/client`) and the REST API (`/api/v2`) listen on this machine only until you change `http-address`.

## Configure

| Setting | Accepted values | Default |
| --- | --- | --- |
| `sftp-address` | `host:port`, `[IPv6]:port` or `:port` for all interfaces; port `1`–`65535` | `:2022` |
| `http-address` | Same as `sftp-address` | `127.0.0.1:8080` |
| `ftp-address` | Same as `sftp-address`; FTP is disabled while unset | Unset |
| `webdav-address` | Same as `sftp-address`; WebDAV is disabled while unset | Unset |
| `users-base-dir` | Folder under `/var/snap/sftpgo/common`, `/media`, `/mnt` or `/run/media` | `/var/snap/sftpgo/common/data` |

```bash
sudo snap get sftpgo
sudo snap set sftpgo http-address=:8080
```

Changes restart the service. `sudo snap unset sftpgo http-address` restores a default. Ports below 1024 can be used when no other service holds them. FTP also opens passive ports `50000`–`50100` for transfers. Use HTTPS, through a reverse proxy or SFTPGo's own TLS settings, before opening the web interfaces to a network.

A new user gets a folder in `users-base-dir` unless you give the user another home directory; existing users keep theirs. For an external drive, use a folder owned by root:

```bash
sudo snap connect sftpgo:removable-media
sudo mkdir -p /mnt/disk1/sftpgo
sudo snap set sftpgo users-base-dir=/mnt/disk1/sftpgo
```

All other [upstream settings](https://docs.sftpgo.com/2.7/config-file/) go in `/var/snap/sftpgo/common/sftpgo.json`, which may hold only the keys you change, or as [environment variables](https://docs.sftpgo.com/2.7/env-vars/) in files under `/var/snap/sftpgo/common/env.d`. Run `sudo snap restart sftpgo.daemon` after editing. The snap options take precedence over these files for `users_base_dir` and for the address and port of each service's first binding; further bindings are kept. For example, this `env.d/admin.env` creates the first administrator at the next start, without the web page; delete the file afterwards:

```
SFTPGO_DATA_PROVIDER__CREATE_DEFAULT_ADMIN=true
SFTPGO_DEFAULT_ADMIN_USERNAME=admin
SFTPGO_DEFAULT_ADMIN_PASSWORD=choose-a-password
```

Data lives under `/var/snap/sftpgo/common`:

| Path | Contents |
| --- | --- |
| `sftpgo.db` | Users, groups, shares and settings made in the web admin |
| `data` | Users' files |
| `id_rsa`, `id_ecdsa`, `id_ed25519` | SSH host keys |
| `backups` | Backups made in the web admin |
| `sftpgo.json`, `env.d` | Additional configuration |

With `sudo`, the `sftpgo` command works on the service's configuration. Stop the service before commands that open the database:

```bash
sudo snap stop sftpgo.daemon
sudo sftpgo resetpwd --admin admin
sudo snap start sftpgo.daemon
```

Without `sudo`, `sftpgo portable -d ~/Public` shares one folder, read-only unless you add permissions, with generated credentials.

## Limitations

- The service reads and writes only under `/var/snap/sftpgo/common` and, once `removable-media` is connected, `/media`, `/mnt` and `/run/media`. Home directories and other host paths are unavailable, also for certificates and keys named in the configuration.
- The service runs as root inside the sandbox, and SFTPGo logs a warning about it at each start. Stored files always belong to root: the UID and GID of a user and `chown` requests from clients are not applied, and folders on external drives must be owned by root.
- Programs used as hooks, event commands or plugins must be stored where the service can read them, for example under `/var/snap/sftpgo/common`. They run inside the sandbox and cannot call host programs such as Python or curl. HTTP hooks are not affected.
- `sftpgo portable` serves folders of your home directory, hidden ones excepted; run it without `sudo`.
- `snap revert` does not roll back the database or users' files. Back up before upgrades.

## Build

```bash
git clone https://github.com/sidalit/sftpgo-snap.git
cd sftpgo-snap
sudo snap install snapcraft --classic
snapcraft pack
```

## Support

- **Installation or snap issues:** [open a packaging issue](https://github.com/sidalit/sftpgo-snap/issues).
- **Application bugs:** [report them upstream](https://github.com/drakkan/sftpgo/issues).

## License

Snap packaging: [MIT](https://github.com/sidalit/sftpgo-snap/blob/main/LICENSE).

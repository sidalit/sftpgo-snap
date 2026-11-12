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

The service starts automatically. Open [http://127.0.0.1:8080/web/admin](http://127.0.0.1:8080/web/admin), create the first administrator with the installation code above, then add users and connect with any SFTP client, for example `sftp -P 2022 alice@server`.

SFTP listens on all interfaces, but nobody can sign in until you create a user. The web admin, the web client and the REST API stay on this machine until you change `http-address`.

## Configure

| Setting | Accepted values | Default |
| --- | --- | --- |
| `sftp-address` | `host:port`, `[IPv6]:port` or `:port` | `:2022` |
| `http-address` | Same as `sftp-address` | `127.0.0.1:8080` |
| `ftp-address` | Same; FTP is off while unset | Unset |
| `webdav-address` | Same; WebDAV is off while unset | Unset |
| `users-base-dir` | Folder under `/var/snap/sftpgo/common`, `/media`, `/mnt` or `/run/media` | `/var/snap/sftpgo/common/data` |

```bash
sudo snap set sftpgo http-address=:8080
```

Changes restart the service, and `sudo snap unset sftpgo <setting>` restores a default. Put HTTPS in front of the web interfaces before opening them to a network.

To keep users' files on an external drive, connect removable media and point `users-base-dir` at a folder owned by root:

```bash
sudo snap connect sftpgo:removable-media
sudo snap set sftpgo users-base-dir=/mnt/disk1/sftpgo
```

## Limitations

- The service reaches only `/var/snap/sftpgo/common` and, with `removable-media` connected, `/media`, `/mnt` and `/run/media`. Home directories and other host paths are unavailable.
- Files are stored as root: per-user UID and GID and client `chown` requests are not applied.
- Hook, event and plugin programs run inside the sandbox and must be stored under `/var/snap/sftpgo/common`; they cannot call host programs. HTTP hooks are not affected.
- `snap revert` does not roll back the database or users' files. Back up before upgrading.

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

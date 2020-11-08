# ike

## What is ike?

A collection of tools developed by Shrew Soft, Inc. to communicate with Open Source VPN servers (e.g. ipsec-tools) as well as some commercial VPN servers

**Disclaimer**: This image is not verified by, affiliated with, or supported by Shrew Soft, Inc.

| Tool | Description |
| - | - |
| iked | Daemon which manages  tun interfaces (*the real vpn client*) |
| ikec | Command-line client to talk to the daemon |
| qikea | Graphical interface to talk to the daemon |

## What can I find here?

A simple and lightweight docker image which contains **iked** and **ikec**. Compiled from scratch to enable LDAP support and based on Debian Stretch 9.

## Where I can get qikea?

On Flathub, upload by me: https://flathub.org/apps/details/net.shrew.ike.qikea

Remember to run iked and qikea both simultaneously.

## How to use this image?

### Running iked

```
docker run -d --name=iked --net=host --privileged -v /etc/resolv.conf:/etc/resolv.conf -v /run:/run beardoverflow/ike
```

| Parameter | Required | Description |
| - | - | - |
| `-d` | No | Run this container on background. Change it to `--rm -it` for foreground |
| `--name` | No | Just the container name |
| `--net=host` | Yes | Show real network interfaces inside of container |
| `--privileged` | Yes | Privileges escalation for administrative tasks |
| `-v /etc/resolv.conf:/etc/resolv.conf` | No |Custom dns servers of your sites overrides your dns configuration |
| `-v /run:/run`  | Yes | Expose the ```/run/ikedi``` socket file for ikec/qikea communication |

### Running ikec

#### Interactive mode

ikec can run in interactive mode. The keyboard's keys are used to navigate between sites, up/down tunnels, show help, etc.

```
docker run --rm -it --name=ikec -v /run:/run -v /home/user/sites:/root/.ike/sites beardoverflow/ike ikec
```

**Warning**: iked must be running before starting. If not, ikec will not work

| Parameter | Required | Description |
| - | - | - |
| `--rm -it` | Yes | Run this container on foreground |
| `--name` | No | Just the container name |
| `-v /run:/run`  | Yes | The ```/run/ikedi``` socket file exposed by iked |
| `-v /home/user/sites:/root/.ike/sites` | Yes | Bind a folder which contains your sites. `/home/user/sites` is your host's folder sites and `/root/.ike/sites` is the container's folder sites |

#### Non-interactive mode

ikec can run in non-interactive mode. You must specify a valid configuration at the startup

```
docker run --rm -it --name=ikec -v /run:/run -v /home/user/sites:/root/.ike/sites beardoverflow/ike ikec -r "My Fancy Site" -u "admin" -p "secretpassword" -a
```

**Warning**: iked must be running before starting. If not, ikec will not work

| Parameter | Required | Description |
| - | - | - |
| `--rm -it` | No | Run this container on foreground. Change it to `-d` for background |
| `--name` | No | Just the container name |
| `-v /run:/run`  | Yes | The ```/run/ikedi``` socket file exposed by iked |
| `-v /home/user/sites:/root/.ike/sites` | Yes | Bind a folder which contains your sites. `/home/user/sites` is your host's folder sites and `/root/.ike/sites` is the container's folder sites |
| `-r "My Fancy Site"` | Yes | Name of site to connect |
| `-u "admin"` | Yes | Username for logging in the site |
| `-p "secretpassword"` | Yes | Password for logging in the site |
| `-a` | Yes | Auto-connect on the startup |

### Running qikea

```
flatpak run net.shrew.ike.qikea
```

**Warning**: iked must be running before starting. If not, qikea will not work
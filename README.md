# wg_config

A simple WireGuard user management script for use on the VPN server. It can generate client configuration files and QR codes (with `qrencode`).

History lesson: this project is forked from [zcutlip/wg_config](https://github.com/zcutlip/wg_config), which is forked from [adrianmihalko/wg_config](https://github.com/adrianmihalko/wg_config) (as part of [adrianmihalko/raspberrypiwireguard](https://github.com/adrianmihalko/raspberrypiwireguard)), which is forked from [faicker/wg-config](https://github.com/faicker/wg-config).

## Dependencies

- wireguard
- qrencode

## Configuration

The script assumes the WireGuard directory is `/etc/wireguard`.

Configuration is done in `wg.def`. A `wg.def.sample` file is provided in this repository.

You can generate the public key and private key with command `wg genkey | tee > prikey | wg pubkey > pubkey`.

## Usage

All commands must be run as root (use `sudo` is logged in as a non-root user).

### Start WireGuard

This script does not automatically start WireGuard on first run, you must do that yourself.

```bash
wg-quick up wg0
```

### Add a user

```bash
./user.sh -a alice
```

This will generate a client conf and qrcode in current directory which name is alice
and add alice to the wg config.

#### delete a user

```bash
./user.sh -d alice
```

This will delete the alice directory and delete alice from the wg config.

#### view a user

```bash
./user.sh -v alice
```

This will show generated QR codes.

#### clear all

```bash
./user.sh -c
```

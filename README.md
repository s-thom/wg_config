# wg_config

A simple WireGuard user management script for use on the VPN server. It can generate client configuration files and QR codes (with `qrencode`).

History lesson: this project is forked from [zcutlip/wg_config](https://github.com/zcutlip/wg_config), which is forked from [adrianmihalko/wg_config](https://github.com/adrianmihalko/wg_config) (as part of [adrianmihalko/raspberrypiwireguard](https://github.com/adrianmihalko/raspberrypiwireguard)), which is forked from [faicker/wg-config](https://github.com/faicker/wg-config).

## Dependencies

-   wireguard
-   qrencode

## Configuration

The script assumes the WireGuard directory is `/etc/wireguard`.

Configuration is done in `wg.def`. A `wg.def.sample` file is provided in this repository.

You can generate the public key and private key with command `wg genkey | tee > prikey | wg pubkey > pubkey`.

| Variable                | Description                                                     |
| ----------------------- | --------------------------------------------------------------- |
| \_INTERFACE             | Name of the WireGuard interface                                 |
| \_OUTBOUND_INTERFACE    | Network interface to send outbound traffic to (probably `eth0`) |
| \_VPN_NET               | Network to be used by WireGuard in CIDR notation                |
| \_DNS_SERVERS           | DNS servers clients will use                                    |
| \_KEEPALIVE             | Keepalive duration (seconds)                                    |
| \_SERVER_PORT           | Post WireGuard will listen on                                   |
| \_SERVER_LISTEN         | Where clients will connect to                                   |
| \_SERVER_PUBLIC_KEY     | Public key of the WireGuard interface                           |
| \_SERVER_PRIVATE_KEY    | Private key of the WireGuard interface                          |
| \_USE_COMMON_PEERS_CONF | If not set to `0`, all peer configuration end up in one file    |

## Usage

All commands must be run as root (use `sudo` is logged in as a non-root user).

### Start WireGuard

This script does not automatically start WireGuard on first run, you must do that yourself.

```bash
wg-quick up wg0
```

### Add a user

Generates a new client configuration using the next available IP address, and adds it to the server.

```bash
./user.sh -a alice
```

### Delete a user

Deletes a client from the server.

```bash
./user.sh -d alice
```

### View a previously generated user

Shows the client's configuration and prints the QR code to the terminal.

```bash
./user.sh -v alice
```

### Clear all

Clear everything to start again

```bash
./user.sh -c
```

### Generate available IPs

Generates the `.available_ip` file. You do not need to run this yourself.

```bash
./user.sh -g
```

## Notes

I'm mostly writing this as I ([s-thom](https://github.com/s-thom)) figure it out for myself. When I started I already had manually set up an interface, and wanted to preserve all of that. Hopefully these notes will help someone else if they need to do the same.

### `users` directory

The users directory contains directories for each of the configured clients. Each directory contains:

-   `client.all.config`: Client WireGuard config with `AllowedIPs = 0.0.0.0/0`
-   `client.config`: Client WireGuard config with `AllowedIPs = <your-vpn-only>`
-   `privatekey`: Private key of the client, ends with newline
-   `publickey`: Public key of the client, ends with newline
-   `<client-name>.all.png`: QR code for `client.all.conf`
-   `<client-name>.png`: QR code for `client.conf`

### `.available_ip`

Each line is an address in your VPN in CIDR notation. When a client is added, the first line of this file will be used for the address. This can be used to manually set the IP for the next user (just make sure to remove it from the generated list).

### `.saved`

`.saved` is an important file, as it is used when generating the server configuration to be applied. Each line is of the format:

```txt
<client-name> <client-ip>/<subnet-size> <client-public-key>
```

### `.<interface>.conf`

This is a temporary file that is generated during modifications, then immediately copied into `/etc/wireguard`. Modifications made directly to the file do not persist.

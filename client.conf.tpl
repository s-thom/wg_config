[Interface]
Address = $_VPN_IP
PrivateKey = $_PRIVATE_KEY

[Peer]
PublicKey = $_SERVER_PUBLIC_KEY
AllowedIPs = $_VPN_NET
Endpoint = $_SERVER_LISTEN

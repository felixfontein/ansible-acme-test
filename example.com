$TTL    1
@       IN      SOA     example.com. localhost. (1 1 1 1 1)
@       IN      NS      localhost.
@       IN      A       127.0.0.1
@       IN      AAAA    ::1
*       IN      A       127.0.0.1
*       IN      AAAA    ::1

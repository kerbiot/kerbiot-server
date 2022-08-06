# CA keypair
openssl genrsa -out ca.key 2048

# CA certificate - needs country and so on ...
# Important to use correct FQDN! for example: 7b7b7b7b.nip.io
openssl req -new -x509 -days 365000 -key ca.key -out ca.crt

# server key pair
openssl genrsa -out server.key 2048

# create certificate request - needs country and so on again ...
# Important to use correct FQDN! for example: 7b7b7b7b.nip.io
openssl req -days 365000 -new -out server.csr -key server.key

# sign server certificate with CA key
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365000

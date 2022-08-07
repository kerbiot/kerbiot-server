echo "Please enter your fqdn (7b7b7b7b.nip.io):"
read fqdn

# CA keypair
echo "Generating CA keypair"
openssl genrsa -out ca.key 2048

# CA certificate - needs country and so on ...
# Important to use correct FQDN! for example: 7b7b7b7b.nip.io
echo "Generating CA certificate"
openssl req -new -x509 -days 365000 -subj "/C=CA/ST=CA/L=CA/O=CA/OU=CA/CN="$fqdn"" -key ca.key -out ca.crt

# server key pair
echo "Generating server keypair"
openssl genrsa -out server.key 2048

# create certificate request - needs country and so on again ...
# Important to use correct FQDN! for example: 7b7b7b7b.nip.io
echo "Generating certificate request"
openssl req -subj "/C=SE/ST=SE/L=SE/O=SE/OU=SE/CN="$fqdn"" -new -out server.csr -key server.key

# sign server certificate with CA key
echo "Signing server certificate"
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365000

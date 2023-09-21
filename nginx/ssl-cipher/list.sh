#!/bin/bash

echo
echo TLS 1.2
echo

openssl ciphers -v | grep 1.2 | grep -v 128 | grep 'Kx=ECDH' | grep -v 'PSK'

echo
echo TLS 1.3
echo

openssl ciphers -s -v | grep 1.3

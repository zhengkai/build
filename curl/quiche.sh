#!/bin/bash -ex

SRC="/usr/local/src"
cd "$SRC" || exit 1

QUCIHE="${SRC}/quiche"

if [ ! -d quiche ]; then
	git clone https://github.com/cloudflare/quiche
fi
cd "$QUCIHE" || exit 1
git pull
git submodule update --init --recursive
cargo build --package quiche --release --features ffi,pkg-config-meta,qlog
QUCIHE_LIB="${QUCIHE}/quiche/deps/boringssl/src/lib"
mkdir -p "${QUCIHE_LIB}"
ln -vnf "${QUCIHE}/$(find target/release -name libcrypto.a)" "$QUCIHE_LIB"
ln -vnf "${QUCIHE}/$(find target/release -name libssl.a)"    "$QUCIHE_LIB"

cd "$SRC" || exit 1
if [ ! -d curl ]; then
	git clone https://github.com/curl/curl
fi
cd curl
git pull
autoreconf -fi
./configure \
	LDFLAGS="-Wl,-rpath,${QUCIHE}/target/release" \
	--with-openssl="${QUCIHE}/quiche/deps/boringssl/src" \
	--with-quiche="${QUCIHE}/target/release"
make -j"$(nproc)"
sudo make install

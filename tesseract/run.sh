#!/bin/bash -ex

apt install libleptonica-dev

pip install asciidoc

SRC_DIR='/usr/local/src'
cd "$SRC_DIR"

git clone https://github.com/tesseract-ocr/tesseract.git
cd tesseract

./autogen.sh
./configure
make
sudo make install
sudo ldconfig
make training
sudo make training-install

cd "$SRC_DIR"
git clone https://github.com/tesseract-ocr/tessdata.git
cd tessdata
cp ./* /usr/local/share/tessdata/

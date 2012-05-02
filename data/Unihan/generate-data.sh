#!/bin/bash

echo "Processing Unihan_Readings.txt"
./process-unihan-readings.rb
echo "Extracting block1 characters data"
./extract-block1.rb
echo "Creating binary data"
./create-bindata.rb
echo "Binray data pinyin.dat generated"

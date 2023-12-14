#!/bin/bash

# 禁止自动升级
echo "mongodb-org hold"          | sudo dpkg --set-selections
echo "mongodb-org-database hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold"   | sudo dpkg --set-selections
echo "mongodb-mongosh hold"      | sudo dpkg --set-selections
echo "mongodb-org-mongos hold"   | sudo dpkg --set-selections
echo "mongodb-org-tools hold"    | sudo dpkg --set-selections

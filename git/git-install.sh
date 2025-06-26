#!/bin/bash

set -euo pipefail

apt update 

apt install -y git

git config --global user.name "Omri Ashkenazi"

git config --global user.email "omri.ashke@gmail.com"
git config --global user.name "Omri Ashkenazi"

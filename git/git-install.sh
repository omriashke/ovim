#!/bin/bash

set -euo pipefail

apt update 

apt install -y git

git config --global user.name "Omri Ashkenazi"

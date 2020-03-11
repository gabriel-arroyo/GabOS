#!/bin/bash

command -v pip || ./pacinstall.sh python-pip >/dev/null 2>&1
yes | pip install "$1"

#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

color_echo() {
    if [[ -z "$1" ]]; then
        echo "Usage: color_echo <color> <text>"
        return 1
    fi
    local color="$1"
    if [[ -z "$2" ]]; then
        echo "Usage: color_echo <color> <text>"
        return 1
    fi
    local text="$2"
    echo -e "${color}${text}${NC}"
}

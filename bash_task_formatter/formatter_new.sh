#!/bin/bash

# Color variables
COLOR_RESET="\033[0m"
COLOR_BLUE="\033[1;34m"
COLOR_YELLOW="\033[1;33m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"

# Symbols
CHECK_MARK="\033[1;32m✔\033[0m"
CROSS_MARK="\033[1;31m✘\033[0m"

# Function to print header with script name
print_header() {
  local script_name=$1
  echo -e "${COLOR_GREEN}"
  echo "   _____           _ _   _                                  "
  echo "  / ____|         (_) | | |                                 "
  echo " | (___  _ __ ___  _| |_| |__  ___  ___ _ ____   _____ _ __ "
  echo "  \\___ \\| '_ \` _ \\| | __| '_ \\/ __|/ _ \\ '__\\ \\ / / _ \\ '__|"
  echo "  ____) | | | | | | | |_| | | \\__ \\  __/ |   \\ V /  __/ |   "
  echo " |_____/|_| |_| |_|_|\\__|_| |_|___/\\___|_|    \\_/ \\___|_|   "
  echo -e "${COLOR_RESET}\n"
  echo -e "${COLOR_GREEN}${script_name}${COLOR_RESET}\n\n\n"
}

# Function to display a spinner
spinner() {
    local pid=$1
    local func_name=$2
    local delay=0.1
    local spinstr=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local temp

    # Hide cursor
    tput civis

    while kill -0 "$pid" 2>/dev/null; do
        for temp in "${spinstr[@]}"; do
            printf "\r${COLOR_BLUE}Function: %s${COLOR_RESET} - ${COLOR_YELLOW}Status: Running... %s${COLOR_RESET}" "$func_name" "$temp"
            sleep $delay
        done
    done

    # Show cursor
    tput cnorm
}

# Function to handle cleanup on exit
cleanup() {
    local exit_status=$?
    tput cnorm
    if [[ -f "$temp_file" ]]; then
        rm -f "$temp_file"
    fi
    if [[ $exit_status -ne 0 ]]; then
        printf "\n${COLOR_RED}Script interrupted or an error occurred${COLOR_RESET}\n"
    fi
    exit $exit_status
}

# Set trap for cleanup on exit or interrupt
trap cleanup EXIT
trap 'exit 130' INT

# Function to format the output of another function
format_output() {
    local func_name=$1
    local display_name=${2:-$func_name}
    temp_file=$(mktemp)

    # Run the function in the background and capture its output
    ( $func_name >"$temp_file" 2>&1 ) &
    local pid=$!
    spinner $pid "$display_name"
    wait $pid
    local exit_status=$?

    if [ $exit_status -eq 0 ]; then
        printf "\r${COLOR_BLUE}Function: %s${COLOR_RESET} - ${COLOR_GREEN}Status: Finished ${CHECK_MARK}${COLOR_RESET}                           \n" "$display_name"
    else
        printf "\r${COLOR_BLUE}Function: %s${COLOR_RESET} - ${COLOR_RED}Status: Error ${CROSS_MARK}${COLOR_RESET}                              \n" "$display_name"
    fi

    echo -e "${COLOR_BLUE}Output:${COLOR_RESET}"
    cat "$temp_file"
    echo "" # Ensure a new line after the function output
    rm -f "$temp_file"
    return $exit_status
}

# Function to format the output of another function that requires user input
format_output_with_input() {
    local func_name=$1
    local display_name=${2:-$func_name}
    temp_file=$(mktemp)

    echo -e "${COLOR_BLUE}Function: $display_name${COLOR_RESET} - ${COLOR_YELLOW}Status: Running...${COLOR_RESET}"

    # Run the function in the foreground to handle interactive input
    $func_name 2>&1 | tee "$temp_file"
    local exit_status=${PIPESTATUS[0]}

    if [ $exit_status -eq 0 ]; then
        printf "\r${COLOR_BLUE}Function: %s${COLOR_RESET} - ${COLOR_GREEN}Status: Finished ${CHECK_MARK}${COLOR_RESET}                           \n" "$display_name"
    else
        printf "\r${COLOR_BLUE}Function: %s${COLOR_RESET} - ${COLOR_RED}Status: Error ${CROSS_MARK}${COLOR_RESET}                              \n" "$display_name"
    fi

    echo -e "${COLOR_BLUE}Output:${COLOR_RESET}"
    cat "$temp_file"
    echo "" # Ensure a new line after the function output
    rm -f "$temp_file"
    return $exit_status
}

# Export the functions for use in other scripts
export -f print_header
export -f format_output
export -f format_output_with_input
export COLOR_RESET COLOR_BLUE COLOR_YELLOW COLOR_GREEN COLOR_RED CHECK_MARK CROSS_MARK

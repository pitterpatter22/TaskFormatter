#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
NC='\033[0m' # No Color

# Spinner frames
SPINNER_FRAMES=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
SPINNER_INTERVAL=0.08

# Function to display the spinner
spinner() {
    local pid=$1
    local task_description=$2
    local delay=$SPINNER_INTERVAL
    local frames=("${SPINNER_FRAMES[@]}")
    local frame_index=0

    while kill -0 $pid 2>/dev/null; do
        printf "\r${BLUE}${BOLD}${UNDERLINE}$task_description Running${NC} [${frames[frame_index]}]"
        frame_index=$(( (frame_index + 1) % ${#frames[@]} ))
        sleep $delay
    done
}

# Function to execute a task with a spinner
run_task() {
    local task_description=$1
    local task_command=$2
    local output_file=$(mktemp)

    # Print the initial task description
    printf "\r${BLUE}${BOLD}${UNDERLINE}$task_description Running${NC} [ ]"
    
    # Run the command in the background, redirecting output to a temporary file
    { eval "$task_command"; echo $? > "$output_file.status"; } > "$output_file" 2>&1 &
    local pid=$!

    # Show the spinner while the command is running
    spinner $pid "$task_description"
    
    # Wait for the command to finish
    wait $pid
    local status=$(cat "$output_file.status")

    # Clear the spinner and move to the next line
    printf "\r\033[K"
    if [ $status -eq 0 ]; then
        printf "${GREEN}${BOLD}${UNDERLINE}$task_description Completed [✔]${NC}\n"
    else
        printf "${RED}${BOLD}${UNDERLINE}$task_description Error [✘]${NC}\n"
        printf "${RED}\nError output:\n"
        cat "$output_file"
        printf "\n${NC}"
    fi

    # Cleanup
    rm "$output_file" "$output_file.status"
}

# Function to run all tasks passed as arguments
run_all_tasks() {
    local tasks=("$@")
    tput civis
    for task in "${tasks[@]}"; do
        IFS=":" read -r description command <<< "$task"
        run_task "$description" "$command"
    done
    tput cnorm
}

# Export the functions to be used in other scripts
export -f spinner
export -f run_task
export -f run_all_tasks

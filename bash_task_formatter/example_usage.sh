#!/bin/bash

# Source the task formatter script
source ./task_formatter.sh

sample_task() {
    echo "This is a sample task running"
    sleep 3
    return 0
}

# Another sample function to be used as a task
another_sample_task() {
    echo "Another sample task running"
    sleep 5
    return 1
}

# Define your tasks here as descriptions and commands
tasks=(
    "Task 1:sample_task"
    "Task 2:another_sample_task"
    "Task 3:sleep 2"
)

# Run all tasks by passing them to the formatter script
run_all_tasks "${tasks[@]}"

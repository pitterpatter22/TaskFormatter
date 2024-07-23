# Task Formatter with Spinner

This repository contains two scripts, `task_formatter.sh` and `example_usage.sh`, that work together to execute tasks with a spinner and formatted output. The `task_formatter.sh` script provides functions for running tasks with a spinner, while the `example_usage.sh` script demonstrates how to use these functions by defining and executing a set of tasks.

## Files

### task_formatter.sh

This script contains functions for running tasks with a spinner and formatted output.

#### Functions

- `spinner(pid)`: Displays a spinner while a background task is running.
- `run_task(task_description, task_command)`: Executes a task with a spinner and captures its output.
- `run_all_tasks(tasks)`: Runs all tasks passed as arguments, using the `run_task` function.

#### Usage

The `task_formatter.sh` script is designed to be sourced by another script, which can then call its functions to run tasks with formatted output.

### example_usage.sh

This script demonstrates how to use the functions provided by `task_formatter.sh` to run a set of tasks.

#### Usage

1. Ensure both `task_formatter.sh` and `example_usage.sh` are executable:
    ```bash
    chmod +x task_formatter.sh
    chmod +x example_usage.sh
    ```

2. Run the `example_usage.sh` script:
    ```bash
    ./example_usage.sh
    ```

#### Example Tasks

The `example_usage.sh` script defines three example tasks:

- `Task 1`: Runs the `sample_task` function, which simulates a task running for 3 seconds.
- `Task 2`: Runs the `another_sample_task` function, which simulates a task running for 5 seconds and then returns an error.
- `Task 3`: Runs the `sleep 2` command, which simulates a task running for 2 seconds.

## How It Works

1. The `example_usage.sh` script sources the `task_formatter.sh` script to gain access to its functions.
2. The `example_usage.sh` script defines a set of tasks in an array, with each task specified as a description and a command separated by a colon (`:`).
3. The `example_usage.sh` script calls the `run_all_tasks` function from `task_formatter.sh`, passing the tasks as arguments.
4. The `run_all_tasks` function iterates over the tasks, splits each task into a description and a command, and calls the `run_task` function for each task.
5. The `run_task` function executes the task with a spinner and captures its output, displaying the task's status when it completes.

## Example Output

```plaintext
Task 1 Running [⠼] [✔] Task 1 Completed 3s
Task 2 Running [⠧] [✘] Task 2 Error 5s

Error output:
Another sample task running

Task 3 Running [⠹] [✔] Task 3 Completed 2s

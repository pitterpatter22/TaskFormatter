#!/bin/bash

# Source the formatter script
source ./formatter_new.sh

# Example function 1
example_function_1() {
    echo "This is example function 1."
    sleep 2
}

# Example function 2
example_function_2() {
    echo "This is example function 2."
    sleep 2
    echo "testing"
    sleep 2
}

# Example function 3 with an error
example_function_3() {
    echo "This is example function 3 and it will fail."
    sleep 3
    return 1
}

ask_reconfigure() {
  read -p "Step CA CLI is already installed. Do you want to reconfigure it? (y/n): " choice
  case "$choice" in 
    y|Y ) return 0;;
    n|N ) return 1;;
    * ) echo "Invalid choice."; ask_reconfigure;;
  esac
}

# Using the formatter to format the output of the example functions
print_header "Example Formatter"
format_output example_function_1 "Example Function 1"
format_output example_function_2 "Example Function 2"
format_output example_function_3 "Example Function 3"
format_output_with_input ask_reconfigure "Test Reconfiguring"

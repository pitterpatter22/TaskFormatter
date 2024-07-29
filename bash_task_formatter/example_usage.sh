#!/bin/bash

# Source the formatter script
source ./task_formatter.sh

# Example function 1
example_function_1() {
    echo -e "This is example function 1. $CHECK_MARK"
    sleep 2
}

# Example function 2
example_function_2() {
    echo "This is example function 2."
    sleep 2
    echo -e "Done $CHECK_MARK"
    sleep 2
}

# Example function 3 with an error
example_function_3() {
    echo -e "This is example function 3 and it will fail. $CROSS_MARK"
    sleep 3
    return 1
}

ask_reconfigure() {
  read -p "Question? (y/n): " choice
  case "$choice" in 
    y|Y ) return 0;;
    n|N ) return 1;;
    * ) echo "Invalid choice."; ask_reconfigure;;
  esac
}

# Using the formatter to format the output of the example functions
print_header "Example Formatter" "https://github.com/seanssmith/TaskFormatter/blob/main/bash_task_formatter/example_new.sh"
format_output example_function_1 "Example Function 1"
format_output example_function_2 "Example Function 2"
format_output example_function_3 "Example Function 3"
format_output_with_input ask_reconfigure "Test Reconfiguring"


# Print final message
final_message "Example Formatter (Success Example) $CHECK_MARK" 0
final_message "Example Formatter (Failure Example) $CROSS_MARK" 1

# Exit with appropriate status
exit 0

from formatter import format_output
from time import sleep

@format_output
def successful_function():
    sleep(2)
    return "Function logic output"

@format_output
def failing_function():
    sleep(2)
    raise ValueError("Something went wrong")

if __name__ == "__main__":
    successful_function()
    try:
        failing_function()
    except Exception as e:
        print("Caught an exception: ", e)

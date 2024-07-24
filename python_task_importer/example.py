from formatter import format_output
from time import sleep

@format_output
def successful_function():
    print("Starting")
    sleep(2)
    print("Function logic output")

@format_output
def failing_function():
    print("Just Started")
    sleep(2)
    print("Running")
    sleep(2)
    print("Done")
    raise ValueError("Custom Error")

if __name__ == "__main__":
    successful_function()
    try:
        failing_function()
    except Exception as e:
        print("Caught an exception: ", e)

import time
import sys
import threading
from functools import wraps
import signal

# Global counter for function numbering
function_counter = 0

def spinner():
    while True:
        for cursor in "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏":
            yield cursor

def format_output(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        global function_counter
        function_counter += 1
        function_number = function_counter
        spinner_gen = spinner()
        start_time = time.time()
        func_name = func.__name__

        # ANSI color codes
        BLUE = '\033[94m'
        GREEN = '\033[92m'
        RED = '\033[91m'
        BOLD = '\033[1m'
        UNDERLINE = '\033[4m'
        RESET = '\033[0m'

        # Spinner thread
        def spin():
            while not spinner_done:
                sys.stdout.write(f"\r{BOLD}{UNDERLINE}{BLUE}{function_number}. {func_name} Running [{next(spinner_gen)}] {RESET}")
                sys.stdout.flush()
                time.sleep(0.1)

        spinner_done = False
        spin_thread = threading.Thread(target=spin)
        spin_thread.start()

        def handle_exit(signum, frame):
            raise SystemExit("Process exited")

        signal.signal(signal.SIGTERM, handle_exit)
        signal.signal(signal.SIGINT, handle_exit)

        try:
            result = func(*args, **kwargs)
            duration = time.time() - start_time
            spinner_done = True
            spin_thread.join()
            sys.stdout.write(f"\r{BOLD}{UNDERLINE}{GREEN}{function_number}. {func_name} Completed [✓] in {duration:.2f}s{RESET}\n")
            sys.stdout.flush()
            print(result)
            sys.stdout.write('\n---\n')  # Add separator before the next function
            return result
        except SystemExit as e:
            duration = time.time() - start_time
            spinner_done = True
            spin_thread.join()
            sys.stdout.write(f"\r{BOLD}{UNDERLINE}{RED}{function_number}. {func_name} Failed [✗] in {duration:.2f}s{RESET}\n")
            sys.stdout.flush()
            print(f"{RED}{UNDERLINE}{e}{RESET}")
            sys.stdout.write('\n---\n')  # Add separator before the next function
            raise e
        except Exception as e:
            duration = time.time() - start_time
            spinner_done = True
            spin_thread.join()
            sys.stdout.write(f"\r{BOLD}{UNDERLINE}{RED}{function_number}. {func_name} Failed [✗] in {duration:.2f}s{RESET}\n")
            sys.stdout.flush()
            print(f"{RED}{UNDERLINE}{e}{RESET}")
            sys.stdout.write('\n---\n')  # Add separator before the next function
            raise e

    return wrapper

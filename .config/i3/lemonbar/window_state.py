from constants import AUTOLOCK_STATE_FILE
import subprocess


def window_title():
    try:
        return subprocess.check_output(("xdotool", "getactivewindow", "getwindowname"))
    except subprocess.CalledProcessError:
        return "??"


def lockscreen_state():
    try:
        with open(AUTOLOCK_STATE_FILE, 'r') as fh:
            state = fh.read()

            if state == b"on":
                return True
            elif state == b"off":
                return False
    except (FileNotFoundError, IOError, OSError):
        return None


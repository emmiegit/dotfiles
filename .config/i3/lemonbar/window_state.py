from constants import AUTOLOCK_STATE_FILE
import subprocess


def window_title():
    try:
        return subprocess.check_output(("xdotool", "getactivewindow", "getwindowname")).decode("utf-8")
    except subprocess.CalledProcessError:
        return "??"


def autolock_state():
    try:
        with open(AUTOLOCK_STATE_FILE, 'r') as fh:
            state = fh.read()

            if state.strip() == "on":
                return True
            elif state.strip() == "off":
                return False
    except (FileNotFoundError, IOError, OSError):
        return None


from constants import AUTOLOCK_STATE_FILE
import os
import re
import subprocess
import threading

XPROP_SPY_REGEX = re.compile(r"_NET_ACTIVE_WINDOW\(WINDOW\): window id # (0x[0-9a-f]+)\n?")
XPROP_ID_REGEX = re.compile(r'_NET_WM_NAME.*? = "(.*)"')


class XpropSpyHandle(threading.Thread):
    def __init__(self):
        super().__init__()
        self.alive = True
        self.proc = subprocess.Popen(("xprop", "-spy", "-root", "_NET_ACTIVE_WINDOW"),
                stdout=subprocess.PIPE, preexec_fn=os.setsid)
        self.window_id = 0
        self.title = ""

    def run(self):
        while self.alive:
            try:
                update = self.proc.stdout.readline()
            except BrokenPipeError:
                break

            match = XPROP_SPY_REGEX.match(update.decode("utf-8"))
            if not match:
                continue
            try:
                window_data = subprocess.check_output(("xprop", "-id", match.group(1)))
            except subprocess.CalledProcessError:
                self.title = ""
                continue

            match = XPROP_ID_REGEX.findall(window_data.decode("utf-8"))
            if match:
                self.title = match[0]


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


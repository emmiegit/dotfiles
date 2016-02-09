#!/usr/bin/env python3
from constants import *
from media import *
from system_stats import *
from window_state import *
import atexit
import os
import subprocess
import sys
import time


def acquire_lock():
    if os.path.exists(LOCK_FILE):
        print("Lock file already exists. Is the process already running?", file=sys.stder)
        sys.exit(1)

    with open(LOCK_FILE, 'w+') as fh:
        pass


def release_lock():
    if not os.path.exists(LOCK_FILE):
        print("Lock file disappeared. Did somebody delete it manually?", file=sys.stderr)
        sys.exit(1)

    os.unlink(LOCK_FILE)


def build_command():
    cmd = ["lemonbar", "-p"]

    for font in FONTS:
        cmd.append("-f")
        cmd.append(font)

    if BACKGROUND_COLOR:
        cmd.append("-B")
        cmd.append(BACKGROUND_COLOR)

    if FOREGROUND_COLOR:
        cmd.append("-F")
        cmd.append(FOREGROUND_COLOR)

    return cmd


def format_text(text, bg=None, fg=None, align=NO_ALIGNMENT):
    if bg and fg:
        return "%s%%{B%s F%s}%s" % (align, bg, fg, text)
    elif bg:
        return "%s%%{B%s}%s" % (align, bg, text)
    elif fg:
        return "%s%%{F%s}%s" % (align, fg, text)
    else:
        return "%s%s" % (align, text)


if __name__ == "__main__":
    # Acquire lock
    acquire_lock()
    atexit.register(release_lock)

    # Set up pipe
    command = build_command()
    process = subprocess.Popen(command, stdin=subprocess.PIPE)

    # Main loop
    while True:
        process.stdin.write(b"test\n")
        process.stdin.flush()
        time.sleep(1)

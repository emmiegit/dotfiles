#!/usr/bin/env python3
from lemongadgetimpl import *
import atexit
import os
import subprocess
import sys


def acquire_lock():
    if os.path.exists(LOCK_FILE):
        print("Lock file already exists. Is the process already running?", file=sys.stder)
        sys.exit(1)

    with open(LOCK_FILE, 'w+') as fh:
        fh.write(str(os.getpid()))


def release_lock():
    if not os.path.exists(LOCK_FILE):
        print("Lock file disappeared. Did somebody delete it manually?", file=sys.stderr)
        sys.exit(1)

    os.unlink(LOCK_FILE)


def build_lemonbar_command():
    #cmd = ["lemonbar", "-p"]
    cmd = ["lemonbar"]

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


if __name__ == "__main__":
    acquire_lock()
    atexit.register(release_lock)
    lemonbar_command = build_lemonbar_command()
    bash_command = ("bash",)
    lemonbar_proc = subprocess.Popen(lemonbar_command, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    bash_proc = subprocess.Popen(bash_command, stdin=lemonbar_proc.stdout, stdout=subprocess.DEVNULL)

    controller = LemonGadgetController(lemonbar_proc)
    controller.register_all(GADGETS)

    try:
        controller.tick()
        time.sleep(120)
        controller.quit()
    except KeyboardInterrupt:
        controller.quit()

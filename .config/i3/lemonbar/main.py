#!/usr/bin/env python3
from lemongadgetimpl import *
import atexit
import os
import signal
import subprocess
import sys

LEFT_GADGETS = (
    # Left
    WorkspacesGadget(1, ALIGN_LEFT, LEFT_MONITOR),
    NowPlayingGadget(20, ALIGN_LEFT),

    # Center
    WindowTitleGadget(1, ALIGN_CENTER),

    # Right
    CPUGadget(10, ALIGN_RIGHT),
    MemoryGadget(10, ALIGN_RIGHT),
    NetworkGadget(10, ALIGN_RIGHT, MIN_UNIT_KBYTES),
    VolumeGadget(2, ALIGN_RIGHT),
    TimeGadget(5, ALIGN_RIGHT),
)

RIGHT_GADGETS = (
    # Left
    WorkspacesGadget(1, ALIGN_LEFT, RIGHT_MONITOR),

    # Center
    WindowTitleGadget(1, ALIGN_CENTER),

    # Right
    TimeGadget(5, ALIGN_RIGHT),
)


def acquire_lock(*args, **kwargs):
    if os.path.exists(LOCK_FILE):
        print("Lock file already exists. Is the process already running?", file=sys.stderr)
        sys.exit(1)

    with open(LOCK_FILE, 'w+') as fh:
        fh.write(str(os.getpid()))


def release_lock(*args, **kwargs):
    if not os.path.exists(LOCK_FILE):
        print("Lock file disappeared. Did somebody delete it manually?", file=sys.stderr)
        sys.exit(1)

    os.unlink(LOCK_FILE)


def build_lemonbar_command(monitor):
    #cmd = ["lemonbar", "-p"]
    cmd = ["lemonbar"]

    cmd.append("-g")
    if monitor == LEFT_MONITOR:
        cmd.append("%dx%d+%d+%d" % (LEFT_MONITOR_WIDTH, BAR_HEIGHT, 0, 0))
    elif monitor == RIGHT_MONITOR:
        cmd.append("%dx%d+%d+%d" % (RIGHT_MONITOR_WIDTH, BAR_HEIGHT, LEFT_MONITOR_WIDTH, 0))
    else:
        raise ValueError("Unknown monitor: %s" % monitor)

    for font in FONTS:
        cmd.append("-f")
        cmd.append(font)

    if BACKGROUND_COLOR:
        cmd.append("-B")
        cmd.append(BACKGROUND_COLOR)

    if FOREGROUND_COLOR:
        cmd.append("-F")
        cmd.append(FOREGROUND_COLOR)

    if MAX_CLICKABLE_AREAS:
        cmd.append("-a")
        cmd.append(str(MAX_CLICKABLE_AREAS))

    return cmd


if __name__ == "__main__":
    acquire_lock()
    atexit.register(release_lock)
    signal.signal(signal.SIGTERM, release_lock)

    shell_command = ("sh",)

    left_lemonbar_command = build_lemonbar_command(LEFT_MONITOR)
    left_lemonbar_proc = subprocess.Popen(left_lemonbar_command, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    left_shell_proc = subprocess.Popen(shell_command, stdin=left_lemonbar_proc.stdout, stdout=subprocess.DEVNULL)
    left_controller = LemonGadgetController(left_lemonbar_proc)
    left_controller.register_all(LEFT_GADGETS)
    left_controller.start()

    right_lemonbar_command = build_lemonbar_command(RIGHT_MONITOR)
    right_lemonbar_proc = subprocess.Popen(right_lemonbar_command, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    right_shell_proc = subprocess.Popen(shell_command, stdin=right_lemonbar_proc.stdout, stdout=subprocess.DEVNULL)
    right_controller = LemonGadgetController(right_lemonbar_proc)
    right_controller.register_all(RIGHT_GADGETS)
    right_controller.start()

    try:
        left_controller.join()
        right_controller.join()
    except KeyboardInterrupt:
        left_controller.quit()
        right_controller.quit()


#!/usr/bin/env python3
from lemongadgetimpl import *
from lemongadgetcontroller import *
import os
import signal
import subprocess
import sys

LEFT_GADGETS = (
    # Left
    WorkspacesGadget(0.5, ALIGN_LEFT, LEFT_MONITOR),

    # Center
    WindowTitleGadget(0.1, ALIGN_CENTER),

    # Right
    CPUGadget(4.0, ALIGN_RIGHT),
    MemoryGadget(8.0, ALIGN_RIGHT),
    NetworkGadget(5.0, ALIGN_RIGHT, MIN_UNIT_KBYTES),
    VolumeGadget(0.2, ALIGN_RIGHT),
    TimeGadget(0.5, ALIGN_RIGHT),
)

RIGHT_GADGETS = (
    # Left
    WorkspacesGadget(0.5, ALIGN_LEFT, RIGHT_MONITOR),

    # Center
    WindowTitleGadget(0.1, ALIGN_CENTER),

    # Right
    NowPlayingGadget(4.0, ALIGN_RIGHT, blank_if_none=True),
    TimeGadget(0.5, ALIGN_RIGHT),
)


def acquire_lock():
    if os.path.exists(LOCK_FILE):
        print("Lock file already exists. Is the process already running?", file=sys.stderr)
        sys.exit(1)

    with open(LOCK_FILE, 'w+') as fh:
        fh.write(str(os.getpid()))


def release_lock():
    if not os.path.exists(LOCK_FILE):
        print("Lock file disappeared. Did somebody delete it manually?", file=sys.stderr)
        return False

    os.unlink(LOCK_FILE)
    return True


def build_lemonbar_command(monitor):
    cmd = ["lemonbar", "-g"]

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


def kill_controllers(*controllers):
    def _func(signum, frame=None):
        print("Caught signal %d, terminating..." % signum)
        for controller in controllers:
            print("[thread %d] Killing controller..." % controller.ident)
            controller.kill()
            print("[thread %d] Waiting for thread to finish..." % controller.ident)
            controller.join()
        release_lock()
    return _func


if __name__ == "__main__":
    acquire_lock()

    left_lemonbar_command = build_lemonbar_command(LEFT_MONITOR)
    left_lemonbar_proc = subprocess.Popen(left_lemonbar_command, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    left_shell_proc = subprocess.Popen(("sh",), stdin=left_lemonbar_proc.stdout, stdout=subprocess.DEVNULL)
    left_controller = LemonGadgetController(left_lemonbar_proc)
    for gadget in LEFT_GADGETS:
        left_controller.register(gadget)
    left_controller.start()

    right_lemonbar_command = build_lemonbar_command(RIGHT_MONITOR)
    right_lemonbar_proc = subprocess.Popen(right_lemonbar_command, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    right_shell_proc = subprocess.Popen(("sh",), stdin=right_lemonbar_proc.stdout, stdout=subprocess.DEVNULL)
    right_controller = LemonGadgetController(right_lemonbar_proc)
    for gadget in RIGHT_GADGETS:
        right_controller.register(gadget)
    right_controller.start()

    kill_cmd = kill_controllers(left_controller, right_controller)
    signal.signal(signal.SIGTERM, kill_cmd)

    try:
        left_controller.join()
        right_controller.join()
    except KeyboardInterrupt:
        kill_cmd(signal.SIGINT)


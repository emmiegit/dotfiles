#!/usr/bin/env python3
from i3_workspaces import *
from controller import *
from media import *
from misc import *
from system_stats import *
from window_state import *
import os
import signal
import subprocess
import sys

# You can specify which gadgets you want here. Order matters.
GADGETS = (
    # Left monitor
    WorkspacesGadget(0.5, ALIGN_LEFT, LEFT_MONITOR),
    WindowTitleGadget(0.3, ALIGN_CENTER),
    CPUGadget(2.0, ALIGN_RIGHT),
    MemoryGadget(8.0, ALIGN_RIGHT),
    NetworkGadget(2.0, ALIGN_RIGHT, MIN_UNIT_KBYTES),
    VolumeGadget(0.3, ALIGN_RIGHT),
    TimeGadget(0.5, ALIGN_RIGHT),

    # Right monitor
    NextMonitor(ALIGN_RIGHT),

    WorkspacesGadget(0.5, ALIGN_LEFT, RIGHT_MONITOR),
    WindowTitleGadget(0.1, ALIGN_CENTER),
    NowPlayingGadget(4.0, ALIGN_RIGHT, blank_if_none=True),
    TimeGadget(0.5, ALIGN_RIGHT),
)


def acquire_lock():
    """
    Create the lock file, or quit if it already exists.
    """
    if os.path.exists(LOCK_FILE):
        print("Lock file already exists. Is the process already running?", file=sys.stderr)
        sys.exit(1)

    with open(LOCK_FILE, 'w+') as fh:
        fh.write(str(os.getpid()))


def release_lock():
    """
    Remove the lock file.
    :return: whether the operation succeeded or not
    """
    if not os.path.exists(LOCK_FILE):
        print("Lock file disappeared. Did somebody delete it manually?", file=sys.stderr)
        return False

    os.unlink(LOCK_FILE)
    return True


def build_lemonbar_command():
    """
    Generates the command-line program that is run to start up lemonbar.
    :return: the command to be invoked as a list, with each argument as a separate item
    """
    cmd = ["lemonbar", "-g", "x12"]

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


def build_kill_function(controller):
    def _func(signum, frame=None):
        print("Caught signal %d, terminating..." % signum)
        controller.kill()
        print("Waiting for thread to finish...")
        controller.join(0.3)
        release_lock()
    return _func


if __name__ == "__main__":
    acquire_lock()

    # Create lemonbar child process
    lemonbar_command = build_lemonbar_command()
    lemonbar_proc = subprocess.Popen(lemonbar_command, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    shell_proc = subprocess.Popen(("sh",), stdin=lemonbar_proc.stdout, stdout=subprocess.DEVNULL)
    controller = LemonGadgetController(lemonbar_proc)
    controller.register_gadgets(GADGETS)
    controller.start()

    # Set up signal handlers
    killfunc = build_kill_function(controller)
    signal.signal(signal.SIGHUP, killfunc)
    signal.signal(signal.SIGTERM, killfunc)

    # Instead of a SIGINT handler, capture KeyboardInterrupt instead
    try:
        controller.join()
    except KeyboardInterrupt:
        killfunc(signal.SIGINT)


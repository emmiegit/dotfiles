#!/usr/bin/env python3
from bar import GADGETS
from constants import *
from controller import LemonGadgetController
import os
import signal
import subprocess
import sys


def check_pid(pid):
    try:
        os.kill(pid, 0)
    except OSError:
        return False
    else:
        return True


def acquire_lock():
    """
    Create the pid file, or quit if it already exists or some other issue occurs.
    """
    if os.path.exists(PID_FILE):
        try:
            with open(PID_FILE, 'r') as fh:
                pid = int(fh.read())
                if check_pid(pid):
                    print("Lemonbar is already running (pid %d)." % pid, file=sys.stderr)
                    sys.exit(1)
        except (ValueError, IOError) as err:
            print("Unable to check pid file at \"%s\": %s" %
                  (PID_FILE, err), file=sys.stderr)
            sys.exit(1)

    try:
        with open(PID_FILE, 'w+') as fh:
            fh.write(str(os.getpid()))
            fh.write("\n")
    except IOError as err:
        print("Unable to write pid to pid file at \"%s\": %s" % (PID_FILE, err))
        sys.exit(1)


def release_lock():
    """
    Remove the lock file.
    :return: whether the operation succeeded or not
    """
    if not os.path.exists(PID_FILE):
        print("Pid file at \"%s\" disappeared. Did somebody delete it manually?" % PID_FILE, file=sys.stderr)
        return False

    try:
        with open(PID_FILE, 'r') as fh:
            pid = int(fh.read())
            if os.getpid() != pid:
                print("Pid file at \"%s\" has a different process id (%d) than our own (%d)! Not removing pid file." %
                      (PID_FILE, pid, os.getpid()), file=sys.stderr)
                return False
    except IOError as err:
        print("Unable to open pid file at \"%s\" to check process id: %s" % (PID_FILE, err))
        return False

    try:
        os.unlink(PID_FILE)
    except IOError as err:
        print("Unable to remove pid file at \"%s\": %s" % (PID_FILE, err))
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

        # Terrible hack, but I honestly couldn't find a different way to do this.
        # If you make the i3.Subscription initialize in start(), then it doesn't update.
        # For anybody who finds a way to fix this, please tell me about it.
        def _exit(signum=None, frame=None):
            release_lock()
            sys.exit()

        signal.signal(signal.SIGALRM, _exit)
        signal.alarm(1)
        controller.join()
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


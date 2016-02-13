from constants import *
from i3_workspaces import i3Handle
from window_state import XpropSpyHandle
import threading
import time


class LemonGadgetController(threading.Thread):
    def __init__(self, process):
        super().__init__()
        self.gadgets = []
        self.proc = process
        self.handles = {}
        self._death = threading.Event()
        self._left = []
        self._center = []
        self._right = []

    def _write_left(self, text):
        if text:
            self._left.append(text)

    def _write_center(self, text):
        if text:
            self._center.append(text)

    def _write_right(self, text):
        if text:
            self._right.append(text)

    def create_handle(self, handle_name):
        if handle_name == "i3":
            handle = i3Handle()
        elif handle_name == "xprop":
            handle = XpropSpyHandle()
        else:
            raise ValueError("Unknown handle: %s" % (handle_name,))

        handle.start()
        self.handles[handle_name] = handle

    def register(self, gadget):
        if gadget.alignment == ALIGN_LEFT:
            gadget._write = self._write_left
        elif gadget.alignment == ALIGN_CENTER:
            gadget._write = self._write_center
        elif gadget.alignment == ALIGN_RIGHT:
            gadget._write = self._write_right
        else:
            raise ValueError("Invalid alignment id: %s" % (gadget.alignment,))

        if gadget.wants:
            if gadget.wants not in self.handles.keys():
                self.create_handle(gadget.wants)
            gadget.handle = self.handles[gadget.wants]

        self.gadgets.append(gadget)

    def kill(self):
        self._death.set()
        for handle in self.handles.values():
            handle.kill()

    def is_dead(self):
        return self._death.isSet()

    def _write(self, string):
        self.proc.stdin.write(string.encode("utf-8"))

    def _flush(self):
        if self._left:
            self._write("%{l}")
            self._write("".join(self._left))
            self._left = []

        if self._center:
            self._write("%{c}")
            self._write("".join(self._center))
            self._center = []

        if self._right:
            self._write("%{r}")
            self._write("".join(self._right))
            self._right = []

        self._write("\n")
        self.proc.stdin.flush()

    def run(self):
        prev = time.time()
        while not self.is_dead():
            if time.time() - prev < TICK_DELAY:
                time.sleep(TICK_SLEEP)
                continue
            self.tick()

    def tick(self):
        for gadget in self.gadgets:
            gadget.tick()
        try:
            self._flush()
        except BrokenPipeError:
            self.kill()


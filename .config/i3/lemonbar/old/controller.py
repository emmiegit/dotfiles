from constants import *
from i3_workspaces import i3Handle
from misc import StaticText
from window_state import XpropSpyHandle
import threading
import time


class LemonGadgetController(threading.Thread):
    _align = {
        ALIGN_LEFT: "%{l}",
        ALIGN_CENTER: "%{c}",
        ALIGN_RIGHT: "%{r}",
    }

    def __init__(self, process, sync_to_whole_second=False):
        super().__init__()
        self.gadgets = []
        self.proc = process
        self.handles = {}
        self.sync_to_whole_second = sync_to_whole_second
        self._death = threading.Event()
        self._buf = []

    def create_handle(self, handle_name):
        if handle_name == "i3":
            handle = i3Handle()
        elif handle_name == "xprop":
            handle = XpropSpyHandle()
        else:
            raise ValueError("Unknown handle: %s" % (handle_name,))

        handle.start()
        self.handles[handle_name] = handle

    def _write_buf(self, text):
        if text:
            self._buf.append(text)

    def register_gadgets(self, gadgets):
        last_align = None
        for gadget in gadgets:
            gadget._write = self._write_buf

            if gadget.alignment != last_align:
                dummy = StaticText(gadget.alignment, self._align[gadget.alignment])
                dummy._write = self._write_buf
                self.gadgets.append(dummy)
                last_align = gadget.alignment

            if gadget.wants:
                if gadget.wants not in self.handles.keys():
                    self.create_handle(gadget.wants)
                gadget.handle = self.handles[gadget.wants]

            self.gadgets.append(gadget)

    def kill(self, *args):
        self._death.set()
        for handle in self.handles.values():
            handle.kill()

    def is_dead(self):
        return self._death.isSet()

    def _write(self, string):
        self.proc.stdin.write(string.encode("utf-8"))

    def _flush(self):
        if self._buf:
            self._write("".join(self._buf))
            self._buf = []

        self._write("\n")
        self.proc.stdin.flush()

    def run(self):
        # Wait until we're synced with a whole second
        if self.sync_to_whole_second:
            _ctime = time.time()
            time.sleep(int(_ctime) - _ctime + 1)
            del _ctime

        # Start main loop
        while not self.is_dead():
            time.sleep(TICK_DELAY)
            self.tick()

    def tick(self):
        for gadget in self.gadgets:
            gadget.tick()
        try:
            self._flush()
        except BrokenPipeError:
            self.kill()


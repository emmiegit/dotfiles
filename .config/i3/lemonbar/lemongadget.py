from constants import *
import atexit
import time


class LemonGadgetController(object):
    def __init__(self, process):
        self.gadgets = []
        self.proc = process
        self._left = []
        self._write_left = self._left.append
        self._center = []
        self._write_center = self._center.append
        self._right = []
        self._write_right = self._right.append

    def register(self, gadget):
        self.gadgets.append(gadget)

        if gadget.alignment == ALIGN_LEFT:
            gadget._write = self._write_left
        elif gadget.alignment == ALIGN_CENTER:
            gadget._write = self._write_center
        elif gadget.alignment == ALIGN_RIGHT:
            gadget._write = self._write_right
        else:
            raise ValueError("Invalid alignment id: %s" % (gadget.alignment,))

        gadget._write = self.proc.stdin.write

    def register_all(self, gadgets):
        for gadget in gadgets:
            self.register(gadget)
            if hasattr(gadget, "quit"):
                atexit.register(gadget.quit)

    def _flush(self):
        if self._left:
            self.proc.stdin.write("%{l}")
            self.proc.stdin.write("".join(self._left))
            self._left = []

        if self._center:
            self.proc.stdin.write("%{c}")
            self.proc.stdin.write("".join(self._center))
            self._center = []

        if self._right:
            self.proc.stdin.write("%{r}")
            self.proc.stdin.write("".join(self._right))
            self._right = []

        self.proc.stdin.flush()

    def start(self):
        while True:
            self.tick()
            time.sleep(TICK_RATE)

    def tick(self):
        for gadget in self.gadgets:
            gadget.tick()
            self._flush()


class LemonGadget(object):
    def __init__(self, cycle, alignment):
        self.cycle = cycle
        self.alignment = alignment
        self._count = 0
        self._buf = []
        self._lastbg = BACKGROUND_COLOR
        self._write = None

    def tick(self):
        if self._count == self.cycle - 1:
            self._count = 0
            self._buf = []
            self.update()
        else:
            self._count += 1

        self.flush()

    def update(self):
        raise NotImplementedError

    def flush(self):
        if self._write is None:
            raise RuntimeError("LemonGagdet is not registered with a LemonGagetController.")

        self._write("".join(self._buf).encode("utf-8"))

    def append_separator(self, transition_color):
        if self.alignment == ALIGN_CENTER:
            return
        elif self.alignment == ALIGN_LEFT:
            sep = SEPARATOR_RIGHT
        elif self.alignment == ALIGN_RIGHT:
            sep = SEPARATOR_LEFT
        else:
            raise ValueError("Invalid alignment: %s" % repr(self.alignment))

        self._buf.append("%%{B%s F%s}%s%%{B%s F%s}" %
                         (transition_color, self._lastbg, sep, self._lastbg, transition_color))
        self._lastbg = transition_color

    def append_light_separator(self):
        if self.alignment == ALIGN_CENTER:
            return
        elif self.alignment == ALIGN_LEFT:
            sep = LIGHT_SEPARATOR_RIGHT
        elif self.alignment == ALIGN_RIGHT:
            sep = LIGHT_SEPARATOR_LEFT
        else:
            raise ValueError("Invalid alignment: %s" % repr(self.alignment))

        self._buf.append(sep)

    def append_text(self, text):
        self._buf.append(text)

    def append_format(self, bg=None, fg=None):
        if bg and fg:
            self._buf.append("%%{B%s F%s}" % (bg, fg))
            self._lastbg = bg
        elif bg:
            self._buf.append("%%{B%s}" % bg)
            self._lastbg = bg
        elif fg:
            self._buf("%s%%{F%s}" % fg)


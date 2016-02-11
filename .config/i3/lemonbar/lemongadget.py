from constants import *


class LemonGadgetController(object):
    def __init__(self, process):
        self.gadgets = []
        self.proc = process
        self.cleanup_hooks = []
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

    def register_all(self, gadgets):
        for gadget in gadgets:
            self.register(gadget)
            if hasattr(gadget, "quit"):
                self.cleanup_hooks.append(gadget.quit)

    def _write(self, string):
        self.proc.stdin.write(string.encode("utf-8"))

    def _flush(self):
        print("left: %s" % self._left)
        print("center: %s" % self._center)
        print("right: %s" % self._right)

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

    def tick(self):
        for gadget in self.gadgets:
            gadget.tick()
        self._flush()

    def quit(self):
        for hook in self.cleanup_hooks:
            hook()


class LemonGadget(object):
    def __init__(self, cycle, alignment):
        self.cycle = cycle
        self.alignment = alignment
        self.preupdate = None
        self.icon_font = 2
        self._count = cycle - 1
        self._buf = []
        self._lastbg = BACKGROUND_COLOR
        self._lastfg = FOREGROUND_COLOR
        self._write = None

        if alignment == ALIGN_LEFT:
            self.append_separator = self.append_left_separator
        elif alignment == ALIGN_RIGHT:
            self.append_separator = self.append_right_separator
        elif alignment == ALIGN_CENTER:
            self.append_separator = self._cant_append_sep
        else:
            raise ValueError("Invalid value for \"alignment\": %s" % alignment)

    def tick(self):
        if self._count >= self.cycle - 1:
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
            raise RuntimeError("This LemonGagdet is not registered with a LemonGagetController.")

        self._write("".join(self._buf))

    def add_anchor(self, leftclick="", rightclick=""):
        self._buf.append("%%{A:%s:%s}" % (leftclick, rightclick))

    def end_anchor(self):
        self._buf.append("%{A}")

    def add_format(self, bg=None, fg=None):
        if bg == self._lastbg:
            bg = None
        if fg == self._lastfg:
            fg = None

        if bg and fg:
            self._buf.append("%%{B%s F%s}" % (bg, fg))
            self._lastbg = bg
            self._lastfg = fg
        elif bg:
            self._buf.append("%%{B%s}" % bg)
            self._lastbg = bg
        elif fg:
            self._buf.append("%%{F%s}" % fg)
            self._lastfg = fg

    @staticmethod
    def _cant_append_sep(self, transition_color):
        return RuntimeError("Attempt to append separator in centered gadget.")

    def append_left_separator(self, transition_color):
        self._buf.append("%%{B%s F%s}%s%%{F%s}" %
                         (transition_color, self._lastbg, SEPARATOR_RIGHT, self._lastfg))
        self._lastbg = transition_color

    def append_right_separator(self, transition_color):
        self._buf.append("%%{B%s F%s}%s%%{F%s}" %
                         (self._lastbg, transition_color, SEPARATOR_LEFT, self._lastfg))
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

    def append_icon(self, text):
        self._buf.append("%%{T%d}%s%%{T-}" % (self.icon_font, text))

    def append_text(self, text):
        self._buf.append(text)


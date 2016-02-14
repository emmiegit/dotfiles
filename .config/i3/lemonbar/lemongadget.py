from constants import *


class LemonGadget(object):
    def __init__(self, delay, alignment, wants=None, **kwargs):
        """
        Creates a LemonGadget object, which, when managed by a LemonGadgetController, can
        pass text for lemonbar to display. Includes methods that help with lemonbar formatting,
        such as add_anchor() rather than manually appending "%{A:left_click:right_click}".
        :param delay: how many seconds should pass in between actually updating the gadget
        :param alignment: where the gadget should be: left, center, or right-aligned
        :param wants: if the gadget needs a special service, like the i3Handle, it must say so here
        :param kwargs: you can manually set class
        """
        if delay < 0:
            self.delay = -1
            self.cycle = -1
        else:
            self.delay = delay
            self.cycle = int(delay / TICK_DELAY)

        self.alignment = alignment
        self.wants = wants
        self.handle = None
        self.icon_font = 2
        self.max_length = 100
        self._count = self.cycle - 1
        self._buf = []
        self._lastbg = BACKGROUND_COLOR
        self._lastfg = FOREGROUND_COLOR
        self._write = None

        for key, value in kwargs.items():
            setattr(self, key, value)

        if alignment == ALIGN_LEFT:
            self.append_separator = self.append_left_separator
        elif alignment == ALIGN_RIGHT:
            self.append_separator = self.append_right_separator
        elif alignment == ALIGN_CENTER:
            self.append_separator = self._cant_append_sep
        else:
            raise ValueError("Invalid value for alignment: %s" % repr(self.alignment))

    def tick(self):
        """
        Run every time the LemonGadgetController ticks.
        It will only invoke update() if the time since last update is greater
        than self.delay.
        """
        if self.cycle > 0 and self._count >= self.cycle - 1:
            self._count = 0
            self._buf = []
            self.update()
        else:
            self._count += 1

        self.flush()

    def update(self):
        raise NotImplementedError("Abstract class method.")

    def flush(self):
        if self._write is None:
            raise RuntimeError("This LemonGadget is not registered with a LemonGadgetController.")

        text = "".join(self._buf)
        if len(text) > self.max_length:
            text = text[:self.max_length - 3] + "..."
        self._write(text)

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
        self._buf.append("%%{B%s F%s}%s%%{B%s F%s}" %
                         (transition_color, self._lastbg, SEPARATOR_RIGHT, transition_color, self._lastfg))
        self._lastbg = transition_color

    def append_right_separator(self, transition_color):
        self._buf.append("%%{B%s F%s}%s%%{B%s F%s}" %
                         (self._lastbg, transition_color, SEPARATOR_LEFT, transition_color, self._lastfg))
        self._lastbg = transition_color

    def append_light_separator(self):
        if self.alignment == ALIGN_CENTER:
            return
        elif self.alignment == ALIGN_LEFT:
            sep = LIGHT_SEPARATOR_RIGHT
        elif self.alignment == ALIGN_RIGHT:
            sep = LIGHT_SEPARATOR_LEFT
        else:
            raise ValueError("Invalid value for alignment: %s" % repr(self.alignment))

        self._buf.append(sep)

    def append_icon(self, text):
        self._buf.append("%%{T%d}%s%%{T-}" % (self.icon_font, text))

    def append_text(self, text):
        self._buf.append(text)


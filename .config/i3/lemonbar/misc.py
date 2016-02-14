from lemongadget import LemonGadget


class Space(LemonGadget):
    def __init__(self, alignment, spacecount=1):
        super().__init__(-1, alignment)
        self.spaces = " " * spacecount

    def update(self):
        self.append_text(self.spaces)


class StaticText(LemonGadget):
    def __init__(self, alignment, text=""):
        super().__init__(-1, alignment)
        self.append_text(text)

    def update(self):
        pass


class StaticIcon(LemonGadget):
    def __init__(self, alignment, text=""):
        super().__init__(-1, alignment)
        self.append_icon(text)

    def update(self):
        pass


class NextMonitor(StaticText):
    def __init__(self, alignment):
        super().__init__(alignment, "%{S+}")


class PreviousMonitor(StaticText):
    def __init__(self, alignment):
        super().__init__(alignment, "%{S-}")


class FirstMonitor(StaticText):
    def __init__(self, alignment):
        super().__init__(alignment, "%{Sf}")


class LastMonitor(StaticText):
    def __init__(self, alignment):
        super().__init__(alignment, "%{Sl}")


class SpecificMonitor(StaticText):
    def __init__(self, alignment, monitor):
        if type(monitor) != int:
            raise TypeError("Expected '%s', got '%s'." % (type(int), type(monitor)))
        elif not 0 > monitor > 9:
            raise ValueError("Monitor must be a value from 0 to 9.")

        super().__init__(alignment, "%%{S%d}" % monitor)


class SetOverline(StaticText):
    def __init__(self, alignment):
        super().__init__(alignment, "%{+o}")


class UnsetOverline(StaticText):
    def __init__(self, alignment):
        super().__init__(alignment, "%{-o}")


class ToggleOverline(StaticText):
    def __init__(self, alignment):
        super().__init__(alignment, "%{!o}")


class SetUnderline(StaticText):
    def __init__(self, alignment):
        super().__init__(alignment, "%{+u}")


class UnsetUnderline(StaticText):
    def __init__(self, alignment):
        super().__init__(alignment, "%{-u}")


class ToggleUnderline(StaticText):
    def __init__(self, alignment):
        super().__init__(alignment, "%{!u}")

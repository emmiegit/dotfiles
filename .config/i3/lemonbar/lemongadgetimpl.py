from i3_workspaces import *
from lemongadget import *
from media import *
from system_stats import *
from weather import *
from window_state import *


# i3_workspaces.py
class WorkspacesGadget(LemonGadget):
    def __init__(self, cycle, alignment, monitor):
        super().__init__(cycle, alignment)
        self.i3_handle = i3Handle(monitor)

    def update(self):
        workspaces = self.i3_handle.get_workspace_list()
        for index, (workspace, state, monitor) in enumerate(workspaces):
            if index == 0:
                if state == WORKSPACE_INACTIVE:
                    self.add_format(bg=INACTIVE_WORKSPACE_COLOR)
                elif state == WORKSPACE_ACTIVE or state == WORKSPACE_FOCUSED:
                    self.add_format(bg=ACTIVE_WORKSPACE_COLOR)
                elif state == WORKSPACE_URGENT:
                    self.add_format(bg=URGENT_WORKSPACE_COLOR)
                else:
                    raise ValueError("Invalid workspace state: %s" % state)

                # print workspace icon
                self.append_text("W:")
            else:
                if state == WORKSPACE_INACTIVE:
                    self.append_separator(INACTIVE_WORKSPACE_COLOR)
                elif state == WORKSPACE_ACTIVE or state == WORKSPACE_FOCUSED:
                    self.append_separator(ACTIVE_WORKSPACE_COLOR)
                elif state == WORKSPACE_URGENT:
                    self.append_separator(URGENT_WORKSPACE_COLOR)

            self.add_anchor(leftclick="i3-msg workspace %s" % workspace)
            self.append_text(workspace)
            self.end_anchor()

            if index == len(workspaces) - 1:
                self.append_separator(BACKGROUND_COLOR)

    def quit(self):
        self.i3_handle.quit()


# media.py
class NowPlayingGadget(LemonGadget):
    def update(self):
        self.append_light_separator()
        # music note icon
        self.append_text(now_playing())


class VolumeGadget(LemonGadget):
    def update(self):
        self.append_light_separator()
        self.append_text("X" if is_muted() else "<")
        self.append_text(get_volume())


# system_stats.py
class CPUGadget(LemonGadget):
    def update(self):
        perc = int(cpu_percentage())

        lastfg = self._lastfg
        if perc >= CPU_PERC_ALERT:
            self.add_format(fg=ALERT_COLOR)

        # cpu icon
        self.append_text("%d%%" % perc)
        self.add_format(fg=lastfg)


class MemoryGadget(LemonGadget):
    def update(self):
        perc = int(memory_percentage())

        lastfg = self._lastfg
        if perc >= MEMORY_PERC_ALERT:
            self.add_format(fg=ALERT_COLOR)

        # memory icon
        self.append_text("%d%%" % perc)
        self.add_format(fg=lastfg)


class NetworkGadget(LemonGadget):
    def update(self):
        up, down = network_up_down()

        if up + down >= NETWORK_ALERT:
            self.append_separator(ALERT_COLOR)
        else:
            self.append_light_separator()

        # network icon
        self.append_text("%s / %s" % (network_units(up), network_units(down)))


class NetworkUsageGadget(LemonGadget):
    def update(self):
        up, down = network_up_down()
        usage = up + down

        if usage >= NETWORK_ALERT:
            self.append_separator(ALERT_COLOR)
        else:
            self.append_light_separator()

        # network icon
        self.append_text(network_units(usage))


class TimeGadget(LemonGadget):
    def update(self):
        self.append_separator(SECONDARY_COLOR)
        self.append_text(formatted_time())


# weather.py
class WeatherFahrenheitGadget(LemonGadget):
    def update(self):
        weather, temp = weather_fahrenheit(ZIP_CODE)
        if weather is None and temp is None:
            self.append_text("(error)")
        elif weather is None:
            self.append_text("%.1f%sF" % (temp, DEGREES))
        else:
            self.append_text("%s %s.1f%sF" % (weather, temp, DEGREES))


class WeatherCelsiusGadget(LemonGadget):
    def update(self):
        weather, temp = weather_celsius(ZIP_CODE)
        if weather is None and temp is None:
            self.append_text("(error)")
        elif weather is None:
            self.append_text("%.1f%sC" % (temp, DEGREES))
        else:
            self.append_text("%s %s.1f%sF" % (weather, temp, DEGREES))


# window_state.py
class WindowTitleGadget(LemonGadget):
    def update(self):
        self.append_text(window_title().rstrip())


class AutolockStateGadget(LemonGadget):
    def update(self):
        if not autolock_state():
            self.append_text("X")
            self.append_light_separator()


# misc
class DummyGadget(LemonGadget):
    def __init__(self, cycle, alignment, text="<TEST>"):
        super().__init__(cycle, alignment)
        self.text = text

    def update(self):
        self.append_text(self.text)

class DummyIconGadget(LemonGadget):
    def __init__(self, cycle, alignment, text=""):
        super().__init__(cycle, alignment)
        self.text = text

    def update(self):
        self.append_icon(self.text)

# support for left vs right monitor?
GADGETS = (
    WorkspacesGadget(1, ALIGN_LEFT, LEFT_MONITOR),
    AutolockStateGadget(1, ALIGN_LEFT),

    WindowTitleGadget(1, ALIGN_CENTER),

    DummyIconGadget(1, ALIGN_RIGHT, ICON_CPU),
    CPUGadget(1, ALIGN_RIGHT),
    MemoryGadget(1, ALIGN_RIGHT),
    TimeGadget(1, ALIGN_RIGHT),
)



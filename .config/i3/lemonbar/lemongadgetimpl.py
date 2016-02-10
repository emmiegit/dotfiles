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
        self.i3_handle = i3Handle()
        self.monitor = monitor

    def update(self):
        first = True

        for workspace, state, monitor in self.i3_handle.get_workspace_list():
            if monitor != self.monitor:
                continue

            if first:
                first = False
                if state == WORKSPACE_INACTIVE:
                    self.append_format(bg=INACTIVE_WORKSPACE_COLOR)
                elif state == WORKSPACE_ACTIVE or state == WORKSPACE_FOCUSED:
                    self.append_format(bg=ACTIVE_WORKSPACE_COLOR)
                elif state == WORKSPACE_URGENT:
                    self.append_format(bg=URGENT_WORKSPACE_COLOR)

                # print workspace icon
            else:
                if state == WORKSPACE_INACTIVE:
                    self.append_separator(INACTIVE_WORKSPACE_COLOR)
                elif state == WORKSPACE_ACTIVE or state == WORKSPACE_FOCUSED:
                    self.append_separator(ACTIVE_WORKSPACE_COLOR)
                elif state == WORKSPACE_URGENT:
                    self.append_separator(URGENT_WORKSPACE_COLOR)

            self.append_text(workspace)

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

        if perc >= CPU_PERC_ALERT:
            self.append_separator(ALERT_COLOR)
        else:
            self.append_light_separator()

        # cpu icon
        self.append_text("%d%%" % perc)


class MemoryGadget(LemonGadget):
    def update(self):
        perc = int(memory_percentage())

        if perc >= MEMORY_PERC_ALERT:
            self.append_separator(ALERT_COLOR)
        else:
            self.append_light_separator()

        # memory icon
        self.append_text("%d%%" % perc)


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
        self.append_text(window_title())


class AutolockStateGadget(LemonGadget):
    def update(self):
        if not autolock_state():
            self.append_light_separator()
            self.append_text("X")

# support for left vs right monitor?
GADGETS = (
    WorkspacesGadget(1, ALIGN_LEFT, "DVI-D-0"),
    AutolockStateGadget(10, ALIGN_LEFT),

    WindowTitleGadget(1, ALIGN_CENTER),

    CPUGadget(2, ALIGN_RIGHT),
    MemoryGadget(2, ALIGN_RIGHT),
    TimeGadget(5, ALIGN_RIGHT),
)



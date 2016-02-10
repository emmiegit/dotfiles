from constants import *
from lemongadget import *
from media import *
from system_stats import *
from weather import *
from window_state import *


# i3_workspaces.py
class WorkspacesGadget(LemonGadget):
    def update(self):
        # workspace icon
        self.append_text("placeholder")


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


class AutolockGadget(LemonGadget):
    def update(self):
        if not autolock_state():
            self.append_light_separator()
            self.append_text("X")


GADGETS = (
)



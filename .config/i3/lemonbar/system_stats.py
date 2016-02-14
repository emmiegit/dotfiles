from constants import *
from lemongadget import LemonGadget
import psutil
import time

NETWORK_TEST_DELAY = 0.0001


def cpu_percentage():
    return psutil.cpu_percent()


def memory_percentage():
    return psutil.virtual_memory().percent


def network_up_down():
    net = psutil.net_io_counters()
    time.sleep(NETWORK_TEST_DELAY)
    net2 = psutil.net_io_counters()

    up = (net2.bytes_sent - net.bytes_sent) / NETWORK_TEST_DELAY
    down = (net2.bytes_recv - net.bytes_recv) / NETWORK_TEST_DELAY
    return up, down


def network_units(bytes_moved):
    if bytes_moved > (1 << 30):
        return bytes_moved, (bytes_moved / (1 << 30)), "GiB"
    elif bytes_moved > (1 << 20):
        return bytes_moved, (bytes_moved / (1 << 20)), "MiB"
    elif bytes_moved > (1 << 10):
        return bytes_moved, (bytes_moved / (1 << 10)), "KiB"
    else:
        return bytes_moved, bytes_moved, "bytes"


def network_units_kb(bytes_moved):
    if bytes_moved > (1 << 30):
        return bytes_moved, (bytes_moved / (1 << 30)), "GiB"
    elif bytes_moved > (1 << 20):
        return bytes_moved, (bytes_moved / (1 << 20)), "MiB"
    else:
        return bytes_moved, (bytes_moved / (1 << 10)), "KiB"


def network_units_mb(bytes_moved):
    if bytes_moved > (1 << 30):
        return bytes_moved, (bytes_moved / (1 << 30)), "GiB"
    else:
        return bytes_moved, (bytes_moved / (1 << 20)), "MiB"


def formatted_time():
    return time.strftime("%A, %b %d %Y%l:%M:%S %p")


class CPUGadget(LemonGadget):
    def update(self):
        self.append_light_separator()
        perc = int(cpu_percentage())

        lastfg = self._lastfg
        if perc >= CPU_PERC_ALERT:
            self.add_format(fg=ALERT_COLOR)

        self.add_anchor(leftclick="gnome-system-monitor")
        self.append_icon(ICON_CPU)
        self.append_text("%2d%%" % perc)
        self.add_format(fg=lastfg)
        self.end_anchor()
        self.append_text(" ")


class MemoryGadget(LemonGadget):
    def update(self):
        self.append_light_separator()
        perc = int(memory_percentage())

        lastfg = self._lastfg
        if perc >= MEMORY_PERC_ALERT:
            self.add_format(fg=ALERT_COLOR)

        self.add_anchor(leftclick="gnome-system-monitor")
        self.append_icon(ICON_MEMORY)
        self.append_text("%2d%%" % perc)
        self.add_format(fg=lastfg)
        self.end_anchor()
        self.append_text(" ")


class NetworkGadget(LemonGadget):
    def __init__(self, cycle, alignment, minunits=MIN_UNIT_BYTES, **kwargs):
        super().__init__(cycle, alignment, **kwargs)

        if minunits == MIN_UNIT_BYTES:
            self.get_units = network_units
        elif minunits == MIN_UNIT_KBYTES:
            self.get_units = network_units_kb
        elif minunits == MIN_UNIT_MBYTES:
            self.get_units = network_units_mb
        else:
            raise ValueError("Invalid value for minunits: %s" % minunits)

    def update(self):
        self.append_light_separator()
        self.append_icon(ICON_UPLOAD)

        up, down = network_up_down()
        lastfg = self._lastfg
        if up >= NETWORK_ALERT:
            self.add_format(fg=ALERT_COLOR)

        self.append_text("%d %s " % self.get_units(up)[1:])
        self.add_format(fg=lastfg)
        self.append_icon(ICON_DOWNLOAD)

        lastfg = self._lastfg
        if down >= NETWORK_ALERT:
            self.add_format(fg=ALERT_COLOR)

        self.append_text("%d %s " % self.get_units(down)[1:])
        self.add_format(fg=lastfg)


class NetworkUsageGadget(LemonGadget):
    def __init__(self, cycle, alignment, minunits=MIN_UNIT_BYTES):
        super().__init__(cycle, alignment)

        if minunits == MIN_UNIT_BYTES:
            self.get_units = network_units
        elif minunits == MIN_UNIT_KBYTES:
            self.get_units = network_units_kb
        elif minunits == MIN_UNIT_MBYTES:
            self.get_units = network_units_mb
        else:
            raise ValueError("Invalid value for minunits: %s" % minunits)

    def update(self):
        self.append_light_separator()
        up, down = network_up_down()
        usage = up + down

        self.append_icon(ICON_UPLOAD)
        self.append_icon(ICON_DOWNLOAD)

        lastfg = self._lastfg
        if usage >= NETWORK_ALERT:
            self.add_format(fg=ALERT_COLOR)

        self.append_text("%d %s " % self.get_units(usage)[1:])
        self.add_format(fg=lastfg)


class TimeGadget(LemonGadget):
    def update(self):
        self.add_anchor(leftclick="%s -e 'gcalcli agenda; %s'" % (TERMINAL, SHELL))
        self.append_light_separator()
        self.append_text(" ")
        self.append_text(formatted_time())
        self.end_anchor()



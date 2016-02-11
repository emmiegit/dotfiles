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
    return time.strftime("%A, %b %d %Y %l:%M:%S %p")

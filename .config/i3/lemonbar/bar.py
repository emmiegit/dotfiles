"""
This file contains the per-computer specification of how you want
your bar to work.
"""

from constants import *
from i3_workspaces import *
from media import *
from misc import *
from system_stats import *
from window_state import *

# Monitor names from xrandr
MONITOR = "LVDS-1"

# You can specify which gadgets you want here. Order matters.
GADGETS = (
    # Built-in monitor
    WorkspacesGadget(0.5, ALIGN_LEFT, MONITOR),
    WindowTitleGadget(0.3, ALIGN_CENTER),
    NowPlayingGadget(4.0, ALIGN_RIGHT, blank_if_none=True),
    CPUGadget(2.0, ALIGN_RIGHT),
    MemoryGadget(8.0, ALIGN_RIGHT),
    NetworkGadget(4.0, ALIGN_RIGHT, MIN_UNIT_KBYTES),
    VolumeGadget(0.2, ALIGN_RIGHT),
    TimeGadget(0.5, ALIGN_RIGHT),
)



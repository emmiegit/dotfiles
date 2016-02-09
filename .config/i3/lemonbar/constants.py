import os

# Files
LOCK_FILE = "/tmp/%s-lemonbar.lock" % (os.environ["USER"],)
AUTOLOCK_STATE_FILE = "/usr/local/scripts/dat/autolock_state"
PIANOBAR_NOWPLAYING = "%s/.config/pianobar/nowplaying" % (os.environ["HOME"],)

# Alert threshholds
CPU_ALERT = 70
MEMORY_ALERT = 50

# Colors
BACKGROUND_COLOR = "#ff000000"
FOREGROUND_COLOR = "#ffcccccc"
ACTIVE_WORKSPACE_COLOR = "#ff061739"
URGENT_WORKSPACE_COLOR = "#ff4d0000"
INACTIVE_WORKSPACE_COLOR = BACKGROUND_COLOR

# Alignment
NO_ALIGNMENT = ""
ALIGN_LEFT = "%{l}"
ALIGN_CENTER = "%{c}"
ALIGN_RIGHT = "%{r}"

# Fonts
FONTS = (
    "-xos4-terminesspowerline-medium-r-normal--12-120-72-72-c-60-iso10646-1",
    "-xos4-terminusicons2mono-medium-r-normal--12-120-72-72-m-60-iso8859-1",
)

# Icons and special characters
SEPARATOR_LEFT = "\xee\x82\xb2"
SEPARATOR_RIGHT = "\xee\x82\xb0"
LIGHT_SEPARATOR_LEFT = "\xee\x82\xb3"
LIGHT_SEPARATOR_RIGHT = "\xee\x82\xb1"
ICON_MEDIA_PLAY = "\xef\x81\x8b"
ICON_MEDIA_PAUSE = "\xef\x81\x8c"
ICON_UNKNOWN = "\xef\x84\xa8"
ICON_WIFI = "\xef\x87\xab"
ICON_TUX = "\xef\x85\xbc"

# terminusicons2 (wip)
ICON_CLOCK = "\xc3\x95"
ICON_CPU = "\xc3\x8f"
ICON_MEMORY = "\xc3\x9e"
ICON_DOWNLOAD = "\xc3\x90"
ICON_UPLOAD = "\xc3\x91"
ICON_VOLUME = "\xc3\x94"
ICON_HARD_DRIVE = "\xc3\x80"
ICON_HOME = "\xc3\x86"
ICON_MAIL = "\xc3\x93"
ICON_CHAT = "\xc3\x92"
ICON_MUSIC = "\xc3\x8e"
ICON_PROGRAM = "\xc3\x82"
ICON_CONTACT = "\xc3\x81"
ICON_WORKSPACE = "\xc3\x89"

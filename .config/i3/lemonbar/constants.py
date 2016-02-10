import os

# Files
LOCK_FILE = "/tmp/%s_lemonbar.lock" % (os.environ["USER"],)
AUTOLOCK_STATE_FILE = "/usr/local/scripts/dat/autolock_state"
PIANOBAR_NOWPLAYING = "%s/.config/pianobar/nowplaying" % (os.environ["HOME"],)
AUDIO_PLAYER_SCRIPT = ("/usr/local/scripts/wm/media/detect-audio-player.sh",)

# Static data
ZIP_CODE = 92521
TICK_RATE = 1 / 10
CPU_PERC_ALERT = 70
MEMORY_PERC_ALERT = 50
NETWORK_ALERT = 500 * (1 << 10)

# Colors
BACKGROUND_COLOR = "#ff000000"
SECONDARY_COLOR = "#ff262626"
FOREGROUND_COLOR = "#ffcccccc"
ALERT_COLOR = "#ff4d0000"
ACTIVE_WORKSPACE_COLOR = "#ff061739"
URGENT_WORKSPACE_COLOR = ALERT_COLOR
INACTIVE_WORKSPACE_COLOR = BACKGROUND_COLOR

# Alignment
ALIGN_LEFT = 0
ALIGN_CENTER = 1
ALIGN_RIGHT = 2

# Fonts
FONTS = (
    "-xos4-terminesspowerline-medium-r-normal--12-120-72-72-c-60-iso10646-1",
    "-xos4-terminusicons2mono-medium-r-normal--12-120-72-72-m-60-iso8859-1",
)

# Icons and special characters
DEGREES = b"\xc2\xb0".decode("utf-8")
SEPARATOR_LEFT = b"\xee\x82\xb2".decode("utf-8")
SEPARATOR_RIGHT = b"\xee\x82\xb0".decode("utf-8")
LIGHT_SEPARATOR_LEFT = b"\xee\x82\xb3".decode("utf-8")
LIGHT_SEPARATOR_RIGHT = b"\xee\x82\xb1".decode("utf-8")
ICON_MEDIA_PLAY = b"\xef\x81\x8b".decode("utf-8")
ICON_MEDIA_PAUSE = b"\xef\x81\x8c".decode("utf-8")
ICON_UNKNOWN = b"\xef\x84\xa8".decode("utf-8")
ICON_WIFI = b"\xef\x87\xab".decode("utf-8")
ICON_TUX = b"\xef\x85\xbc".decode("utf-8")

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

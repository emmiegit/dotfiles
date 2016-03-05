import os

# Files
PID_FILE = "/run/user/%d/lemonbar.pid" % os.geteuid()
AUTOLOCK_STATE_FILE = "/usr/local/scripts/dat/autolock_state"
PIANOBAR_NOWPLAYING = "%s/.config/pianobar/nowplaying" % (os.environ["HOME"],)
AUDIO_PLAYER_SCRIPT = ("/usr/local/scripts/wm/media/detect-audio-player.sh",)

# Static data
BAR_HEIGHT = 15
TERMINAL = "terminator"
SHELL = "zsh"
MAX_CLICKABLE_AREAS = 10
ZIP_CODE = 92521
TICK_DELAY = 1 / 6
CPU_PERC_ALERT = 70
MEMORY_PERC_ALERT = 50
NETWORK_ALERT = 10 * (1 << 20)

# Colors
BACKGROUND_COLOR = "#ff000000"
SECONDARY_COLOR = "#ff4d4d4d"
FOREGROUND_COLOR = "#ffcccccc"
ALERT_COLOR = "#ffb30000"
ACTIVE_WORKSPACE_COLOR = "#ff253a8d"
URGENT_WORKSPACE_COLOR = ALERT_COLOR
INACTIVE_WORKSPACE_COLOR = BACKGROUND_COLOR

# Enums
ALIGN_LEFT = 0
ALIGN_CENTER = 1
ALIGN_RIGHT = 2

MIN_UNIT_BYTES = 0
MIN_UNIT_KBYTES = 1
MIN_UNIT_MBYTES = 2

# Fonts
FONTS = (
    "AnonymousProForPowerline-10:Regular",
    "Terminusicons2Mono-10:Regular",
)

# Icons and special characters
DEGREES = b"\xc2\xb0".decode("utf-8")
SEPARATOR_LEFT = b"\xee\x82\xb2".decode("utf-8")
SEPARATOR_RIGHT = b"\xee\x82\xb0".decode("utf-8")
LIGHT_SEPARATOR_LEFT = b"\xee\x82\xb3".decode("utf-8")
LIGHT_SEPARATOR_RIGHT = b"\xee\x82\xb1".decode("utf-8")
ICON_CHAT = b"\xc3\x92".decode("utf-8")
ICON_CLOCK = b"\xc3\x95".decode("utf-8")
ICON_CONTACT = b"\xc3\x81".decode("utf-8")
ICON_CPU = b"\xc3\x8f".decode("utf-8")
ICON_DOWNLOAD = b"\xc3\x90".decode("utf-8")
ICON_LOCK = b"\xf0\x9f\x94\x91".decode("utf-8")
ICON_HARD_DRIVE = b"\xc3\x80".decode("utf-8")
ICON_HOME = b"\xc3\x86".decode("utf-8")
ICON_MAIL = b"\xc3\x93".decode("utf-8")
ICON_MEMORY = b"\xc3\x9e".decode("utf-8")
ICON_MUSIC = b"\xc3\x8e".decode("utf-8")
ICON_PROGRAM = b"\xc3\x82".decode("utf-8")
ICON_TUX = b"\xef\x85\xbc".decode("utf-8")
ICON_UPLOAD = b"\xc3\x91".decode("utf-8")
ICON_VOLUME = b"\xc3\x94".decode("utf-8")
ICON_WIFI = b"\xef\x87\xab".decode("utf-8")
ICON_WORKSPACE = b"\xc3\x89".decode("utf-8")

# Non-terminus icons
ICON_MEDIA_PAUSE = b"\xef\x81\x8c".decode("utf-8")
ICON_MEDIA_PLAY = b"\xef\x81\x8b".decode("utf-8")
ICON_UNKNOWN = b"\xef\x84\xa8".decode("utf-8")
ICON_VOLUME_HIGH = b"\xf0\x9f\x94\x8a".decode("utf-8")
ICON_VOLUME_LOW = b"\xf0\x9f\x94\x87".decode("utf-8")
ICON_VOLUME_MEDIUM = b"\xf0\x9f\x94\x88".decode("utf-8")
ICON_VOLUME_MUTED = b"\xf0\x9f\x94\x87".decode("utf-8")


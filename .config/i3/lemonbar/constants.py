import os

# Files
LOCK_FILE = "/tmp/%s_lemonbar.lock" % (os.environ["USER"],)
AUTOLOCK_STATE_FILE = "/usr/local/scripts/dat/autolock_state"
PIANOBAR_NOWPLAYING = "%s/.config/pianobar/nowplaying" % (os.environ["HOME"],)
AUDIO_PLAYER_SCRIPT = ("/usr/local/scripts/wm/media/detect-audio-player.sh",)

# Static data
LEFT_MONITOR = "DVI-D-0"
RIGHT_MONITOR = "DVI-D-1"
ZIP_CODE = 92521
TICK_RATE = 1 / 10
CPU_PERC_ALERT = 70
MEMORY_PERC_ALERT = 50
NETWORK_ALERT = 500 * (1 << 10)

# Colors
BACKGROUND_COLOR = "#ff000000"
SECONDARY_COLOR = "#ff262626"
FOREGROUND_COLOR = "#ffcccccc"
ALERT_COLOR = "#ff22195b"
ACTIVE_WORKSPACE_COLOR = "#ff18255a"
URGENT_WORKSPACE_COLOR = ALERT_COLOR
INACTIVE_WORKSPACE_COLOR = BACKGROUND_COLOR

# Alignment
ALIGN_LEFT = 0
ALIGN_CENTER = 1
ALIGN_RIGHT = 2

# Fonts
FONTS = (
    "DroidSansMonoDottedForPowerline-9:Regular",
    "Terminusicons2Mono-15:Regular",
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
ICON_CLOCK = b"\xc3\x95".decode("utf-8")
ICON_CPU = b"\xc3\x8f".decode("utf-8")
ICON_MEMORY = b"\xc3\x9e".decode("utf-8")
ICON_DOWNLOAD = b"\xc3\x90".decode("utf-8")
ICON_UPLOAD = b"\xc3\x91".decode("utf-8")
ICON_VOLUME = b"\xc3\x94".decode("utf-8")
ICON_HARD_DRIVE = b"\xc3\x80".decode("utf-8")
ICON_HOME = b"\xc3\x86".decode("utf-8")
ICON_MAIL = b"\xc3\x93".decode("utf-8")
ICON_CHAT = b"\xc3\x92".decode("utf-8")
ICON_MUSIC = b"\xc3\x8e".decode("utf-8")
ICON_PROGRAM = b"\xc3\x82".decode("utf-8")
ICON_CONTACT = b"\xc3\x81".decode("utf-8")
ICON_WORKSPACE = b"\xc3\x89".decode("utf-8")

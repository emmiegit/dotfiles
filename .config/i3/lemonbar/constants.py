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
MAX_CLICKABLE_AREAS = 20
ZIP_CODE = 92521
TICK_DELAY = 1 / 6
CPU_PERC_ALERT = 80
MEMORY_PERC_ALERT = 80
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

# Terminus icons
ICON_CDROM = b"\xc3\x80".decode("utf-8")
ICON_SOCIAL = b"\xc3\x81".decode("utf-8")
ICON_WINDOW = b"\xc3\x82".decode("utf-8")
ICON_MENU = b"\xc3\x83".decode("utf-8")
ICON_FACE = b"\xc3\x84".decode("utf-8")
ICON_CONNECTED = b"\xc3\x85".decode("utf-8")
ICON_HOME = b"\xc3\x86".decode("utf-8")
ICON_ARCH_LINUX = b"\xc3\x87".decode("utf-8")
ICON_MONITOR = b"\xc3\x88".decode("utf-8")
ICON_VERTICAL_WORKSPACES = b"\xc3\x89".decode("utf-8")
ICON_TWO_BOXES = b"\xc3\x8a".decode("utf-8")
ICON_SQUARE = b"\xc3\x8b".decode("utf-8")
ICON_HORIZONTAL_WORKSPACES = b"\xc3\x8c".decode("utf-8")
ICON_APPLICATIONS = b"\xc3\x8d".decode("utf-8")
ICON_MUSIC = b"\xc3\x8e".decode("utf-8")
ICON_CRATE = b"\xc3\x8f".decode("utf-8")
ICON_DOWN_ARROW = b"\xc3\x90".decode("utf-8")
ICON_UP_ARROW = b"\xc3\x91".decode("utf-8")
ICON_CHAT_BUBBLE = b"\xc3\x92".decode("utf-8")
ICON_MAIL = b"\xc3\x93".decode("utf-8")
ICON_VOLUME = b"\xc3\x94".decode("utf-8")
ICON_CLOCK = b"\xc3\x95".decode("utf-8")
ICON_DOT = b"\xc3\x96".decode("utf-8")
ICON_MULTIPLICATION_SIGN = b"\xc3\x97".decode("utf-8")
ICON_WIFI = b"\xc3\x98".decode("utf-8")
ICON_TRANSMISSION = b"\xc3\x99".decode("utf-8")
ICON_SEPARATOR_RIGHT = b"\xc3\x9a".decode("utf-8")
ICON_LIGHT_SEPARATOR_RIGHT = b"\xc3\x9b".decode("utf-8")
ICON_SEPARATOR_LEFT = b"\xc3\x9c".decode("utf-8")
ICON_LIGHT_SEPARATOR_LEFT = b"\xc3\x9d".decode("utf-8")
ICON_MICROCHIP = b"\xc3\x9e".decode("utf-8")
ICON_TALL_BLOCK = b"\xc3\x9f".decode("utf-8")

# Powerline icons
LIGHT_SEPARATOR_LEFT = b"\xee\x82\xb3".decode("utf-8")
LIGHT_SEPARATOR_RIGHT = b"\xee\x82\xb1".decode("utf-8")
SEPARATOR_LEFT = b"\xee\x82\xb2".decode("utf-8")
SEPARATOR_RIGHT = b"\xee\x82\xb0".decode("utf-8")

# Other icons
DEGREES = b"\xc2\xb0".decode("utf-8")
ICON_LOCK = b"\xf0\x9f\x94\x91".decode("utf-8")
ICON_MEDIA_PAUSE = b"\xef\x81\x8c".decode("utf-8")
ICON_MEDIA_PLAY = b"\xef\x81\x8b".decode("utf-8")
ICON_TUX = b"\xef\x85\xbc".decode("utf-8")
ICON_UNKNOWN = b"\xef\x84\xa8".decode("utf-8")
ICON_VOLUME_HIGH = b"\xf0\x9f\x94\x8a".decode("utf-8")
ICON_VOLUME_LOW = b"\xf0\x9f\x94\x87".decode("utf-8")
ICON_VOLUME_MEDIUM = b"\xf0\x9f\x94\x88".decode("utf-8")
ICON_VOLUME_MUTED = b"\xf0\x9f\x94\x87".decode("utf-8")
ICON_WIFI = b"\xef\x87\xab".decode("utf-8")

# Icon aliases
ICON_CPU = ICON_MICROCHIP
ICON_MEMORY = ICON_CRATE
ICON_WORKSPACE = ICON_VERTICAL_WORKSPACES
ICON_UPLOAD = ICON_UP_ARROW
ICON_DOWNLOAD = ICON_DOWN_ARROW


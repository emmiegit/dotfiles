from lemongadget import LemonGadget
from constants import AUDIO_PLAYER_SCRIPT, ICON_MUSIC, ICON_VOLUME, PIANOBAR_NOWPLAYING
import subprocess


def audio_player():
    try:
        return subprocess.check_output(AUDIO_PLAYER_SCRIPT)
    except subprocess.CalledProcessError:
        return b"??"


def now_playing():
    player = audio_player()
    if player == b"mocp":
        try:
            song = subprocess.check_output(("mocp", "-Q", "%song")).decode("utf-8").rstrip()
            artist = subprocess.check_output(("mocp", "-Q", "%artist")).decode("utf-8").rstrip()

            if not song:
                song = "(unknown)"
            if not artist:
                artist = "(unknown)"

            return "%s by %s" % (song, artist)
        except subprocess.CalledProcessError:
            return "(error)"
    elif player == b"pianobar":
        artist = "(unknown)"
        title = "(unknown)"

        try:
            with open(PIANOBAR_NOWPLAYING, 'r') as fh:
                for line in fh.readlines():
                    if line.startswith("artist="):
                        artist = line[7:-1]
                    elif line.startswith("title="):
                        title = line[6:-1]
        except (FileNotFoundError, IOError, OSError):
            return "(error)"

        return "%s by %s" % (title, artist)
    elif player == b"vlc":
        try:
            output = subprocess.check_output((
                "qdbus", "org.mpris.MediaPlayer2.vlc",
                "/org/mpris/MediaPlayer2", "org.freedesktop.DBus.Properties.Get",
                "org.mpris.MediaPlayer2.Player", "Metadata"))

            for line in output.splitlines():
                if line.startswith("xesam: url: "):
                    return line[12:]

            return "??"
        except subprocess.CalledProcessError:
            return "(error)"
    else:
        return "(none)"


# TODO: switch to use libpulseaudio
def is_muted():
    return subprocess.getoutput("pamixer --get-mute") == "true"


def get_volume():
    volume = subprocess.getoutput("pamixer --get-volume")

    if volume.isdigit():
        return int(volume)
    else:
        return -1


class NowPlayingGadget(LemonGadget):
    blank_if_none = False

    def update(self):
        song = now_playing()

        if song == "(none)" and self.blank_if_none:
            return

        self.append_icon(ICON_MUSIC)
        self.append_text(" ")
        self.append_text(song)
        self.append_text(" ")


class VolumeGadget(LemonGadget):
    def update(self):
        self.append_light_separator()
        self.add_anchor(leftclick="pamixer --toggle-mute")
        self.append_icon(ICON_VOLUME)
        if is_muted():
            self.append_text("--% ")
        else:
            volume = get_volume()
            if volume >= 0:
                self.append_text("%2d%% " % volume)
            else:
                self.append_text("??")
        self.end_anchor()



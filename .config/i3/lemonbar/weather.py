from constants import *
from lemongadget import LemonGadget
from urllib.request import urlopen, URLError
import re

TEMPERATURE_REGEX = re.compile(r"<title>Currently: ([A-Za-z]+): ([0-9]+)F</title>")


def weather_fahrenheit(zip_code):
    try:
        req = urlopen("http://rss.accuweather.com/rss/liveweather_rss.asp?locCode=%d" % zip_code)
    except URLError:
        return None, None

    matches = TEMPERATURE_REGEX.findall(req.read().decode("utf-8"))
    if matches:
        return matches[0][0], float(matches[0][1])
    else:
        return None, None


def weather_celsius(zip_code):
    weather, temp = weather_fahrenheit(zip_code)
    if temp is None:
        return weather, temp
    else:
        return weather, (temp - 32) / 1.8


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


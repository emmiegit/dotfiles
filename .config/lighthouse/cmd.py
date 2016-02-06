#!/usr/bin/env python2
from __future__ import division
from multiprocessing import Array
from ctypes import c_char
import os, sys, subprocess
import random, math
import json, re, time

try:
    import xdg.BaseDirectory
    import xdg.DesktopEntry
    import xdg.IconTheme
    HAS_XDG = True
except ImportError:
    HAS_XDG = False

HERE = os.path.dirname(sys.argv[0])

if "XDG_CONFIG_HOME" in os.environ:
    XDG_CONFIG_HOME = os.environ["XDG_CONFIG_HOME"]
else:
    XDG_CONFIG_HOME = os.path.expanduser("~/.config")

try:
    _dict = json.load(file("%s/shortcuts.json" % (HERE), 'r'))
    SHORTCUTS = {}
    for key in _dict.keys():
        SHORTCUTS[key.lower()] = _dict[key]
except:
    SHORTCUTS = {}

MATH_FUNCTIONS = (
    "atan",
    "atan2",
    "atanh",
    "ceil",
    "cos",
    "cosh",
    "degrees",
    "exp",
    "exmp1",
    "factorial",
    "floor",
    "inf",
    "log",
    "log10",
    "radians",
    "sin",
    "sinh",
    "tan",
    "tanh",
)

ICON_THEME_CONFIG_FILES = (
    os.path.expanduser("~/.gtkrc-2.0"),
    os.path.expanduser("~/.config/gtkrc-2.0"),
    "/etc/gtk-2.0/gtkrc",
    "%s/gtk-3.0/settings.ini" % XDG_CONFIG_HOME,
    "/etc/gtk-3.0/settings.ini",
)

TERMINAL = "terminator"
ANSWER_TOO_LONG = 30 # In digits
MAX_OUTPUT = 100 * 1024
result_buf = Array(c_char, MAX_OUTPUT);

# Output management
def clear_output():
    result_buf.value = json.dumps([])

def update_output():
    results = json.loads(result_buf.value)
    print("".join(results))
    sys.stdout.flush()

def append_output(title, action):
    result = create_result(title, action)
    results = json.loads(result_buf.value)

    if len(results) < 2:
        results.append(result)
    else: # Ignore the bottom two default option
        results.insert(-2, result)

    result_buf.value = json.dumps(results)

def prepend_output(title, action):
    results = json.loads(result_buf.value)
    results.insert(0, create_result(title, action))
    result_buf.value = json.dumps(results)

def get_process_output(process, string, action):
    process_out = str(subprocess.check_output(process))
    out_str = ((string % (process_out) if ("%s" in string) else string))
    out_act = ((action % (process_out) if ("%s" in action) else action))
    return (out_str, out_act)

# Other results
def add_math_result(string):
    string = string.lower() \
                   .replace("pi", str(math.pi)) \
                   .replace("e", str(math.e)) \
                   .replace("x", "*") \
                   .replace("^", "**") \
                   .replace("[", "(") \
                   .replace("]", ")") \
                   .replace("log", "log10") \
                   .replace("ln", "log")

    for func in MATH_FUNCTIONS:
        string = string.replace(func, "math." + func)

    if not re.match(r"[()0-9.+-x*/acdefghilmnoprstx]+", string):
        return

    try:
        answer = eval(string)

        if type(answer) in (int, float):
            prepend_output("= %s" % (answer), "true")
        elif type(answer) == long:
            if math.log(abs(answer)) < ANSWER_TOO_LONG: # Make sure the output isn't hideously long
                prepend_output("= %d" % (answer), "true")
            else:
                prepend_output("= %s..." % (str(answer)[:ANSWER_TOO_LONG]), "true")
    except ZeroDivisionError:
        prepend_output("= undefined", "true")
    except:
        pass

def get_calendar_event():
    try:
        outp = subprocess.check_output(("gcalcli", "agenda", time.ctime()))
        evt = outp.splitlines()[1]
        return re.sub("\x1b\\[.*?m", "", evt)
    except:
        return None

# XDG functions
def xdg_find_desktop_entry(cmd):
    files = list(xdg.BaseDirectory.load_data_paths(\
            "applications", "%s.desktop" % (cmd)))

    if files:
        # Earlier paths take precedence
        return xdg.DesktopEntry.DesktopEntry(files[0])

def xdg_get_icon_theme():
    for fn in ICON_THEME_CONFIG_FILES:
        try:
            for line in file(fn, 'r').readlines():
                # Extract icon theme and remove quotes
                match = re.match(r'^\s*gtk-icon-theme-name\s*=\s*("?)(.*)\1\s*', line)
                if match:
                    return match.group(2)
        except:
            pass

    # Fallback icon theme, required to be present
    return "hicolor"

def xdg_get_icon(desktop_entry):
    icon = desktop_entry.getIcon()
    if icon:
        fn = xdg.IconTheme.getIconPath(icon, theme=xdg_get_icon_theme())

        if fn.lower().endswith(".svg"):
            # Temporary, because lighthouse can't show svgs :(
            return xdg.IconTheme.getIconPath(icon)
        else:
            return fn

def xdg_get_exec(desktop_entry):
    # Since the exec path may contain subsitution parameters such as %f,
    # we need to remove them.
    exec_spec = desktop_entry.getExec()
    return re.sub(r"%.", "", exec_spec).strip()

def xdg_get_cmd(cmd):
    if not HAS_XDG:
        return

    desktop_entry = xdg_find_desktop_entry(cmd)
    if not desktop_entry:
        return

    exec_path = xdg_get_exec(desktop_entry)
    if not exec_path:
        return

    icon = xdg_get_icon(desktop_entry)
    if icon:
        menu_entry = "%%I%s%%%s" % (icon, cmd)
    else:
        menu_entry = cmd

    return (menu_entry, exec_path)

# Helper functions
def sanitize(string):
    return string.replace("{", "\\{") \
                 .replace("}", "\\}") \
                 .replace("|", "\\|") \
                 .replace("\n", " ")

def create_result(title, action):
    return "{%s |%s }" % \
        (sanitize(title),
         sanitize(action))

# Main function
def parse_line():
    line = sys.stdin.readline()[:-1]
    clear_output()

    if not line:
        update_output()
        return

    try:
        complete = subprocess.check_output("compgen -c %s" % (line),
                shell=True, executable="/bin/bash").split("\n")

        for cmd_num in range(min(len(complete), 5)):
            # Look for XDG applications of the given name.
            xdg_cmd = xdg_get_cmd(complete[cmd_num])
            if xdg_cmd:
                append_output(*xdg_cmd)
    except:
        pass

    shortcut = SHORTCUTS.get(line)
    if shortcut:
        append_output("shortcut: %s" % (shortcut), shortcut)

    # Make sure these items are at the top
    add_math_result(line)
    prepend_output("run '%s' in a shell" % (line), "%s -e %s" % (TERMINAL, line))
    prepend_output("execute '%s'" % line, line)
    update_output()

# Main loop
if __name__ == "__main__":
    while True:
        parse_line()


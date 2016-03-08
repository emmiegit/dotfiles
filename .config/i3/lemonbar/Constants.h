/* Constants.h
 *
 * barman - A program to manage your lemonbar
 * Copyright (c) 2016 Ammon Smith
 * 
 * barman is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 * 
 * barman is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with barman.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef __CONSTANTS_H
#define __CONSTANTS_H

#define TICK_DELAY            (1 / 6.0)

#define DEGREES               "\xc2\xb0"
#define SEPARATOR_LEFT        "\xee\x82\xb2"
#define SEPARATOR_RIGHT       "\xee\x82\xb0"
#define LIGHT_SEPARATOR_LEFT  "\xee\x82\xb3"
#define LIGHT_SEPARATOR_RIGHT "\xee\x82\xb1"

#define ICON_CHAT             "\xc3\x92"
#define ICON_CLOCK            "\xc3\x95"
#define ICON_CONTACT          "\xc3\x81"
#define ICON_CPU              "\xc3\x9e"
#define ICON_DOWNLOAD         "\xc3\x90"
#define ICON_HARD_DRIVE       "\xc3\x80"
#define ICON_HOME             "\xc3\x86"
#define ICON_MAIL             "\xc3\x93"
#define ICON_MEMORY           "\xc3\x8f"
#define ICON_MUSIC            "\xc3\x8e"
#define ICON_PROGRAM          "\xc3\x82"
#define ICON_UPLOAD           "\xc3\x91"
#define ICON_VOLUME           "\xc3\x94"
#define ICON_WORKSPACE        "\xc3\x89"

#define LEMONBAR_ALIGN_LEFT   "%{l}"
#define LEMONBAR_ALIGN_CENTER "%{c}"
#define LEMONBAR_ALIGN_RIGHT  "%{r}"

enum Alignment {
    Left,
    Center,
    Right,
};

enum DataUnit {
    Bytes,
    Kilobytes,
    Megabytes,
};

enum GadgetResource {
    None,
    i3,
    xprop,
};

#endif /* __CONSTANTS_H */


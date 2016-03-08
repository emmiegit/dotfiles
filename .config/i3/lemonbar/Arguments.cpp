/* Arguments.cpp
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

#include <cstring>
#include <cstdlib>
#include <iostream>

#define STREQ(x, y) (strcmp((x), (y)) == 0)

static void helpAndQuit();
static void usageAndQuit();

void parseArgs(const int argc, const char *argv[])
{
    if (argc == 1) {
        return;
    }

    for (int i = 0; i < argc; i++) {
        if (STREQ(argv[i], "-h") ||
            STREQ(argv[i], "--help")) {
            helpAndQuit();
        } else {
            usageAndQuit();
        }
    }
}

static void helpAndQuit()
{
    std::cout << "help message here" << std::endl;
}

static void usageAndQuit()
{
    std::cout << "usage here" << std::endl;
}


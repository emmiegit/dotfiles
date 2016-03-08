/* Main.cpp
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

#include <cstdlib>

#include "Arguments.hpp"
#include "Constants.h"
#include "Main.hpp"
#include "SignalHandler.hpp"

static void acquireLock();
static void releaseLock();

int main(const int argc, const char *argv[])
{
    acquireLock();
    setupSignalHandlers();
    parseArgs(argc, argv);

    return 0;
}

void cleanup(int ret)
{
    releaseLock();
    exit(ret);
}

void reloadConfig()
{
    // TODO
}

static void acquireLock()
{
    // TODO
}

static void releaseLock()
{
    // TODO
}


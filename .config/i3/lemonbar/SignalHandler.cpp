/* SignalHandler.cpp
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

#include <csignal>
#include <iostream>

#include "Main.hpp"
#include "SignalHandler.hpp"

static void handleSignal(const int signum);

void setupSignalHandlers()
{
    signal(SIGSEGV, handleSignal);
    signal(SIGTERM, handleSignal);
    signal(SIGINT,  handleSignal);
    signal(SIGHUP,  handleSignal);
}

static void handleSignal(const int signum)
{
    switch (signum) {
        case SIGSEGV:
            std::cerr << "Error: segmentation fault. Dumping core (if enabled)." << std::endl;
            cleanup(1);
            break;
        case SIGTERM:
            std::cerr << "Termination signal received. Exiting." << std::endl;
            cleanup(0);
            break;
        case SIGINT:
            std::cerr << "Interrupt signal recieved. Exiting." << std::endl;
            cleanup(0);
            break;
        case SIGHUP:
            std::cerr << "Hangup signal recieved. Reloading configuration." << std::endl;
            reloadConfig();
    }
}


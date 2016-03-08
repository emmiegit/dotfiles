# Makefile
#
# barman - A program to manage your lemonbar
# Copyright (c) 2016 Ammon Smith
# 
# barman is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
# 
# barman is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with barman.  If not, see <http://www.gnu.org/licenses/>.
#

.PHONY: all debug force direct distclean clean

CC=g++
FLAGS=-ansi -I. -Wall -Wextra
OBJECTS=Main.cpp.o \
		Arguments.cpp.o \
		Config.cpp.o \
		LemonGadget.cpp.o \
		LemonGadgetController.cpp.o \
		Media.cpp.o \
		MediaGadget.cpp.o \
		MiscGadget.cpp.o \
		SignalHandler.cpp.o \
		SystemGadget.cpp.o \
		SystemStats.cpp.o \
		Weather.cpp.o \
		WeatherGadget.cpp.o \
		WindowState.cpp.o \
		WindowStateGadget.cpp.o \
		i3Gadget.cpp.o \
		i3Workspaces.cpp.o
EXE=barman

all: $(EXE)

%.cpp.o: %.cpp
	$(CC) $(FLAGS) $(EXTRA_FLAGS) -c -o $@ $<

$(EXE): $(OBJECTS)
	$(CC) $(FLAGS) $(EXTRA_FLAGS) -o $(EXE) $(OBJECTS)

debug: clean
	make $(EXE) EXTRA_FLAGS=-g

force: clean $(EXE)

distclean:
	rm -f *.cpp.o *~ $(EXE) core core.*

clean:
	rm -f *.cpp.o core core.* vgcore.* $(EXE)


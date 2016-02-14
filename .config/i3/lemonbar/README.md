## i3 + Lemonbar

My lemonbar setup is based heavily on [electro7's dotfiles](https://github.com/electro7/dotfiles/tree/master/.i3/lemonbar), but written in Python rather than in shell.

### Requirements:
* [i3wm](https://i3wm.org/)
* [Lemonbar](https://github.com/LemonBoy/bar)
* [pamixer](https://github.com/cdemoulins/pamixer) for volume and mute
* [python-psutil](https://www.archlinux.org/packages/?sort=&q=python-psutil) for cpu, memory, etc.
* [python-i3-git](https://aur.archlinux.org/packages/python-i3-git/) for getting workspaces
* [moc](https://moc.daper.net/) is detected as a media player
* [pianobar](https://6xq.net/pianobar/) is detected as a media player
* [vlc](http://www.videolan.org/) is detected as a media player

### Scripts:
My setup uses some of the scripts I have written, which are available in my [`scripts`](https://github.com/ammongit/scripts) repo:
* `wm/start-autolock.sh` (requires [xautolock](http://www.freecode.com/projects/xautolock))
* `wm/set-autolock.sh`


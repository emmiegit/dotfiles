## i3 + Lemonbar

My lemonbar setup is based heavily on [https://github.com/electro7/dotfiles/tree/master/.i3/lemonbar](electro7's setup), but written in Python rather than in shell.

### Requirements:
* [https://i3wm.org/](i3wm)
* [https://github.com/LemonBoy/bar](Lemonbar)
* [https://github.com/cdemoulins/pamixer](pamixer) for volume and mute
* [https://www.archlinux.org/packages/?sort=&q=python-psutil](python-psutil) for cpu, memory, etc.
* [https://aur.archlinux.org/packages/python-i3-git/](python-i3-git) for getting workspaces
* [https://moc.daper.net/](moc) is detected as a media player
* [https://6xq.net/pianobar/](pianobar) is detected as a media player
* [http://www.videolan.org/](vlc) is detected as a media player

### Scripts:
My setup uses some of the scripts I have written, which are available in my [https://github.com/ammongit/scripts](`scripts`) repo:
* `wm/start-autolock.sh` (requires [http://www.freecode.com/projects/xautolock](xautolock))
* `wm/set-autolock.sh`


set from             = "grawcards@gmail.com"
set imap_user        = "grawcards@gmail.com"
set imap_keepalive   = 30
unset imap_passive
set folder           = "imaps://imap.gmail.com"
set spoolfile        = "=INBOX"
set record           = "=[Gmail]/Sent Mail"
set postponed        = "=[Gmail]/Drafts"
set mbox             = "imaps://imap.gmail.com/[Gmail]/All Mail"
set trash            = "imaps://imap.gmail.com/[Gmail]/Trash"
set move             = no
set smtp_url         = "smtp://grawcards@smtp.gmail.com:587/"

source "gpg -d ~/.mutt/passwords.grawcards.gpg |"

# vim: set ft=muttrc:

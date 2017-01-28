set from             = "ammon.i.smith@gmail.com"
set imap_user        = "ammon.i.smith@gmail.com"
set imap_keepalive   = 30
unset imap_passive
set folder           = "imaps://imap.gmail.com"
set spoolfile        = "=INBOX"
set record           = "=[Gmail]/Sent Mail"
set postponed        = "=[Gmail]/Drafts"
set mbox             = "imaps://imap.gmail.com/[Gmail]/All Mail"
set trash            = "imaps://imap.gmail.com/[Gmail]/Trash"
set move             = no
set smtp_url         = "smtp://ammon.i.smith@smtp.gmail.com:587/"

# vim: set ft=muttrc:

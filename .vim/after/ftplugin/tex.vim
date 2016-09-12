" Undo some the LaTeX-suite macros

call IMAP('()', '()', 'tex')
call IMAP('{}', '{}', 'tex')
call IMAP('[]', '[]', 'tex')
call IMAP('::', '::', 'tex')
call IMAP('{{', '{{', 'tex')
call IMAP('((', '((', 'tex')
call IMAP('[[', '[[', 'tex')
call IMAP('$$', '$$', 'tex')


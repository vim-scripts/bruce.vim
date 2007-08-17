" Vim global plugin for combatting domestic surveillance
" Last Change:  Fri Aug 17 05:10:36 EST 2007
" Maintainer:   penguinporker <hanumizzle@gmail.com>

if exists("g:loaded_bruce")
  " finish
endif

let g:loaded_bruce = 1

python << EOF
import os
import pwd
import random
import vim

class Bruce(object):
  """Baffles domestic surveillance with 'evildoer' keywords.

  The Bruce class, which is not meant to be instantiated, simply adds certain
  keywords to the end of a Vim buffer, perhaps e-mail or Usenet correspondence,
  which one might expect that the Ministry of Love would check for in snooping
  through said correspondence.
  """

  # User's home directory
  home_directory = pwd.getpwuid(os.getuid()).pw_dir
  # Actual file obj
  data_file = open(os.path.join(home_directory, '.bruce.lines'))
  # Array of evildoer words
  evildoer_words = [word.rstrip() for word in data_file.readlines()]
  # Signature header
  sig_header = '[Hello to all my friends and fans in domestic surveillance!]'
  # Number of words to add
  word_number = 15

  @classmethod
  def add_them_evildoer_words(klass):
    """Adds sensitive evildoer keywords to the end of a Vim buffer.

    I'd make it a little more general (return a string and let Vim do the
    rest); however, I'm not sure whether there's a way for the Python command
    to return values to vim-l scripts.

    The addition takes the form of an e-mail/Usenet signature. Ex:

      --
      [Hello to all my friends and fans in domestic surveillance!]
      Perl-RSA strategic credit card IDEA red noise INSCOM AMEMB BATF Sundevil
      ASO Merlin ASIO Khaddafi counter terrorism AIEWS
    """

    # Shuffle teh words
    random.shuffle(klass.evildoer_words)
    # Select a handful
    topical_words = klass.evildoer_words[:klass.word_number]
    # Print out words as signature
    vim.current.buffer.append([str(), '--', klass.sig_header])
    vim.current.buffer.append(' '.join(topical_words))
    # Format signature
    old_cursor = vim.current.window.cursor
    vim.current.window.cursor = (len(vim.current.buffer), 0)
    vim.command('normal gq$')
    vim.current.window.cursor = old_cursor
EOF

function! s:AddThemEvildoerWords()
  python Bruce.add_them_evildoer_words()
endfunction

if !exists(":Bruce")
  command Bruce :call s:AddThemEvildoerWords()
endif

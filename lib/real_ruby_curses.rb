require 'ncurses'

module RealRubyNcurses
  def getyx(screen = stdscr)
    y = x = []
    super(screen, y, x)
    y + x
  end

  def getmaxyx(screen = stdscr)
    row = col = []
    super(screen, row, col)
    row + col
  end

  def getstr
    str = ""
    super(str)
    str
  end
end

class << Ncurses
  prepend RealRubyNcurses
end


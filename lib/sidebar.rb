class Sidebar < Window
  def initialize(height, width, startx, starty)
    super
    Ncurses.attron Ncurses.COLOR_PAIR(1)
    c = ' '.ord
    b = Ncurses::ACS_VLINE
    @window.border(c, b, c, c, c, b, c, b)
    @window.wbkgd(Ncurses.COLOR_PAIR(1))
    refresh
  end
end

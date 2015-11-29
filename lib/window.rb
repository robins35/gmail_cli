class Window
  attr_reader :window

  def initialize(height, width, startx, starty)
    @height = height
    @width = width
    @startx = startx
    @starty = starty
    @window = Ncurses.newwin(height, width, startx, starty)
  end

  def refresh
    Ncurses.wrefresh(@window)
  end

  def wbkgd(color_pair)
    Ncurses.wbkgd(@window, color_pair)
  end
end

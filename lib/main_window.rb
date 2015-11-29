class MainWindow
  attr_reader :window

  def initialize
    @window = Ncurses.initscr
    Ncurses.start_color
    Ncurses.raw
    Ncurses.keypad(Ncurses.stdscr, true)
    Ncurses.noecho

    Ncurses.init_pair(1, Ncurses::COLOR_WHITE, Ncurses::COLOR_BLUE)
  end
end

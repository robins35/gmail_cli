class MainWindow
  attr_reader :window, :rows, :cols

  def initialize
    @window = Ncurses.initscr
    Ncurses.start_color
    Ncurses.raw
    Ncurses.keypad(Ncurses.stdscr, true)
    Ncurses.noecho
    @rows, @cols = Ncurses.getmaxyx

    Ncurses.init_color(Ncurses::COLOR_BLACK, 0, 0, 0)
    Ncurses.init_pair(1, Ncurses::COLOR_WHITE, Ncurses::COLOR_BLACK)
  end
end

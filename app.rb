#!/usr/bin/env ruby

require_relative 'environment'

begin
  window = MainWindow.new

  Ncurses.refresh
  sidebar = Sidebar.new window.rows, window.cols / 4, 0, 0

  Ncurses.getch
ensure
  Ncurses.endwin
end

#!/usr/bin/env ruby

require_relative 'environment'

begin
  window = MainWindow.new

  rows, cols = Ncurses.getmaxyx

  Ncurses.refresh
  sidebar = Sidebar.new rows, cols / 4, 0, 0

  Ncurses.getch
ensure
  Ncurses.endwin
end

#!/usr/bin/env ruby

require_relative 'environment'

print "Email: "
email = gets.chomp

gmail_credentials = YAML.load_file('config/gmail.yml')
client_id = gmail_credentials["client_id"]
client_secret = gmail_credentials["client_secret"]

exec("python oauth2.py --generate_oauth2_token --client_id=#{client_id} --client_secret=#{client_secret}")
binding.pry
#gmail = Gmail.new!(:xoauth2, email, "ya29.PgI4eSmbP-cj9r4_9Q3xb-pXkA7QHiWl-5oG5eOPv_8deAbuH7tCcQvq0IRR8JbAQo4h")

exit
begin
  window = MainWindow.new

  Ncurses.refresh
  sidebar = Sidebar.new window.rows, window.cols / 4, 0, 0

  Ncurses.getch
ensure
  Ncurses.endwin
end

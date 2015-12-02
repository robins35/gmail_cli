require 'active_record'
#require 'active_support'
#require 'active_support/all'
#require 'action_view'
#require 'action_view/helpers'
require 'awesome_print'
require 'pry'
require 'yaml'
require 'rake'
require 'gmail'
require 'highline/import'

app = Rake.application
app.init
app.add_import 'lib/tasks/db.rake'
app.load_rakefile
app['db:configure_connection'].invoke

librbfiles = File.join("**", "lib", "**", "*.rb")
#Dir.glob('./lib/*').each do |folder|
#['./lib/models', './lib/tasks'].each do |folder|
  #Dir.glob(folder +"/*.rb").each do |file|
Dir.glob(librbfiles).each do |file|
  require_relative file
end

require 'active_record'
require 'awesome_print'
require 'pry'
require 'yaml'
require 'rake'
require 'launchy'
require 'highline/import'
require 'uri'
require 'net/http'
require 'google/apis/gmail_v1'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/storage'
require 'google/api_client/auth/storages/file_store'

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

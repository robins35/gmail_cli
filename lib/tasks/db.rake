require 'yaml'
require 'logger'
require 'active_record'
require 'active_support/core_ext'
require 'pg'
require 'pry'

namespace :db do
  def create_database config
    options = {:charset => 'utf8'}

    create_db = lambda do |config|
      ActiveRecord::Base.establish_connection config.merge(:database => "template1")
      ActiveRecord::Base.connection.create_database config[:database], options
      ActiveRecord::Base.establish_connection config
    end

    begin
      create_db.call config
    rescue Exception => e
      puts e
    end
  end

  task :environment do
    DATABASE_ENV ||= ENV['DATABASE_ENV'] || 'development'
    MIGRATIONS_DIR ||= ENV['MIGRATIONS_DIR'] || 'db/migrate'
  end

  task :configuration => :environment do
    @config = YAML.load_file('config/database.yml')["development"].to_options
    @drop_config = YAML.load_file('config/database.yml')["drop_environment"].to_options
  end

  task :configure_connection => :configuration do
    ActiveRecord::Base.establish_connection @config
    ActiveRecord::Base.logger = Logger.new STDOUT if @config[:logger]
  end

  desc 'Create the database from config/database.yml for the current DATABASE_ENV'
  task :create => :configure_connection do
    create_database @config
  end

  desc 'Drops the database for the current DATABASE_ENV'
  task :drop => :configure_connection do
    ActiveRecord::Base.establish_connection @drop_config
    ActiveRecord::Base.connection.drop_database @config[:database]
  end

  desc 'Migrate the database (options: VERSION=x, VERBOSE=false).'
  task :migrate => :configure_connection do
    ActiveRecord::Migration.verbose = true
    begin
      ActiveRecord::Migrator.migrate MIGRATIONS_DIR, ENV['VERSION'] ? ENV['VERSION'].to_i : nil
    rescue Exception => e
      puts e
    end
  end

  desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
  task :rollback => :configure_connection do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback MIGRATIONS_DIR, step
  end

  desc "Retrieves the current schema version number"
  task :version => :configure_connection do
    puts "Current version: #{ActiveRecord::Migrator.current_version}"
  end
end

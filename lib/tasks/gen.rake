require 'pry'

namespace :g do
  def migration_name name
    "#{Time.now.to_i}_#{name.split(/(?=[A-Z])/).join('_').downcase}.rb"
  end

  task :environment do
    MIGRATIONS_DIR = ENV['MIGRATIONS_DIR'] || 'db/migrate'
  end

  desc "Make a new migration file with timestamp prepended"
  task :migration, [:name] => :environment do |task, args|
    file_name = migration_name(args[:name])
    file_path = File.join(MIGRATIONS_DIR, file_name)

    File.open(file_path, 'w') do |f|
      f.write("# #{file_name}\n")
      f.write("require_relative '../../environment'\n\n")
      f.write("class #{args[:name]} < ActiveRecord::Migration\n\n\nend")
    end
  end
end

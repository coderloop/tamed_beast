require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/actions'

class TamedBeastGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  include Rails::Generators::Actions

  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end

  # Implement the required interface for Rails::Generators::Migration.
  # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
  def self.next_migration_number(dirname) #:nodoc:
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

  def add__default_routes
    route(File.read(File.join(File.dirname(__FILE__), 'templates/routes.rb') ), "config/routes.rb")
  end

  def create_migration_file
    migration_template 'migration.rb', 'db/migrate/create_tamed_beast_tables.rb'
  end

  def copy_plugins
    from = File.join(File.dirname(__FILE__), '../../../vendor/plugins/')
    to = File.join(Rails.root, 'vendor/plugins/')
    log :plugin, "vendor/plugins/white_list"
    FileUtils.cp_r((File.join(from, 'white_list')), to)
    log :plugin, "vendor/plugins/white_list_formatted_content"
    FileUtils.cp_r((File.join(from, 'white_list_formatted_content')), to)
  end

  private
  # overrided from https://github.com/rails/rails/blob/master/railties/lib/rails/generators/actions.rb
  # we need a custom message and omit our routes.rb content
  def route(routing_code, msg=nil)
    log :route, msg || routing_code
    sentinel = /\.routes\.draw do(?:\s*\|map\|)?\s*$/

      in_root do
      inject_into_file 'config/routes.rb', "\n  #{routing_code}\n", { :after => sentinel, :verbose => false }
      end
    end
  end

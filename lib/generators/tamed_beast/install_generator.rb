require 'rails/generators'
require 'rails/generators/actions'

class TamedBeast::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Actions

  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end

  def add_default_routes
    route(File.read(File.join(File.dirname(__FILE__), 'templates/routes.rb') ), "config/routes.rb")
  end

  def copy_plugins
    to = File.join(Rails.root, 'vendor/plugins/')
    
    from = File.join(File.dirname(__FILE__), '../../../vendor/plugins/white_list')
    copy_files(from, to, :plugin, "vendor/plugins/white_list")
    
    from = File.join(File.dirname(__FILE__), '../../../vendor/plugins/white_list_formatted_content')
    copy_files(from, to, :plugin, "vendor/plugins/white_list_formatted_content")
    
    from = File.join(File.dirname(__FILE__), '../../../test/')
    contents = Dir.glob( File.join(from, '**', '*') )
    copy_files(from, Rails.root, :test, contents)
  end

  private
  def copy_files(from, to, log_type, log_msg)
    if log_msg.is_a?(String)
      log log_type, log_msg
    else
      log_msg.each do |content|
        f = content.gsub(/.*\/tamed_beast\/..\/..\/..\//,'')
        if File.directory? content
          log :directory, f
        else
          log :file, f
        end
      end
    end
    FileUtils.cp_r(from, to)
  end

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

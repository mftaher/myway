require "myway/version"
require "thor"

class String
  def camelize(first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      self.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
    else
      self.first + camelize(self)[1..-1]
    end
  end
end

module Myway
  class Frank < Thor
    include Thor::Actions
    attr_accessor :name

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "new [NAME]", "Creates new sinatra projects, use 'sinatra:new help' for more."
    def new(name=nil)
      @name = name
      if @name.nil?
        puts "You must provide a name for your project"
        name = @name = ask "Project Name: "
      end

      empty_directory "#{name}/app/routes"
      empty_directory "#{name}/app/views"
      empty_directory "#{name}/app/models"
      empty_directory "#{name}/config"
      empty_directory "#{name}/assets/js"
      empty_directory "#{name}/assets/css"
      empty_directory "#{name}/spec"

      template "myway/templates/app/version.tt", "#{name}/app/version.rb"
      template "myway/templates/app/app.tt", "#{name}/app/#{name}.rb"
      template "myway/templates/config/unicorn.tt", "#{name}/config/unicorn.rb"
      template "myway/templates/config.ru.tt", "#{name}/config.ru"
      template "myway/templates/gemspec.tt", "#{name}/#{name}.gemspec"
      template "myway/templates/gemfile.tt", "#{name}/Gemfile"
      template "myway/templates/rakefile.tt", "#{name}/Rakefile"
      template "myway/templates/readme.tt", "#{name}/README.md"
      template "myway/templates/gitignore.tt", "#{name}/.gitignore"

    end

    no_tasks do
      def in_app?
        File.exists?('./app') && File.directory?('./app')
      end

      def git_init
        puts "Initializating git repo in #{name}"
        Dir.chdir(File.join(Dir.pwd, name)) { `git init`; `git add .` }
      end

      def bundle_init
        puts "Installing gems for #{name}"
        Dir.chdir(File.join(Dir.pwd, name)) { `bundle install` }
      end

      def cap_init
        puts "Generating capistrano config for #{name}"
        Dir.chdir(File.join(Dir.pwd, name)) { `capify` }
      end
    end
  end
end

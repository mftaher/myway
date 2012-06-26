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
        exit 0
      end

      user_info

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

      Dir.chdir(File.join(Dir.pwd, name))

      init_git
      init_bundle
      init_capistrano

    end

    no_tasks do
      def in_app?
        File.exists?('./app') && File.directory?('./app')
      end

      def user_info
        @user = IO.popen("git config --global user.name").read.gsub("\n", "")
        @email = IO.popen("git config --global user.email").read.gsub("\n", "")
      end

      def method_missing(meth, *args, &block)
        return init($1.to_sym) if meth.to_s =~ /^init_(.*)/
        super
      end

      def append_cap
        #inject_into_file "#{name}/config/deploy.rb", :after => "# these http://github.com/rails/irs_process_scripts\n" do
        append_file "#{name}/config/deploy.rb" do
'
#set :sin_env, :production

# Where will it be located on a server?
#set :deploy_to, "/var/www/#{application}"
#set :unicorn_conf, "#{deploy_to}/config/unicorn.rb"
#set :unicorn_pid, "#{deploy_to}/pids/unicorn.pid"


# Unicorn control tasks
#namespace :deploy do
#  task :restart do
#    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to} && bundle exec unicorn -c #{unicorn_conf} -E #{sin_env} -D; fi"
#  end
#  task :start do
#    run "cd #{deploy_to} && bundle exec unicorn -c #{unicorn_conf} -E #{sin_env} -D"
#  end
#  task :stop do
#    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
#  end
#
#end
'
        end
      end

      def init(op)
        case op
          when :git
            say "Initialing git repo in #{name}"
            `git init`
            `git add .`
          when :bundle
            say "Installing gems for #{name}"
            `bundle install`
          when :capistrano
            say "Generating capistrano config for #{name}"
            `capify .`
            append_cap
        end
      end
    end
  end
end





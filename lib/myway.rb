require "myway/version"
require "open-uri"
require "zip/zipfilesystem"
require "fileutils"
require "thor"

JS_LIBS = {
    'head' => 'https://github.com/headjs/headjs/raw/v0.96/dist/head.load.min.js',
    'jquery' => 'http://code.jquery.com/jquery-1.8.2.min.js',
    'backbone' => 'http://documentcloud.github.com/backbone/backbone-min.js',
    'underscore' => 'http://documentcloud.github.com/underscore/underscore-min.js',
    'bootstrap' => 'http://twitter.github.com/bootstrap/assets/bootstrap.zip',
    'kickstart' => 'http://www.99lime.com/downloads/',
    'yepnope' => 'https://github.com/SlexAxton/yepnope.js/zipball/master'
}
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
      create_file "#{name}/app/routes/.gitkeep", ""
      empty_directory "#{name}/app/models"
      create_file "#{name}/app/models/.gitkeep", ""
      empty_directory "#{name}/assets/js"
      empty_directory "#{name}/spec"

      template "myway/templates/app/version.tt", "#{name}/app/version.rb"
      template "myway/templates/app/app.tt", "#{name}/app/#{name}.rb"
      template "myway/templates/app/views/layout.haml.tt", "#{name}/app/views/layout.haml"
      template "myway/templates/app/views/index.haml.tt", "#{name}/app/views/index.haml"
      template "myway/templates/app/views/includes/navbar.haml.tt", "#{name}/app/views/includes/navbar.haml"
      template "myway/templates/config/unicorn.tt", "#{name}/config/unicorn.rb"
      template "myway/templates/config.ru.tt", "#{name}/config.ru"
      template "myway/templates/gemspec.tt", "#{name}/#{name}.gemspec"
      template "myway/templates/gemfile.tt", "#{name}/Gemfile"
      template "myway/templates/rakefile.tt", "#{name}/Rakefile"
      template "myway/templates/readme.tt", "#{name}/README.md"
      template "myway/templates/gitignore.tt", "#{name}/.gitignore"

      template "myway/templates/spec/spec_helper.rb.tt", "#{name}/spec/spec_helper.rb"
      template "myway/templates/spec/acceptance_helper.rb.tt", "#{name}/spec/acceptance_helper.rb"

      Dir.chdir(File.join(Dir.pwd, name))

      build_js_libs

      init_git
      init_bundle
      init_jasmine
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

      def unzip_file (file, destination)
        Zip::ZipFile.open(file) { |zip_file|
          zip_file.each { |f|
            f_path=File.join(destination, f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(f, f_path) unless File.exist?(f_path)
          }
        }
      end

      def build_js_libs(libs=%w(head underscore backbone bootstrap))

        libs.each do |lib|
          begin
            if lib != "bootstrap"
              File.open "./assets/js/#{lib}.min.js", 'w+' do |file|
                file.write get_latest(lib)
              end
            else
              File.open "assets/js/#{lib}.zip", 'wb' do |file|
                file.write get_latest(lib)
              end
              unzip_file "./assets/js/#{lib}.zip", "./assets/"
              File.delete "./assets/js/#{lib}.zip"
              `mv ./assets/bootstrap/js/* ./assets/js/`
              `mv ./assets/bootstrap/css/ ./assets/`
              `mv ./assets/bootstrap/img/ ./assets/`
              FileUtils.rm_rf "./assets/bootstrap/"
            end
          rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
            say "#{e} Error while getting #{lib}"
            say "Add the library manually"
          end
        end
      end

      def get_latest(scriptname)
        open(JS_LIBS[scriptname]).read
      end

      def method_missing(meth, *args, &block)
        return init($1.to_sym) if meth.to_s =~ /^init_(.*)/
        super
      end

      def init(op)
        case op
          when :git
            say "Initialing git repo in #{name} ..."
            `git init`
            `git add .`
          when :bundle
            say "Installing gems for #{name} ..."
            `bundle install`
          when :capistrano
            say "Initializing capistrano deploy script"
            template "myway/templates/config/deploy.rb.tt", "#{name}/config/deploy.rb"
          when :jasmine
            say "Initialize Jasmine specs settings in #{name} ..."
            `jasmine init`
            FileUtils.rm_rf "./public/javascripts"
            FileUtils.rm_rf "./spec/javascripts/helpers/*.js"
            FileUtils.rm_rf "./spec/javascripts/*.js"
            template "myway/templates/spec/specHelper.js.tt", "#{name}/spec/javascripts/helpers/specHelper.js"
            template "myway/templates/spec/fixture.js.tt", "#{name}/spec/javascripts/fixtures/fixtures.js"
        end
      end
    end
  end
end





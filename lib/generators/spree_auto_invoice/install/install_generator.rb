module SpreeAutoInvoice
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, :type => :boolean, :default => false

      source_root File.expand_path("../templates", __FILE__)
      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end
      
      def add_javascripts
        append_file 'app/assets/javascripts/store/all.js', "//= require store/spree_auto_invoice\n"
        append_file 'app/assets/javascripts/admin/all.js', "//= require admin/spree_auto_invoice\n"
      end

      def add_stylesheets
        inject_into_file 'app/assets/stylesheets/store/all.css', " *= require store/spree_auto_invoice\n", :before => /\*\//, :verbose => true
        inject_into_file 'app/assets/stylesheets/admin/all.css', " *= require admin/spree_auto_invoice\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_auto_invoice'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end
      
      def copy_templates_file
        puts ">> Copy invoice template"
        copy_file "invoice_template.html.erb", "app/views/spree/invoices/invoice_template.html.erb"
      end

      def copy_initializer_file
        puts ">> Copy config file"
        copy_file "initializer.rb", "config/initializers/spree_auto_invoice.rb"
        puts "\n>>> Don't forget to check your config file! <<<"
      end
      
      def generate_missing_records
        res = ask ">> Would you like to run the generating missing orders now? [Y/n]"
        if res == "" || res.downcase == "y"
          puts ">> Generating missing records..."
          run 'bundle exec rake spree_auto_invoice:generate'
        else
          puts ">> Skiping rake spree_auto_invoice:generate, don't forget to run it!"
        end
      end
      
    end
  end
end

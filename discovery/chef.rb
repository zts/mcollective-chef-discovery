# discovers against a Chef server

require 'chef/knife'
require 'chef/config'
require 'spice'

module MCollective
  class Discovery
    class Chef
      def self.discover(filter, timeout, limit=0, client=nil)
        load_chef_configuration

        search_terms = client.options[:discovery_options]

        unless filter["cf_class"].empty?
          filter["cf_class"].each do |c|
             search_terms << cf_class_to_term(c)
          end
        end

        unless filter["identity"].empty?
          terms = filter["identity"].map { |i| "name:" + i }
          search_terms << '(' + terms.join(' OR ') + ')'
        end
          
        if search_terms.empty?
          nodes = Spice.nodes.map { |n| n.name }
        else
          query = search_terms.join(' AND ')
          nodes = Spice.nodes( :q => query ).map { |n| n.name }
        end

        nodes
      end

      def self.cf_class_to_term(c)
        # Transform run_list item syntax (eg, recipe[foo::bar]) to
        # search query syntax (eg, recipe:foo\:\:bar).
        /(?<type>(role|recipe))\[(?<name>[^\]]*)\]/ =~ c
        name.gsub!(/:/, '\:')
        return "#{type}:#{name}"
      end

      def self.load_chef_configuration
        Spice.reset
        ::Chef::Knife.new.configure_chef
        chef = ::Chef::Config

        # Spice copes poorly when chef_server_url has a trailing slash.
        chef_server_url = chef.chef_server_url.gsub!(/\/$/, '')

        # Choose the correct SSL verification mode
        if chef.ssl_verify_mode == :verify_none
          ssl_verify_mode = OpenSSL::SSL::VERIFY_NONE
        else
          ssl_verify_mode = OpenSSL::SSL::VERIFY_PEER
        end

        # Load the Chef private key from disk
        client_key = Spice.read_key_file(File.expand_path(chef.client_key))

        # Configure Spice
        Spice.setup do |s|
          s.server_url  = chef_server_url
          s.client_name = chef.node_name
          s.client_key  = client_key
          s.connection_options = {
            :ssl => {
              :verify_mode => ssl_verify_mode,
              :client_cert => chef.ssl_client_cert,
              :client_key  => chef.ssl_client_key,
              :ca_path     => chef.ssl_ca_path,
              :ca_file     => chef.ssl_ca_file,
            }
          }
        end
      end
    end
  end
end

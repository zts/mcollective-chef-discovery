# discovers against a Chef server

require 'spice'

module MCollective
  class Discovery
    class Chef
      def self.discover(filter, timeout, limit=0, client=nil)
        cfg = Config.instance

        keyfile                  = cfg.pluginconf["chef-discovery.client_key"]
        Spice.client_key         = Spice.read_key_file(keyfile)
        Spice.client_name        = cfg.pluginconf["chef-discovery.client_name"]

        Spice.server_url         = cfg.pluginconf["chef-discovery.server_url"]
        Spice.connection_options = { :ssl => {:verify => false} }

        search_terms = []

        unless filter["cf_class"].empty?
          filter["cf_class"].each do |c|
             search_terms << cf_class_to_term(c)
          end
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
    end
  end
end

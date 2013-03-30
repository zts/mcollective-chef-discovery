# mcollective-chef-discovery #

MCollective discovery plugin that uses the Chef server as its data source.

List all nodes on the server, or only those with specific run_list
items.


# Configuration #

    plugin.chef-discovery.client_key  = /path/to/client_key.pem
    plugin.chef-discovery.client_name = username
    plugin.chef-discovery.server_url  = https://chefserver.example.com


# Usage #

All nodes in the Chef server:

    $ mco rpc rpcutil ping --dm chef

Only nodes with the graphite role:

    $ mco rpc rpcutil ping --dm chef -C 'role[graphite]'
    

# TODO #

 * Support identity and fact criteria
 * Support arbitrary search queries
 * Filter discovered nodes with identity regexp
 * Load Chef configuration from knife.rb
 * Optional SSL verification on Chef server connection
 







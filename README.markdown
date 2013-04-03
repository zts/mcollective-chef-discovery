# mcollective-chef-discovery #

MCollective discovery plugin that uses the Chef server as its data source.

List all nodes on the server, or those matching a given search.

The -C option matches run list items.  When specified more than once,
only nodes matching every item will be discovered.

The -I option matches against the Chef node name.  When the -I option
is specified multiple times, nodes matching any item will be discovered.


# Installation

Copy chef.ddl and chef.rb to the discovery directory in your
MCollective libdir.  You will need to install the `spice` and `chef`
gems into the Ruby running mcollective.

    $ gem install spice chef --no-rdoc --no-ri


# Configuration #

This plugin takes its configuration from your Chef knife.rb.


# Usage #

Select the Chef discovery plugin by including `--dm chef` on your mco
commandline.  By default, this will discover all nodes in the Chef
server.

Example: 'mco ping' all nodes known to Chef

    $ mco rpc rpcutil ping --dm chef


The `-C` option (config management class) discovers nodes that apply
particular roles or recipes.  If this option is used more than once, a
node must match every value to be discovered.

Example: nodes applying the graphite role:

    $ mco rpc rpcutil ping --dm chef -C 'role[graphite]'

Example: nodes applying the graphite role AND mcollective::server recipe:

    $ mco rpc rpcutil ping --dm chef -C 'role[graphite]' -C 'role[mcollective::server]'


The `-I` option (identity) limits discovered nodes by their Chef node
name.  Wildcards suitable for Chef search are permitted.  When this
option is used more than once, nodes must match at least one value to
be discovered.

Example: node names starting with 'm':

    $ mco rpc rpcutil ping --dm chef -I 'm*'

Example: node 'foo.example.com', and node names starting with 'm':

    $ mco rpc rpcutil ping --dm chef -I 'm*' -I foo.example.com


Finally, you can specify an arbitrary Chef search using the `--do`
option.  Nodes matching the search, and any other filter criteria,
will be discovered.

Example: arbitrary search expression:

    $ mco rpc rpcutil ping --dm chef --do "chef_environment:dev AND platform_family:debian"


# TODO #

 * Support for fact (-F) criteria
 * Filter discovered nodes with identity regexp
 * Optionally specify Chef server configuration (instead of using
   knife.rb)
 * Optionally specify a knife configuration file

# mcollective-chef-discovery #

MCollective discovery plugin that uses the Chef server as its data source.

List all nodes on the server, or those matching a given search.

The -C option matches run list items.  When specified more than once,
only nodes matching every item will be discovered.

The -I option matches against the Chef node name.  When the -I option
is specified multiple times, nodes matching any item will be discovered.


# Installation

Copy chef.ddl and chef.rb to the discovery directory in your
MCollective libdir.


# Configuration #

This plugin takes its configuration from your Chef knife.rb.


# Usage #

All nodes in the Chef server:

    $ mco rpc rpcutil ping --dm chef

Only nodes with the graphite role:

    $ mco rpc rpcutil ping --dm chef -C 'role[graphite]'

Only node names starting with 'm':

    $ mco rpc rpcutil ping --dm chef -I 'm*'

Only node names starting with 'm' or matching 'foo.example.com':

    $ mco rpc rpcutil ping --dm chef -I 'm*' -I foo.example.com

Arbitrary search expression:

    $ mco rpc rpcutil ping --dm chef --do "role:one OR role:two"


# TODO #

 * Support identity and fact criteria
 * Filter discovered nodes with identity regexp
 * Optionally specify Chef server configuration (instead of using
   knife.rb)
 * Optionally specify a knife configuration file

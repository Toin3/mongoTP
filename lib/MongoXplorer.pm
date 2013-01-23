##!/usr/bin/env perl

package MongoXplorer;
use Mojolicious::Lite;

sub get_databases {
	my $self = shift;
	my ( $instance_name, $instance_port ) = @_;
	my $mongo_connection = MongoDB::MongoClient->new(host => $instance_name.':'.$instance_port);
	my @dbs = $mongo_connection->database_names;
	return @dbs;
}

1;
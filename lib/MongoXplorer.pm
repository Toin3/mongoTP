##!/usr/bin/env perl

package MongoXplorer;
use Mojolicious::Lite;
use MongoDB;
use MongoDB::OID;
use strict;
use warnings;

my $g_instance_name;
my $g_instance_port;


sub get_databases {
	my $self = shift;
	my ( $instance_name, $instance_port ) = @_;
	my $mongo_connection = MongoDB::MongoClient->new(host => $instance_name.':'.$instance_port);
	$g_instance_name = $instance_name;
	$g_instance_port = $instance_port;
	my @dbs = $mongo_connection->database_names;
	return @dbs;
}

sub get_collections
{
	my $self = shift;
	my ($db_name) = @_;
	my $mongo_connection = MongoDB::MongoClient->new(host => $g_instance_name.':'.$g_instance_port);
	my $database = $mongo_connection->get_database($db_name);
        my @collections = $database->collection_names;
	@collections = grep { index($_, '.$_id_') == -1 } @collections;
	return @collections;
}

1;

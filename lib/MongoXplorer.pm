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
	my $mongo_connection;
	my $rv = eval { $mongo_connection = MongoDB::MongoClient->new(host => $instance_name.':'.$instance_port) }; 
	if ($@) {
		return "instance-not-found";
	}else
	{
		$g_instance_name = $instance_name;
		$g_instance_port = $instance_port;
		my @dbs = $mongo_connection->database_names;
		return @dbs;
	}   
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

sub get_collection_data
{
	my $self = shift;
	my ( $db_name, $collection_name ) = @_;
	my $mongo_connection = MongoDB::MongoClient->new(host => $g_instance_name.':'.$g_instance_port);
	my $db = $mongo_connection->get_database( $db_name );
	my $collection_content = $db->get_collection( $collection_name );
	my $data = $collection_content->find_one({ "yahoo.woe" => {'$exists' => 1} });
	
	return $data;
}

1;

##!/usr/bin/env perl

package MongoXplorer;
use Mojolicious::Lite;
use MongoDB;
use MongoDB::OID;
use strict;
use warnings;
use Data::Dumper;
use JSON;
use Mojo::JSON;

my $g_instance_name;
my $g_instance_port;
my $g_database_name;
my $g_collection_name;

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
	my $mongo_connection;
	my $rv = eval { $mongo_connection = MongoDB::MongoClient->new(host => $g_instance_name.':'.$g_instance_port) };
	if ($@) {
		return "database-not-found";
	} else
	{
		$g_database_name = $db_name;
		my $database = $mongo_connection->get_database($db_name);
			my @collections = $database->collection_names;
		@collections = grep { index($_, '.$_id_') == -1 } @collections;
		return @collections;
	}
}


sub get_collection_data
{
 	my $self = shift;
 	my ( $collection_name ) = @_;
 	my $mongo_connection = MongoDB::MongoClient->new(host => $g_instance_name.':'.$g_instance_port);
	my $db = $mongo_connection->get_database( $g_database_name );
 	my $collection_content = $db->get_collection( $collection_name );
	my $data = $collection_content->find();

 	my @arr_data;
 	while (my $record = $data->next)
	{
  		push(@arr_data, to_json($record,{allow_blessed=>1,convert_blessed=>1, utf8=>1}));
	}

 	my $formated_json = '['.join(',', @arr_data).']';
	$g_collection_name = $collection_name;
 	return $formated_json;
}

sub execute_query
{
	my $self = shift;
 	my ( $json_query, $json_projection) = @_;
	my $mongo_connection = MongoDB::MongoClient->new(host => $g_instance_name.':'.$g_instance_port);
	my $db = $mongo_connection->get_database( $g_database_name );
	my $json  = Mojo::JSON->new; 
	my $query = $json->decode($json_query);
	my $projection = $json->decode($json_projection);
	my $data;
	my $rv = eval { $data = $db->get_collection($g_collection_name)->find( $query, $projection )};
	if ($@) {
		return "bad-query";
	} else
	{
		my @arr_data;
		while (my $record = $data->next)
		{
			push(@arr_data, to_json($record,{allow_blessed=>1,convert_blessed=>1, utf8=>1}));
		}
		my $formated_json = '['.join(',', @arr_data).']';
		return $formated_json;
	}
}

1;

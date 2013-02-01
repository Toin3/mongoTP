#!/usr/bin/env perl
use lib 'lib';
use Mojolicious::Lite;
use MongoXplorer;
use MongoDB;
use Data::Dumper;
use strict;
use warnings;
use JSON;

get '/' => sub {
  my $self = shift;
  $self->render('index', title => 'Accueil');
};

post '/dblist' => sub {
    my $self = shift;
	my @dbs = MongoXplorer->get_databases($self->param('instance_name'), $self->param('instance_port'));
	if (join('', @dbs) eq "instance-not-found")
	{
		$self->flash(warning_message => "L'instance n'a pas été trouvée. Vérifiez l'adresse IP et le port de destination.");
		$self->redirect_to( '/' );
	}
	else
	{
		$self->render('dblist', dbs => [@dbs], title => 'Liste des bases de données');
	}
};

get '/databasename/:collectionname' => sub {
    my $self = shift;
    my $dbname = $self->param('collectionname');
    my @collections = MongoXplorer->get_collections($dbname);
	if (join('', @collections) eq "database-not-found")
	{
		$self->flash(warning_message => "La base n'a pas été trouvé ou un problème est survenu. Merci de vous reconnecter.");
		$self->redirect_to( '/' );
	}
	else
	{
		$self->render('collectionlist', databasename => $dbname, collections => [@collections], title => 'Collections de la base '.$dbname);
	}
};

get '/collectiondetails/:collectionname' => sub {
    my $self = shift;
	my $data = MongoXplorer->get_collection_data($self->param('collectionname'));
	my $index2d = MongoXplorer->get_collection_index();
	my $jsonIndex = $self->render(json => $index2d, partial => 1);
 	my $jsonifier = $self->render(json => $data, partial => 1);
    $self->render('collectiondetails', title => 'Aperçu de la collection '.$self->param('collectionname'), collectionname => $self->param('collectionname'), collection_content => $jsonifier, collection_index => $jsonIndex);
};

post '/ajax/execute' => sub {
	my $self = shift;
	my $data = MongoXplorer->execute_query($self->param('query'), $self->param('projection'));
	$self->app->log->debug(Dumper($data));
	$self->render(json => $data);
};

post '/ajax/gmap' => sub {
	my $self = shift;
	my $data = MongoXplorer->execute_gmap($self->param('latitude'), $self->param('longitude'));
	#$self->app->log->debug(Dumper($data));
	$self->render(json => $data);
};

post '/ajax/test' => sub {
	my $self = shift;
	
	$self->render(json => {"message"=>"TEST"});
};

app->start;

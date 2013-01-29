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
    $self->render('collectionlist', databasename => $dbname, collections => [@collections], title => 'Collections de la base '.$dbname);
};

get '/collectiondetails/:collectionname' => sub {
    my $self = shift;
	my $data = MongoXplorer->get_collection_data($self->param('collectionname'));
 	my $jsonifier = $self->render(json => $data, partial => 1);
    $self->render('collectiondetails', title => 'Aperçu de la collection '.$self->param('collectionname'), collectionname => $self->param('collectionname'), collection_content => $jsonifier);
};

post '/ajax/execute' => sub {
	my $self = shift;
	my $data = MongoXplorer->execute_query($self->param('query'));
	
	$self->render(json => $data);
};

app->start;

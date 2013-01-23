#!/usr/bin/env perl
use lib 'lib';
use Mojolicious::Lite;
use MongoXplorer;

get '/' => sub {
  my $self = shift;
  $self->render('index', title => 'Accueil');
};

post '/dblist' => sub {
    my $self = shift;
	my @dbs = MongoXplorer->get_databases($self->param('instance_name'), $self->param('instance_port'));
	return $self->render('dblist', dbs => [@dbs], title => 'Liste des bases de données');
};

get '/databasename/:collectionname' => sub {
    my $self = shift;
    my $dbname = $self->param('collectionname');
    my @collections = MongoXplorer->get_collections($dbname);
    $self->render('collectionlist', databasename => $dbname, collections => [@collections], title => 'Collections de la base '.$dbname);
};


app->start;

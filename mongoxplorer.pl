#!/usr/bin/env perl
use lib 'lib';
use Mojolicious::Lite;
use MongoDB;
use MongoXplorer;

get '/' => sub {
  my $self = shift;
  $self->render('index');
};

post '/dblist' => sub {
    my $self = shift;
	my @dbs = MongoXplorer->get_databases($self->param('instance_name'), $self->param('instance_port'));
	return $self->render('dblist', dbs => [@dbs]);
};

get '/database/:dbname' => sub {
    my $self = shift;
    my $dbname = $self->param('dbname');
    my @collections = MongoXplorer->get_collections($dbname);
    $self->render('collectionlist', dbname => $dbname, collections => [@collections]);    
};

app->start;

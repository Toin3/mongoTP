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

app->start;
#!/usr/bin/env perl
use Mojolicious::Lite;
use MongoDB;
# Documentation browser under "/perldoc"
plugin 'PODRenderer';

get '/' => sub {
  my $self = shift;
  $self->render('index');
};

post '/connect' => sub {
    my $self = shift;
    # control de la validite de l'url
    my $instance_name = $self->param('instance_name');
    my $instance_port = $self->param('instance_port');
	my $mongo_connection = MongoDB::MongoClient->new(host => $instance_name.':'.$instance_port);
	my @dbs = $mongo_connection->database_names;
	return $self->render('accueil', dbs => [@dbs]);
};

app->start;
__DATA__
@@ layouts/default.html.ep
<!doctype html><html>
    <head><title>shorturl demo</title></head>
    <body><%= content %></body>
</html>

@@ index.html.ep
% layout 'default';
<%= form_for connect => (method => 'post') => begin %>
	<h1>Bienvenue sur Mongo(mery burns), explorateur de collections MongoDB</h1>
    <p>Adresse IP de l'instance :
    <%= text_field 'instance_name' %> 
    Port de l'instance :  
    <%= text_field 'instance_port' %> 
    <%= submit_button 'Se connecter' %>
    </p>
<% end %>

@@ accueil.html.ep
% layout 'default';
    <h1>Liste des bases</h1>
    <ul>
    % foreach my $database (@$dbs) {
		<li><%= $database %></li>
    % }
    </ul>
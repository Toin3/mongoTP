use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new();

# Include application
use FindBin;
require "$FindBin::Bin/../mongoxplorer.pl";

# JSON
$t->post_form_ok('/ajax/execute' => {query => '{"loc": {"$exists": 1}}', projection=> ""})
->status_is(200)
->json_has('/0');

$t->post_form_ok('/ajax/test' => {latitude => 55.32914440840507, longitude=> 38.232421875})
->status_is(200)
->json_content_is({"message"=>"TEST"});

# JSON
$t->post_form_ok('/ajax/gmap' => {latitude => 55.32914440840507, longitude=> 38.232421875})
->status_is(200)
->json_has('/loc');

done_testing();
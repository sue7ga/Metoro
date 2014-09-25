package Metoro::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
use Data::Dumper;
use Metoro::Model::Metro;

use Module::Find;
useall 'Metoro::Web::C';
base 'Metoro::Web::C';

any '/' => sub {
    my ($c) = @_;
    my $metro = Metoro::Model::Metro->new(api_key => 'e4346dc05e12b8e457bdfe693a858f83aa7a31ebed6af708f410543c4e5e5c4b');
    my @datapoints =  @{$metro->datapoints};
    my @titles = map{$_->{'dc:title'}}@datapoints;
    return $c->render('index.tx', {
       'titles' => \@titles,
    });
};

get '/metro/:name' => 'Root#metro';


1;

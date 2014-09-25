package Metoro::Web::C::Root;

use strict;
use warnings;
use utf8;
use Data::Dumper;

sub metro{
 my($class,$c,$args) = @_;
 my $title = $args->{name};
 return $c->render('metro.tx',{'title' => $title});
}

1;

package Metoro::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
use Data::Dumper;
use Metoro::Model::Metro;
use Encode qw/decode_utf8/;
use Lingua::JA::Moji 'romaji2hiragana';

use Module::Find;
useall 'Metoro::Web::C';
base 'Metoro::Web::C';

my $metro = Metoro::Model::Metro->new(api_key => 'e4346dc05e12b8e457bdfe693a858f83aa7a31ebed6af708f410543c4e5e5c4b');

any '/' => sub {
    my ($c) = @_;
    my @datapoints =  @{$metro->datapoints};
    #my @titles = map{$_->{'dc:title'}}@datapoints;
    #my $json = $metro->datapoints;
    return $c->render_json(\@datapoints);
};

get '/metro/:name' => sub{
  my($c,$args) = @_;
  my $title = $args->{name};
  $title = decode_utf8($title);
  my @datapoints = @{$metro->datapoints};
  my @travelTime = ();
  for my $data(@datapoints){
    my $data_title = decode_utf8($data->{'dc:title'});
    next if $data_title ne $title;
    push @travelTime,@{$data->{'odpt:travelTime'}};
  }
  my $station = $metro->station->[0];
  my @toStation;
  for my $travel(@travelTime){
   $travel->{'odpt:toStation'} =~ s/odpt.Station:TokyoMetro.(\w+).//;
   $travel->{'odpt:fromStation'} =~ s/odpt.Station:TokyoMetro.(\w+).//;
   my $to = $station->{"$travel->{'odpt:toStation'}"};
   my $from = $station->{"$travel->{'odpt:fromStation'}"};
   push @toStation,{'to' => $to,'from' => $from,'time' => $travel->{'odpt:necessaryTime'}};
  }
  return $c->render('metro.tx',{'title' => $title,'travelTime' => \@toStation});
};

get 'hoge/station' => sub{
 my($c) = @_;
 my $station = $metro->station;
 print Dumper $station;
 return $c->render('station.tx');
};

1;



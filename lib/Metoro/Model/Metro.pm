package Metoro::Model::Metro;

use 5.008005;
use strict;
use warnings;
use Mouse;
use utf8;
use URI;
use LWP::UserAgent;
use JSON;

our $VERSION = "0.01";

use constant END_POINT => 'https://api.tokyometroapp.jp/api/v2/';

has 'api_key' => (is => 'rw',isa => 'Str',required => 1);

sub datapoints{
 my $self = shift;
 my $uri = END_POINT.'datapoints';
 my $url = URI->new($uri);
 my $param = {
  "acl:consumerKey" => $self->api_key,
  "rdf:type" => "odpt:Railway",
 };
 $url->query_form(%$param);
 $url =~ s/%3A/:/g;
 my $ua = LWP::UserAgent->new;
 my $res = $ua->get($url);
 my $json = JSON::decode_json($res->decoded_content);
 return $json;
}

1;

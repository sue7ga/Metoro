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

my %Yurakucho = (
   'わこし' => '和光市',
   'ちかてつなります' => '地下鉄成増',
   'ちかてつなります' => '地下鉄成増',
   'ちかてつあかつか' => '地下鉄赤塚',
   'へいわだい' => '平和台',
   'ひかわだい' => '氷川台',
   'こたけむかいはら' => '小竹向原',
   'せんかわ' => '千川',
   'かなめちょ' => '要町',
   'いけぶくろ' => '池袋',
   'ひがしいけぶくろ' => '東池袋',   
   'ごこくじ' => '護国寺',
   'えどがわばし'         => '江戸川橋',
   'いいだばし' => '飯田橋',
   'いちがや' => '市ヶ谷',
   'こじまち' => '麹町',
   'ながたちょ' => '永田町',
   'さくらだもん' => '桜田門',
   'ゆらくちょ' => '有楽町',
   'ぎんざいっちょめ' => '銀座一丁目',
   'しんとみちょ' => '新冨町',
   'つきしま' => '月島',
   'とよす' => '豊洲',
   'たつみ' => '辰巳',
   'しんきば'      => '新木場'
);

my %Hibiya = (
 'なかめぐろ' => '中目黒',
 'えびす'     => '恵比寿',	      
 'ひろお'     => '広尾',
 'ろっぽんぎ' => '六本木',
 'かみやちょ' => '神谷町',
 'かすみがせき' => '霞が関',
 'ひびや'  => '日比谷',
 'ぎんざ'  => '銀座',
 'ひがしぎんざ' => '東銀座',
 'つきじ' => '築地',
 'はっちょぼり' => '八丁堀',
 'かやばちょ' => '茅場町',
 'にんぎょちょ' => '人形町',
 'こでんまちょ' => '小伝馬町',
 'あきはばら' => '秋葉原',
 'なかおかちまち' => '仲御徒町',
 'うえの' => '上野',
 'いりや' => '入谷',
 'みのわ' => '三ノ輪',
 'みなみせんじゅ' => '南千住',
 'きたせんじゅ' => '北千住',
);

any '/' => sub {
    my ($c) = @_;
    my @datapoints =  @{$metro->datapoints};
    my @titles = map{$_->{'dc:title'}}@datapoints;
    return $c->render('index.tx', {
       'titles' => \@titles,
    });
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
  my @toStation;
  for my $travel(@travelTime){
   $travel->{'odpt:toStation'} =~ s/odpt.Station:TokyoMetro.(\w+).//;
   $travel->{'odpt:fromStation'} =~ s/odpt.Station:TokyoMetro.(\w+).//;
   my $line = $1;
   $travel->{'odpt:toStation'} = romaji2hiragana($travel->{'odpt:toStation'});
   $travel->{'odpt:fromStation'} = romaji2hiragana($travel->{'odpt:fromStation'});
   my $to   = $Yurakucho{"$travel->{'odpt:toStation'}"};
   my $from = $Yurakucho{"$travel->{'odpt:fromStation'}"}; 
   push @toStation,{'to' => $travel->{'odpt:toStation'},'from' => $travel->{'odpt:fromStation'},'time' => $travel->{'odpt:necessaryTime'}};
  }
  return $c->render('metro.tx',{'title' => $title,'travelTime' => \@toStation});
};


1;

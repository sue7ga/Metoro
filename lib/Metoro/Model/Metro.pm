package Metoro::Model::Metro;
use 5.008005;
use strict;
use warnings;
use Mouse;
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
 #my $json = $res->decodec_content;
 my $json = JSON::decode_json($res->decoded_content);
 return $json;
}

sub station{
 my $self = shift;
 my $metro_json = '[{"AoyamaItchome":"青山一丁目","Akasaka":"赤坂","AkasakaMitsuke":"赤坂見附","AkabaneIwabuchi":"赤羽岩淵","Akihabara":"秋葉原","Asakusa":"浅草","AzabuJuban":"麻布十番","Ayase":"綾瀬","Awajicho":"淡路町","Iidabashi":"飯田橋","Ikebukuro":"池袋","Ichigaya":"市ケ谷","Inaricho":"稲荷町","Iriya":"入谷","Ueno":"上野","UenoHirokoji":"上野広小路","Urayasu":"浦安","Edogawabashi":"江戸川橋","Ebisu":"恵比寿","Oji":"王子","OjiKamiya":"王子神谷","Otemachi":"大手町","Ogikubo":"荻窪","Oshiage":"押上<スカイツリー前>","Ochiai":"落合","Ochanomizu":"御茶ノ水","OmoteSando":"表参道","Gaiemmae":"外苑前","Kagurazaka":"神楽坂","Kasai":"葛西","Kasumigaseki":"霞ケ関","Kanamecho":"要町","Kamiyacho":"神谷町","Kayabacho":"茅場町","Kanda":"神田","KitaAyase":"北綾瀬","KitaSando":"北参道","KitaSenju":"北千住","Kiba":"木場","Gyotoku":"行徳","Kyobashi":"京橋","KiyosumiShirakawa":"清澄白河","Ginza":"銀座","GinzaItchome":"銀座一丁目","Kinshicho":"錦糸町","Kudanshita":"九段下","Kojimachi":"麴町","Korakuen":"後楽園","Gokokuji":"護国寺","KotakeMukaihara":"小竹向原","KokkaiGijidomae":"国会議事堂前","Kodemmacho":"小伝馬町","Komagome":"駒込","Sakuradamon":"桜田門","Shibuya":"渋谷","Shimo":"志茂","Shirokanedai":"白金台","ShirokaneTakanawa":"白金高輪","ShinOtsuka":"新大塚","ShinOchanomizu":"新御茶ノ水","ShinKiba":"新木場","ShinKoenji":"新高円寺","Shinjuku":"新宿","ShinjukuGyoemmae":"新宿御苑前","ShinjukuSanchome":"新宿三丁目","Shintomicho":"新富町","ShinNakano":"新中野","Shimbashi":"新橋","Jimbocho":"神保町","Suitengumae":"水天宮前","Suehirocho":"末広町","Sumiyoshi":"住吉","Senkawa":"千川","Sendagi":"千駄木","Zoshigaya":"雑司が谷","Takadanobaba":"高田馬場","Takebashi":"竹橋","Tatsumi":"辰巳","TameikeSanno":"溜池山王","Tawaramachi":"田原町","ChikatetsuAkatsuka":"地下鉄赤塚","ChikatetsuNarimasu":"地下鉄成増","Tsukiji":"築地","Tsukishima":"月島","Tokyo":"東京","Todaimae":"東大前","Toyocho":"東陽町","Toyosu":"豊洲","Toranomon":"虎ノ門","NakaOkachimachi":"仲御徒町","Nagatacho":"永田町","Nakano":"中野","NakanoSakaue":"中野坂上","NakanoShimbashi":"中野新橋","NakanoFujimicho":"中野富士見町","NakaMeguro":"中目黒","NishiKasai":"西葛西","Nishigahara":"西ケ原","NishiShinjuku":"西新宿","NishiNippori":"西日暮里","NishiFunabashi":"西船橋","NishiWaseda":"西早稲田","Nijubashimae":"二重橋前","Nihombashi":"日本橋","Ningyocho":"人形町","Nezu":"根津","Nogizaka":"乃木坂","Hatchobori":"八丁堀","BarakiNakayama":"原木中山","Hanzomon":"半蔵門","HigashiIkebukuro":"東池袋","HigashiGinza":"東銀座","HigashiKoenji":"東高円寺","HigashiShinjuku":"東新宿","Hikawadai":"氷川台","Hibiya":"日比谷","HiroO":"広尾","Heiwadai":"平和台","Honancho":"方南町","HongoSanchome":"本郷三丁目","HonKomagome":"本駒込","Machiya":"町屋","Mitsukoshimae":"三越前","MinamiAsagaya":"南阿佐ケ谷","MinamiGyotoku":"南行徳","MinamiSunamachi":"南砂町","MinamiSenju":"南千住","Minowa":"三ノ輪","Myogadani":"茗荷谷","Myoden":"妙典","MeijiJingumae":"明治神宮前<原宿>","Meguro":"目黒","MonzenNakacho":"門前仲町","Yurakucho":"有楽町","Yushima":"湯島","Yotsuya":"四ツ谷","YotsuyaSanchome":"四谷三丁目","YoyogiUehara":"代々木上原","YoyogiKoen":"代々木公園","Roppongi":"六本木","RoppongiItchome":"六本木一丁目","Wakoshi":"和光市","Waseda":"早稲田"}]';
 my $data = JSON::decode_json($metro_json);
 return $data;
}

1;


use strict;
use warnings;
use Test::More;


use Metoro;
use Metoro::Web;
use Metoro::Web::View;
use Metoro::Web::ViewFunctions;

use Metoro::DB::Schema;
use Metoro::Web::Dispatcher;


pass "All modules can load.";

done_testing;

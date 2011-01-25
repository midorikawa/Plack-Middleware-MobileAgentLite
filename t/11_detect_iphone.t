use strict;
use Test::More;
BEGIN { use_ok 'Plack::Middleware::MobileAgentLite' }

my $ma = HTTP::MobileAgentLite->new();

my $env = { HTTP_USER_AGENT =>
"Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1 like Mac OS X; ja-jp) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7C144 Safari/528.16", };

my $res = $ma->detect($env);

is_deeply $res,
  {
    'is_vodafone'      => 0,
    'is_ezweb'         => 0,
    'is_airh'          => 0,
    'is_docomo'        => 0,
    'is_bot'           => 0,
    'is_gps'           => 0,
    'carrier'          => 'S',
    'is_mobile'        => 0,
    'is_non_mobile'    => 0,
    'carrier_longname' => 'iPhone',
    'user_id'          => undef,
    'is_softbank'      => 0,
    'encoding'         => 'utf-8',
    'content_type'     => 'text/html;charset=utf-8',
	'is_smartphone'    => 1,
	'is_iphone'		   => 1,
	'is_android'       => 0,
  };

done_testing;

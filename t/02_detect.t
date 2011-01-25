use strict;
use Test::More;
BEGIN { use_ok 'Plack::Middleware::MobileAgentLite' }

my $ma = HTTP::MobileAgentLite->new();

my $env = { HTTP_USER_AGENT => 'Mozilla/1.1' };
my $res = $ma->detect($env);

is_deeply $res,
  {
    'is_vodafone'      => 0,
    'is_ezweb'         => 0,
    'is_airh'          => 0,
    'is_docomo'        => 0,
    'is_bot'           => 0,
    'is_gps'           => 0,
    'carrier'          => '',
    'is_mobile'        => 0,
    'is_non_mobile'    => 1,
    'carrier_longname' => '',
    'user_id'          => undef,
    'is_softbank'      => 0,
    'encoding'         => 'utf-8',
    'content_type'     => 'text/html;charset=utf-8',
	'is_smartphone'    => 0,
	'is_iphone'		   => 0,
	'is_android'       => 0,
  };

done_testing;

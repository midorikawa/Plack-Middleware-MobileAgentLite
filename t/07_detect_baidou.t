use strict;
use Test::More;
BEGIN { use_ok 'Plack::Middleware::MobileAgentLite' }

my $ma = HTTP::MobileAgentLite->new();

my $env =
  { HTTP_USER_AGENT =>
'DoCoMo/2.0 P05A(c100;TB;W24H15) (compatible; BaiduMobaider/1.0;+http://www.baidu.jp/spider/)',
  };
my $res = $ma->detect($env);

is_deeply $res,
  {
    'is_vodafone'      => 0,
    'is_ezweb'         => 0,
    'is_airh'          => 0,
    'is_docomo'        => 1,
    'is_bot'           => 1,
    'is_gps'           => 0,
    'carrier'          => 'I',
    'is_mobile'        => 1,
    'is_non_mobile'    => 0,
    'carrier_longname' => 'DoCoMo',
    'user_id'          => undef,
    'is_softbank'      => 0,
    'encoding'         => 'x-utf8-docomo',
    'content_type'     => 'application/xhtml+xml',
	'is_smartphone'    => 0,
	'is_iphone'		   => 0,
	'is_android'       => 0,
  };

done_testing;

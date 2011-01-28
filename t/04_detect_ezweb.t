use strict;
use Test::More;
BEGIN { use_ok 'Plack::Middleware::MobileAgentLite' }

my $ma = HTTP::MobileAgentLite->new();

my $env = {
    HTTP_USER_AGENT => 'KDDI-SH3D UP.Browser/6.2_7.2.7.1.K.4.303 (GUI) MMP/2.0',
    HTTP_X_UP_SUBNO => 'abcdefghij',
    HTTP_X_UP_DEVCAP_MULTIMEDIA => 'A300971224403120',
};
my $res = $ma->detect($env);

is_deeply $res,
  {
    'is_vodafone'      => 0,
    'is_ezweb'         => 1,
    'is_airh'          => 0,
    'is_docomo'        => 0,
    'is_bot'           => 0,
    'is_gps'           => 1,
    'carrier'          => 'E',
    'is_mobile'        => 1,
    'is_non_mobile'    => 0,
    'carrier_longname' => 'EZweb',
    'user_id'          => 'abcdefghij',
    'is_softbank'      => 0,
    'encoding'         => 'x-sjis-ezweb-auto',
    'content_type'     => 'text/html;charset=shift_jis',
	'is_smartphone'    => 0,
	'is_iphone'		   => 0,
	'is_android'       => 0,
	'type' 			   => 'mobile',
  };

done_testing;

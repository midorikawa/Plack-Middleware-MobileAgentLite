use strict;
use Test::More;
BEGIN { use_ok 'Plack::Middleware::MobileAgentLite' }

my $ma = HTTP::MobileAgentLite->new();

my $env = { HTTP_USER_AGENT =>
      "Mozilla/3.0(WILLCOM;KYOCERA/WX331K/2;1.0.7.13.000000/0.1/C100) Opera 7.2 EX", };
my $res = $ma->detect($env);

is_deeply $res,
  {
    'is_vodafone'      => 0,
    'is_ezweb'         => 0,
    'is_airh'          => 1,
    'is_docomo'        => 0,
    'is_bot'           => 0,
    'carrier'          => 'H',
    'is_mobile'        => 1,
    'is_non_mobile'    => 0,
    'carrier_longname' => 'AirHPhone',
    'user_id'          => undef,
    'is_softbank'      => 0,
    'encoding'         => 'x-sjis-docomo',
    'content_type'     => 'text/html;charset=shift_jis',
  };

done_testing;

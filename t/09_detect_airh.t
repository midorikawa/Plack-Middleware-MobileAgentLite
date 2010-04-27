use strict;
use Test::More;
BEGIN { use_ok 'Plack::Middleware::MobileAgentLite' }

my $ma = HTTP::MobileAgentLite->new();

my $env = { HTTP_USER_AGENT =>
      'Mozilla/3.0(DDIPOCKET;JRC/AH-J3001V,AH-J3002V/1.0/0100/c50)CNF/2.0', };
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

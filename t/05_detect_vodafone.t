use strict;
use Test::More;
BEGIN { use_ok 'Plack::Middleware::MobileAgentLite' }

my $ma = HTTP::MobileAgentLite->new();

my $env = {
    HTTP_USER_AGENT =>
'SoftBank/1.0/DM004SH/SHJ001/SN359401028055165 Browser/NetFront/3.5 Profile/MIDP-2.0 Configuration/CLDC-1.1',
    HTTP_X_JPHONE_UID => 'abcdefghij'
};
my $res = $ma->detect($env);

is_deeply $res,
  {
    'is_vodafone'      => 1,
    'is_ezweb'         => 0,
    'is_airh'          => 0,
    'is_docomo'        => 0,
    'is_bot'           => 0,
    'carrier'          => 'V',
    'is_mobile'        => 1,
    'is_non_mobile'    => 0,
    'carrier_longname' => 'Vodafone',
    'user_id'          => 'abcdefghij',
    'is_softbank'      => 1,
    'encoding'         => 'x-utf8-vodafone'
  };

done_testing;

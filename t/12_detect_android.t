use strict;
use Test::More;
use Plack::Middleware::MobileAgentLite;

my $res =  +{
    'is_vodafone'      => 0,
    'is_ezweb'         => 0,
    'is_airh'          => 0,
    'is_docomo'        => 0,
    'is_bot'           => 0,
    'is_gps'           => 0,
    'carrier'          => 'A',
    'is_mobile'        => 0,
    'is_non_mobile'    => 0,
    'carrier_longname' => 'Android',
    'user_id'          => undef,
    'is_softbank'      => 0,
    'encoding'         => 'utf-8',
    'content_type'     => 'text/html;charset=utf-8',
	'is_smartphone'    => 1,
	'is_iphone'		   => 0,
	'is_android'	   => 1,
};


for (
'Mozilla/5.0 (Linux; U; Android 1.5; ja-jp; HT-03A Build/CDB72)AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/525.20.1',
'Mozilla/5.0 (Linux; U; Android 1.6; ja-jp; SonyEricssonSO-01B Build/R1EA018)AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/525.20.1',
'Mozilla/5.0 (Linux; U; Android 2.1-update1; ja-jp; HTCX06HT Build/ERE27) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17',
'Mozilla/5.0 (Linux; U; Android 1.6; ja-jp; SonyEricssonSO-01B Build/R1EA018)AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/525.20.1'
)
{
	is_deeply detect($_), $res;
}



sub detect {
	my ($env, $ma);
	$env->{HTTP_USER_AGENT} = shift;
	$ma ||= HTTP::MobileAgentLite->new();
	$ma->detect($env);
}

done_testing;


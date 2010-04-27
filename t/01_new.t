use strict;
use Test::More;

BEGIN { use_ok 'Plack::Middleware::MobileAgentLite' }


my $ma = HTTP::MobileAgentLite->new();

isa_ok $ma, 'HTTP::MobileAgentLite';
done_testing;

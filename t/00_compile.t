use strict;
use Test::More tests => 1;

BEGIN { use_ok 'Plack::Middleware::MobileAgentLite' }

diag "VERSION is: ", ${Plack::Middleware::MobileAgentLite::VERSION};

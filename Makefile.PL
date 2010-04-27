use inc::Module::Install;
name 'Plack-Middleware-MobileAgentLite';
all_from 'lib/Plack/Middleware/MobileAgentLite.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;

use inc::Module::Install;

name     'WebService-Polycom';
license  'MIT';
all_from 'lib/WebService/Polycom/RemoteController.pm';

requires       'Any::Moose';
build_requires 'Test::More';

author_tests   'xt';
auto_set_repository;
auto_include_deps;
WriteAll;

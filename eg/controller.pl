#!/usr/bin/env perl

use strict;
use warnings;
use Config::Pit;
use Term::ReadLine;

use FindBin::libs;
use WebService::Polycom::RemoteController;

my $config = pit_get('polycom.kyoto', require => {
    host     => 'your host for polycom',
    username => 'your username for polycom',
    password => 'your password for polycom',
});

my $polycom = WebService::Polycom::RemoteController->new;
   $polycom->host($config->{host});
   $polycom->username($config->{username});
   $polycom->password($config->{password});

my $term = Term::ReadLine->new('Polycom Controller');

while (defined (my $command = $term->readline('polycom> '))) {
    my $res = $polycom->button($command);
    for my $command (@{$res->commands}) {
        printf "%s: %s\n", $command->is_success ? 'OK' : 'NG', $command->message
    }
}

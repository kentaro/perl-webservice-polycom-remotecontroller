package WebService::Polycom::RemoteController::Result;
use Any::Moose;
use XML::Simple;

use WebService::Polycom::RemoteController::Result::Command;

has 'res' => (is => 'rw', isa => 'HTTP::Response');

no Any::Moose;
__PACKAGE__->meta->make_immutable;

sub is_success {
    my $self = shift;
    $self->res->is_success;
}

sub is_error {
    my $self = shift;
    $self->res->is_error;
}

sub commands {
    my $self = shift;
    my $xml  = XMLin($self->res->content, ForceArray => 1);

    +[
        map {
            chomp $_->{result}->[0];
            WebService::Polycom::RemoteController::Result::Command->new({
                status  => $_->{command}->[0]->{status},
                command => $_->{command}->[0]->{content},
                message => $_->{result}->[0],
            });
        } @{$xml->{apicommand} || []}
    ];
}

!!1;

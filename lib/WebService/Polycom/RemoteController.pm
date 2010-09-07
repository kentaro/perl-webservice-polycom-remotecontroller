package WebService::Polycom::RemoteController;
use 5.008_001;
use Any::Moose;
use Carp qw(croak);

use LWP::UserAgent;
use HTTP::Request::Common;

use WebService::Polycom::RemoteController::Result;

our $VERSION = '0.01';

has 'ua' => (
    is         => 'rw',
    isa        => 'LWP::UserAgent',
    lazy_build => 1,
);

has 'username' => (
    is  => 'rw',
    isa => 'Str',
);

has 'password' => (
    is  => 'rw',
    isa => 'Str',
);

has 'host' => (
    is  => 'rw',
    isa => 'Str',
);

no Any::Moose;
__PACKAGE__->meta->make_immutable;

sub _build_ua {
    my $self = shift;

    my ($host, $username, $password) = map {
        $self->$_ or croak "$_ is required";
    } qw(host username password);

    my $ua = LWP::UserAgent->new;
       $ua->credentials($host.":80", 'this web site', $username, $password);

    $self->ua($ua);
}

sub is_alive {
    my $self = shift;
    my $host = $self->host;
    $self->ua->get("http://$host/")->is_success;
}

sub request {
    my $self = shift;
    my $res  = $self->ua->post("http://@{[$self->host]}/a_apicommand.cgi", [@_]);
    WebService::Polycom::RemoteController::Result->new({res => $res});
}

sub button {
    my ($self, $commands) = @_;
    my $api_command = join '', (map { "button $_;" } split /\s+/, $commands);
    $self->request(apicommand => $api_command);
}

!!1;

__END__

=head1 NAME

WebService::Polycom::RemoteController - A Perl extension for blah,
blah, blah...

=head1 SYNOPSIS

  use WebService::Polycom::RemoteController;

  my $obj = WebService::Polycom->new($args);
  my $res = $obj->foo($args);

=head1 DESCRIPTION

WebService::Polycom is  blah, blah, blah...

=head1 METHODS

=head2 new ( I<$args> )

=over 4

  my $obj = WebService::Polycom::RemoteController->new($args);

Creates and returns a new WebService::Polycom::RemoteController
object.

=back

=head2 foo ( I<$args> )

=over 4

  my $res = $obj->foo($args);

Description for the method here.

=back

=head1 SEE ALSO

=over 4

=item * item

Desctiption for the item above.

=back

=head1 AUTHOR

Kentaro Kuribayashi E<lt>kentaro@cpan.orgE<gt>

=head1 SEE ALSO

=head1 COPYRIGHT AND LICENSE (The MIT License)

Copyright (c) Kentaro Kuribayashi E<lt>kentaro@cpan.orgE<gt>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=cut

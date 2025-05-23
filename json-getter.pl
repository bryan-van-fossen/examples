#!/usr/bin/perl
# Copyright (c) 2025 Bryan Van Fossen. All rights reserved.

use strict;
use warnings;

use Getopt::Long;
use REST::Client;
use JSON;
use Data::Dumper;
use Pod::Usage;

sub get_options {
    # Default values
    my %opt = (host => 'https://httpbin.org',
               port => 443,
               path => '/json');
    GetOptions(\%opt,
               'host=s',
               'port=i',
               'path=s',
               'help');
    if ($opt{help}) {
        pod2usage(-verbose => 2, -noperldoc => 1)
    }
    
    return \%opt;
}

sub new_client {
    my %p = @_;

    my $client = REST::Client->new();
    my $socket = $p{host} . ':' . $p{port};
    $client->setHost($socket);
    $client->addHeader(ContentType => 'application/json');
    $client->setTimeout(60);

    return $client;
}

sub get_json {
    my %p = @_;

    $p{client}->GET($p{path});
    return decode_json($p{client}->responseContent());
}

sub main {
    my $opt = get_options();
    my $client = new_client(host => $opt->{host},
                            port => $opt->{port});
    my $content = get_json(client => $client,
                           path   => $opt->{path});

    print Dumper($content) . "\n";
}

main();

__END__

=head1 NAME

json-getter.pl

=head1 SYNOPSIS

json-getter.pl --host='https://httpbin.org' --port=443 --path='/json'

=head1 OPTIONS

=over 2

=item --host

The host to query.

=item --port

The TCP port that the host is listening on.

=item --path

The path on the host to the JSON you wish to retrieve.

=back

=head1 DESCRIPTION

Performs an unauthenticated query to a host for JSON structured data,
converts it into a hash, and dumps it to STDOUT.

=cut

1;

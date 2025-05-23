#!/usr/bin/perl

use REST::Client;
use JSON;
use Data::Dumper;

my $url = $ARGV[0] || 'https://httpbin.org/json';

my $client = REST::Client->new();
$client->addHeader(ContentType => 'application/json');
$client->GET($url); 

my $content = decode_json($client->responseContent());
print Dumper($content) . "\n";
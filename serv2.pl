#!/usr/bin/perl -w
use strict;
use Net::HTTPServer;
our $version = 0.1;

my $server = new Net::HTTPServer(
        port=>5000,
        type=>'single',
    );

$server->AddServerTokens("bmwiedemann/opensuse-redir-cache-$version");
$server->RegisterRegex(".*", \&myurlhandler);
$server->Start();
$server->Process();

sub myurlhandler
{   my $req = shift;             # Net::HTTPServer::Request object
    my $res = $req->Response();  # Net::HTTPServer::Response object
    my $url = $req->URL();
    $res->Print("Hello $url\n");
    return $res;
}

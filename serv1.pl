#!/usr/bin/perl -w
use strict;
use Net::HTTPServer;
our $version = 0.1;

my $server = new Net::HTTPServer(
        port=>5000,
        #docroot=>'/srv/www',
        type=>'single',
    );

$server->AddServerTokens("bmwiedemann/opensuse-redir-cache-$version");
$server->RegisterRegex(".*", \&myurlhandler);
#$server->RegisterRegex({
#                     ".*" => \&myurlhandler,
#                     }); #TODO: this should be working -> debug+report upstream
# but Net-HTTPServer-1.1.1.tar.gz is from 2011 :-(

$server->Start();
$server->Process();

sub myurlhandler
{   my $req = shift;             # Net::HTTPServer::Request object
    my $res = $req->Response();  # Net::HTTPServer::Response object
    $res->Print("Hello\n");
    return $res;
}

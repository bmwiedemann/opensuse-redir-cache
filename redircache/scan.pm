package redircache::scan;

use strict;
use warnings;
use WWW::Curl::Easy;
use WWW::Curl::Multi;
use WWW::Curl::Share;

my %easy;
my @mirrorurls = qw(
  http://ftp.tu-chemnitz.de/pub/linux/opensuse/
  http://ftp.gwdg.de/pub/linux/suse/opensuse/
);
my @body;
my $curlsh = new WWW::Curl::Share;
$curlsh->setopt(CURLSHOPT_SHARE, CURL_LOCK_DATA_DNS);
$curlsh->setopt(CURLSHOPT_SHARE, CURL_LOCK_DATA_CONNECT);
$curlsh->setopt(CURLSHOPT_SHARE, CURL_LOCK_DATA_SSL_SESSION);
my $curlm = WWW::Curl::Multi->new;
#$curlm->setopt(CURLMOPT_PIPELINING, 3);
my $active_handles = 0;
for(my $id=0; $id<@urls; $id++) {
    my $curl_id = $id+1; # This should be a handle unique id.
    my $curl = WWW::Curl::Easy->new;
    $easy{$curl_id} = $curl;
    $curl->setopt(CURLOPT_PRIVATE,$curl_id);
    $curl->setopt(CURLOPT_URL, $urls[$id]);
    $curl->setopt(CURLOPT_HEADER, 1);
    $curl->setopt(CURLOPT_SHARE, $curlsh);
    $curl->setopt(CURLOPT_TIMEOUT_MS, 500);
    # Add an easy handle
    $curlm->add_handle($curl);
    my $response_body;
    $curl->setopt(CURLOPT_WRITEDATA,\$response_body);
    push(@body, \$response_body);
    $active_handles++;
}


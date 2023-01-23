#!/usr/bin/perl -w
use strict;

use strict;
use warnings;
use WWW::Curl::Easy;
use WWW::Curl::Multi;
use WWW::Curl::Share;

my %easy;
my @urls = qw(
  http://download.opensuse.org/tumbleweed/repo/oss/repodata/repomd.xml
  http://download.opensuse.org/tumbleweed/repo/oss/repodata/repomd.xml.asc
  http://download.opensuse.org/update/tumbleweed/repodata/repomd.xml
  http://download.opensuse.org/update/tumbleweed/repodata/repomd.xml.asc
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

# launch parallel requests
    while ($active_handles) {
            my $active_transfers = $curlm->perform;
            if ($active_transfers != $active_handles) {
                    while (my ($id,$return_value) = $curlm->info_read) {
                            if ($id) {
                                    $active_handles--;
                                    my $actual_easy_handle = $easy{$id};
                                    # do the usual result/error checking routine here
                                    #...
                                    print "XXX $active_handles\n";
                                    # letting the curl handle get garbage collected, or we leak memory.
                                    delete $easy{$id};
                                    my $b = ${$body[$id-1]};
                                    print "XXX body ".length($b)."$b\n";
                            }
                    }
            }
    }


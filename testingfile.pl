#!/usr/bin/perl -w

#filename create_vhosts_subdomains.pl


use File::Copy;
use File::Path;

$domaintype ="something1";
$domain = "something";

$file = "
              <VirtualHost *:80>\n
                      DocumentRoot \/home\/www\/html\/".$domaintype.$domain."/public_html\/\n
                      ServerName $domain\n
                      ServerAlias www.$domain
                      ErrorLog logs\/".$domaintype.$domain."\/".$domain."_error_log\n
                      CustomLog logs\/".$domaintype.$domain."\/".$domain."_access_log common\n
                      </VirtualHost>\n
                 ";

print $file;


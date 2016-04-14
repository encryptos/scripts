#!/usr/bin/perl -w

#filename create_ftp_accounts.pl
use File::Copy;
use File::Path;

print "Enter domain:- ";
$domain=<STDIN>;
chomp $domain;

#maybe use combined paths into 1 variable, tidy up script.

$base = '/home/www/html/maindomains/';
$base2 = '/var/log/httpd/maindomains/';
$path = "$base$domain";

#If the domain doesnt already exist.
if ( -d $path)
{
	print "$path Already exists, Exiting\n";
	exit 0;
}
else
{
	
	#Make http directory, also known as the ftp directory.
	$command1 = "local_root=/home/www/html/maindomains/$domain";
	
	$public = '/public_html/';
	$ftp = '/etc/vsftpd/vsftpd_user_conf/';
	$ftp2 = '/etc/vsftpd/vsftpd_user_conf/script_template';	

	mkpath ($base.$domain.$public);
	mkpath ($base2.$domain);
	#chown vsftpd:nobody
	#chmod 755($base.$domain.
	
	print "your new ftp directory is \n $base$domain\n";
	print "FTP config directory is \n $ftp$domain\n";

	# Every file in /etc/vsftpd/vsftpd_user_conf enables us to use custom
	# ftp home directorys, so we make one based on our domain name, then insert
	# that into the custom vsftpd user file for our domain.
	copy($ftp2,$ftp."/".$domain)or die "Cannot copy vsftpd file";
	open(FTP,">>",  '/etc/vsftpd/vsftpd_user_conf/'.$domain);
	print FTP $command1;
	exit 0;

}

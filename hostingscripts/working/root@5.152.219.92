#!/usr/bin/perl -w
use File::Copy;

print "Enter domain:- ";
$domain=<STDIN>;
chomp $domain;
$base = "\/home\/www\/html\/";
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
	$public = "\/public_html\';
	$ftp = '/etc/vsftpd/vsftpd_user_conf';
	$ftp2 = '/etc/vsftpd/vsftpd_user_conf/script_template';	
	#mkdir ($base.$domain); 
	mkdir ($base.$domain.$public);
	
	print "your new ftp directory is \n $base$domain\n";

	# Every file in /etc/vsftpd/vsftpd_user_conf enables us to use custom
	# ftp home directorys, so we make one based on our domain name, then insert
	# that into the custom vsftpd user file for our domain.
	copy($ftp2,$ftp."/".$domain)or die "Cannot copy vsftpd file";
	open(FTP,">>",  '/etc/vsftpd/vsftpd_user_conf/'.$domain);
	print FTP $command1;
	exit 0;

}

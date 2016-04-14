#!/usr/bin/perl -w

#filename create_vhosts_subdomains.pl


use File::Copy;
use File::Path;

print "Which domain type maindomain(1) or subdomain(2) for your ftp account";
$domainchoice = <STDIN>;
chomp $domainchoice;

if ( $domainchoice == "1" )
	
	{	
		$domaintype = "maindomains/";
		
	}

elsif ( $domainchoice == "2")

	{	
		$domaintype = "subdomains/";
			
	}
else
	{
		print "Neither 1 or 2 selected, go back";
		exit 0;
	}

print "here is your domain type $domaintype\n";
	
print "Enter domain:- ";
$domain=<STDIN>;
chomp $domain;

#maybe use combined paths into 1 variable, tidy up script.

### DECLARE VARS ###

$basevhost='/etc/httpd/conf/vhosts/$domaintype';
$path_domain = "$basevhost$domain";
$path_domain_logs ="/var/log/httpd/$domaintype$domain"; 
$error_log = '/'.$domain.'_error_log';
$access_log = '/'.$domain.'_access_log common';
$null ='';
$httpd_base ='/home/www/html/'.$domainchoice;


$command1 = "local_root=/home/www/html/$domaintype$domain";
$public = '/public_html/';
$ftp = '/etc/vsftpd/vsftpd_user_conf/';
$ftp2 = '/etc/vsftpd/vsftpd_user_conf/script_template';


### If the domain doesnt already exist..... /etc/httpd/conf/vhosts/$domaintype$domain ###
if ( -d $path_domain )

	{
		print "$path_domain Already exists, Exiting\n";
		exit 0;
	}

else
	{
		
		### CREATE VSFTPD_USER_CONFIG ###


		#Make http directory, also known as the ftp directory.

	        mkpath ($httpd_base.$domain.$public);
	        
        	print "your new ftp directory is \n $httpd_base$domain\n";
	        print "FTP config directory is \n $ftp$domain\n";

	        # Every file in /etc/vsftpd/vsftpd_user_conf enables us to use custom
        	# ftp home directorys, so we make one based on our domain name, then insert
	        # that into the custom vsftpd user file for our domain.
	        copy($ftp2,$ftp."/".$domain)or die "Cannot copy vsftpd file";
	        open(FTP,">>",  '/etc/vsftpd/vsftpd_user_conf/'.$domain);
	        print FTP $command1;

	
		### VIRTUAL HOST STUFF ###
		
		$file = "
		<VirtualHost *:80>\n
	        DocumentRoot \/home\/www\/html\/".$domaintype.$domain."/public_html\/\n
	        ServerName $domain\n
		ServerAlias www.$domain
	        ErrorLog logs\/".$domaintype.$domain."\/".$domain."_error_log\n
	        CustomLog logs\/".$domaintype.$domain."\/".$domain."_access_log common\n
		</VirtualHost>\n
		";

		#### CONFIRM AND CREATE LOG FILES ###

		if ( -d $path_domain_logs)

			{
				print "Path $path_domain_logs already exists, skipping...\n\n";

				##print $path_domain_logs.$error_log ;
			}
	
		else
			{
				mkdir ( $path_domain_logs, 0755 );
		


				print "Path $path_domain_logs does not exist, created with 0755 Permissions\n\n";
				

				### CREATE HTTPD ERROR LOGS
				if( -f $path_domain_logs.$error_log )

					{
						print "Error log $error_log exists, skipping...";
					}	
				else
					{	
	
						open(LOG1,">", "$path_domain_logs$error_log");
						print LOG1 $null;
						print "$path_domain_logs$error_log doesnt exist, creating...\n\n";
					}

				if( -f $path_domain_logs.$access_log )

					{
						print "Error log $access_log exists, skipping...\n\n";
					}
				
				else
					{	
						
						open(LOG2,">", "$path_domain_logs$access_log");
						print LOG2 $null;    
                                                print "$path_domain_logs$access_log doesnt exist, creating...\n\n";

					}
			}

		
		open(FTP,">",  '/etc/httpd/conf/vhosts/'.$domaintype.$domain.'.conf');
		print FTP $file;
		
#		if (-f '/etc/httpd/conf/vhosts/ );
		print "VirtualHost file created:-\n";
		print  '/etc/httpd/conf/vhosts/'.$domaintype.$domain.'.conf';
		print "\n\n DONT FORGET TO RELOAD OR RESTART APACHE\n";

		exit;

	}

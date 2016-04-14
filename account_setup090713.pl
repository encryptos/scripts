#!/usr/bin/perl -w

#filename account_setup.pl

use File::Copy;
use File::Path;
use warnings;
use strict;
use Switch;
use DBI;

sub generatePassword
{
	my $length = shift;
	my $password = "";
	my $possible = 'abcdefghijkmnpqrstuvwxyz23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
 
	while(length($password) < $length)
	{
		$password .= substr($possible, (int(rand(length($possible)))), 1);
        
	}
	return $password
}


my $input = '';

while ($input ne '7')
{
#	clear_screen();

	print "1. Create maindomain or subdomain\n".
	      "2. Create FTP account with password\n".
	      "3. Create Database\n".
	      "4. Create Email account(domain must be already in place)\n".
	      "5. Reset Email Password\n".
              "6. Reset FTP Password\n";
	      "7. Exit\n\n";
		

	print "Enter your choice: ";              
        my $input = <STDIN>;
	chomp ($input);

	switch($input)
	{	
		my $domainchoice;
		#Create maindomain or subdomain
		case'1'
		{
		
			print "(1)Maindomain or (2)Subdomain: ";
			my $choice1 = <STDIN>;
			chomp $choice1;
			
			if($choice1 == 1)
				{
					$domainchoice="maindomains";
				}
			else
				{
					$domainchoice="subdomains";
				}				
			
			#READ ME ####
			#Script checks to see if /etc/httpd/conf/vhosts/domainchoice/domainname exists
			#If it exists, exits. If not...
			
			#Normally in apache config you list all the virtual domains in the main config. I have set out a folder called vhosts, that each domain has its own vhost  file.
			#This ensures better setup and less likely to break the main config file.
			
			#Create virtual host file for apache at  /etc/httpd/conf/vhosts/
			#Check to see if apache log paths exist /var/log/httpd/maindomains/domain exists, if it does exit, else..
			#Create the path and log files domain_error_log and domain_access_log, path permisions 0755 and file permissions are currently 0644, owner root:root
			#Last part of the script inserts the info that makes up the vhost file for apache.

			print "Enter domain:- ";
			my $domain=<STDIN>;
			chomp $domain;

			#mayybe use combined paths into 1 variable, tidy up script.

			### DECLARE VARS ###
			#my $domainchoice;
			my $httpdir = '/home/www/html/'.$domainchoice;
			my $basevhost='/etc/httpd/conf/vhosts/'.$domainchoice;
			my $path_maindomain = "$basevhost$domain";
			my $path_maindomain_logs ='/etc/httpd/logs/'.$domainchoice.'/'.$domain;
			my $error_log = '/'.$domain.'_error_log';
			my $access_log = '/'.$domain.'_access_log';
			my $null ='';

			#If the domain doesnt already exist..... /etc/httpd/conf/vhosts/$domainchoice/$domain ###

			#check if /home/www/html/domainchoice/domain exists. If this isnt created apache gives an error cant find this dir
			
			#print $path_maindomain_logs."\n";
			#print $path_maindomain_logs.$error_log."\n";
			#print $path_maindomain_logs.$access_log."\n";

			#checks for /home/www/html/domainchoice/
			if ( -d $httpdir."/".$domain )
				{
					print $httpdir."/".$domain ."/ \n exists exiting.";
				}

			else 
				{
	
					print $httpdir."/".$domain ."/ \n created with 0755 Permissions\n\n";

					mkpath ($httpdir."/".$domain."/public_html",0755);	
					
				}

			## create 

			####	CONFIRM AND CREATE LOG FILES	###
			if ( -d $path_maindomain_logs)
				{
					print "Path $path_maindomain_logs already exists, skipping...\n\n";
			        }
			else
				{
				       	mkdir ( $path_maindomain_logs, 0755 );
			                print "Path $path_maindomain_logs does not exist, created with 0755 Permissions\n\n";
				}
			if( -f $path_maindomain_logs.$error_log )

				{
			        	print "Error log $error_log exists, skipping...\n\n";

			        }	
			else
				{
			  	        open(LOG1,">", "$path_maindomain_logs$error_log");
			                print LOG1 $null;
			                print "$path_maindomain_logs$error_log doesnt exist, creating...\n\n";
			        }

			if( -f $path_maindomain_logs.$access_log )
			        {
					print "Error log $access_log exists, skipping...\n\n";
			        }
			else
			        {
				        open(LOG2,">", "$path_maindomain_logs$access_log");
			                print LOG2 $null;
			                print "$path_maindomain_logs$access_log doesnt exist, creating...\n\n";
			        }

			###	END CREATING LOGFILES	###

			#checks for /etc/httpd/conf/vhosts/domainchoice/domain for apache virtual site
			if ( -d $path_maindomain)
			        {
			                print $path_maindomain."Already exists, Exiting\n";
			                exit 0;
			        }
			else
			        {

			                my $file = "
			                <VirtualHost *:80>\n
			                DocumentRoot \/home\/www\/html\/$domainchoice\/$domain\/public_html\/\n
			                ServerName $domain\n
			                ServerAlias www.$domain
			                ErrorLog logs\/$domainchoice\/$domain\/$domain"."_error_log\n
			                CustomLog logs\/$domainchoice\/$domain\/$domain"."_access_log common\n
			                </VirtualHost>\n
		                	";

                			#copy($ftp2,$ftp."/".$domain)or die "Cannot copy vsftpd file";
			                open(FTP,">",  '/etc/httpd/conf/vhosts/'.$domainchoice.'/'.$domain.'.conf');
			                print FTP $file;

                			print "VirtualHost file created:-\n";
					print  '/etc/httpd/conf/vhosts/'.$domainchoice.'/'.$domain.'.conf';
        			        print "\n DONT FORGET TO RELOAD OR RESTART APACHE\n";

			                exit;

        			}
			
			
		}# END OF CASE 1
		
		## Create FTP account
		case'2'
		{
			### DECLARE VARS ###
			
			my $domainchoice;
			#my $httpdir = '/home/www/html/'.$domainchoice;
			my $stdpass = generatePassword(10);
			my $database = "vsftpd";
			my $user = "vsftpd";
			my $pass = "vsftpdpassword";
			my $password;
			my $domain; 
			my $choice1;

			print "(1)Maindomain or (2)Subdomain: ";
                        $choice1 = <STDIN>;
                        chomp $choice1;

                        if($choice1 == 1)
                                {
                                        $domainchoice="maindomains";
                                }
                        else
                                {
                                        $domainchoice="subdomains";
                                }
			my $httpdir = '/home/www/html/'.$domainchoice;	
			print "Enter domain:- ";
                        $domain=<STDIN>;
                        chomp $domain;

			if ( -d $httpdir."/".$domain )
				{
					#print "$path Already exists, skipping\n\n";


					 print $httpdir."/".$domain ."/ \n\n exists exiting.";
		        	}
			
			else
				{
					 
        	                         mkpath ($httpdir."/".$domain."/public_html",0755);
					 print $httpdir."/".$domain ."/ \n created with 0755 Permissions\n\n";
	
				}		
	
        			#Make http directory, also known as the ftp directory.
			        my $command1 = "local_root=/home/www/html/".$domainchoice."/".$domain;

			        my $ftp = '/etc/vsftpd/vsftpd_user_conf/';
			        my $ftp2 = '/etc/vsftpd/vsftpd_user_conf/script_template';

			        #chown vsftpd:nobody
			        #chmod 755($base.$domain.

			        #print "your new ftp directory is \n $base$domain\n";
			        print "FTP config directory is \n $ftp$domain\n";

			        # Every file in /etc/vsftpd/vsftpd_user_conf enables us to use custom
			        # ftp home directorys, so we make one based on our domain name, then insert
			        # that into the custom vsftpd user file for our domain.
			        copy($ftp2,$ftp."/".$domain)or die "Cannot copy vsftpd file";
 			        open(FTP,">>",  '/etc/vsftpd/vsftpd_user_conf/'.$domain);
			        print FTP $command1;
			        

			### PASSWORD CODE ###
			
			#sub generatePassword
			#	{
			#	        my $length = shift;
			#	        my $possible = 'abcdefghijkmnpqrstuvwxyz23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
			#
			#	         while(length($password) < $length)
			#                 {
                        #			$password .= substr($possible, (int(rand(length($possible)))), 1);
			#	
			#                 }
			#	        return $password
			#	}
			 #Config Variables;
     			

			 # Data Source Name
			 my $dbh = DBI->connect("dbi:mysql:$database",$user,$pass) or die "Connection Error:$DBI::errstr\n";
			    
			 print "Enter your domainname:- \n";
			 my $stduser=<STDIN>;
		
			 $stduser =~ s/\s+$//;
			    
			 print "Enter your password:- \n";
			 $stdpass=generatePassword(10);
			
			 #setup the query
			 my $query = "INSERT INTO accounts(username,pass) values (trim('$stduser'),md5('$stdpass'))";
			 #$query = "INSERT INTO accounts(username,pass) values ('$stduser',('$stdpass'))";
			    
			 my $sth = $dbh->prepare($query);
			 $sth->execute() or die "SQL Error: $DBI::errstr\n";
			    
			 print "Your username is :- $stduser\n";
			 print "Your password is :- $stdpass\n";



				


		}#end of case 2
		
		
		## Create database for website
		case'3'
		{
		## start database code

		}
	

			
		### Start Email Code
		case'4'
		{
			

			##use DBI;

			my $stdpass = generatePassword(10);
			my $password;

			#sub generatePassword
			#{
			#        my $length = shift;
			#        my $possible = 'abcdefghijkmnpqrstuvwxyz23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
			#
			#         while(length($password) < $length)
	                #		 {
			#                 	$password .= substr($possible, (int(rand(length($possible)))), 1);
			#
	                #		 }
			#        return $password
			#}
	
			#Config Variables;
	
			my $database = "mail";
			my $user = "mailcreateacct";
			my $pass = "PtpKjiGyiYCsvrGl6xBD";
	
			# Data Source Name
			my $dbh = DBI->connect("dbi:mysql:$database",$user,$pass) or die "Connection Error:$DBI::errstr\n";
	
			print "Enter the email :- \n";
			my $stduser=<STDIN>;
			$stduser =~ s/\s+$//;
	
			print "Enter your password:- \n";
			$stdpass=generatePassword(10);
	
			#setup the query
			my $query = "INSERT INTO users(email,password) values (trim('$stduser'),ENCRYPT('$stdpass'))";
	
			#query = "INSERT INTO users(email,password) values (trim('$stduser'),md5('$stdpass'))";
	
			my $sth = $dbh->prepare($query);
			$sth->execute() or die "SQL Error: $DBI::errstr\n";
	
			print "Your Email is :- $stduser\n";
			print "Your password is :- $stdpass\n";
	
			#system ('mailx $stduser /r; echo "welcome your new email /r"; echo "This is your new email /r" & CTRL+D');
			system('echo "Body of your email" | mailx -s Your new email account $stduser ', 'EXIT');
			#############
			
		}# end of case 4
		

		#Reset Email password	
		case'5'
	
		{
		############################################

			use DBI;

			#$stdpass = generatePassword(10);

			my $password1;
			my $password2;
			my $database = "mail";
			my $db_user = "mailcreateacct";
			my $db_pass = "PtpKjiGyiYCsvrGl6xBD";
			my $email;
			my $passchoice;
			my $dbh;
			my $query;
			my $sth;

			# Data Source Name
			$dbh = DBI->connect("dbi:mysql:$database",$db_user,$db_pass) or die "Connection Error:$DBI::errstr\n";

			print "Enter the email for the password you want to change:- \n:";
			
			$email=<STDIN>;	
			chomp $email;

			print "Which password type would you like: \n
			(1) Enter password manually
			(2) Random Generated(10) pass\n :";

			$passchoice=<STDIN>;
			chomp $passchoice;

			if($passchoice == 1)

			        {
			                print "Enter the password you would like to use(MAX 20 Chars):-\n:";
			                $password1=<STDIN>;
			                chomp $password1;

			                $query = "UPDATE users SET password=ENCRYPT('$password1') WHERE email='$email' ";

			                $sth = $dbh->prepare($query);
					$sth->execute() or die "SQL Error: $DBI::errstr\n";

			                print "Your Email is :- $email\n";
			                print "Your password is :- $password1\n";
			                exit();

			        }

			elsif($passchoice == 2)

			        {

			                $password2=generatePassword(10);
				
					#$dbh = DBI->connect("dbi:mysql:$database",$db_user,$db_pass) or die "Connection Error:$DBI::errstr\n";	
			                $query = "UPDATE users SET password=(ENCRYPT('$password2')) WHERE email='$email'";

			                $sth = $dbh->prepare($query);
			                $sth->execute() or die "SQL Error: $DBI::errstr\n";

			                print "Your Email is :- $email\n";
			                print "Your password is :- $password2\n";

			                exit();

			        }
			els
			        {
			                print "Neither 1 or 2 was select, please go back";
			                exit();

			        }

			#$stdpass=generatePassword(10);

			#setup the query
			#$query = "INSERT INTO users(email,password) values (trim('$stduser'),ENCRYPT('$stdpass'))";
			#$query = "UPDATE users SET password=(ENCRYPT('')) WHERE email='$';

			#$sth = $dbh->prepare($query);
			#$sth->execute() or die "SQL Error: $DBI::errstr\n";

			#print "Your Email is :- $stduser\n";
			#print "Your password is :- $stdpass\n";

	
		##########################################
		}##end of case 5
		
		case'6'
		
	#}# end of switch


	}#end of switch

}# end of while

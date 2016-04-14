#!/usr/bin/perl -w
#reference:- http://perl.about.com/od/perltutorials/a/perlmysql.htm

use DBI;

#$stdpass = generatePassword(10);

$password1 = NULL;
$password2 = NULL;
$database = "mail";
$db_user = "mailcreateacct";
$db_pass = "PtpKjiGyiYCsvrGl6xBD";
$email = NULL;


#sub generatePassword
#{
#        $length = shift;
#        $possible = 'abcdefghijkmnpqrstuvwxyz23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
#
#         while(length($password) < $length)
#                 {
#                        $password .= substr($possible, (int(rand(length($possible)))), 1);
#
#                 }
#        return $password
#}

# Data Source Name
#$dbh = DBI->connect("dbi:mysql:$database",$db_user,$db_pass) or die "Connection Error:$DBI::errstr\n";

print "Enter the email for the password you want to change:- \n:";
#$stduser=<STDIN>;
our $email=<STDIN>;

#$stduser =~ s/\s+$//;
#email=~ s/\s+$//;

print "Which password type would you like: \n
(1) Enter password manually
(2) Random Generated(10) pass\n :";

$passchoice=<STDIN>;

if($passchoice == 1)

	{
		print "Enter the password you would like to use:-\n:";
		$password1=<STDIN>;
		chomp $password1;
		
	       # $query = "UPDATE users SET password=(ENCRYPT(TRIM('$password1'))) WHERE email='$email' ";
		
		$dbh = DBI->connect("dbi:mysql:$database",$db_user,$db_pass) or die "Connection Error:$DBI::errstr\n";

	        $query = "UPDATE users SET password='$password1' WHERE email='$email' ";

                $sth = $dbh->prepare($query);
                $sth->execute() or die "SQL Error: $DBI::errstr\n";

                print "Your Email is :- $email\n";
                print "Your password is :- $password1\n";
		exit();

	}

elsif($passchoice == 2)
	
	{

		sub generatePassword

   			{	
			     $password = NULL;
	        	     $length = shift;
		             $possible = 'abcdefghijkmnpqrstuvwxyz23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
    
	      		     while(length($password) < $length)
	                	       {
		                              $password .= substr($possible, (int(rand(length($possible)))), 1);
		   	               }
	        	     return $password     	 

			}
		
		$password2=generatePassword(10);

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


#!/usr/bin/perl -w
#reference:- http://perl.about.com/od/perltutorials/a/perlmysql.htm

use DBI;

$stdpass = generatePassword(10);

sub generatePassword
{
        $length = shift;
        $possible = 'abcdefghijkmnpqrstuvwxyz23456789ABCDEFGHJKLMNPQRSTUVWXYZ';

         while(length($password) < $length)
                 {
                        $password .= substr($possible, (int(rand(length($possible)))), 1);

                 }
        return $password
}

#Config Variables;

$database = "mail";
$user = "mailcreateacct";
$pass = "PtpKjiGyiYCsvrGl6xBD";

# Data Source Name
$dbh = DBI->connect("dbi:mysql:$database",$user,$pass) or die "Connection Error:$DBI::errstr\n";

print "Enter the email :- \n";
$stduser=<STDIN>;
$stduser =~ s/\s+$//;

print "Enter your password:- \n";
$stdpass=generatePassword(10);

#setup the query
$query = "INSERT INTO users(email,password) values (trim('$stduser'),ENCRYPT('$stdpass'))";

#query = "INSERT INTO users(email,password) values (trim('$stduser'),md5('$stdpass'))";

$sth = $dbh->prepare($query);
$sth->execute() or die "SQL Error: $DBI::errstr\n";

print "Your Email is :- $stduser\n";
print "Your password is :- $stdpass\n";


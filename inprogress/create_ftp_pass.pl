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

$database = "vsftpd";
$user = "vsftpd";
$pass = "vsftpdpassword";

# Data Source Name
$dbh = DBI->connect("dbi:mysql:$database",$user,$pass) or die "Connection Error:$DBI::errstr\n";

print "Enter your domainname:- \n";
$stduser=<STDIN>;
$stduser =~ s/\s+$//;

print "Enter your password:- \n";
$stdpass=generatePassword(10);

#setup the query
$query = "INSERT INTO accounts(username,pass) values (trim('$stduser'),md5('$stdpass'))";
#$query = "INSERT INTO accounts(username,pass) values ('$stduser',('$stdpass'))";

$sth = $dbh->prepare($query);
$sth->execute() or die "SQL Error: $DBI::errstr\n";

print "Your username is :- $stduser\n";
print "Your password is :- $stdpass\n";


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

$stdpass=generatePassword(10);

print "Your password is $stdpass";




#!/usr/bin/perl -w
#print generatePassword(10) . "\n";
#exit;
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

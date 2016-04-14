#!/usr/bin/perl
use strict;
use warnings;
use Digest::MD5 qw(md5 md5_hex md5_base64);
my $psw = "";
my $psw2 = "";

sub enter_pass 
{
	print "Enter Password: ";
	system "stty -echo";
	$psw = <STDIN>;
	system "stty echo";
	print "\nEnter Password again: ";
	system "stty -echo";
	$psw2 = <STDIN>;
	system "stty echo";
	chomp $psw;
	chomp $psw2;
}

enter_pass();
review_pass();
sub review_pass 
{
	if ($psw eq $psw2) 
	{
        	my $salt = "4d";
	        my $encryptedPsw = md5_hex($psw);
	        print "\n$encryptedPsw\n";
	}
	else 
	{
		print "\nPasswords did not match\n";
		enter_pass();
	}
}

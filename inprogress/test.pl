#!/usr/bin/perl -w
use File::Copy;
use File::Path;

$base ='/home/cubell/test/test/';
$base2 = 'testing';

mkpath "$base";
mkdir "$base"."$base2",0777;
#chmod 0777, "$base.$base2";
#chown vsftp

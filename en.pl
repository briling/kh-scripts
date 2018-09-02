#!/usr/bin/perl

use strict;
use warnings;

my $Eh = 627.51;
my $transition_state_pattern = "[0-9]*[xyz][0-9]*";

sub find_energy($){
  my $file = shift;
  my $ret  = 0.0;
  open(FILE, $file) or die "Can't find file";
  while(<FILE>) {
    if(/^ Energy =/){
      my @tmp = split;
      $ret = $tmp[2];
      last;
    }
  }
  close FILE;
  return $ret;
}

sub find_hessian($){
  my $file = shift;
  my $ret  = 0;
  open(FILE, $file) or die "Can't find file";
  while(<FILE>) {
    if(/H=/){
      $ret = 1;
      last;
    }
  }
  close FILE;
  return $ret;
}

my $e0 = 0.0;
my $arg_num = $#ARGV+1;
my $mask = "";
my $suf  = "";

while (my $arg = shift @ARGV) {

  $arg_num--;

  $e0 += find_energy($arg);

  my $s = $arg;        # TODO also replace \[ -> \\\[
  if ( index($s, "_") != -1 ) {
    $s =~ s|[^_]+$||;  # remove all after the last '_'
    chop $s;           # remove the last '_'
  }
  else{
    $s =~ s/\..+//;
  }

  $mask = $mask . $s;
  if(not $arg_num){
    my $t = $arg;
    $t    =~ s/\..+//;
    $suf  = $arg;
    $suf  =~ s/$t//;
    $suf  =~ s/in/*in/;
    $mask = $mask . '*' . $suf;
  }
  else{
    $mask = $mask . "[\~\_]";
  }

}
#print "$e0\n";
#print "$mask\n";

my @files = glob("$mask");
my $max_length = 0;
foreach my $file (@files) {
  my $fname_length = length($file);
  if($fname_length > $max_length){
    $max_length = $fname_length;
  }
}
my $format = "%-" . "$max_length" . "s  %s%20.10lf%s\n";

my $output = "";

foreach my $file (@files) {
  my $p1 = "";
  my $p2 = "";

  if ($file =~ m/$transition_state_pattern/) {
    if(not find_hessian($file)){
      $p1 = $p1 . "\e[1;35m";
      $p2 = $p2 . "\e[0m";
      }
    else{
      my $rxfile = $file;
      $rxfile =~ s/in/rx/;
      if(not -e $rxfile){
        $p1 = $p1 . "\e[1;34m";
        $p2 = $p2 . "\e[0m";
      }
    }
  }
#### new
  else{
    if(not find_hessian($file)){
      $p1 = $p1 . "\e[1;39m";
      $p2 = $p2 . "\e[0m";
    }
  }
####

  my $running_process = "pgrep --count --full -u \$USER \'p $file\'";  # "p \$(echo "\$i" | sed -e 's/+/\\+/g') ""); TODO
  if(`$running_process` != 0){
    $p1 = $p1 . "\e[41m";
    $p2 = $p2 . "\e[0m";
  }

  my $nmrfile = $file;
  $nmrfile =~ s/in/nmr/;
  if(-e $nmrfile){
    $p1 = $p1 . "\e[1;32m";
    $p2 = $p2 . "\e[0m";
  }

  my $e = (find_energy($file) - $e0) * $Eh;
  $output = $output . sprintf ( $format, $file, $p1, $e, $p2);
}

print $output;


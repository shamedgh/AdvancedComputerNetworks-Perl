#!/usr/bin/perl

%asHash = ();
$asCounter = 0;

%prefixHash = ();
$prefixCounter = 0;

$check = 0;
$lineCounter = 0;
while ( $lineInput = <STDIN> )
{
	@lineSplitted = split(/ /, $lineInput );
	#print "linesplit: ".$lineSplitted[0]."\n";
	if ( $lineSplitted[0] eq "PREFIX:" )
	{
		$tempString = $lineSplitted[1];
	}
	if ( $lineSplitted[0] eq "FROM:" )
	{
		if ( $lineSplitted[1] eq "12.0.1.63" )
		{
			$check = 1;
			if ( $prefixHash{$tempString} != 1 )
			{
				$prefixHash{$tempString} = 1;
				$prefixCounter++;	
			}
		}
	}
	if ( $lineSplitted[0] eq "ASPATH:" && $check == 1)
	{
		for ( $i = 1; $i <= $#lineSplitted; $i++)
		{
			$tempString = $lineSplitted[$i];
			if ( $asHash{"$tempString"} != 1 )
			{
				$asHash{"$tempString"} = 1;
				$asCounter++;
			}
		}
		$check = 0;
	}

	
	$lineCounter++;
	if ( $lineCounter%100000 == 0 )
	{
		print "line number: ".$lineCounter."\n";
	}
	
}
print "AS Counter: ".$asCounter."\n";
print "Prefix Counter: ".$prefixCounter."\n";
open OUTPUTFILE, ">>/home/Hamed/Desktop/HW3/Question2&3/rib20091001-AS&Prefix.txt";
print OUTPUTFILE "AS Counter: ".$asCounter."\n";
print OUTPUTFILE "Prefix Counter: ".$prefixCounter."\n";
close OUTPUTFILE;
exit;
#39110


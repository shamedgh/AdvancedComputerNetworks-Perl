#!/usr/bin/perl

%asHash = ();
$asCounter = 0;
$check = 0;
$lineCounter = 0;
while ( $lineInput = <STDIN> )
{
	@lineSplitted = split(/ /, $lineInput );
	#print "linesplit: ".$lineSplitted[0]."\n";
	for ( $i = 1; $i <= $#lineSplitted; $i++)
	{
		$tempString = $lineSplitted[$i];
		if ( $asHash{"$tempString"} != 1 )
		{
			$asHash{"$tempString"} = 1;
			$asCounter++;
		}
	}

	
	$lineCounter++;
	if ( $lineCounter%10000 == 0 )
	{
		print "line number: ".$lineCounter."\n";
	}
	
}
print "AS Counter: ".$asCounter."\n";
open OUTPUTFILE, ">>hw3quest2Output.txt";
print OUTPUTFILE "AS Counter: ".$asCounter."\n";
close OUTPUTFILE;
exit;
#39110


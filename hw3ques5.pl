#!/usr/bin/perl


%asLinkHash = ();
$asLinkCounter = 0;

%asHash = ();
$asCounter = 0;
$lineCounter = 0;
while( $lineInput = <STDIN> )
{
	@lineSplitted = split(/ /, $lineInput );
	#print "linesplit: ".$lineSplitted[0]."\n";
	if ( $lineSplitted[0] eq "ASPATH:")
	{
		for ( $i = 1; $i < $#lineSplitted; $i++)
		{
			$ii = $i+1;
			$tempString = $lineSplitted[$i];
			$tempString2 = $lineSplitted[$ii];
			$hashString = $tempString.",".$tempString2;
			$hashString2 = $tempString2.",".$tempString;						
			if ( $asLinkHash{"$hashString"} != 1 && $asLinkHash{"$hashString2"} != 1 )
			{
				$asLinkHash{"$hashString"} = 1;
				$asLinkCounter++;
			}
			if ( $asHash{"$tempString"} != 1 )
			{
				$asHash{"$tempString"} = 1;
				$asCounter++;
			}
		}
		$tempString = $lineSplitted[$#lineSplitted];
		if ( $asHash{"$tempString"} != 1 )
		{
			$asHash{"$tempString"} = 1;
			$asCounter++;
		}
	}
	$lineCounter++;
	if ( $lineCounter%1000000 == 0 )
	{
		print "Line Counter: ".$lineCounter."\n";
	}
	
}
open OUTPUTFILE, ">/home/Hamed/Desktop/HW3/Question5/hw3quest5Output.txt";
print OUTPUTFILE "AS Counter: ".$asCounter."\n";
print OUTPUTFILE "AS Link Counter: ".$asLinkCounter."\n";
print "AS Counter: ".$asCounter."\n";
print "AS Link Counter: ".$asLinkCounter."\n";

close OUTPUTFILE;
exit;



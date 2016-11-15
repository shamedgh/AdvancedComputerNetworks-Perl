#!/usr/bin/perl


%asLinkHash = ();
$asLinkCounter = 0;
$lineCounter = 0;
$check = 0;
while( $lineInput = <STDIN> )
{
	@lineSplitted = split(/ /, $lineInput );
	#print "linesplit: ".$lineSplitted[0]."\n";
	if ( $lineSplitted[0] eq "FROM:" && $lineSplitted[1] eq "12.0.1.63")
	{
		$check = 1;
	}	
	if ( $lineSplitted[0] eq "ASPATH:" && $check == 1)
	{
		for ( $i = 1; $i < $#lineSplitted; $i++)
		{
			$ii = $i+1;
			$tempString = $lineSplitted[$i];
			$tempString2 = $lineSplitted[$ii];
			if ( !($tempString eq $tempString2) )
			{
				$hashString = $tempString.",".$tempString2;
				$hashString2 = $tempString2.",".$tempString;						
				if ( $asLinkHash{"$hashString"} != 1 && $asLinkHash{"$hashString2"} != 1 )
				{
					$asLinkHash{"$hashString"} = 1;
					$asLinkCounter++;
				}
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
print "AS Counter: ".$asLinkCounter."\n";
open OUTPUTFILE, ">/home/Hamed/Desktop/hw3quest4Output.txt" or die "could not open file";
print OUTPUTFILE "AS Counter: ".$asLinkCounter."\n";
close OUTPUTFILE;
exit;

#51211

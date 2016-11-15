#!/usr/bin/perl

$counter = 0;
%prefixHash = ();
$prefixCounter = 0;
$repeats = 0;
while( $lineInput = <STDIN> )
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
			if ( $prefixHash{$tempString} != 1 )
			{
				$prefixHash{$tempString} = 1;
				$prefixCounter++;	
			}
		}
	}
	
}
print "Prefix Counter: ".$prefixCounter."\n";
exit;

#[Hamed@localhost libbgpdump-1.4.99.11]$ ./bgpdump /home/Hamed/Desktop/HW3/rib.20091001.0000.bz2 | perl /home/Hamed/Desktop/HW3/Question3/hw3quest3.pl
#Prefix Counter: 291660


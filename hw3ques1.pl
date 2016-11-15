#!/usr/bin/perl

open INPUTFILE, "/home/Hamed/Desktop/split-bgp-12.txt" or die "could not open";
@lineInput = <INPUTFILE>;
$counter = 0;
%asDegreeHash = ();
$repeats = 0;
for ( $j = 0; $j <= $#lineInput; $j++ )
{
	@lineSplitted = split(/ /, $lineInput[$j] );
	#print "linesplit: ".$lineSplitted[0]."\n";
	if ( $lineSplitted[0] eq "ASPATH:" )
	{
		for ( $i = 1; $i < $#lineSplitted; $i++ )
		{
			$check = 0;
			$ii = $i+1;
			$asOne = $lineSplitted[$i];
			$asTwo = $lineSplitted[$ii];		
			if ( !($asOne eq $asTwo) ){
				$temp2 = $asDegreeHash{"$asOne"};
				@temp = @{$temp2};
				$tempCount1 = $#temp + 1;
				
				#search for repetition of node
				for ( $m = 0; $m < $tempCount1; $m++ )
				{
					if ($asTwo eq $asDegreeHash{"$asOne"}[$m] )
					{
						$check = 1;
						break;
					}	
				}
				if ( $check == 0 )
				{				
					$asDegreeHash{"$asOne"}[$tempCount1] = $asTwo;
					$asOneForPrint = $asDegreeHash{"$asOne"}[$tempCount1];

					$temp2 = $asDegreeHash{"$asTwo"};
					@temp = @{$temp2};
					$tempCount2 = $#temp + 1;
					$asDegreeHash{"$asTwo"}[$tempCount2] = $asOne;
					$asTwoForPrint = $asDegreeHash{"$asOne"}[$tempCount2];

					#print "\ntesting, Input: ASes: AS1: ".$asOne." AS2: ".$asTwo." In Hash: AS{".$asOne."}[".$tempCount1."]: ".$asOneForPrint." and AS{".$asTwo."}[".$tempCount2."]: ".$asTwoForPrint." end\n";
				}
				else
				{
					$repeats++;
					#print "\nrepetition has occured!!!\n";
				}
			}
		}
	}
	if ( $counter%1000 == 0 )
	{
		$percent = ($counter/291659)*100;
		print "line number: ".$counter." total lines: 291659, percentage completed: %".$percent."\n";
	}
	$counter++;
}
close INPUTFILE;
#$asDegreeHash{'7820'} = ['2120', '2222', '2333'];
#$asDegreeHash{'20'} = ["220", "222", "233", "34234"];
#$asDegreeHash{'820'} = ["4120", "3222", "1333"];
#$asDegreeHash{'720'} = ["2920", "6222", "5333"];

print "finished hashing\n";
$asCount = 0;	
$maxDegree = 0;
for ( $l = 0; $l < 200000; $l++ )
{
	$temp = $asDegreeHash{"$l"};
	@temp2 = @{$temp};
	#print "tttttemp: ".$#temp2;
#	print "temp: ".$#temp2."\n";
	if ( $#temp2 > 0 )
	{
		print "AS number: ".$l.", degree: ".($#temp2+1)."\n";
		
		#for part two of question one
		$degreeNum = $#temp2+1;
		if ( $asDegree[$degreeNum] <= 0 )
		{
			$asDegree[$degreeNum] = 1;
		}
		else
		{
			$asDegree[$degreeNum]++;
		}
		if ( $#temp2 > $maxDegree )
		{
			$maxDegree = $#temp2+1;
		}
		#for question two:
		$asCount++;	
	}
}
print "As count: ".$asCount."\n";
print "finished printing\n";
print "Number of AS Nodes of different degrees:\n";
for ( $n = 0; $n <= $maxDegree; $n++)
{
	if ( $asDegree[$n] > 0 )
	{
		print "Degree[".$n."]: ".$asDegree[$n]."\n";
	}
}
open PLOTFILE, ">/home/Hamed/Desktop/question1AnswerPlotFile.txt" or die "could not open";
$cdfDegree = 0;
print "CDF of AS Nodes of different degrees:\n";
for ( $n = 0; $n <= $maxDegree; $n++)
{
	$cdfDegree = $cdfDegree + $asDegree[$n];
	print "Degree[".$n."]: ".$cdfDegree."\n";	
	print PLOTFILE $n." ".$cdfDegree."\n";	
}
close PLOTFILE;
exit;



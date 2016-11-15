#!/usr/bin/perl


open INPUTFILE, "/home/Hamed/Desktop/HW3/Question1/question1AnswerPlotFile.txt";
@lineInput = <INPUTFILE>;
open OUTPUTFILE, ">>/home/Hamed/Desktop/HW3/Question1/plotWithLograthm.txt";
$logarithmicVal = 0;
for ( $i = 0; $i <= $#lineInput; $i++ )
{
	@lineSplitted = split(/ /, $lineInput[$i] );
	
	if ( $lineSplitted[1] != 0 )
	{
		$logarithmicVal = log($lineSplitted[1])/log(2);
	}
	print OUTPUTFILE $lineSplitted[0]."  ".$logarithmicVal."  ".$lineSplitted[1]."\n";
	print "lograthm: ".$logarithmicVal."\n";
	
}
print "logarithme 8: ".log(8);
close OUTPUTFILE;
exit;
#39110


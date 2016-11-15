#!/usr/bin/perl

#TCPDUMP: tcpdump -n -tt -v -r packetCapture1 | grep -v ARP
#ARP Packets have to be removed, or else the program won't work!!!! Because the two line reading won't be able to work correctly!!! 

$numOfPackets = 0;

$fileName = "/usr/sbin/tcpdump -ttnvSr /media/dumps/loc/before_trace.0.tcpdump | grep -v ARP |";
open (DATA, $fileName);
$doLoop = 0;
$firstTime = 0;
$epochLength = 60;
					
do
{
	print $timeBase."\n";
	while ($inputLine = <DATA> ) 
	{
		if ( $numOfPackets % 50000 == 0 )
		{
			print "Number of packets read: ".$numOfPackets."\n";
		}

		$numOfPackets++;
		$checkLength = 0;
		$packetLength = 1000;
		@splittedLine = split(' ', $inputLine);
		#print "input line: ".$inputLine."\n";
		#print "input line2: ".$inputLine2."\n";
		#Retrieve first four values	
		$timeStamp = $splittedLine[0];
		if ( $firstTime == 0 )
		{
			$startTime = $timeStamp;
			$firstTime = 1;
		}
		#if ( $timeStamp - $startTime > 600 )
		#{
		#	print "Reached 10 minutes! Exitting...\n";
		#	last;
		#}
		$protocol = $splittedLine[1];
		$dontContinue = 0;
		if ( $protocol eq "DTPv1,")
		{
			$dontContinue = 1;
			$inputLine2 = <DATA>;
			$temp1 = <DATA>;
			$temp2 = <DATA>;
			$temp3 = <DATA>;
		}
		if ( $protocol eq "Label-Space-ID:" )
		{
			$dontContinue = 1;
			$inputLine2 = <DATA>;			
		}
		if ( $protocol eq "STP" )
		{
			$dontContinue = 1;
			$inputLine2 = <DATA>;
			$temp = <DATA>;
		}
		if ( $protocol eq "VTPv2," || $protocol eq "CDPv2,")
		{
			$dontContinue = 1;
			$inputLine2 = <DATA>;
			$temp = <DATA>;
		}
		if ( $protocol eq "VTPv1," )
		{
			$dontContinue = 1;
			$inputLine2 = <DATA>;		
		}
		if ( $protocol eq "IP6" || $protocol eq "IPX" || $protocol eq "[|ip]" || $protocol eq "NBF" )
		{
			$dontContinue = 1;
		}
		if ( $inputLine =~ /^$/ )
		{
			$dontContinue = 1;
			#print "The input line is empty!\n";
		}
		if ( $dontContinue == 0 )
		{
			$inputLine2 = <DATA>;
			@splittedLine2 = split(' ', $inputLine2);
			$sourceIp = $splittedLine2[0];
			$destIp = $splittedLine2[2];
			
			$sourcePort = getPort($sourceIp);
			$destPort = getPort($destIp);
			$sourceIp = getIpWithoutPort($sourceIp);
			$destIp = getIpWithoutPort($destIp);
			if ( (checkPort($sourcePort) == 1 && checkPort($destPort) == 0) || (checkPort($sourcePort) == 0 && checkPort($destPort) == 1) )
			{
				#print "Source Port: ".$sourcePort." Dest port: ".$destPort."\n";
				if ( checkPort($sourcePort) == 1 && checkPort($destPort) == 0)
				{
					$server2client = 1;
					$client2server = 0;
					$portNo = $sourcePort;
				}
				if ( checkPort($sourcePort) == 0 && checkPort($destPort) == 1 )
				{
					$server2client = 0;
					$client2server = 1;
					$portNo = $destPort;
				}
				#print "Port no: ".$portNo."\n";
				$fourTupleS2D = $sourceIp.":".$sourcePort." -> ".$destIp.":".$destPort;
				$twoTupleS2D = $sourceIp."->".$destIp;
				$fourTupleD2S = $destIp.":".$destPort." -> ".$sourceIp.":".$sourcePort;
				$twoTupleD2S = $destIp."->".$sourceIp;

				$searchAck = 0;
				$checkAck = "ack";
				$searchAck = grep /^$checkAck/, @splittedLine2;
				($a, $b, $c, $protoIndex) = findIndexes($inputLine);
				($seqIndex, $ackIndex, $flagIndex, $d) = findIndexes($inputLine2);
				$flag = $splittedLine2[$flagIndex];
				$checkLength = 0;
				for ( $i = 2; $i < $#splittedLine; $i++ )
				{
					if ( $splittedLine[$i] eq "length" )
					{
						$checkLength = 1;
						$lengthIndex = $i+1;			
						$packetLength = $splittedLine[$lengthIndex];		
					}		
				}
				#Remove paranthesis or comma from the end of the packet length if necessary!!!!
				$indexOfSecondParanthesis = index($packetLength, ')');
				if ( $indexOfSecondParanthesis != -1 )
				{
					$packetLength = substr( $packetLength, 0, $indexOfSecondParanthesis );
				}
				$indexOfComma = index($packetLength, ',');
				if ( $indexOfComma != -1 )
				{
					$packetLength = substr( $packetLength, 0, $indexOfComma );
				}
				#If we don't have a length item in the IP header, set the packet length to 2000 so it doesn't enter the calculations at all!!!
				if ( $checkLength == 0 )
				{
					$packetLength = 0;
				}
				if ( $splittedLine[$protoIndex] eq "TCP" )
				{
					if ( $client2server == 1 )
					{
						$signedPacketLength = $packetLength;
					}
					if ( $server2client == 1 )
					{
						$signedPacketLength = (-1)*$packetLength;
					}
#					if ($flag eq "[S.]," || $flag eq "[S.EW]," || $flag eq "[S.E]," || $flag eq "[S.W],")
#					{
#						$portTuples{$portNo}[$portCount{$portNo}][3] = 1;
#					}
					$portTuples{$portNo}[$portCount{$portNo}][1] = $timeStamp;
					$portTuples{$portNo}[$portCount{$portNo}][2] = $signedPacketLength;
					$packetTuple = "<".$signedPacketLength.",".$timeStamp.">";
					$portTuples{$portNo}[$portCount{$portNo}++][0] = $packetTuple;

				}	#Check TCP
			}	#Check port number
		}	#End of if dont continue
	}	#End of while
close (DATA);
$doLoop++;
$fileName = "/usr/sbin/tcpdump -ttnvSr /media/dumps/loc/before_trace.".$doLoop.".tcpdump | grep -v ARP |";
open (DATA, $fileName);
print "Entering another file, file name is: ".$fileName."\n";

}while ($doLoop < 5);	#End of do while

foreach $port (keys %portTuples)
{
	$firstTime = 0;
	$fileName = ">portTuples-".$port."";
	#open (OUTPUT, $fileName);
	for ( $i = 0; $i < $portCount{$port}; $i++ )
	{
		if ( $firstTime == 0 )
		{
			$firstTime = $portTuples{$port}[$i][1];
		}
		#print OUTPUT $portTuples{$port}[$i][0].",";
		if ( $i%6 == 5 )
		{
			print OUTPUT "\n";
		}
		$timeStamp = $portTuples{$port}[$i][1];
		$signedPacketLength = $portTuples{$port}[$i][2];
		if ( $timeStamp - $firstTime > $epochLength )
		{
			$epochCount{$port}++;
			$firstTime = $timeStamp;
		}
		#else
		#{
			if ( $signedPacketLength < 0 && $signedPacketLength > -64 )	#Smaller than 64 - Server to Client
			{
				$n{$port}[$epochCount{$port}][0]++;
			}
			elsif ( $signedPacketLength < 0 && $signedPacketLength < -64 )	#Bigger than 64 - Server to Client
			{
				$n{$port}[$epochCount{$port}][1]++;
			}
			if ( $signedPacketLength > 0 && $signedPacketLength < 64 )	#Smaller than 64 - Client to Server
			{
				$n{$port}[$epochCount{$port}][2]++;
			}
			if ( $signedPacketLength > 0 && $signedPacketLength > 64 )	#Bigger than 64 - Client to Server
			{
				$n{$port}[$epochCount{$port}][3]++;
			}
		#	if ( $portTuples{$port}[$i][3] != 0 )
		#	{
		#		$n{$port}[$epochCount{$port}][4]++;
		#	}
		#}
	}
	#close (OUTPUT);
}
$fileName = ">mydata-epoch".$epochLength.".arff";
open (ARFF, $fileName);
print ARFF "@"."RELATION protocol\n";

print ARFF "@"."ATTRIBUTE smallerthans2c NUMERIC\n";
print ARFF "@"."ATTRIBUTE biggerthans2c NUMERIC\n";
print ARFF "@"."ATTRIBUTE smallerthanc2s NUMERIC\n";
print ARFF "@"."ATTRIBUTE biggerthanc2s NUMERIC\n";

print ARFF "@"."ATTRIBUTE class {http,https,smtp,ssh}\n";
print ARFF "@"."DATA\n";

foreach $port (keys %n)
{
	#$fileName = ">allPortEpochs-".$port."";
	#open (OUTPUT, $fileName);
	#print OUTPUT "Epoch:  <64/S2C  >64/S2C  <64/C2S  >64/C2S\n";

	if ( $port == 80 )
	{
		$portString = "http";
	}
	if ( $port == 443 )
	{
		$portString = "https";
	}
	if ( $port == 25 )
	{
		$portString = "smtp";
	}
	if ( $port == 22 )
	{
		$portString = "ssh";
	}
	for ( $i = 0; $i < $epochCount{$port}; $i++ )
	{
		if ( $n{$port}[$i][0] == 0 )
		{
			$n{$port}[$i][0] = 0;
		}
		if ( $n{$port}[$i][1] == 0 )
		{
			$n{$port}[$i][1] = 0;
		}
		if ( $n{$port}[$i][2] == 0 )
		{
			$n{$port}[$i][2] = 0;
		}
		if ( $n{$port}[$i][3] == 0 )
		{
			$n{$port}[$i][3] = 0;
		}
#		if ( $n{$port}[$i][4] == 0 )
#		{
#			$n{$port}[$i][4] = 0;
#		}
		print ARFF $n{$port}[$i][0].",".$n{$port}[$i][1].",".$n{$port}[$i][2].",".$n{$port}[$i][3].",".$portString."\n";
		#print OUTPUT "Epoch: ".$i.": <".$n{$port}[$i][0].",".$n{$port}[$i][1].",".$n{$port}[$i][2].",".$n{$port}[$i][3].",".$n{$port}[$i][4].">\n";
	}
	#close (OUTPUT);
}
close (ARFF);
sub getIpWithoutPort
{
	$ipWithPort = $_[0]; #Ip with port, gotten from argument sent to function

	$ipLastDotIndex = rindex($ipWithPort, '.');
	return substr($ipWithPort, 0, $ipLastDotIndex);
}

sub getPort
{
	$ipWithPort = $_[0]; #Ip with port, gotten from argument sent to function
	$length = length($ipWithPort);
	$ipLastDotIndex = rindex($ipWithPort, '.');
	$dif = $length - $ipLastDotIndex;
	$portWith = substr($ipWithPort, $ipLastDotIndex+1, $dif);
	@splittedPort = split(':', $portWith);
	return $splittedPort[0];
}

sub findIndexes
{
	@tempSplit = split(" ", $_[0]);
	$seqIndex = -1;
	$ackIndex = -1;
	for ( $m = 0; $m < 14; $m++ )
	{
		if ( $tempSplit[$m] eq "seq" )
		{
			$seqIndex = $m;
		}
		if ( $tempSplit[$m] eq "ack" )
		{
			$ackIndex = $m;
		}
		if ( $tempSplit[$m] eq "Flags" )
		{
			$flagIndex = $m+1;
		}
		if ( $tempSplit[$m] eq "proto" )
		{
			$protoIndex = $m+1;
		}
	}

	return ($seqIndex, $ackIndex, $flagIndex, $protoIndex);	
}


sub checkPort
{
	$portNo = $_[0];
	if ( $portNo eq "80" || $portNo eq "443" || $portNo eq "20" || $portNo eq "22" || $portNo eq "23" || $portNo eq "25" )
	{
		return 1;
	}
	#print "Not one of the six ports\n";
	return 0;
}



exit;







#!/usr/bin/perl
use strict;
use warnings;

use feature qw(say);

use Data::Dumper;

# Translate a key with the given dictionary (i.e. return to destination from a given source)
# BUG: something's borked
sub translate {
    my ($key, $dictionary, $rev) = @_;
    $rev ||= 0; # Default value for 'reverse' is False
    foreach my $entry (@$dictionary) {
        my $destination = $entry->{destinationRangeStart};
        my $source = $entry->{sourceRangeStart};
        my $range = $entry->{rangeLength};
        my $offset = $rev?$key-$source:$key-$destination;
        if(($key >= ($rev? $source : $destination)) && ($key <= ($rev? $source : $destination) + $range)) {
            return ($rev? $destination : $source) + $offset;
        }
    }
    return $key;
}

# Unbork the above function
sub revTranslate {
    my ($key, $dictionary) = @_;
    foreach my $entry (@$dictionary) {
        my $destination = $entry->{destinationRangeStart};
        my $source = $entry->{sourceRangeStart};
        my $range = $entry->{rangeLength};
        my $offset = $key-$destination;
        if(($key >= $destination) && ($key <= $destination + $range)) {
            return  $source + $offset;
        }
    }
    return $key;
}

my $file = './input.txt';
open my $lines, $file or die "Could not open $file: $!";

my %almanacHeadings = ( 
    'seed-to-soil' => [],
    'soil-to-fertilizer' => [],
    'fertilizer-to-water' => [],
    'water-to-light' => [],
    'light-to-temperature' => [],
    'temperature-to-humidity' => [],
    'humidity-to-location' => []
);
my @seeds;
my @seedRanges;
my $currentMapping = '';

# Process the file
while( my $line = <$lines> ) {
    # Obtain Seed Numbers
    if ($. == 1) {
        my @inputString = split(': ', $line);
        foreach (split(' ', $inputString[1])) {
            if (scalar(@seeds) == scalar(@seedRanges)) {
                push(@seeds, $_);
            }
            else {
                push(@seedRanges, $_);
            }
        }
        #say($seeds[0]%{'id'});
        next;
    }

    # Clear current mapping (moving to next almanac heading)
    if ($line =~ s/^\s*$//) {
        $currentMapping = '';
        next;
    }

    # Update mapping (new almanac heading found)
    if ($currentMapping eq '' and index($line, ' map') != -1) {
        $currentMapping = substr($line, 0, length($line) - 7); # drop the ' map:'
        next;
    }

    # If none of the above checks fire, can start populating the almanac translation tables
    my @almanacEntry = split(' ', $line);
    my %almanacHash = ( 
        destinationRangeStart => $almanacEntry[0],
        sourceRangeStart => $almanacEntry[1],
        rangeLength => $almanacEntry[2]
    );
    push( @{$almanacHeadings{$currentMapping}}, \%almanacHash);
}

# ugh -- got tired and just let the computer figure it out... there's so many better ways to do this.
my $locationIndex = 0;
while (1) {
    my $humidity = revTranslate($locationIndex, $almanacHeadings{'humidity-to-location'});
    my $temperature = revTranslate($humidity, $almanacHeadings{'temperature-to-humidity'});
    my $light = revTranslate($temperature, $almanacHeadings{'light-to-temperature'});
    my $water = revTranslate($light, $almanacHeadings{'water-to-light'});
    my $fertilizer = revTranslate($water, $almanacHeadings{'fertilizer-to-water'});
    my $soil = revTranslate($fertilizer, $almanacHeadings{'soil-to-fertilizer'});
    my $seed = revTranslate($soil, $almanacHeadings{'seed-to-soil'});

    #say($seed);

    my $seedIndex = 0;
    for my $baseSeed (@seeds) {
        if($baseSeed <= $seed && $baseSeed + $seedRanges[$seedIndex] >= $seed) {
            say("baseSeed: $baseSeed");
            say("index: $seedRanges[$seedIndex]");
            say("Lowest location: $locationIndex");
            exit 0;
        }
        $seedIndex++;
    }
    $locationIndex++;
}

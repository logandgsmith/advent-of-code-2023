#!/usr/bin/perl
use strict;
use warnings;

use feature qw(say);

use Data::Dumper;

# Translate a key with the given dictionary (i.e. return to destination from a given source)
sub translate {
    my ($key, $dictionary) = @_;
    foreach my $entry (@$dictionary) {
        my $destination = $entry->{destinationRangeStart};
        my $source = $entry->{sourceRangeStart};
        my $range = $entry->{rangeLength};
        my $offset = $key - $source;
        if($key >= $source && $key <= $source + $range) {
            return $destination + $offset;
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
my $currentMapping = '';

# Process the file
while( my $line = <$lines> ) {
    # Obtain Seed Numbers
    if ($. == 1) {
        my $start;
        my @inputString = split(': ', $line);
        foreach (split(' ', $inputString[1])) {
            # push(@seeds, { id => $_ });
            push(@seeds, $_);
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

#say(Dumper(%almanacHeadings{'soil-to-fertilizer'}));

# Translate Seeds to Locations
# my $test = translate('1514493331', $almanacHeadings{'seed-to-soil'});
# say($test);
my @locations;
for my $seed (@seeds) {
    my $soil = translate($seed, $almanacHeadings{'seed-to-soil'});
    my $fertilizer = translate($soil, $almanacHeadings{'soil-to-fertilizer'});
    my $water = translate($fertilizer, $almanacHeadings{'fertilizer-to-water'});
    my $light = translate($water, $almanacHeadings{'water-to-light'});
    my $temperature = translate($light, $almanacHeadings{'light-to-temperature'});
    my $humidity = translate($temperature, $almanacHeadings{'temperature-to-humidity'});
    push(@locations, translate($humidity, $almanacHeadings{'humidity-to-location'}));
}

my $lowestLocation;
for my $location (@locations) {
    $lowestLocation = $location if !defined $lowestLocation or $location < $lowestLocation;
}

say("Lowest location is $lowestLocation");

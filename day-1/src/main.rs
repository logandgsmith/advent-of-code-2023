// Advent of Code -- day 1
// Today was a warm up with an old favorite: Rust!
// This really made me want to pick it up again.

use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

pub fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {                     // AsRef dereferences filename to a Path object
    let file = File::open(filename)?;       // The `?` operator checks if result is Ok
    Ok(io::BufReader::new(file).lines())    // No `;` as the last line of a function will return this value
}

pub fn part_one() {
    println!("PART 1!");
    let lines = read_lines("./input.txt").expect("Failed to read file!");

    let mut total = 0; 

    for line in lines {
        if let Ok(entry) = line {
            let mut calibration_number = entry
                .chars()
                .find(|x| x.is_digit(10))
                .expect("failed to find digit").to_string();
            calibration_number.push(
                entry
                    .chars()
                    .rev()
                    .find(|x| x.is_digit(10))
                    .expect("failed to find digit")
                );

            total += calibration_number.parse::<i32>().expect("Failed to parse calibration number.");
        }
    }

    println!("Final calibration number: {}", total);
    println!();
}

pub fn part_two() {
    println!("PART TWO!");

    let values = vec!(
        ("zero", "0"),
        ("one", "1"),
        ("two", "2"),
        ("three", "3"),
        ("four", "4"),
        ("five", "5"),
        ("six", "6"),
        ("seven", "7"),
        ("eight", "8"),
        ("nine", "9"),
        ("0", "0"),
        ("1", "1"),
        ("2", "2"),
        ("3", "3"),
        ("4", "4"),
        ("5", "5"),
        ("6", "6"),
        ("7", "7"),
        ("8", "8"),
        ("9", "9")
    );

    let mut total = 0;
    
    let lines = read_lines("./input.txt").expect("Failed to parse the input");
    for line in lines {
        if let Ok(entry) = line {
            let mut lowest_match = (1000, "0"); 
            let mut highest_match = (0, "0"); 

            let values_slice = &values[..];
            for value in values_slice {
                let matches = entry.match_indices(value.0);
                for pair in matches {
                    if pair.0 <= lowest_match.0 { lowest_match = (pair.0, value.1) }
                    if pair.0 >= highest_match.0 { highest_match = (pair.0, value.1) }
                }
            }

            let calibration_number = lowest_match.1.to_owned() + highest_match.1;
            total += calibration_number.parse::<i32>().expect("failed to parse the calibration number.");
        }
    }

    println!("Final calibration number: {}", total);

}

fn main() {
    part_one();
    part_two();
}

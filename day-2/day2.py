#!/usr/bin/env python3

import argparse

from pathlib import Path

def parse_games(max_cubes:dict, game_path:Path) -> list[dict]:
    valid_id_total = 0
    set_power_total = 0
    with open(game_path, 'r') as game_lines:
        for line in game_lines:
            id = int(line[5 : line.index(':')])
            rounds_str = line[line.index(':')+1:]
            rounds = rounds_str.split(';')
            is_valid = True
            print(f'Game: {id}')
            least_cubes = {
                'red': 0,
                'green': 0,
                'blue': 0
            }
            for round in rounds:
                color_counts = dict(reversed(count_string.strip().split(' ', 1)) for count_string in round.split(','))
                for (key, value) in max_cubes.items():
                    color_count = int(color_counts.get(key, '0'))
                    if color_count > least_cubes[key]:
                        least_cubes[key] = color_count
                    if color_count > value:
                        print(f'  {key}: {color_count}')
                        is_valid = False
            if is_valid:
                valid_id_total += id
                print(f'    total: {valid_id_total}')
            set_power_total += least_cubes['red'] * least_cubes['green'] * least_cubes['blue']
    print(f'Valid Game Total: {valid_id_total}')
    print(f'Total Set Power: {set_power_total}')


def main():
    MAXIMUM_CUBES = {
        'red': 12,
        'green': 13,
        'blue': 14
    }

    parser = argparse.ArgumentParser(
        prog='day2.py -f <path to file>',
        description='Advent of Code 2023 Day 2',
        epilog='Holly jolly python coding'
    )
    parser.add_argument('--file', '-f', type=Path, help='Path to the file of game results')

    args = parser.parse_args()

    if not args.file:
        print('Need a path to the file containing game results.')
        return
    
    games = parse_games(MAXIMUM_CUBES, args.file)


if __name__ == '__main__':
    main()
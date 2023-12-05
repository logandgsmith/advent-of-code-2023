package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"math"
	"os"
	"strings"
)



func main() {
	filePath := flag.String("fpath", "./input.txt", "File path to be read from")
	flag.Parse()

	file, err := os.Open(*filePath)
	if err != nil {
		log.Fatal(err)
	}

	defer func() {
		if err = file.Close(); err != nil {
			log.Fatal(err)
		}
	}()

	totalValue := 0;

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		// Split game data
		initialSplit := strings.Split(scanner.Text(), ":")
		//cardName := initialSplit[0]
		cardsString := initialSplit[1]

		// Split hands
		cardSplit := strings.Split(cardsString, "|")
		winningNumbers := strings.Split(cardSplit[0], " ")
		chosenNumbers := strings.Fields(cardSplit[1])

		//fmt.Println(len(chosenNumbers))

		matches := 0
		for _, number := range chosenNumbers {
			for _, winningNumber := range winningNumbers {
				if number == winningNumber {
					//fmt.Println(number)
					matches++
					continue
				}
			}
		}
		//fmt.Println(matches)

		if matches > 0 {
			cardPoints := int(math.Pow(2.0, float64(matches - 1)))
			//fmt.Println(cardPoints)
			totalValue += cardPoints
		}
	}
	err = scanner.Err()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Total score:%d\n", totalValue)

}

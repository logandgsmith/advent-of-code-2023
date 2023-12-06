#include <cmath>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

std::vector<int> parseString(std::string input) {
    std::vector<int> foundValues;
    std::stringstream inputStream;
    inputStream << input;

    std::string temp;
    while(inputStream >> temp) {
        try {
            foundValues.push_back(std::stoi(temp));
        }
        catch(...) {
            std::cout << "failed to parse number" << std::endl;
        }
    }
    return foundValues;
}

// Calculates the distance travelled after waiting a certain amount of time
int calculateDistance(int timeLimit, int timeWaiting) {
    return timeLimit * timeWaiting - std::pow(timeWaiting, 2);
}

int main() {
    std::ifstream file("./input.txt");

    std::string timesString;
    std::string distancesString;

    std::getline(file, timesString);
    std::getline(file, distancesString);

    auto times = parseString(timesString);
    auto distances = parseString(distancesString);

    int winnersProduct = 0;
    int winners = 0;
    for(int i = 0; i < times.size(); i++) {
        int time = times.at(i);
        for (int j = 0; j <= time; j++) {
            if(distances[i] < calculateDistance(time, j)) {
                winners++;
            }
        }
        if(winnersProduct == 0) {
            winnersProduct = winners;
        }
        else {
            winnersProduct *= winners;
        }
        winners = 0;
    }

    std::cout << "Product of winning strategies from each race: " << winnersProduct << std::endl;

    return 0;
}
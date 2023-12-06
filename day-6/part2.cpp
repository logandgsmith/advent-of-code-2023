#include <cmath>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

long parseString(std::string input) {
    std::string compoundInput = "";
    std::stringstream inputStream;
    inputStream << input;

    std::string temp;
    while(inputStream >> temp) {
        if(temp.find(':') == std::string::npos) {
            compoundInput += temp;
        }
    }

    return std::stol(compoundInput);
}

// Calculates the distance travelled after waiting a certain amount of time
long calculateDistance(long timeLimit, long timeWaiting) {
    return timeLimit * timeWaiting - std::pow(timeWaiting, 2);
}

int main() {
    std::ifstream file("./input.txt");

    std::string timesString;
    std::string distancesString;

    std::getline(file, timesString);
    std::getline(file, distancesString);

    long time = parseString(timesString);
    long distance = parseString(distancesString);

    long winners = 0;
    for(long i=0; i <= time; i++) {
        if(distance < calculateDistance(time, i)) {
            winners++;
        }
    }

    std::cout << "Winning strategies in this race: " << winners << std::endl;

    return 0;
}
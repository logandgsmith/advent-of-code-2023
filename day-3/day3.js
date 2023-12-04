import { open } from 'node:fs/promises';

const [ROWS, COLS] = [140, 140];

const getNumberFromGrid = (grid, row, col) => {
    let currentCol = col;
    let numberString = '';
    //console.log(`${row} ${col}`)
    while (currentCol < COLS && grid[row][currentCol].match(/^[0-9]+$/)) {
        numberString += grid[row][currentCol];
        currentCol++;
    }
    return numberString;
}

const checkIfPartNumber = (grid, row, col, length) => {
    // The token we're evaluating can't be longer than the grid
    if (col + length > COLS) {
        console.log(`${row} ${col} ${length}`)
        throw new Error('Invalid length -- over size of grid');
    }

    const symbols = ['-', '&', '/', '*', '@', '#', '%', '+', '$', '='];

    // establish a bounding box
    const startingRow = row-1>=0? row - 1 : row;
    const startingCol = col-1>=0? col - 1 : col;
    const endingRow = row+1<ROWS? row + 1 : row;
    const endingCol = col + length;

    // check if symbol present
    let currentRow = startingRow;
    while (currentRow <= endingRow) {
        let currentCol = startingCol;
        while (currentCol <= endingCol) {
            if (symbols.includes(grid[currentRow][currentCol])) {
                // console.log(`${row},${col}: ${currentRow},${currentCol} -- [${startingRow},${startingCol}][${endingRow},${endingCol}] -- ${grid[currentRow][currentCol]}`)
                return true;
            }
            currentCol++;
        }
        currentRow++;
    }

    return false;
}

// Example from https://nodejs.org/api/fs.html#filehandlereadlinesoptions
const generateGrid = async () => {
    const inputFile = await open('./input.txt');
    let grid = Array(ROWS).fill().map(() => Array(COLS).fill('.'));

    // Import grid
    let lineNumber = 0;
    for await (const line of inputFile.readLines()) {
        let charNumber = 0;
        for (const char of line) {
            grid[lineNumber][charNumber] = char;
            charNumber++
        }
        lineNumber++;
    }

    return grid;
}

const partOne = async () => {
    let total = 0;
    const grid = await generateGrid();

    // Check and add number to total
    let currentRow = 0;
    while (currentRow < ROWS) {
        let currentCol = 0;
        while (currentCol < COLS) {
            if (grid[currentRow][currentCol].match(/^[0-9]+$/)) {
                const number = getNumberFromGrid(grid, currentRow, currentCol);
                if (checkIfPartNumber(grid, currentRow, currentCol, number.length)) {
                    total += parseInt(number);
                }
                currentCol += number.length;
            }
            currentCol++;
        }
        currentRow++;
    }
    console.log(`Total Part Number: ${total}`);
}

const findFullNumber = (grid, row, col) => {
    let fullNumber = grid[row][col];

    // Find prior numbers in sequence
    let currentCol = col - 1;
    while (currentCol >= 0 && grid[row][currentCol].match(/^[0-9]+$/)) {
        fullNumber = grid[row][currentCol] + fullNumber;
        currentCol--;
    }

    // Find latter numbers in sequence
    currentCol = col + 1;
    while (currentCol < COLS && grid[row][currentCol].match(/^[0-9]+$/)) {
        fullNumber = fullNumber + grid[row][currentCol];
        currentCol++;
    }

    return fullNumber;
}

const findGearRatio = (grid, row, col) => {
    // establish a bounding box
    const startingRow = row-1>=0? row - 1 : row;
    const startingCol = col-1>=0? col - 1 : col;
    const endingRow = row+1<ROWS? row + 1 : row;
    const endingCol = col+1<COLS? col + 1 : col;

    //console.log(`[${startingRow},${startingCol}]:[${endingRow},${endingCol}]`);

    let firstNumber = 0;
    let secondNumber = 0;

    let currentRow = startingRow;
    while (currentRow <= endingRow) {
        let currentCol = startingCol;
        let isNeedSpace = false;
        while (currentCol <= endingCol) {
            if (isNeedSpace) {
                if (grid[currentRow][currentCol].match(/^[0-9]+$/)) {
                    currentCol++;
                    continue;
                }
                else {
                    isNeedSpace = false;
                }
            }
            if (grid[currentRow][currentCol].match(/^[0-9]+$/)) {
                if (firstNumber === 0) { 
                    firstNumber = findFullNumber(grid, currentRow, currentCol);
                    isNeedSpace = true;
                }
                else {
                    secondNumber = findFullNumber(grid, currentRow, currentCol);
                    return firstNumber * secondNumber;
                }
            }
            currentCol++;
        }
        currentRow++;
    }

    return 0;
}

const partTwo = async () => {
    let total = 0;
    const grid = await generateGrid();

    let currentRow = 0;
    while (currentRow < ROWS) {
        let currentCol = 0;
        while (currentCol < COLS) {
            if (grid[currentRow][currentCol] === '*') {
                const gearRatio = findGearRatio(grid, currentRow, currentCol);
                console.log(`${currentRow},${currentCol}: ${gearRatio}`);
                total += gearRatio;
            }
            currentCol++;
        }
        currentRow++;
    }

    console.log(`Total Gear Ratio: ${total}`);
}

partOne();
partTwo();

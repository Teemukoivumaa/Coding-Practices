
// Java 2d-array. Takes 2d-array and searches it for "hour glasses"
// and adds their numbers together.
/* Example:

1 1 1 0 0 0       1 1 1
0 1 0 0 0 0         1    = 7
1 1 1 0 0 0   ->  1 1 1
0 0 2 4 4 0
0 0 0 2 0 0
0 0 1 2 4 0

*/

static int hourglassSum(int[][] arr) {
        int sum, nextSum, column, row, middleCol, middleRow, columnLimit, rowLimit, switchPoint;
        sum = nextSum = column = row = switchPoint = 0;
        for (int master = 0; master < 16; master++) {
            
            middleRow = row + 1;
            middleCol = column + 1;
            
            columnLimit = column + 3;
            rowLimit = row + 3;
            nextSum = 0;
            
            for (int i = row; i < rowLimit; i++) { // Row
                if (i == middleRow) {
                    nextSum = nextSum + arr[i][middleCol];
                    //System.out.print(arr[i][middleCol] + " ");
                } else {
                    for (int j = column; j < columnLimit; j++) { // Column
                        //System.out.print("j"+j);
                        //System.out.print(arr[i][j] + " "); 
                        nextSum = nextSum + arr[i][j];
                    } 
                }
                System.out.println(); 
            }
            
            column++;
            switchPoint++;
            if (switchPoint == 4) { 
                row++; column = switchPoint = 0; //System.out.println("New row. Row:" + row);
            } else {
                if (sum < nextSum) sum = nextSum;
                //System.out.println("New glass. Column:" + column);
            }
        }
        
        return sum;
    }
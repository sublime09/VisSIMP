// author Patrick Sullivan
public class SimData
{
    final static int DEFAULT_BINS = 10;
    final static int DEFAULT_BIN_DELTA = 1;

    private int[] residueData;
    private float[] positionData;

    int minResidue, maxResidue, numResidues;
    float minPos, closeMaxPos, maxPos;
    float posBinWidth;

    int numBins = DEFAULT_BINS;
    Table binTable;

    public SimData(int[] residueData, float[] positionData) 
    {
        this.residueData = residueData;
        this.positionData = positionData;
        
        minResidue = min(residueData);
        maxResidue = max(residueData);
        numResidues = maxResidue - minResidue + 1;
        minPos = min(positionData);
        maxPos = max(positionData);
        closeMaxPos = Math.nextUp(Math.nextUp(Math.nextUp((maxPos))));
        posBinWidth = (maxPos - minPos) / (float)numBins;
        assert closeMaxPos != maxPos;
    }

    public void changeBins(int deltaBins) {
        this.numBins = max(1, numBins + deltaBins);
        this.posBinWidth = (maxPos - minPos) / (float)numBins;
    }
    public void increaseBins() {
        changeBins(DEFAULT_BIN_DELTA);
    }
    public void decreaseBins() {
        changeBins(-DEFAULT_BIN_DELTA);
    }

    public void process()
    {
        assert residueData != null;
        assert positionData != null;
        assert residueData.length == positionData.length;
        assert numBins > 0;        
        int inputLines = residueData.length;
        
        println("processing", inputLines, "input lines into", this.numBins, "bins");

        Mapper posMapper = new Mapper(minPos, closeMaxPos, 0, numBins);
        int[] binIndexes = posMapper.mapi(positionData);

        int[][] bins = new int[numResidues][numBins];
        for (int i=0; i<inputLines; i++) {
            int resIndex = residueData[i] - minResidue;
            int posBinIndex = binIndexes[i];
            bins[resIndex][posBinIndex] ++;
        }

        int[] binTotals = new int[numResidues];
        for (int r = 0; r < numResidues; r++) {
            for (int b=0; b < numBins; b++) {
                binTotals[r] += bins[r][b];
            }
        }

        float[][] binProbs = new float[numResidues][numBins];
        for (int r = 0; r < numResidues; r++) {
            float binTotal = binTotals[r];
            for (int b=0; b < numBins; b++) {
                binProbs[r][b] = bins[r][b] / binTotal;
            }
        }

        binTable = new Table();
        binTable.addColumn("Residue", Table.INT);
        binTable.addColumn("Position", Table.FLOAT);
        binTable.addColumn("BinSize", Table.INT);
        binTable.addColumn("BinProb", Table.FLOAT);

        for (int i=0; i<numResidues; i++) {
            int residueNum = i + minResidue;
            for (int b=0; b<numBins; b++) {
                // this is the min position for the BIN, not actual sim position
                float binPosition = map(b, 0, numBins, minPos, closeMaxPos);

                TableRow newRow = binTable.addRow();
                newRow.setInt("Residue", residueNum);
                newRow.setFloat("Position", binPosition);
                newRow.setInt("BinSize", bins[i][b]);
                newRow.setFloat("BinProb", binProbs[i][b]);
            }
        }
    }

    public Table getBinTable() {
        assert numBins > 0;
        return binTable;
    }

    public void print() {
        if (binTable == null) {
            println("No data is binned");
            return;
        }
        binTable.print();
        println("Residues min:", minResidue, "max:", maxResidue);
        println("Position min:", minPos, "max:", maxPos);
        println("Bins:", numBins, "PosBinWidth:", posBinWidth);
    }
}
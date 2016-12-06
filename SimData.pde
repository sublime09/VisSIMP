// author Patrick Sullivan
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

public class SimData
{
    final static int DEFAULT_BINS = 10;
    final static int DEFAULT_BIN_DELTA = 1;

    protected int[] residueData;
    protected float[] positionData;
    public int[] tableResidueRows;
    int minResidue, maxResidue, numResidues;
    float minPos, closeMaxPos, maxPos;
    float posBinWidth;

    private boolean processOrdered = true;
    private boolean processBins = true;
    protected int numBins = DEFAULT_BINS;
    protected Table binTable;
    protected Table orderedTable;

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

    public Table getBinTable() {
        assert numBins > 0;
        if (binTable == null || processBins) processBins();
        return binTable;
    }

    public Table getOrderedTable() {
        if (orderedTable == null || processOrdered) processOrdered();
        return orderedTable;
    }

    public void changeBins(int deltaBins) {
        this.numBins = max(1, numBins + deltaBins);
        this.posBinWidth = (maxPos - minPos) / (float)numBins;
        processBins = true;
    }
    public void increaseBins() {
        changeBins(DEFAULT_BIN_DELTA);
    }
    public void decreaseBins() {
        changeBins(-DEFAULT_BIN_DELTA);
    }
    public int getNumBins() {
        return numBins;
    }

    public void process() {
        if (processBins) processBins();
        if (processOrdered) processOrdered();
    }
    public int getNumberOfBins()
    {
      return numBins;
    }
    private void processOrdered() {
        assert residueData != null;
        assert positionData != null;
        assert residueData.length == positionData.length;

        orderedTable = new Table();
        orderedTable.addColumn("Residue", Table.INT);
        orderedTable.addColumn("MinPosition", Table.FLOAT);
        orderedTable.addColumn("AvgPosition", Table.FLOAT);
        orderedTable.addColumn("MeanPosition", Table.FLOAT);
        orderedTable.addColumn("MaxPosition", Table.FLOAT);

        // seperate into residue arrays
        List<List<Float>> resList = new ArrayList();
        for (int i=0; i<numResidues; i++) 
            resList.add(new ArrayList<Float>());
        for (int i=0; i<residueData.length; i++) {
            int residue = residueData[i];
            float pos = positionData[i];
            int residueIndex = residue - minResidue;
            resList.get(residueIndex).add(pos);
        }

        for (int i=0; i<resList.size(); i++) {
            int residue = minResidue + i;
            List<Float> positions = resList.get(i);
            assert positions.size() > 0;
            Collections.sort(positions);
            float minPosition = positions.get(0);
            float maxPosition = positions.get(positions.size()-1);
            int meanIndex = positions.size() / 2;
            float meanPosition = positions.get(meanIndex);
            double sum = 0;
            for (float f : positions) sum += f;
            float averagePosition = (float) (sum / positions.size());

            TableRow newRow = orderedTable.addRow();
            newRow.setInt("Residue", residue);
            newRow.setFloat("MinPosition", minPosition);
            newRow.setFloat("MaxPosition", maxPosition);
            newRow.setFloat("AvgPosition", averagePosition);
            newRow.setFloat("MeanPosition", meanPosition);
        }
        
        processOrdered = false;
    }

    private void processBins()
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
        processBins = false;
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
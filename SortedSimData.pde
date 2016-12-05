public enum SortingCritrion {
  MIN, MAX, AVERAGE
};

public class SortedSimData extends SimData
{
  ArrayList<Element> sortedElements;
  int[] sortedIndeces;
  public SortedSimData(SimData simData, SortingCritrion criterion)
  {
    super(simData.residueData, simData.positionData);
    sortedElements = new ArrayList<Element>();
    sortedIndeces = sortedResiduesIndeces(criterion);
    tableResidueRows = sortedIndeces;
  }
  public int[] sortedResiduesIndeces(SortingCritrion criterion)
  {
    float[][] data = new float[numResidues][2];
    int index = 0;
    while (index < residueData.length)
    {
      int resdiueIndex = residueData[index];
      if(criterion == SortingCritrion.MAX || criterion == SortingCritrion.MIN)
        data[resdiueIndex - minResidue][0] = positionData[index];
      while (index < residueData.length && resdiueIndex == residueData[index])
      {
        if (criterion == SortingCritrion.MAX)
        {
          data[resdiueIndex - minResidue][0] = max(data[resdiueIndex - minResidue][0], positionData[index]);
        } else if (criterion == SortingCritrion.MIN)
        {
          data[resdiueIndex - minResidue][0] = min(data[resdiueIndex - minResidue][0], positionData[index]);
        } else
        {
          data[resdiueIndex - minResidue][0]+= positionData[index];
          data[resdiueIndex - minResidue][1]++;
        }
        index++;
      }
    }
    sortResidues(data,criterion);
    return sortedIndeces;
  }
  private void sortResidues(float[][] data, SortingCritrion criterion)
  { //<>//
    for(int i=0; i< data.length; i++)
    {
      float value = 0.0f;
      if(criterion == SortingCritrion.AVERAGE)
      {
        value = data[i][0]/data[i][1];
      }
      else{
        value = data[i][0];
      }
      sortedElements.add(new Element(i + minResidue, value));
    }
    sortedElements.sort(null);
    sortedIndeces = new int[numResidues];
    int index = 0;
    for (Element e : sortedElements)
    {
      sortedIndeces[index++] = e.index;
    }
  } //<>// //<>//
  @Override
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
      int residueNum = sortedIndeces[i];
      for (int b=0; b<numBins; b++) {
        // this is the min position for the BIN, not actual sim position
        float binPosition = map(b, 0, numBins, minPos, closeMaxPos);
        int newI = residueNum - minResidue;
        TableRow newRow = binTable.addRow();
        newRow.setInt("Residue", residueNum);
        newRow.setFloat("Position", binPosition);
        newRow.setInt("BinSize", bins[newI][b]);
        newRow.setFloat("BinProb", binProbs[newI][b]);
      }
    }
  }
  private class Element implements Comparable<Element>
  {
    int index;
    float distance;
    public Element(int index, float distance)
    {
      this.index = index;
      this. distance = distance;
    }
    public int compareTo(Element other)
    {
      Float dist = new Float(distance);
      return dist.compareTo(other.distance);
    }
  }
}
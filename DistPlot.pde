// author Patrick Sullivan and Mostafa Mohammed
public class DistPlot {
    SimData sim;
    Membrane membrane;
    ResidueColors residue;
    int selectedRes = -1;
    public DistPlot(SimData sim, Membrane membrane)
    {
        this.sim = sim;
        this.membrane = membrane;
        this.residue = new ResidueColors(sim);
    }
    
    public void draw(float x, float y, float w, float h) {
        float boxW = w / sim.numResidues;
        
        Mapper xPosMapper = new Mapper(0, sim.numResidues, x, x+w);
        Mapper yPosMapper = new Mapper(sim.minPos, sim.maxPos, y+h, y);
        
        Table orderT = sim.getOrderedTable();
        Table binT = sim.getBinTable();
   
        Table orderTable = new Table();
        orderTable.addColumn("Residue", Table.INT);
        orderTable.addColumn("BinSize", Table.INT);
        orderTable.addColumn("BinPosition", Table.FLOAT);
        for(int i = 0; i < sim.numResidues; i++) {
          int size = 0;
          int startingBin = i * sim.getNumBins();
          for(int j = 0; j < sim.getNumBins(); j++) {
            if(binT.getRow(startingBin + j).getFloat("BinSize") > binT.getRow(startingBin + size).getFloat("BinSize")) {
              size = j;
            }
          }
          float pos = binT.getRow(startingBin + size).getFloat("Position");
          TableRow newRow = orderTable.addRow();
          newRow.setInt("Residue", i + 1);
          newRow.setInt("BinSize", size);
          newRow.setFloat("BinPosition", pos);
        }
        orderTable.sort("BinSize");
        
        for(int i = 0; i < orderTable.getRowCount(); i++) {
          // fetch features from the table
          //int i = order[n];
          TableRow row = orderT.getRow(i);
          TableRow binRow = orderTable.getRow(i);
          
          // Calculate the largest bin for the residue and the standard deviation.
          int startingBin = i * sim.getNumBins();
          float[] binData = new float[sim.getNumBins()];
          
          for(int j = 0; j < sim.getNumBins(); j++) {
            binData[j] = binT.getRow(startingBin + j).getFloat("Position");
          }
          
          float sigma = stdDev(binData, row.getFloat("MeanPosition"));
          
          float binPosition = binRow.getFloat("BinPosition");
          
          float minPos = binPosition - (0.5 * sigma);
          float maxPos = binPosition + (0.5 * sigma);
          
          // map features to the screen area
          float xPos = xPosMapper.map(i);
          float minPosY = yPosMapper.map(minPos);
          float maxPosY = yPosMapper.map(maxPos);
          float boxH = minPosY - maxPosY;
          
          // draw box representing min and max position of residue
          PShape box = createShape(RECT, xPos, maxPosY, boxW, boxH);
          box.setFill(residue.residueColors[binRow.getInt("Residue")-1]);
          if(binRow.getInt("Residue") == selectedRes)
            {
              colorMode(RGB);
              box.setStrokeWeight(10);
              box.setStroke(color(153,153,0));
              colorMode(HSB);
            }
          shape(box);
          
          // fetch position for where label goes
          //float labelPos = row.getFloat(sortColumn);
          float labelPos = binPosition;
          
          // place text label into screen area
          String residueLabel = Integer.toString(binRow.getInt("Residue"));
          float nextXPos = xPosMapper.map(i + 1);
          float labelX = (nextXPos + xPos) / 2;
          float labelY = yPosMapper.map(labelPos);
          textAlign(CENTER, CENTER);
          text(residueLabel, labelX, labelY);   
      }
        
        membrane.drawMembrane(x, y, w, h);
    }
    
    public int getSelectedRes(int xPos,float x, float w)
    {
      Mapper xPosMapper = new Mapper(x, x+w, 0, sim.numResidues);
      int index = floor(xPosMapper.map(xPos));
      int ResNumber = sim.getOrderedTable().getRow(index).getInt("Residue");
      if(selectedRes == ResNumber)
        selectedRes = -1;
        else
        selectedRes = ResNumber;
      //println(selectedRes);
      return selectedRes;
    }
}
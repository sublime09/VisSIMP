// author Patrick Sullivan
public class DistPlot {
    SimData sim;
    Membrane membrane;
    ResidueColors residue;
    
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
        int[] order = new int[sim.numResidues];
        
        for(int i = 0; i < order.length; i++) {
          order[i] = i;
        }
        
        for(int i : order) {
          // fetch features from the table
          TableRow row = orderT.getRow(i);
          
          // Calculate the largest bin for the residue and the standard deviation.
          int maxBin = 0;
          int startingBin = i * sim.getNumBins();
          float[] binData = new float[sim.getNumBins()];
          
          for(int j = 0; j < sim.getNumBins(); j++) {
            binData[j] = binT.getRow(startingBin + j).getFloat("Position");
            if(binT.getRow(startingBin + j).getFloat("BinSize") > binT.getRow(startingBin + maxBin).getFloat("BinSize")) {
              maxBin = j;
            }
          }
          
          float sigma = stdDev(binData, row.getFloat("MeanPosition"));
          
          float binPosition = binT.getRow(startingBin + maxBin).getFloat("Position");
          
          float minPos = binPosition - (0.5 * sigma);
          float maxPos = binPosition + (0.5 * sigma);
          
          // map features to the screen area
          float xPos = xPosMapper.map(i);
          float minPosY = yPosMapper.map(minPos);
          float maxPosY = yPosMapper.map(maxPos);
          float boxH = minPosY - maxPosY;
          
          // draw box representing min and max position of residue
          PShape box = createShape(RECT, xPos, maxPosY, boxW, boxH);
          box.setFill(residue.residueColors[i]);
          shape(box);
          
          // fetch position for where label goes
          //float labelPos = row.getFloat(sortColumn);
          float labelPos = binPosition;
          
          // place text label into screen area
          String residueLabel = Integer.toString(i+1);
          float nextXPos = xPosMapper.map(i + 1);
          float labelX = (nextXPos + xPos) / 2;
          float labelY = yPosMapper.map(labelPos);
          textAlign(CENTER, CENTER);
          text(residueLabel, labelX, labelY);   
      }
        
        membrane.drawMembrane(x, y, w, h);
    }
}
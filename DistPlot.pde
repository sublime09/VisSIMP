// author Patrick Sullivan
public class DistPlot {
    SimData sim;
    Membrane membrane;
    String sortColumn = "AvgPosition";
    
    public DistPlot(SimData sim, Membrane membrane)
    {
        this.sim = sim;
        this.membrane = membrane;
        sim.getOrderedTable().sort(sortColumn);
    }
    
    public void draw(float x, float y, float w, float h) {
        float boxW = w / sim.numResidues;
        
        Mapper xPosMapper = new Mapper(0, sim.numResidues, x, x+w);
        Mapper yPosMapper = new Mapper(sim.minPos, sim.maxPos, y+h, y);
        
        Table orderT = sim.getOrderedTable();
        for (int i=0 ; i<orderT.getRowCount() ; i++){
            // fetch features from the table
            TableRow row = orderT.getRow(i);
            float minPos = row.getFloat("MinPosition");
            float maxPos = row.getFloat("MaxPosition");
            
            // map features to the screen area
            float xPos = xPosMapper.map(i);
            float minPosY = yPosMapper.map(minPos);
            float maxPosY = yPosMapper.map(maxPos);
            float boxH = minPosY - maxPosY;
            
            // draw box representing min and max position of residue
            PShape box = createShape(RECT, xPos, maxPosY, boxW, boxH);
            box.setFill(100);
            shape(box);
            
            // fetch position for where label goes
            float labelPos = row.getFloat(sortColumn);
            
            // place text label into screen area
            String residueLabel = Integer.toString(row.getInt("Residue"));
            float nextXPos = xPosMapper.map(i + 1);
            float labelX = (nextXPos + xPos) / 2;
            float labelY = yPosMapper.map(labelPos);
            textAlign(CENTER, CENTER);
            text(residueLabel, labelX, labelY);   
        }
        
    }
}
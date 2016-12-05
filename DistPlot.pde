
public enum Positioning { 
    MIN, MAX, MEAN, MEDIAN
};

public class DistPlot {
    SimData sim;
    Membrane membrane;
    Positioning posOfRes = Positioning.MEDIAN;

    public DistPlot(SimData sim, Membrane membrane)
    {
        this.sim = sim;
        this.membrane = membrane;
        
        if (posOfRes == Positioning.MEAN)
            sim.getOrderedTable().sort("MeanPosition");
        else 
            sim.getOrderedTable().sort("AvgPosition");
    }
    
    public void draw(float x, float y, float w, float h) {
        float boxW = w / sim.numResidues;
        
        Mapper xPosMapper = new Mapper(0, sim.numResidues, x, x+w);
        Mapper yPosMapper = new Mapper(sim.minPos, sim.maxPos, y+h, y);
        
        Table orderT = sim.getOrderedTable();
        for (int i=0 ; i<orderT.getRowCount() ; i++){
            TableRow row = orderT.getRow(i);
            String residueLabel = Integer.toString(row.getInt("Residue"));
            float minPos = row.getFloat("MinPosition");
            float maxPos = row.getFloat("MaxPosition");
            
            float xPos = xPosMapper.map(i);
            float minPosY = yPosMapper.map(minPos);
            float maxPosY = yPosMapper.map(maxPos);
            float boxH = minPosY - maxPosY;
            
            PShape box = createShape(RECT, xPos, maxPosY, boxW, boxH);
            box.setFill(100);
            shape(box);
            
            float labelPos = row.getFloat("AvgPosition");
            if (posOfRes == Positioning.MEAN)
                labelPos = row.getFloat("MeanPosition");
            
            float nextXPos = xPosMapper.map(i + 1);
            float labelX = (nextXPos + xPos) / 2;
            float labelY = yPosMapper.map(labelPos);
            textAlign(CENTER, CENTER);
            text(residueLabel, labelX, labelY);
            
        }
        
        for (int i=0 ; i<orderT.getRowCount() ; i++){
            // use positioning enum
        }
        
    }
    
}
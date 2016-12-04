// author Patrick Sullivan and Taylor Rydahl
public class HeatMap {

    static final float CANVAS_W = 4096; // 4k resolution 
    static final float CANVAS_H = 2060;
    
    SimData sim;
    Membrane membrane;
    PShape canvas = null;

    public HeatMap(SimData sim, Membrane membrane)
    {
        this.sim = sim;
        this.membrane = membrane;
    }
    
    public void printData()
    {
        if (sim != null) sim.binTable.print(); 
        else println("NULL");
    } //<>//

    public void prepCanvas()
    {
        canvas = createShape(GROUP);
        float boxW = CANVAS_W / sim.numResidues;
        float boxH = CANVAS_H / sim.numBins;
        
        int minResidue = min(sim.binTable.getIntColumn("Residue"));
        int maxResidue = max(sim.binTable.getIntColumn("Residue"));
        Mapper xPosMapper = new Mapper(minResidue, maxResidue, 0, CANVAS_W - boxW);
        
        float minPos = min(sim.binTable.getFloatColumn("Position"));
        float maxPos = max(sim.binTable.getFloatColumn("Position"));
        Mapper yPosMapper = new Mapper(maxPos, minPos, 0, CANVAS_H - boxH);
        
        float maxProb = max(sim.binTable.getFloatColumn("BinProb"));
        
        colorMode(HSB);
        color from = color(0, 0, 255); // white
        color to = color(0, 255, 128); // dark red
        
        for (TableRow row : sim.binTable.rows()){
            float xPos = xPosMapper.map(row.getInt("Residue"));
            float yPos = yPosMapper.map(row.getFloat("Position"));
            
            float prob = row.getFloat("BinProb");
            color c = lerpColor(from, to, prob / maxProb);
            
            PShape box = createShape(RECT, xPos, yPos, boxW, boxH);
            box.setFill(c);
            canvas.addChild(box);
        }
        
        membrane.setCanvas(CANVAS_W, CANVAS_H);
    }

    public void draw(float x, float y, float w, float h)
    {
        if (sim == null) return;
        if (canvas == null) prepCanvas();
        
        float xScale = map(w, 0, CANVAS_W, 0, 1.0);
        float yScale = map(h, 0, CANVAS_H, 0, 1.0);
        
        // canvas image is drawn on area requested
        pushMatrix();
        translate(x, y);
        scale(xScale, yScale);
        shape(canvas); 
        popMatrix();
        
        membrane.drawMembrane(x,y,w,h);
    }
    
}
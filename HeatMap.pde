// author Patrick Sullivan, Taylor Rydahl and Mostafa Mohammed
public class HeatMap {

    static final float CANVAS_W = 4096; // 4k resolution
    static final float CANVAS_H = 2060;

    SimData sim;
    Membrane membrane;
    PShape canvas = null;
    int selectedRes = -1;
    public HeatMap(SimData sim, Membrane membrane)
    {
        this.sim = sim;
        this.membrane = membrane;
    }

    public void prepCanvas()
    {
        canvas = createShape(GROUP);
        float boxW = CANVAS_W / sim.numResidues;
        float boxH = CANVAS_H / sim.numBins;

        int minResidue = sim.minResidue;
        int maxResidue = sim.maxResidue;
        float minPos = sim.minPos;
        float maxPos = sim.maxPos;
        float maxProb = max(sim.binTable.getFloatColumn("BinProb"));

        Mapper xPosMapper = new Mapper(minResidue, maxResidue, 0, CANVAS_W - boxW);
        Mapper yPosMapper = new Mapper(maxPos, minPos, 0, CANVAS_H - boxH);
        
        colorMode(HSB);
        color from = color(0, 0, 255); // white
        color to = color(0, 255, 128); // dark red

        for (TableRow row : sim.binTable.rows()) {
            int residue = row.getInt("Residue");
            float xPos = xPosMapper.map(residue);
            float yPos = yPosMapper.map(row.getFloat("Position"));

            float prob = row.getFloat("BinProb");
            color c = lerpColor(from, to, prob / maxProb);

            PShape box = createShape(RECT, xPos, yPos, boxW, boxH);
            if(residue == selectedRes)
            {
              colorMode(RGB);
              box.setStrokeWeight(10);
              box.setStroke(color(153,153,0));
              colorMode(HSB);
            }
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

        membrane.drawMembrane(x, y, w, h);
    }
    
}
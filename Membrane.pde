// author Taylor Rydahl
public class Membrane
{
    PImage memImage;
    float MEM_DIST = 1.76;
    float CANVAS_H = 1.0;
    float CANVAS_W = 1.0;
    float IMG_W = 1.0;
    
    SimData sim;
    
    public Membrane(SimData sim) 
    {
        memImage = loadImage("membrane.png");
        IMG_W = memImage.width;
        this.sim = sim;
    }
    
    public void setMembrane(String fileLocation) 
    {
        memImage = loadImage(fileLocation);
        IMG_W = memImage.width;
    }
    
    public void setCanvas(float h, float w) 
    {
        CANVAS_H = h;
        CANVAS_W = w;
    }
    
    public void setSim(SimData sim) 
    {
        this.sim = sim;
    }
    
    public void drawMembrane(float x, float y, float w, float h) 
    {
        if (sim == null) return;
        float minPos = min(sim.binTable.getFloatColumn("Position"));
        float maxPos = max(sim.binTable.getFloatColumn("Position"));
        float memHeight = map(MEM_DIST, minPos, maxPos, 0, CANVAS_H);
        
        float xScale = map(w, 0, CANVAS_W, 0, 1.0);
        float yScale = map(h, 0, CANVAS_H, 0, 1.0);
        
        pushMatrix();
        translate(x,y);
        scale(xScale,yScale);
        tint(255,192);
        for(int i = 0; i < CANVAS_W / IMG_W; i++) {
          image(memImage, i * IMG_W, CANVAS_H - memHeight, IMG_W, memHeight);
        }
        popMatrix();
    }
}
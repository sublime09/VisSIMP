

public float[] map(float[] vals, float minV, float maxV, float minF, float maxF)
{
    float[] result = new float[vals.length];
    float slope = (maxF - minF) / (maxV - minV);
    for (int i=0 ; i<vals.length ; i++)
    {
        result[i] = (vals[i] - minV) * slope + minF;
    }
    return result;
}

public float[] mapAuto(float[] vals, float minF, float maxF)
{
    float minV = min(vals);
    float maxV = max(vals);
    return map(vals, minV, maxV, minF, maxF);
}

public class Box
{
    float x, y, w, h;
    public Box(float xx, float yy, float ww, float hh)
    {
        x = xx;
        y = yy;
        w = ww;
        h = hh;
    }
}


public float[] iter(float[] vals, int start, int end, int pace)
{
    int resultLen = (end - start) / pace;
    float[] result = new float[resultLen];
    for (int i=0; i<resultLen ; i++)
    {
        result[i] = vals[start + i * pace]; 
    }
    return result;
}


// draws the title at the top of the visualization
public void drawTitle() {
    String title = "VisSIMP"; 
    int textSize = 23;
    fill(255);
    float xPos = width / 2;
    textSize(textSize);
    textAlign(CENTER, TOP);
    text(title, xPos, 0);
    textSize(textSize / 2);
    textAlign(RIGHT, TOP);
    text("made with Processing", width, 0);
    //textAlign(LEFT, TOP);
    //text("Patrick Sullivan, CS 5764", 0, 0);
}

// draws the footer with fps, numPoints
public void drawFooter() {
    int textSize = 15;
    String points = "Points: ????";
    String frate = "FPS: " + nf((int)frameRate, 2) ;
    String rendered = "Rendered: ???";
    String[] footer = {points, frate, rendered};

    fill(255);
    textSize(textSize);
    textAlign(RIGHT, BOTTOM);
    text(join(footer, "  "), width, height);
}
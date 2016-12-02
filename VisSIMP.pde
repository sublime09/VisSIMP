// VisSIMP program 
// Visualization of Simulated Interactions between Membranes and Proteins
// Authors: Mohammed Mustafa, Taylor Rhydahl, and Patrick Sullivan
//import java.io.File;
import java.awt.FileDialog;

final float HEADER_AREA = 30;
final float FOOTER_AREA = 20;
final float MARGIN = 5;
final float X_AxisSpace = 20;
final float Y_AxisSpace = 275;
float mousePressX, mousePressY;

SimData simInput = null;
HeatMap heat = null;

public void setup()
{
    size(1080, 720);
    surface.setResizable(true);
    askForFile();
}


public void draw()
{
    clear();
    background(0);
    stroke(255);

    float x = MARGIN + Y_AxisSpace;
    float y = MARGIN + HEADER_AREA;
    float w = width - x - MARGIN ;
    float h = height - y - FOOTER_AREA - MARGIN - X_AxisSpace;

    if (heat != null) 
      heat.draw(x, y, w, h);
    drawTitle();
    drawFooter();
    //test case 1
    //drawX_Axis(null);
    //test case 2
    int[] asd = new int[]{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42};
    drawX_Axis(asd);
    drawY_Axis();
}

// makes all vis elements
void updateVis()
{
    heat = null;
    assert simInput != null;
    simInput.process();
    heat = new HeatMap(simInput);
}

// clears all vis elements
void clearVis()
{
    heat = null;
}

void keyPressed() {
    if (key == ESC || key == 'q') exit();
    if (key == 'p') save("VisSIMP.png");
    if (key == 'o') askForFile();
    if (key == 'd') simInput.print();
    if (key == '=') simInput.increaseBins();
    if (key == '-') simInput.decreaseBins();
    if (key == '=' || key == '-') updateVis();
}

void mousePressed()
{
    mousePressX = mouseX;
    mousePressY = mouseY;
}
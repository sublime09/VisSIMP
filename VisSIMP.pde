// VisSIMP program 
// Visualization of Simulated Interactions between Membranes and Proteins
// Authors: Mohammed Mustafa, Taylor Rhydahl, and Patrick Sullivan
//import java.io.File;
import java.awt.FileDialog;

final float HEADER_AREA = 30;
final float FOOTER_AREA = 20;
final float MARGIN = 5;

float mousePressX, mousePressY;

int bins = 20;
SimData simInput;
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

    float x = MARGIN;
    float y = MARGIN + HEADER_AREA;
    float w = width - x - MARGIN;
    float h = height - y - FOOTER_AREA - MARGIN;

    if (heat != null) heat.draw(x, y, w, h);

    drawTitle();
    drawFooter();
}

// makes all vis elements
void makeVis()
{
    assert simInput != null;
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
    if (key == 'd') {
        simInput.print();
    }
}

void mousePressed()
{
    mousePressX = mouseX;
    mousePressY = mouseY;
}
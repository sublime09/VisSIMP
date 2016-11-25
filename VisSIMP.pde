// VisSIMP program 
// Visualization of Simulated Interactions between Membranes and Proteins
// Authors: Mohammed Mustafa, Taylor Rhydahl, and Patrick Sullivan
//import java.io.File;
import java.awt.FileDialog;

final float HEADER_AREA = 30;
final float FOOTER_AREA = 20;
final float MARGIN = 5;

float mousePressX, mousePressY;

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

    drawTitle();
    drawFooter();
}

void keyPressed() {
    if (key == ESC || key == 'q') exit();
    if (key == 'p') save("screenshot.png");
    if (key == 'o') askForFile();
}

void mousePressed()
{
    mousePressX = mouseX;
    mousePressY = mouseY;
}
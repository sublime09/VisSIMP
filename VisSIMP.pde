// VisSIMP program 
// Visualization of Simulated Interactions between Membranes and Proteins
// Authors: Mohammed Mustafa, Taylor Rhydahl, and Patrick Sullivan

final float HEADER_AREA = 30;
final float FOOTER_AREA = 20;
final float MARGIN = 5;

float mousePressX, mousePressY;

String[] datafiles = {"CS_Data_Viz_Project\\Residue_COM_Membrane_Data\\ab42_tetramer_popc_rep1_COM_memb.xvg"};

public void setup()
{
    size(1080, 720);
    surface.setResizable(true);
    
    int end = 100000; // TODO: change to num lines in input file
    Progress progBar = new Progress("Reading Data", 0, end);
    for (int i=0 ; i<end ; i++)
    {
        //TODO: input file reading happens here
        progBar.tryTick(i);
    }
    progBar.end();

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
}

void mousePressed()
{
    mousePressX = mouseX;
    mousePressY = mouseY;
}
// VisSIMP program 
// Visualization of Simulated Interactions between Membranes and Proteins
// Authors: Mohammed Mustafa, Taylor Rhydahl, and Patrick Sullivan

final float HEADER_AREA = 30;
final float FOOTER_AREA = 45;
final float LEFT_MARGIN = 50;
final float RIGHT_MARGIN = 5;
final float MARGIN = 5;
final float X_AxisSpace = 20;
final float Y_AxisSpace = 275;
float mousePressX, mousePressY;

SimData simInput = null;
HeatMap heat = null;
Axes visAxes = null;

public void setup()
{
    size(1080, 720);
    surface.setResizable(true);
    askForFile();
}

public void draw()
{
    clear();
    background(255);
    stroke(0);
    fill(0);

    float x = LEFT_MARGIN;
    float y = HEADER_AREA;
    float w = (width - x) - RIGHT_MARGIN ;
    float h = (height - y) - FOOTER_AREA ;

    if (heat != null) heat.draw(x, y, w, h);
    if (visAxes != null) visAxes.draw(x, y, w, h);

    drawTitle();
    drawFooter();
}

// makes all vis elements
void updateVis()
{
    heat = null;
    assert simInput != null;
    simInput.process();
    heat = new HeatMap(simInput);
    AxesFactory af = new AxesFactory();
    visAxes = af.getResidueOrderAxes(simInput);
}

// clears all vis elements
void clearVis()
{
    heat = null;
    visAxes = null;
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
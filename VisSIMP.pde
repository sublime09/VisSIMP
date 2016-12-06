// VisSIMP program
// Visualization of Simulated Interactions between Membranes and Proteins
// Authors: Mohammed Mustafa, Taylor Rydahl, and Patrick Sullivan

final float HEADER_AREA = 30;
final float FOOTER_AREA = 60;
final float LEFT_MARGIN = 70;
final float RIGHT_MARGIN = 5;
final float MARGIN = 5;
final float X_AxisSpace = 20;
final float Y_AxisSpace = 275;
float mousePressX, mousePressY;
SimReader sm=null;
SimData simInput = null;

enum Vis {
    NONE, HEATMAP, DIST_ORDER
};
Vis currentView = Vis.NONE;

HeatMap heat = null;
DistPlot dPlot = null;
Axes visAxes = null;
Membrane membrane = null;

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
    boolean drawXaxis = true;
    if (currentView == Vis.HEATMAP)
    {
      heat.draw(x, y, w, h);
      drawXaxis = true;
    }
    if (currentView == Vis.DIST_ORDER)
    {
      drawXaxis = false;
        dPlot.draw(x, y, w, h);
    }
        
    if (visAxes != null) visAxes.draw(x, y, w, h, drawXaxis);

    drawTitle();
    drawFooter();
}

// makes all vis elements
void updateVis(Vis v)
{
    assert simInput != null;
    simInput.process();
    membrane = new Membrane(simInput);
    heat = new HeatMap(simInput, membrane);
    dPlot = new DistPlot(simInput, membrane);
    AxesFactory af = new AxesFactory();
    visAxes = af.getResidueOrderAxes(simInput);
    currentView = v;
}

void toggleView() {
    //visAxes = null;
    if (currentView == Vis.HEATMAP) currentView = Vis.DIST_ORDER;
    else if  (currentView == Vis.DIST_ORDER) currentView = Vis.HEATMAP;
}

void keyPressed() {
    if (key == ESC || key == 'q') exit();
    if (key == 'p') save("VisSIMP.png");
    if (key == 'o') askForFile();
    if (key == 'd') simInput.print();
    if (key == '=') simInput.increaseBins();
    if (key == '-') simInput.decreaseBins();
    if (key == '=' || key == '-') updateVis(currentView);
    if (key == 'm') askForImage();
    if (key == TAB) toggleView();
}

void mousePressed()
{
    mousePressX = mouseX;
    mousePressY = mouseY;
}
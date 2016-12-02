boolean drawAxies = false;//to prevent draw axis method from working before loading the file
public void askForFile()
{
  selectInput("Select a Simulation (.xvg) to process:", "fileSelected");
}

void fileSelected(File selection) {
  // window closed or pressed cancel
  if (selection == null) return;

  clearVis();
  String filepath = selection.getAbsolutePath();
  println("Input File = " + selection.getAbsolutePath());
  SimReader sm = new SimReader(filepath);
  simInput = sm.readFile();
  updateVis();
  drawAxies = true;//to prevent draw axis methods from working before loading the file
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
public void drawX_Axis(int[] labels)
{
  if (drawAxies)//to prevent draw method from working before loading the file
  {
    float offset = ((width - Y_AxisSpace) / simInput.numResidues)/2;//to center the label
    float yLocation = height  - MARGIN - FOOTER_AREA - X_AxisSpace+5;//the start y position for the axe
    line(0, yLocation, width - Y_AxisSpace, yLocation);//draw x axis
    if (labels == null)//for drawing the first view labels (1,2,3,...,42)
    {
      Mapper posMapper = new Mapper(simInput.minResidue, simInput.maxResidue, offset + Y_AxisSpace, width - offset);
      for (int i = simInput.minResidue; i<= simInput.maxResidue; i++)
      {
        int x = (int)posMapper.map(i);
        text(i+"", x, yLocation+20);
      }
    } else//for drawing the second view (sorted based on membrain distance)
    {
      Mapper posMapper = new Mapper(0, labels.length-1, offset + Y_AxisSpace, width - offset);
      for (int i = 0; i< labels.length; i++)
      {
        int x = (int)posMapper.map(i);
        text(labels[i]+"", x, yLocation+20);
      }
    }
  }
}
public void drawY_Axis()
{
  if (drawAxies)//to prevent draw method from working before loading the file
  {
    float yLocation = height  - MARGIN - FOOTER_AREA - X_AxisSpace+5; // the start y value for Y axis
    line(Y_AxisSpace - 5, yLocation, Y_AxisSpace - 5, 0);//draw the axis
    float boxH = (height - HEADER_AREA - FOOTER_AREA - MARGIN - X_AxisSpace) / heat.sim.numBins; // to center the lable
    float minPos = min(heat.sim.binTable.getFloatColumn("Position"));
    float maxPos = max(heat.sim.binTable.getFloatColumn("Position"));
    //map based on the actual height of the heatmap
    Mapper yPosMapper = new Mapper(maxPos, minPos, HEADER_AREA + boxH/2, (height - HEADER_AREA - FOOTER_AREA - X_AxisSpace - boxH/2));
    for (TableRow row : heat.sim.binTable.rows()) {
      float value = row.getFloat("Position");
      float yPos = yPosMapper.map(value);
      text(value+"", Y_AxisSpace - 20, yPos+boxH/4);
    }
  }
}
public float[] iter(float[] vals, int start, int end, int pace)
{
  int resultLen = (end - start) / pace;
  float[] result = new float[resultLen];
  for (int i=0; i<resultLen; i++)
  {
    result[i] = vals[start + i * pace];
  }
  return result;
}

public float[] map(float[] vals, float minV, float maxV, float minF, float maxF)
{
  float[] result = new float[vals.length];
  float slope = (maxF - minF) / (maxV - minV);
  for (int i=0; i<vals.length; i++)
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

public float calculateSum(float[] vals)
{
  float sum = 0.0;
  for (float value : vals)
    sum+=value;
  return sum;
}

public float calculateAverage(float[] vals)
{
  return calculateSum(vals)/vals.length;
}
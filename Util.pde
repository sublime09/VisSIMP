// author Patrick Sullivan, Taylor Rydahl and Mustafa Mohammed
public void askForFile()
{
  selectInput("Select a Simulation (.xvg) to process:", "fileSelected");
}

void fileSelected(File selection) {
  // window closed or pressed cancel
  if (selection == null) return;
  String filepath = selection.getAbsolutePath();
  println("Input File = " + selection.getAbsolutePath());
  sr = new SimReader(filepath);
  simInput = sr.readFile();
  updateVis(Vis.HEATMAP);
}

public void askForImage()
{
  selectInput("Select a membrane image (.png) to load:", "imageSelected");
}

void imageSelected(File selection) {
  if (selection == null) return;
  if (membrane != null) {
    membrane.setMembrane(selection.getAbsolutePath());
  }
}

// draws the title at the top of the visualization
public void drawTitle() {
  String title = "VisSIMP";
  int textSize = 23;
  fill(0); //black
  float xPos = width / 2;
  textSize(textSize);
  textAlign(CENTER, TOP);
  text(title, xPos, 0);
  textSize(textSize / 2);
  textAlign(RIGHT, TOP);
  text("made with Processing", width, 0);
  if (sr!=null)
  {
    textAlign(LEFT, TOP);
    
    text(sr.fileName, 5, 0);
  }
}

// draws the footer with fps, numPoints
public void drawFooter() {
  String frate = "FPS: " + nf((int)frameRate, 2) ;
  String bins = "Number of Bins: ";
  String lines = "Input File Lines: ";
  if (sr!=null) 
    lines+= sr.inputLines;
  if (simInput != null) 
    bins += simInput.getNumberOfBins();
  String[] footer = {lines, bins, frate};

  fill(0);// black
  textSize(15);
  textAlign(RIGHT, BOTTOM);
  text(join(footer, "  "), width, height);
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

public float sum(float[] vals)
{
  float sum = 0.0;
  for (float value : vals)
    sum+=value;
  return sum;
}

public float avg(float[] vals)
{
  return sum(vals)/vals.length;
}

public float stdDev(float[] data, float mean)
{
  float diffSq = 0;
  for(int i = 0; i < data.length; i++) {
    diffSq += sq(data[i] - mean);
  }
  diffSq /= data.length;
  return sqrt(diffSq);
}
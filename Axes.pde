// author Patrick Sullivan and Mostafa Mohammed
import java.text.DecimalFormat;

// factory that creates the axes for what view mode we are using
class AxesFactory {
    public Axes getResidueOrderAxes(SimData sd) {
        AxisInt xAxis = new AxisInt("Residue", Orientation.HORIZONTAL);
        xAxis.setRange(sd.minResidue, sd.maxResidue);
        xAxis.setupLabels(sd.numResidues);

        Axes axes = new Axes(xAxis, getNormalYAxis(sd));
        return axes;
    }

    public Axes getDistanceOrderAxes(SimData sd) {
        Axis xAxis = new Axis("Residue", Orientation.HORIZONTAL);
        Axes axes = new Axes(xAxis, getNormalYAxis(sd));
        return axes;
    }

    private Axis getNormalYAxis(SimData sd) {
        AxisFloat yAxis = new AxisFloat("Distance", Orientation.VERTICAL);
        yAxis.setRange(sd.minPos, sd.maxPos - sd.posBinWidth);
        //yAxis.setRange(0, sd.maxPos - sd.posBinWidth);
        yAxis.setDecimalFormat("0.000");
        yAxis.setupLabels(sd.numBins);
        return yAxis;
    }
}


// class that helps manages two axes at the same time.
class Axes {
    Axis xAxis;
    Axis yAxis;

    public Axes(Axis xAxis, Axis yAxis) {
        this.xAxis = xAxis;
        this.yAxis = yAxis;
    }
    public void draw(float x1, float y1, float w, float h, boolean drawXaxis) {
        float x2 = x1 + w;
        float y2 = y1 + h;
        if (yAxis != null) yAxis.drawAxis(x1, y1, x1, y2);
        if(drawXaxis)
        if (xAxis != null) xAxis.drawAxis(x1, y2, x2, y2);
    }
}

// enum that helps with axis label text alignment, tick markers, etc...
public enum Orientation {
    HORIZONTAL, VERTICAL
};

// Class that defines the common structure of any kind of axis.
// Abstract class since it does not understand the type of data to label
class Axis {
    float tickLength = 5;
    String title;
    Orientation ori;
    String[] labels;
    protected int numLabels;
    protected int numTicks;

    public void setLabels(String[] labels) {
        this.labels = labels;
        this.numLabels = labels.length;
        this.numTicks = labels.length;
    }

    protected Axis(String title, Orientation ori) {
        this.title = title;
        this.ori = ori;
    }

    public void drawAxis(float x1, float y1, float x2, float y2) {
        assert labels != null;
        assert labels.length != 0;

        // draw axis baseline
        line(x1, y1, x2, y2);

        // draw ticks and labels
        if (ori == Orientation.HORIZONTAL) {
            textAlign(CENTER, TOP);
            float tickTop = y1 - tickLength;
            float tickBot = y1 + tickLength;
            float y = y1;

            for (int i=0; i<labels.length; i++) {
                float tickX = map(i, 0, labels.length, x1, x2);
                float labelX = map(i + .5, 0, labels.length, x1, x2);
                line(tickX, tickTop, tickX, tickBot);
                text(labels[i], labelX, y);
            }
        } else { // VERTICAL axis
            textAlign(RIGHT, BOTTOM);
            float tickLeft = x1 - tickLength;
            float tickRight = x1 + tickLength;
            float x = x1;

            for (int i=0; i<labels.length; i++) {
                float tickY = map(i, 0, labels.length, y2, y1);
                float labelY = map(i, 0, labels.length, y2, y1);
                line(tickLeft, tickY, tickRight, tickY);
                text(labels[i], x, labelY);
            }
        }

        if (ori == Orientation.HORIZONTAL) {
            float x = (x1 + x2) / 2;
            float y = y1 + 20;
            textAlign(CENTER, TOP);
            text(title, x, y);
        } else { // VERTICAL ori
            float x = x1 - 70;
            float y = (y1 + y2) / 2;
            translate(x, y); 
            rotate( - HALF_PI);
            textAlign(CENTER, TOP);  
            text(title, 0, 0);
            rotate(HALF_PI);
            translate(-x, -y);
            
        }
    }
}

class AxisInt extends Axis {
    int min, max;

    public AxisInt(String title, Orientation ori) {
        super(title, ori);
    }

    public void setRange(int min, int max) {
        this.min = min;
        this.max = max;
    }

    public void setupLabels(int numLabels) {
        this.numLabels = numLabels;
        this.numTicks = numLabels;

        labels = new String[numLabels];
        for (int i=0; i<numLabels; i++) {
            labels[i] = str(floor(map(i, 0, numLabels-1, min, max)));
        }
    }
}

class AxisFloat extends Axis {
    DecimalFormat formatter = new DecimalFormat("#");
    float min, max;

    public AxisFloat(String title, Orientation ori) {
        super(title, ori);
    }

    public void setRange(float min, float max) {
        this.min = min;
        this.max = max;
    }

    public void setDecimalFormat(String format) {
        formatter = new DecimalFormat(format);
    }

    public void setupLabels(int numLabels) {
        this.numLabels = numLabels;
        this.numTicks = numLabels;

        labels = new String[numLabels];
        for (int i=0; i<numLabels; i++) {
            labels[i] = formatter.format(map(i, 0, numLabels-1, min, max));
        }
    }
}





public class BeforeAxes {

    final float X_SPACE = 20;
    final float Y_SPACE = 275;

    public BeforeAxes() {
    }

    public void setNumLabels(int xLabels, int yLabels) {
    }


    public void drawX_Axis(int[] labels)
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
        }
         else//for drawing the second view (sorted based on membrane distance)
        {
            Mapper posMapper = new Mapper(0, labels.length-1, offset + Y_AxisSpace, width - offset);
            for (int i = 0; i< labels.length; i++)
            {
                int x = (int)posMapper.map(i);
                text(labels[i]+"", x, yLocation+20);
            }
        }
    }
    public void drawY_Axis()
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
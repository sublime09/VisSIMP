// author Patrick Sullivan
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.BufferedInputStream;
import java.io.FileInputStream;

public class SimReader
{ 
    String filepath = null;
    int inputLines;
    int[] residueData;
    float[] positionData;

    public SimReader(String fp)
    {
        inputLines = 0;
        filepath = fp;
        try {
            inputLines = countLines();
        } 
        catch( IOException e) {
            e.printStackTrace();
        }
    }
    
    public SimData readFile() {
        BufferedReader bf = null;
        residueData = new int[inputLines];
        positionData = new float[inputLines];

        try {
            Progress progBar = new Progress("Reading Sim", 0, inputLines);
            bf = new BufferedReader(new FileReader(filepath));

            int lineNum = 0;
            String line = bf.readLine();
            while (line != null) {
                String [] delim = line.split("\t");
                residueData[lineNum] = Integer.parseInt(delim[0]);
                positionData[lineNum] = Float.parseFloat(delim[1]);
                progBar.tryTick(lineNum);
                lineNum++;
                line = bf.readLine();
            }

            progBar.end();
        } 
        catch (IOException e) {
            e.printStackTrace();
        }
        
        SimData sim = new SimData(residueData, positionData);
        return sim;
    }
    
    private int countLines() throws IOException {
        InputStream is = new BufferedInputStream(new FileInputStream(filepath));
        try {
            byte[] c = new byte[1024];
            int count = 0;
            int readChars = 0;
            boolean empty = true;
            while ((readChars = is.read(c)) != -1) {
                empty = false;
                for (int i = 0; i < readChars; ++i) {
                    if (c[i] == '\n') {
                        count++;
                    }
                }
            }
            return (count == 0 && !empty) ? 1 : count;
        } 
        finally {
            is.close();
        }
    }
}
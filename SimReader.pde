import java.util.Scanner;
import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
//import java.io.BufferedReader;

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

    public SimData readFile()
    {
        FileInputStream inputStream = null;
        Scanner sc = null;
        
        residueData = new int[inputLines];
        positionData = new float[inputLines];

        try {
            Progress progBar = new Progress("Reading Sim", 0, inputLines);

            inputStream = new FileInputStream(filepath);
            sc = new Scanner(inputStream);

            int lineNum = 0;
            while (sc.hasNext()) {
                residueData[lineNum] = sc.nextInt();
                positionData[lineNum] = sc.nextFloat();
                progBar.tryTick(lineNum);
                lineNum++;
            }

            // note that Scanner suppresses exceptions
            if (sc.ioException() != null) {
                sc.ioException().printStackTrace();
            }            

            progBar.end();
        } 
        catch (IOException e) {
            e.printStackTrace();
        }
        
        SimData sim = new SimData();
        sim.setInput(residueData, positionData);
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
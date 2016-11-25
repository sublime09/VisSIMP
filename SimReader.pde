import java.util.Scanner;
import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
//import java.io.BufferedReader;

public class SimReader
{ 
    String filepath = null;

    public SimReader(String fp)
    {
        filepath = fp;
    }

    public void readFile()
    {
        FileInputStream inputStream = null;
        Scanner sc = null;

        try {
            int totalLines = countLines();
            Progress progBar = new Progress("Reading Input", 0, totalLines);
            int lineNum = 0;

            inputStream = new FileInputStream(filepath);
            sc = new Scanner(inputStream);

            while (sc.hasNext()) {
                int residue = sc.nextInt();
                float pos = sc.nextFloat();
                progBar.tryTick(lineNum);
                lineNum++;
            }

            // note that Scanner suppresses exceptions
            if (sc.ioException() != null) {
                sc.ioException().printStackTrace();
            }            

            progBar.end();
        } 
        catch (FileNotFoundException e) {
            e.printStackTrace();
        } 
        catch (IOException e) {
            e.printStackTrace();
        }
    }

    public int countLines() throws IOException {
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
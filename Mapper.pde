// author Patrick Sullivan
public class Mapper
{
    float scalar;
    float minV, minR;

    public Mapper(float minV, float maxV, float minR, float maxR)
    {
        this.minV = minV;
        this.minR = minR;
        this.scalar = (maxR - minR) / (maxV - minV);
    }

    public float map(float value)
    {
        return (value - minV) * scalar + minR;
    }
    
    public float[] map(float[] vals)
    {
        float[] result = new float[vals.length];
        for (int i=0; i<vals.length; i++)
            result[i] = this.map(vals[i]);
        return result;
    }
    
    public int[] mapi(float[] vals)
    {
        int[] result = new int[vals.length];
        for (int i=0; i<vals.length; i++)
            result[i] = (int) this.map(vals[i]);
        return result;
    }
    
}
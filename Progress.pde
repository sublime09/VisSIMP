
class Progress
{
    float TICK_MS = 500;
    int BAR_LEN  = 50;

    String name;
    float start;
    float end;
    float prevTick;
    float startTick;

    float nextTime;
    float nextMark;

    public Progress(String name, float start, float end)
    {
        this.name = name;
        this.start = start;
        this.end = end;
        this.startTick = millis();
        prevTick = this.startTick;

        nextTime = millis();
        nextMark = start;
    }

    public void tryTick(float value)
    {
        float now = millis();
        //if (now - prevTick > TICK_MS)
        if (now > nextTime && value > nextMark)
        {
            println(getProg(value, now));
            //prevTick = now;
            nextTime = now + TICK_MS;
            float pct = map(value, start, end, 0, 100);
            nextMark = map(pct + 1, 0, 100, start, end);
        }
    }

    public String getProg(float value, float now)
    {
        int pct = (int) map(value, start, end, 0, 100);
        String percent = nf(pct, 2) + "%";

        int progs = (int) map(value, start, end, 0, BAR_LEN);

        StringBuilder bar = new StringBuilder("|");
        for (int i=0; i<BAR_LEN; i++)
            bar.append( i<progs ? '#' : ' ');
        bar.append("|");

        float msEnd = map(end, start, value, startTick, now);
        int secToEnd = (int) (msEnd - now) / 1000;
        String etc = "ETC: " + secToEnd + "s";

        String[] prog = {name, ":", percent, bar.toString(), etc};
        return join(prog, " ");
    }

    public void end()
    {
        float dur = millis() - startTick;
        if (dur > TICK_MS) println(name, "complete in", dur, "ms");
    }
}
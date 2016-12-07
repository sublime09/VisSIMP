class Menu
{
  int numberOfItems, x, y, totalHeight, MenuWidth;
  MenuItem[] items;
  String[] labels;
  public Menu(int n, int x, int y, int h, int w, String[] l)
  {
    labels = l;
    numberOfItems = n;
    this.x = x;
    this.y = y;
    totalHeight = h;
    MenuWidth = w;
    items = new MenuItem[n];
    int itemHeight = h/n;
    for(int i = 0; i<n; i++)
    {
      items[i] = new MenuItem(x, y + i* itemHeight, w, itemHeight, labels[i], i+1);
    }
  }
  public void draw()
  {
    fill(color(0,255,0));
    for(int i = 0; i<numberOfItems; i++)
    {
      items[i].draw();
    }
  }
  public boolean containsMouse(boolean click)
  {
    for(int i = 0; i<numberOfItems; i++)
    {
      if(items[i].containsMouse())
      {
        draw();
        if(click)
        {
          items[i].action();
        }
        return true;
      }
    }
    return false;
  }
}
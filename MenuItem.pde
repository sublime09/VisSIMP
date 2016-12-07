class MenuItem
{
  int x, y, menuWidth, menuHeight;
  int menuItemIndex;
  String Text;
  PShape menuShape;
  public MenuItem(int x, int y, int w, int h, String t, int index)
  {
    this.x= x;
    this.y = y;
    menuWidth = w;
    menuHeight = h;
    menuItemIndex = index;
    Text = t;
    menuShape = createShape(RECT, x,y,w,h);
  }
  public void draw()
  {
    //rect(x,y,menuWidth, menuHeight);
    colorMode(RGB);
    menuShape.setFill(color(0,255,0));
    shape(menuShape);
    textAlign(CENTER);
    fill(0);
    text(Text, x + menuWidth/2 ,y + menuHeight/2);
    colorMode(HSB);
  }
  public boolean containsMouse()
  {
    if(mouseX > x && mouseX <x + menuWidth && mouseY > y && mouseY < y + menuHeight)
      return true;
      else
      return false;
  }
  private void action()
  {
    switch(menuItemIndex)
    {
      case 1:
        toggleView();
        break;
      case 2:
        updateVis(currentView);
        break;
      case 3:
        simInput.increaseBins();
        updateVis(currentView);
        break;
        case 4:
        simInput.decreaseBins();
        updateVis(currentView);
        break;
        case 5:
        askForFile();
        break;
        case 6:
        save("VisSIMP.png");
        break;
        case 7:
        askForImage();
        break;
    }
  }
}
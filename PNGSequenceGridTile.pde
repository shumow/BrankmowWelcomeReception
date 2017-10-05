//***************************************************************
// uses a looping sequence of pngs to render a tile
//***************************************************************
class PNGSequenceGridTile extends AnimatedGridTile
{
    //offset to line png up with grid
  float offset[] = {0,0};
  //***************************************************************
  //origin construtor
  //***************************************************************
  public PNGSequenceGridTile(int x, int y)
  {
    super(x,y);
  }
  
  //***************************************************************
  // XML constructor
  //***************************************************************
  public PNGSequenceGridTile(XML xml)
  {
    super(xml);
  }
  
  //***************************************************************
  // actually draw this image sequence tile
  //***************************************************************
  public void draw()
  {
    pushStyle();
    
    popStyle();
    //fill me in
  }
  
  //***************************************************************
  // update tick
  //***************************************************************
  public void update(float dt)
  {
    //fill me in
  }
  
  //***************************************************************
  // load with XML
  //***************************************************************
  void loadWithXML(XML xml)
  {
    super.loadWithXML(xml);
    println("XML: Initializing " + this.getClass().getName());
  }
}

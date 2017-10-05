//***************************************************************
//parent class for all animated tiles
//***************************************************************
class AnimatedGridTile extends BaseGridTile
{
  //***************************************************************
  //origin construtor
  //***************************************************************
  public AnimatedGridTile(int x, int y)
  {
    super(x,y);
  }
  
  //***************************************************************
  // XML constructor
  //***************************************************************
  public AnimatedGridTile(XML xml)
  {
    super(xml);
  }
  
  //***************************************************************
  // actually draw this tile
  //***************************************************************
  public void draw()
  {
    //TODO
  }
  
  // update tick
  //***************************************************************
  public void update(float dt)
  {
    //TODO
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

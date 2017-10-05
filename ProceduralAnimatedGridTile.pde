//***************************************************************
// kewl computer graphics!
//***************************************************************
class ProceduralAnimatedGridTile extends AnimatedGridTile
{
    int tileColor = 0;
  //***************************************************************
  //origin construtor
  //***************************************************************
  public ProceduralAnimatedGridTile(int x, int y)
  {
    super(x,y);
  }
  
  //***************************************************************
  // XML constructor
  //***************************************************************
  public ProceduralAnimatedGridTile(XML xml)
  {
    super(xml);
  }
  
  //***************************************************************
  // actually draw this tile
  //***************************************************************
  public void draw()
  {
    pushStyle();
    //fill me in
    fill(tileColor);
    rect(0,0,40,40);
    popStyle();
  }
  
  //***************************************************************
  // update tick
  //***************************************************************
  public void update(float dt)
  {
    //fill me in
    tileColor = color(255*(1+sin(millis()/1000.f))/2,
                      255*(1+sin(20+millis()/900.f))/2,
                      255*(1+sin(3+millis()/222.f))/2);
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

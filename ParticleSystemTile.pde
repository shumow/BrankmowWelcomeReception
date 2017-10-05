class ParticleSystemTile extends AnimatedGridTile
{
  class particle{}
  float lifetime = 0;
  //***************************************************************
  //origin construtor
  //***************************************************************
  public ParticleSystemTile(int x, int y)
  {
    super(x,y);
  }
  
  //***************************************************************
  // XML constructor
  //***************************************************************
  public ParticleSystemTile(XML xml)
  {
    super(xml);
  }
  
  //***************************************************************
  // actually draw this tile
  //***************************************************************
  public void draw()
  {
    //TODO
    pushStyle();
    
    popStyle();
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

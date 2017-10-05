class SkyTile extends ProceduralAnimatedGridTile
{
  int tileColor = 0;
  
  boolean is_right = false;
  boolean is_left = false;
  boolean is_top = false;
  boolean is_cloudlayer = false;
  
  int upx;
  int upy;

  void setTileColor()
  {
    tileColor = color(135,206,235);
  }

  
  //***************************************************************
  //origin construtor
  //***************************************************************
  public SkyTile(int x, int y)
  {
    super(x,y);
    setTileColor();
  }
  
  //***************************************************************
  // XML constructor
  //***************************************************************
  public SkyTile(XML xml)
  {
    super(xml);
    setTileColor();
  }
  
  //***************************************************************
  // actually draw this tile
  //***************************************************************
  public void draw()
  {
    float[][] bases = gridTiles.getBasisVectors();
    dg.pushStyle();
    dg.noStroke();
    dg.fill(tileColor);
    dg.beginShape(TRIANGLE_STRIP);
      dg.vertex(0, 0);
      dg.vertex(bases[0][0], bases[0][1]);
      dg.vertex(bases[1][0], bases[1][1]);
      dg.vertex(bases[0][0] + bases[1][0], bases[0][1] + bases[1][1]); 
    dg.endShape();

    dg.popStyle();
  }
  
  //***************************************************************
  // update tick
  //***************************************************************
  public void update(float dt)
  {

  }
  
  //***************************************************************
  // load with XML
  //***************************************************************
  void loadWithXML(XML xml)
  {    
    super.loadWithXML(xml);
    println("XML: Initializing " + this.getClass().getName());
 
    if (xml.hasAttribute("isright"))
    {
      is_right = true;
    }
    
    if (xml.hasAttribute("isleft"))
    {
      is_left = true;
    }
    
    if (xml.hasAttribute("isTop"))
    {
      is_top = true;
    }
    
    boolean has_upx;
    boolean has_upy;

    has_upx = xml.hasAttribute("upx");
    has_upy = xml.hasAttribute("upy");

    // if we only have one of these there's an error
    //if (has_upx ^ has_upy)    
  }
}

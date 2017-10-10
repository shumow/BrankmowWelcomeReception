//***************************************************************
// mother of all tiles
//***************************************************************
class BaseGridTile implements XMLLoadable
{
  //the origin coordinates on the grid at which this tile lives
  int[] position = {0,0};
  int[] size = {1,1};
  
  int tintColor = color(255);
    float colorShiftOffset[]= new float[]{random(TWO_PI),random(TWO_PI)};;
  float colorShiftSpd[] =new float[]{ random(.1), random(.1)};
    
  private ArrayList<BaseGridTile> subTiles = new ArrayList<BaseGridTile>();
  private BaseGridTile parentTile;
  
  //***************************************************************
  //origin construtor
  //***************************************************************
  public BaseGridTile(int x, int y)
  {
    position = new int[]{x,y};
  }
  
  //***************************************************************
  //origin + size construtor
  //***************************************************************
  public BaseGridTile(int x, int y, int w, int h)
  {
    position = new int[]{x,y};
    size = new int[]{w,h};
    
    createSubTiles();
  }
  
  //***************************************************************
  // XML constructor
  //***************************************************************
  public BaseGridTile(XML xml)
  {
    loadWithXML(xml);
    createSubTiles();
  }
  
  //create empty tiles to take up the area of the tile 
  protected void createSubTiles()
  {
    for(int i =0; i< size[0]; i++)
    {
      for(int j =0; j< size[1]; j++)
      {
        if( !(i == 0 && j== 0)) //don't add ourself
        {
          BaseGridTile bgt = new BaseGridTile(position[0]+i,position[1]+j);
          bgt.parentTile = this;
          subTiles.add(bgt);
        }
      }
    }
    //println("added " + subTiles.size() + " subtiles");
  }
  
  public GridPos getPosition()
  {
    return new GridPos(position[0], position[1]);
  }
  
  @Override public boolean equals(Object o) 
  {
    return (o instanceof BaseGridTile) && (this.position[0] == ((BaseGridTile) o).position[0]) && (this.position[1] == ((BaseGridTile) o).position[1]);
  }
  
  @Override public int hashCode()
  {
    // Right now I'm just using a hypothetical max dimension of 2^(2^4) + 1 (Fermat-4)
    // a better solution would be to make the GridPos aware of the actual dimensions of
    // the grid that we are using.
    int R = (1 << 16) + 1;
    
    return ((this.position[0] + R) + 2*R*(this.position[1]+R));
  }
  
  //***************************************************************
  // actually draw this tile - do nothing base call
  //***************************************************************
  public void draw()
  {
    dg.pushStyle();
    
    dg.popStyle();
  }
  
  //***************************************************************
  // update tick
  //***************************************************************
  public void update(float dt)
  {
    tintColor = color(80*(1+sin(position[0] + colorShiftOffset[0]+ colorShiftSpd[0]*millis()/1000.f))/2,
                      165*(1+sin(position[0] + colorShiftOffset[1]+ colorShiftSpd[1]*millis()/1000.f))/2,
                      0);
  }

  
  //***************************************************************
  // load with XML
  //***************************************************************
  void loadWithXML(XML xml)
  {
    println("XML: Initializing " + this.getClass().getName());
    position[0] = xml.getInt("x");
    position[1] = xml.getInt("y");
    println("position: " + position[0] + ", " + position[1]);
    
    //enforce a minimum size dimension '1'
    size[0] = max(1,xml.getInt("w"));
    size[1] = max(1,xml.getInt("h"));
    println("size: " + size[0] + ", " + size[1]);
  }
}

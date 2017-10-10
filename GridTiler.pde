import java.util.Hashtable;
boolean populate_tiles = true;

class GridPos 
{
  int x;
  int y;
  
  GridPos()
  {
    x = y = MAX_INT;
  }
  
  GridPos(int ix, int iy)
  {
    x = ix;
    y = iy;
  }

  @Override public boolean equals(Object o)
  {
    return (o instanceof GridPos) && ((((GridPos) o).x == this.x) && (((GridPos) o).y == this.y));
  }
  
  @Override public int hashCode()
  {
    // Right now I'm just using a hypothetical max dimension of 2^(2^4) + 1 (Fermat-4)
    // a better solution would be to make the GridPos aware of the actual dimensions of
    // the grid that we are using.
    int R = (1 << 16) + 1;
    
    return ((x + R) + 2*R*(y+R));
  }
}

//***************************************************************
// grid responsible for managing, drawingm and updating all of the
// animated an non animated tiles
//***************************************************************
class GridTiler implements XMLLoadable
{
  protected float[] xAxis = {39,5};
  protected float[] yAxis = {5,13};
  protected float[] origin = {0,0};
  
  //  table of tiles that come from xml
  Hashtable<GridPos,BaseGridTile> xmlTiles = new Hashtable<GridPos,BaseGridTile>();
  //table of tile that we generate ourselves
  Hashtable<GridPos,BaseGridTile> genTiles = new Hashtable<GridPos,BaseGridTile>();

  //ArrayList<BaseGridTile> xmlTiles = new ArrayList<BaseGridTile>();
  //ArrayList<BaseGridTile> genTiles = new ArrayList<BaseGridTile>();
  //  table of tiles that come from xml
//  Hashtable<pos,BaseGridTile> xmlTiles = new Hashtable<pos,BaseGridTile>();
  //table of tile that we generate ourselves
//  Hashtable<pos,BaseGridTile> genTiles = new Hashtable<pos,BaseGridTile>();
  //***************************************************************
  // xml - xml object containing serialized object
  //***************************************************************
  public GridTiler(XML xml)
  {
    loadWithXML(xml);
    if (populate_tiles) {
      populateNearbyTiles();
    }
  }
  //***************************************************************
  // graphscale: scale of unit vectors
  // xAxisTheta: radian measurement of the xaxis
  // yAxisTheta: radian measurement of the yaxis
  //***************************************************************
  public GridTiler(float graphScale, float xAxisTheta, float yAxisTheta)
  {
    this(new float[]{width/2.f,height/2.f}, graphScale, xAxisTheta, yAxisTheta);
  }
  
  //***************************************************************
  // origin: 2d vector screen space offset
  // graphscale: scale of unit vectors
  // xAxisTheta: radian measurement of the xaxis
  // yAxisTheta: radian measurement of the yaxis
  //***************************************************************
  public GridTiler(float[] origin, float graphScale, float xAxisTheta, float yAxisTheta)
  {
    this.origin = origin;
    xAxis = new float[]{graphScale*cos(xAxisTheta),
                        graphScale*sin(xAxisTheta)};
  
    yAxis = new float[]{graphScale*cos(yAxisTheta),
                        graphScale*sin(yAxisTheta)}; 
  }

  //***************************************************************
  // populate nearby tiles (with a terrible O(n^2) alg because I 
  // can't figure out how to get java's hash maps or hash tables 
  // to do what I want them to here... 
  //***************************************************************
  private void populateNearbyTiles()
  {
    int[] dims = {-25,0};
    for(int i = dims[0]; i < dims[1]; i++)
    {
      for(int j = dims[0]; j < dims[1]; j++)
      {
        boolean occupied = isTileOccupied(i,j,3,3);
        if(!occupied)
        {
          addRandomTile(i,j,3,3);
        }
        
        occupied = isTileOccupied(i,j,2,2);
        if(!occupied)
        {
          addRandomTile(i,j,2,2);
        }
        
//        occupied = isTileOccupied(i,j,2,1);
//        if(!occupied)
//        {
//          addRandomTile(i,j,2,1);
//        }
        
        occupied = isTileOccupied(i,j,1,1);
        if(!occupied)
        {
          addRandomTile(i,j,1,1);
        }
      }
    }
  }

  void addRandomTile(int x, int y, int w, int h)
  {
    
    BaseGridTile tile = null;
    if(w==3 && h ==3)
    {
    
      if(random(1) > .5)
      {
        String[] names = {"terrain_block1-3x3.png","terrain_wave1-3x3.png","terrain_star1-3x3.png","leaves3x3-0x75.png","bldg3x3-0x75.png","leafs3x3-0x75.png","sand3x3-0x75.png"};
        int rndIndex = (int)(random(names.length));
        tile = new PNGGridTile(new int[]{x,y}, new int[]{3,3}, new float[]{0,75},names[rndIndex] );
      }
      else
      {
        
        tile = new StaticProceduralTile(x,y,3,3);
      }
    }
    else if(w==2 && h ==2)
    {
        if(random(1) > .5)
        {
          tile = new StaticProceduralTile(x,y,2,2);
        }
        else
        {
          String[] names = {"metal2x2-0x50 copy.png","grass2x2-0x50.png"};
          int rndIndex = (int)(random(names.length));
          tile = new PNGGridTile(new int[]{x,y}, new int[]{2,2}, new float[]{0,50},names[rndIndex] );
        }
      
    }
    else if(w==2 && h == 1)
    {
          String[] names = {"text2x1-0x25.png"};
          int rndIndex = (int)(random(names.length));
          tile = new PNGGridTile(new int[]{x,y}, new int[]{2,1}, new float[]{0,75},names[rndIndex] );
    }
    else if(w==1 && h ==1)
    {
        if(random(1) > .5)
        {
          tile = new StaticProceduralTile(x,y,1,1);
        }
        else
        {
          String[] names = {"corn1x1-0x25.png"};
          int rndIndex = (int)(random(names.length));
          tile = new PNGGridTile(new int[]{x,y}, new int[]{1,1}, new float[]{0,25},names[rndIndex] );
        }
    }
    addTile(genTiles,tile);
  }

  boolean isTileOccupied(int x, int y, int w, int h)
  {
    boolean occupied = false;

    for(int i = 0; i < w; i++)
    {
      for(int j = 0; j < h; j++)
      {
        BaseGridTile tile = xmlTiles.get(new GridPos(x+i,y+j));
        if (null != tile)
        {
          occupied = occupied || ((tile.position[0] == x+i) && (tile.position[1] == y+j));
        }
      }
    }  
    
    for(int i = 0; i < w; i++)
    {
      for(int j = 0; j < h; j++)
      {
        BaseGridTile tile = genTiles.get(new GridPos(x+i,y+j));
        if (null != tile)
        {
          occupied = occupied || ((tile.position[0] == x+i) && (tile.position[1] == y+j));
        }
      }
    }  

    return occupied;
  }
  
  Hashtable<GridPos,BaseGridTile> getGenTiles()
  {
    return new Hashtable<GridPos,BaseGridTile>(genTiles);
  }

  //***************************************************************
  // updates all tiles and the grid itself
  //***************************************************************
  void update(float dt)
  { 
    for(BaseGridTile tile : xmlTiles.values())
    {
      tile.update(dt);
    }
    for(BaseGridTile tile : genTiles.values())
    {
      tile.update(dt);
    }
  }

  //***************************************************************
  // draws all tiles and the grid itself
  //***************************************************************
  void draw()
  {
    dg.pushMatrix();
    dg.translate(origin[0],origin[1]);
//    background(255,0,0);
    for(BaseGridTile tile : xmlTiles.values())
    {
      dg.pushMatrix();
      dg.translate(tile.position[0]*xAxis[0] + tile.position[1]*yAxis[0], 
                tile.position[0]*xAxis[1] + tile.position[1]*yAxis[1]);
      tile.draw();
//println("tile.position: " + tile.position[0] + ", " + tile.position[1]);
      dg.popMatrix();
    }
    
    for(BaseGridTile tile : genTiles.values())
    {
      dg.pushMatrix();
      dg.translate(tile.position[0]*xAxis[0] + tile.position[1]*yAxis[0], 
                tile.position[0]*xAxis[1] + tile.position[1]*yAxis[1]);
      tile.draw();
//println("tile.position: " + tile.position[0] + ", " + tile.position[1]);
      dg.popMatrix();
    }
    dg.popMatrix();
  }
 

  //***************************************************************
  // grabs the basis vectors from us
  //***************************************************************
  float[][] getBasisVectors()
  {
    return new float[][]{{xAxis[0],xAxis[1]},{yAxis[0],yAxis[1]}};
  }
  
  //***************************************************************
  // load fresh from disk
  //***************************************************************
  void loadWithXML(XML xml)
  {
    //init properties
    println("XML: Initializing " + this.getClass().getName());
    
    float graphScale = xml.getFloat("scale");
    println("graphScale: " + graphScale);
    
    XML xAxisElem = xml.getChild("xAxis");
    xAxis[0] = xAxisElem.getFloat("x");
    xAxis[1] = xAxisElem.getFloat("y");
    println("xaxis: " + xAxis[0] + ", " + xAxis[1]);

    XML yAxisElem = xml.getChild("yAxis");
    yAxis[0] = yAxisElem.getFloat("x");
    yAxis[1] = yAxisElem.getFloat("y");
    println("yaxis: " + yAxis[0] + ", " + yAxis[1]);

    // apply scaling
    xAxis[0] *= graphScale; xAxis[1] *= graphScale;
    yAxis[0] *= graphScale; yAxis[1] *= graphScale;

    
    XML originElem = xml.getChild("origin");
    origin[0] = originElem.getFloat("x");
    origin[1] = originElem.getFloat("y");
    println("origin: " + origin[0] + ", " + origin[1]);
    
    //create babies!!!
    XML tileXML = xml.getChild("Tiles");
    XML[] tileElems = tileXML.getChildren();
    for(int i = 0; i < tileElems.length; i++)
    {
      XML currentTileXML = tileElems[i];
      String className = currentTileXML.getName();
      BaseGridTile tile = null;
      if(className == "BaseGridTile")
      {  tile = new BaseGridTile(currentTileXML); }
      else if(className == "AnimatedGridTile")
      {  tile = new AnimatedGridTile(currentTileXML); }
      else if(className == "PNGGridTile")
      {  tile = new PNGGridTile(currentTileXML); }
      else if(className == "PNGSequenceGridTile")
      {  tile = new PNGSequenceGridTile(currentTileXML); }
      else if(className == "ProceduralAnimatedGridTile")
      {  tile = new ProceduralAnimatedGridTile(currentTileXML); }
      else if(className == "StaticProceduralTile")
      {  tile = new StaticProceduralTile(currentTileXML); }
      else if(className == "AnimatedGridTile")
      {  tile = new AnimatedGridTile(currentTileXML); }
      else if(className == "RiverTile")
      {  tile = new RiverTile(currentTileXML,xAxis,yAxis); }
      else if(className == "SkyTile")
      {  tile = new SkyTile(currentTileXML); }
      else if (className == "#text")
      { /*do nothing empty whitespace nodes.*/}
      else
      {
        println("XML: Error! Encountered unknown tile with class: " + className);
        println("XML: CONTENTS:\n    " + currentTileXML.format(0) + ":ENDCONTENTS");
      }
      if(tile != null)
      {
//          tiles.add(new pos(tile.position[0],tile.position[0]),tile);
//         xmlTiles.add(tile);
         addTile(xmlTiles,tile);
      }
    }
  }
  
  void addTile(Hashtable<GridPos,BaseGridTile> list, BaseGridTile tile)
  {
    GridPos p = new GridPos(tile.position[0], tile.position[1]);
    
    if (null != genTiles.get(p))
    {
      return;
    }   
    list.put(p, tile);
    for(BaseGridTile t : tile.subTiles)
    {
      GridPos sp = new GridPos(t.position[0], t.position[1]);      
      list.put(sp, t);
    }
  }
  
  void removeTileAt( int x, int y)
  {
    for(BaseGridTile tile : genTiles.values()) 
    {
      if(tile.position[0] == x && tile.position[1] == y )
      {
        removeTile(genTiles, tile);
        return;
      }
    }
  }
  
  //removes a tile from the grid and its children and its parent
  void removeTile(Hashtable<GridPos,BaseGridTile> list, BaseGridTile tile)
  {
    if (null == tile)
    {
      return;
    }

    GridPos p = tile.getPosition();
    
    if(tile == list.remove(p))  // could be a bug if we ever have multiple tiles loaded at the same position
    {
      removeTile(list,tile.parentTile);
      tile.parentTile = null;
      for(BaseGridTile t : tile.subTiles)
      {
        removeTile(list,t);
      }
      tile.subTiles.clear();
    }
  }
}




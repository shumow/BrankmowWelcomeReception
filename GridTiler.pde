import java.util.Hashtable;
boolean populate_tiles = true;

//***************************************************************
// grid responsible for managing, drawingm and updating all of the
// animated an non animated tiles
//***************************************************************
class GridTiler implements XMLLoadable
{
  protected float[] xAxis = {20,5};
  protected float[] yAxis = {5,20};
  protected float[] origin = {0,0};
  
  ArrayList<BaseGridTile> xmlTiles = new ArrayList<BaseGridTile>();
    ArrayList<BaseGridTile> genTiles = new ArrayList<BaseGridTile>();
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
    int[] dims = {-12,12};
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
    for(BaseGridTile tile : xmlTiles) 
    {
      for(int i = 0; i < w; i++)
      {
        for(int j = 0; j < h; j++)
        {
          occupied = occupied || ((tile.position[0] == x+i) && (tile.position[1] == y+j));
        }
      }  
    }
    
    for(BaseGridTile tile : genTiles) 
    {
      for(int i = 0; i < w; i++)
      {
        for(int j = 0; j < h; j++)
        {
          occupied = occupied || ((tile.position[0] == x+i) && (tile.position[1] == y+j));
        }
      }  
    }
    return occupied;
  }

  ArrayList<BaseGridTile> getGenTiles()
  {
    return new ArrayList<BaseGridTile>(genTiles);
  }

  //***************************************************************
  // updates all tiles and the grid itself
  //***************************************************************
  void update(float dt)
  { 
    for(BaseGridTile tile : xmlTiles)
    {
      tile.update(dt);
    }
    for(BaseGridTile tile : genTiles)
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
    for(BaseGridTile tile : xmlTiles)
    {
      dg.pushMatrix();
      dg.translate(tile.position[0]*xAxis[0] + tile.position[1]*yAxis[0], 
                tile.position[0]*xAxis[1] + tile.position[1]*yAxis[1]);
      tile.draw();
//println("tile.position: " + tile.position[0] + ", " + tile.position[1]);
      dg.popMatrix();
    }
    
    for(BaseGridTile tile : genTiles)
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
  
  void addTile(ArrayList<BaseGridTile> list, BaseGridTile tile)
  {
    for(BaseGridTile t : genTiles) 
    {
      if(t.position[0] == tile.position[0] && t.position[1] == tile.position[1])
        return;
    }   
    list.add(tile);
    for(BaseGridTile t : tile.subTiles)
    {
      list.add(t);
    }
  }
  
  void removeTileAt( int x, int y)
  {
    for(BaseGridTile tile : genTiles) 
    {
      if(tile.position[0] == x && tile.position[1] == y )
      {
        removeTile(genTiles, tile);
        return;
      }
    }
  }
  
  //removes a tile from the grid and its children and its parent
  void removeTile(ArrayList<BaseGridTile> list, BaseGridTile tile)
  {
    if(list.remove(tile))
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




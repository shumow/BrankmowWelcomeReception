class TileChanger
{
  float tickDown = 15+random(15);
  GridTiler tiler;
  ArrayList<int[]> switchedTiles = new ArrayList<int[]>();
  ArrayList<int[]> unswitchedTiles  = new ArrayList<int[]>();;
  
  public TileChanger(GridTiler tiles)
  {
    this.tiler = tiles;
    reset();
  }
  
  boolean isComplete()
  {
    return unswitchedTiles.size() == 0;
  }
  void reset()
  {
    switchedTiles.clear();
    unswitchedTiles.clear();
    for(BaseGridTile bgt : this.tiler.getGenTiles().values())
    {
      unswitchedTiles.add(bgt.position);
    } 
  }
  
  void update(float dt)
  {
    tickDown -= dt;
  }
}

class RadialTileChanger extends TileChanger
{
  float[] centerPos = {0,0};
  float expansionRate = 8.1;
  float radius = 0;
  public RadialTileChanger(GridTiler tiles, float[] center)
  {
    super(tiles);
    centerPos = center;
  }
  
  void update(float dt)
  {
    tickDown -= dt;
    if(!isComplete())
    {
      radius += dt*expansionRate;
      ArrayList<int[]> newTiles = new ArrayList<int[]>();
      for(int[] pos : this.unswitchedTiles)
      {
        if(dist(centerPos[0],centerPos[1],pos[0],pos[1]) < radius)
        {
          newTiles.add(pos);
        }
      }
      
      for(int[] pos : newTiles)
      {
        this.tiler.removeTileAt(pos[0],pos[1]);
      }
      this.unswitchedTiles.removeAll(newTiles);
      switchedTiles.addAll(newTiles);
      if(newTiles.size() > 0)
      {
        this.tiler.populateNearbyTiles();
      }
    }
    if(tickDown < 0)
      reset();
  }
  
  void reset()
  {
    //println("sakjhdkasjhdkajshdkjashd");
    super.reset();
    tickDown = random(15)+15;
    expansionRate = 4+random(8);
    radius = 0;
    centerPos = new float[]{random(20)-10,random(20)-10};
  }
  
}

class LinearTileChanger extends TileChanger
{
  float[] centerPos = {0,0};
  float expansionRate = 10.1;
  float radius = 0;
  public LinearTileChanger(GridTiler tiles, float[] center)
  {
    super(tiles);

  }
  
  void update(float dt)
  {
    radius += dt*expansionRate;
    ArrayList<int[]> newTiles = new ArrayList<int[]>();
    for(int[] pos : this.unswitchedTiles)
    {
      if(dist(centerPos[0],centerPos[1],pos[0],pos[1]) < radius)
      {
        newTiles.add(pos);
      }
    }
    
    for(int[] pos : newTiles)
    {
      this.tiler.removeTileAt(pos[0],pos[1]);
    }
    this.unswitchedTiles.removeAll(newTiles);
    switchedTiles.addAll(newTiles);
    this.tiler.populateNearbyTiles();
  }
  
  void reset()
  {
    super.reset();
    radius = 0;
  }
  
}

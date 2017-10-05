//***************************************************************
// tile with contents that are procedural but don't animate
//***************************************************************
class StaticProceduralTile extends BaseGridTile
{
  PImage paw;

  PGraphics pg;
  float t = 0;
  //***************************************************************
  //origin construtor
  //***************************************************************
  public StaticProceduralTile(int x, int y)
  {
    super(x,y);
  }
  
    //***************************************************************
  //origin construtor
  //***************************************************************
  public StaticProceduralTile(int x, int y, int w, int h)
  {
    super(x,y,w,h);
    pg = createGraphics(50,50);
    paw = loadImage("paw.png");
  }
  
  //***************************************************************
  // XML constructor
  //***************************************************************
  public StaticProceduralTile(XML xml)
  {
    super(xml);
  }
  
  public void update(float dt)
  {
    super.update(dt);
    t = (t+dt)%10.f;
    pg.beginDraw();
    pg.fill(0,0,0,6);
    pg.rect(0,0,pg.width,pg.height);
pg.tint(tintColor);
    pg.noStroke();
    pg.fill(tintColor);
    if(random(1) > .7)
    {
     pg.pushMatrix(); 
     pg.translate(random(pg.width),random(pg.height));
     pg.rotate(random(TWO_PI));
    pg.image(paw,0,0,10,10);
    pg.popMatrix();
    
    }
//      pg.ellipse(random(pg.width),random(pg.width),10,10);
 
    pg.endDraw();

//    pg.image(pg,-ofs,-ofs);//,pg.width+ofs,pg.height+ofs);  
}
  
  //***************************************************************
  // actually draw this tile
  //***************************************************************
  public void draw()
  {
    //Temporary
    
    float[][] bases = gridTiles.getBasisVectors();
    pushStyle();
      fill(random(255),0,0);
      textureMode(NORMAL); //use tex coord 0-1
      noStroke();
      beginShape(TRIANGLE_STRIP);
      texture(pg);
      vertex(0,0,0,0);
      vertex(bases[0][0]*size[0],
             bases[0][1]*size[0],1,0);       
             
      vertex(bases[1][0]*size[1],
             bases[1][1]*size[1],0,1);
      vertex(bases[0][0]*size[0] + bases[1][0]*size[1],
             bases[0][1]*size[0] + bases[1][1]*size[1],1,1); 
      endShape();
    popStyle();
  }
  
  //***************************************************************
  // load with XML
  //***************************************************************
  void loadWithXML(XML xml)
  {
    super.loadWithXML(xml);
    println("XML: Initializing " + this.getClass().getName());
    size = new int[2];
    size[0] = xml.getInt("w");
    size[1] = xml.getInt("h");
    println("size: " + size[0] + ", " + size[1]);
  }
}

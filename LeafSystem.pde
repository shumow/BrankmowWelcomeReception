static final boolean leafs_fall = true;

static final float fullScreenFallTime = 4.0;
static final float tumblesPerFullScreenFall = 5;
static final float maxRotationalVelocity = 5*TWO_PI/fullScreenFallTime;
static final float[] rotationDirections = {-1,1};

static final float leaf_img_sz = 50.0;

class LeafSystem {

  class Point {    
    float x;
    float y;
    
    Point(float ix, float iy) {
      x = ix;
      y = iy;
    }
    
    Point(Point o) {
      x = o.x;
      y = o.y;
    }
  }
  
  class Leaf {
    Point pt;
    
    boolean falling;
    boolean offScreen;

    PImage img;
    
    float rad;
    float rotateDir;
    float rotationalVelocity;
    color c;

    float leaf_bound;


    color randLeafColor() {
      float r,g;
      if (1 < random(4)) {
        r = random(128, 255);
        g = random(r-128);
      } else {
        r = 128 + random(128);
        g = 128 + random(r - 128);
      }
      return color(r,g,0);
    }    
    Leaf(Point ipt, PImage iimg) {
      pt = ipt;
      img = iimg;
      falling = false;
      offScreen = false;
      
      if (!ROTATE_DISPLAY) {
        leaf_bound = height;
      } else {
        leaf_bound = width;
      }
      
      rad = random(-PI, PI);  // this should be where the position gets set.
      rotateDir = rotationDirections[int(random(2))];
      c = randLeafColor();
    }
    
    void draw() {
      dg.pushMatrix();
        dg.pushStyle();
          dg.translate(pt.x, pt.y);
          dg.tint(c);
          dg.rotate(rad);
          dg.image(img, 0, 0, leaf_img_sz, leaf_img_sz);
        dg.popStyle();
      dg.popMatrix();
      
    }
    
    void update(float dt) {
      if (!leafs_fall) {
        return;
      }
      
      if (falling) {
        pt.y += dt*(800.0/fullScreenFallTime);
        rad += dt*rotateDir*rotationalVelocity;
        if ((leaf_bound + leaf_img_sz/2) < pt.y) {
          offScreen = true;
        }
      } else {
        float s = dt/30.0;
        float p = random(1);
        
        if (p < s) {
          falling = true;
          rotationalVelocity = maxRotationalVelocity*random(.2,1);
        }
      }
      
    }
  }
  
  ArrayList<Point> leafSpawnPts;
  
  PGraphics pg;
  PImage img = null;
  
  PImage[] leafImages;
  
  Leaf[] leaves;
  
  float radius;

  String fileName;

  boolean spawn_leaves;

  void drawBackgroundImg() {
    pg.pushMatrix();
    if(!ROTATE_DISPLAY)
    { 
      pg.translate(0,width);
      pg.rotate(-PI/2);
    } 
    
    pg.background(img); 
    pg.popMatrix();
  }

  // create a leaf
  LeafSystem(float Radius, String FileName, int leafCount){

    leafSpawnPts = new ArrayList<Point>();

    fileName = dataPath(FileName);
    loadLeafSystemFile();
    
    pg = createGraphics(600, 800);
    pg.beginDraw();
    if (null == img) {
      pg.background(color(0),0);
    } else {
      drawBackgroundImg();
    }
    pg.fill(color(255,255,0));
    pg.noStroke();
    pg.endDraw();
    radius = Radius;
    
    leaves = new Leaf[leafCount];
    loadLeafImages();
  }
  
  // go through our mask and add points for anything that isn't pure
  // black and clear...
  void ingestLeafData() {
    img.loadPixels();
    for (int y = 0; y < img.width; y++) {
      for (int x = 0; x < img.height; x++) {
        if (0 != img.pixels[y *img.width + x]) {
          //println("adding spawnpoint " + i + "," + j);
          leafSpawnPts.add(new Point(x, y)); // I don't know why these are reveresed...
        }
      }
    }
    if (0 == leafSpawnPts.size()) {
      leafSpawnPts.add(new Point(width, height));
    }
    println(this.getClass() + ": Number of ingested leaf spawn points " + leafSpawnPts.size());

    if (0 == leafSpawnPts.size()) {
      println(this.getClass() + ": No leaf spawn points, not spawning leaves.");
      spawn_leaves = false;
    } else {
      spawn_leaves = true;
    }
  }
  
  // load leaf file from disk and ingest it.
  void loadLeafSystemFile() {
    File f = new File(fileName);
    
    if (f.exists()) {
      // here we don't use the image cache,
      // because this file can be saved and reloaded.
      img = loadImage(fileName);
      ingestLeafData();
    }
    else
    {
      println(fileName + " doesn't exist - We are probably going to crash now.");
    }
  }

// save the leaf region to disk
  void saveLeafSystemFile() {
    pg.save(fileName);
    loadLeafSystemFile();
    pg.beginDraw();
    pg.clear();
    drawBackgroundImg();    
    pg.endDraw();
  }

  void loadLeafImages() {
    leafImages = new PImage[4];
    leafImages[0] = loadCachedPNGFile("leaf1.png");
    leafImages[1] = loadCachedPNGFile("leaf2.png");
    leafImages[2] = loadCachedPNGFile("leaf3.png");
    leafImages[3] = loadCachedPNGFile("leaf4.png");
  }

  // draws an ellipse at x,y with radius 'radius'
  void addSpawnPoint(int x, int y) {
    pg.beginDraw();
    pg.ellipse(x, y, radius, radius);
    pg.endDraw();
  }
  
  //perform post-processing on the mask file - modifying the alpha channel
  // and then save it to file
  void finishSpawnMask() {
    pg.beginDraw();
    for (int i = 0; i < pg.width; i++) {
      for (int j = 0; j < pg.height; j++) {
        color c = pg.get(i,j);
        if (0 != alpha(c)) {
          pg.set(i,j, color(red(c),green(c),blue(c),64));
        }
      }
    }
    pg.endDraw();
    saveLeafSystemFile();
  }
  
  void displaySpawnData(){
    dg.pushMatrix();
      if (ROTATE_DISPLAY) {
        dg.translate(0,height);
        dg.rotate(-PI/2);
      }
      dg.image(pg, 0, 0);
    dg.popMatrix();
  }
  
  Point getRandomSpawnPoint() {
    Point p = new Point(leafSpawnPts.get(int(random(leafSpawnPts.size()))));
    return p;
  }
  
  Leaf spawnLeaf() {
    if (!spawn_leaves)
    {
      return null;
    }

    Point p = getRandomSpawnPoint();
    PImage leafImg = leafImages[int(random(leafImages.length))];
    Leaf newLeaf = new Leaf(p, leafImg);
    
    return newLeaf;
    
  }
  
  void spawn() {
    if (!spawn_leaves)
    {
      return;
    }
    
    if(leafSpawnPts == null || leafSpawnPts.size() <1)
    {
      println(this.getClass() + " we got a damn problem.");
      return;
    }
    for (int i = 0; i < leaves.length; i++) {
      leaves[i] = spawnLeaf();
    }
  }
  
  //render the leaf system
  void draw() {
    if (!spawn_leaves)
    {
      return;
    }

    dg.pushMatrix();

    if (ROTATE_DISPLAY) {
      dg.translate(0,height);
      dg.rotate(-PI/2);
    }
    
    try{
      //println("drawing leaves.");
      dg.imageMode(CENTER);
      for (Leaf l : leaves) {
        l.draw();
      }
      dg.imageMode(CORNER);
    }
    catch(Exception e)
    {
//      println(this.getClass() + ":draw: " + e);
    }
    dg.popMatrix();
  }
  
  
  void update(float dt) {
     if (!spawn_leaves ||
        !leafs_fall)
    {
      return;
    }

   for (int i=0; i < leaves.length; i++) {
      leaves[i].update(dt);
      if (leaves[i].offScreen) {
        leaves[i] = spawnLeaf();
      }
    }
  }
}


//***************************************************************
//falling leaves app
//***************************************************************
final boolean DEBUG_MODE = true;
final boolean ROTATE_DISPLAY = false;
static boolean display_tree = true;
static PImage imgTree = null;
static PImage imgSilhouette = null; 
static GridTiler gridTiles;
float lastEndTick = 0;

static boolean edit_mode = false;
static boolean display_leaf_system = false;
static boolean display_leaves = true;
static boolean crop_line = false;
static boolean draw_crop_line = false;

static float cropX;

static LeafSystem leafs;

RadialTileChanger tileChanger;

static PGraphics dg;

static int screenWidth = 1920;
static int screenHeight = 1080;

//FluidMotionReceiver fmr;
//***************************************************************
// called to set everything up
//***************************************************************
void setup()
{
  if(!ROTATE_DISPLAY)
  { size(screenWidth,screenHeight,P2D); }
  else
  { size(screenHeight,screenWidth,P2D); }
  if (!DEBUG_MODE) {
    noCursor();
  }
  
  dg = g;
  
  XML xml = loadXML("GridTiler.xml");
  if(DEBUG_MODE)
  { gridTiles = new GridTool(xml);}//new float[]{width/2,height/2},50, PI/3, 2*PI/3.f);
  else
  { gridTiles = new GridTiler(xml); }
 
  gridTiles.loadWithXML(xml);
  
  tileChanger = new RadialTileChanger(gridTiles,new float[]{0,0});
  leafs = new LeafSystem(50, "leafSystem.png", 200);
  leafs.spawn();
  
  imgTree = loadImage("treeoverlay.png");
  imgSilhouette = loadImage("treesilhouette.png");
  
  println("classname: " + super.getClass().getSuperclass());
//  fmr = new FluidMotionReceiver(this,"videoFluidSyphon");
}

void drawTree()
{
  dg.pushMatrix();
  if(!ROTATE_DISPLAY)
  { 
    dg.translate(0,width);
  } else { 
    dg.translate(0,height);
  }
  dg.rotate(-PI/2);
  
  dg.pushStyle();
  dg.imageMode(CORNER);
  dg.image(imgTree, 0, 0);
  dg.popStyle();  
  dg.popMatrix();
}

void drawSilhouette()
{
  dg.pushMatrix();
  if(!ROTATE_DISPLAY)
  { 
    dg.translate(0,width);
  } else { 
    dg.translate(0,height);
  }
  dg.rotate(-PI/2);
  
  dg.pushStyle();
  dg.imageMode(CORNER);
  dg.image(imgSilhouette, 0, 0);
  dg.popStyle();  
  dg.popMatrix();
}


//***************************************************************
// our looping function called once per tick
// resposible for drawing AND updating... everything
//***************************************************************
void draw()
{
  dg.pushStyle();
  dg.fill(0,0,0,90);
  dg.rect(0,0,width,height);
  dg.popStyle();
  
  if(!ROTATE_DISPLAY)
  { 
    dg.pushMatrix();
    dg.translate(width,0);
    dg.rotate(PI/2);
  }

  float secondsSinceLastUpdate = (millis()-lastEndTick)/1000.f;
  gridTiles.update(secondsSinceLastUpdate);
  leafs.update(secondsSinceLastUpdate);
//  if(!tileChanger.isComplete())
    tileChanger.update(secondsSinceLastUpdate);
//  else
//    tileChanger.reset();
  gridTiles.draw();
  lastEndTick = millis();
  
  if (display_tree) {
    drawTree();
  } else {
    drawSilhouette(); 
  }

  if (!ROTATE_DISPLAY) {
    dg.popMatrix();
  }
    
  if (edit_mode || display_leaf_system) {
     leafs.displaySpawnData();
  }

  if (display_leaves) {
    leafs.draw();
  }
  
  if (crop_line || draw_crop_line) {
    dg.pushStyle();
    dg.stroke(255,0,0);
    dg.line(cropX,0,cropX,height);
    dg.popStyle();
  }
}

//***************************************************************
// super basic input
//***************************************************************
void mousePressed() {
  int x = mouseX;
  int y = mouseY;
  if (edit_mode) {
    leafs.addSpawnPoint(x, y);
  }
}

void mouseClicked() {
  if (crop_line) {
    draw_crop_line = true;
    crop_line = false;
  }
}

void mouseDragged() {
  int x = mouseX;
  int y = mouseY;
  if (edit_mode) {
    leafs.addSpawnPoint(x, y);
  }
}

void mouseMoved() {
  if (crop_line) {
    cropX = mouseX;
  }
}

void saveScreenToPicture()
{
  dg.save("screenCap/fallingLeaves-"+year()+"-"+month()+"-"+day()+":"+hour()+":"+minute()+":"+second()+":"+millis() +".png");
}


boolean ifKeyPair(char k, char c1, char c2) {
  return ((k == c1)||(k == c2));
}

void keyPressed()
{
  if (ifKeyPair(key,'p','P')) {
    saveScreenToPicture();
  }
  if (ifKeyPair(key,'g','G')) {
    if(DEBUG_MODE)
      ((GridTool)gridTiles).generateCutouts();
  }
  if (ifKeyPair(key,'t','T')) {
    display_tree ^= true;
  }
  if (ifKeyPair(key,'e','E')) {
    if (edit_mode) {
      leafs.finishSpawnMask();
      display_leaf_system = true;
    }
    edit_mode ^= true;
  }
  if (ifKeyPair(key,'l','L')) {
    display_leaf_system ^= true;
  }
  if (ifKeyPair(key,'f','F')) {
    display_leaves ^= true;
  }
  if (ifKeyPair(key,'x','X')) {
    if (draw_crop_line) {
      draw_crop_line = false;
    } else {
      crop_line ^= true;
    }
  }
}

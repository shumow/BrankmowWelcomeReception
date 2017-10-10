int xLowerOffset = 250;
int yLowerOffset = 25;

int xUpperOffset = 25;
int yUpperOffset = 25;

class PictureFrame {

  static final int xLowerOffset = 250;
  static final int yLowerOffset = 25;

  static final int xUpperOffset = 25;
  static final int yUpperOffset = 25;
  
  static final float change_probability = 0.05;
  
  int cX;
  int cY;
  
  PImage imgCur;
  
  int wImg;
  int hImg;
  
  ArrayList<PImage> picFrameImgFileCache;
  
  int wFrame;
  int hFrame;  

  boolean showing_picture;
 
  float t;
 
  public PictureFrame() {
    wFrame = screenWidth/2 - (xLowerOffset + xUpperOffset);
    hFrame = screenHeight/2 - (yLowerOffset + yUpperOffset);
    
    cX = screenWidth/2 + xLowerOffset + wFrame/2;
    cY = yLowerOffset + hFrame/2;
    
    imgCur = null;
    showing_picture = false;

    t = 0.0;
    
    picFrameImgFileCache = new ArrayList<PImage>();
    
    loadImages();
  }

  void next() {
   if (showing_picture) {
     imgCur = null;
     showing_picture = false;
   } else {
     int curImage = int(random(picFrameImgFileCache.size()));
     float scl = 1.0;
     
     imgCur = picFrameImgFileCache.get(curImage);

     if (imgCur.width <= imgCur.height) {
       scl = ((float)imgCur.height)/((float)hFrame);
     } else {
       scl = ((float)imgCur.width)/((float)wFrame);       
     }
     
     if (1.0 < scl) {
       hImg = (int)(imgCur.height/scl);
       wImg = (int)(imgCur.width/scl);
     } else {
       wImg = imgCur.width;
       hImg = imgCur.height;
     }    

     showing_picture = true;
   }
  }

 void update(float dt) {

   boolean change = false;
   
   t += dt;
   
   if (1.0 < t) {
     float r = random(1);
     
     if (r <= change_probability) {
       change = true;
     }
     
     t -= 1.0;
   }
   
   if (change) {
     this.next();
   }
 } 
 
 void draw() {
   if (DEBUG_MODE) {
     pushStyle();
     stroke(#FF0000);
     fill(#000000, 0);
     rect(screenWidth/2 + xLowerOffset, yLowerOffset, wFrame, hFrame);
     popStyle();
   }
   
   if (showing_picture) {
     pushStyle();
       imageMode(CENTER);
       image(imgCur, cX, cY, wImg, hImg);
     popStyle();
   }
 }
  
 void loadImages() {
   String strPicDir = sketchPath("data" + File.separator + "pics");
   File dirPics = new File(strPicDir);
   println(dirPics.getAbsolutePath());
   if (!dirPics.isDirectory()) {
     println("pic directory not found.");
     return;
   }
   
   File[] pics = dirPics.listFiles();
   
   for (File f : pics) {
     String fileName = f.getName(); 
     String extStr = fileName.substring(fileName.length() - 4).toLowerCase();
     if (extStr.equals(".jpg") || extStr.equals(".png")) {
       String imgFileName = "pics" + File.separator + fileName;
       picFrameImgFileCache.add(loadImage(imgFileName));
     }
   }
 }
}

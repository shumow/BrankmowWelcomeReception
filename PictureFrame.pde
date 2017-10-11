int xLowerOffset = 250;
int yLowerOffset = 25;

int xUpperOffset = 25;
int yUpperOffset = 25;

class PictureFrame {

  static final int xLowerOffset = 250;
  static final int yLowerOffset = 25;

  static final int xUpperOffset = 25;
  static final int yUpperOffset = 25;
    
  static final float minNoPicTime = 5.0;
  static final float maxNoPicTime = 20.0;
  
  static final float minPicTime = 25.0;
  static final float maxPicTime = 50.0;

  static final float fadeTime = 4.0;
  
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
 
  float changeTime;
 
  public PictureFrame() {
    wFrame = screenWidth/2 - (xLowerOffset + xUpperOffset);
    hFrame = screenHeight/2 - (yLowerOffset + yUpperOffset);
    
    cX = screenWidth/2 + xLowerOffset + wFrame/2;
    cY = yLowerOffset + hFrame/2;
    
    imgCur = null;
    showing_picture = false;

    t = 0.0;
    changeTime = random(minNoPicTime, maxNoPicTime);
    
    picFrameImgFileCache = new ArrayList<PImage>();
    
    loadImages();
  }

  void next() {
   if (showing_picture) {
     imgCur = null;
     showing_picture = false;
     changeTime = random(minNoPicTime, maxNoPicTime);
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
     
     changeTime = random(minPicTime, maxPicTime);
     t = 0.0;

     showing_picture = true;
   }
  }

  void update(float dt) {

    boolean change = false;
   
     t += dt;
   
     if (changeTime <= t) {
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

     float a = 255.0;
     if (t < fadeTime) {
       a = 255.0*t/fadeTime;
     } else if ((changeTime - t) < fadeTime) {
       a = -255.0*(t - changeTime)/fadeTime;
     }

     pushStyle();
       imageMode(CENTER);
       tint(255, a);
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

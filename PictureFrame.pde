int xLowerOffset = 250;
int yLowerOffset = 25;

int xUpperOffset = 25;
int yUpperOffset = 25;

class PictureFrame {

  
 
  public PictureFrame() {
  
 }

 void update(float dt) {
  
 } 
 
 void draw() {
   if (DEBUG_MODE) {
     pushStyle();
     stroke(#FF0000);
     fill(#000000, 0);
     rect(screenWidth/2 + xLowerOffset, yLowerOffset, screenWidth/2 - (xLowerOffset + xUpperOffset), screenHeight/2 - (yLowerOffset + yUpperOffset));
     popStyle();
   }
 }
}

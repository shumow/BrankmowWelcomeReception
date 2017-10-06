//***************************************************************
// shows a bunch of debug stuff and allows easy alteration of the 
//  properties in the grid
//class to assist:
// 1) building an appropriate grid in situ at the gallery
// 2) asset creation
//***************************************************************
class GridTool extends GridTiler
{
    //***************************************************************
  // xml - xml object containing serialized object
  //***************************************************************
  public GridTool(XML xml)
  {
    super(xml);
  }
  
  //***************************************************************
  // origin: 2d vector screen space offset
  // graphscale: scale of unit vectors
  // xAxisTheta: radian measurement of the xaxis
  // yAxisTheta: radian measurement of the yaxis
  //***************************************************************
  public GridTool(float[] origin, float graphScale, float xAxisTheta, float yAxisTheta)
  {
    super(origin, graphScale, xAxisTheta, yAxisTheta);
  }
  
  //***************************************************************
  // basically re-inits but without re-generating the tiles
  //***************************************************************
  void rebuildGrid(float graphScale, float xAxisTheta, float yAxisTheta)
  {
    xAxis = new float[]{cos(xAxisTheta),
                        sin(xAxisTheta)};
  
    yAxis = new float[]{cos(yAxisTheta),
                        sin(yAxisTheta)}; 
                        
    println("GridTool: rebuildGrid: axes:<"+xAxis[0]+ "," +xAxis[1]+ "><" +yAxis[0]+ "," +yAxis[1]+"> - scale: " + graphScale);
    // apply scaling
    xAxis[0] *= graphScale; xAxis[1] *= graphScale;
    yAxis[0] *= graphScale; yAxis[1] *= graphScale;
  }
  
  //***************************************************************
  // draws a bunch of debug stuff over the top of the regular tile-shit
  //***************************************************************
  void draw()
  {
    super.draw();
    int graphRange[] = {-20,20};
    dg.pushMatrix();
    dg.translate(origin[0],origin[1]);
    //draw x axis markers
    dg.stroke(0,255,0);
    for(int i = graphRange[0]; i < graphRange[1]+1; i++)
    {
//      println(i + " skajdhaskj " + (yAxis[0] * i + graphRange[0] * xAxis[0]) + ", " + (yAxis[1] * i + graphRange[0] * xAxis[1]) );
//      println(i + " sdetijlkmn " + ( yAxis[0] * i + graphRange[1] * xAxis[0]) + ", " + (yAxis[1] * i + graphRange[1] * xAxis[1]) );
      dg.beginShape(LINES);
      dg.vertex( yAxis[0] * i + graphRange[0] * xAxis[0], 
                 yAxis[1] * i + graphRange[0] * xAxis[1]);
               
      dg.vertex( yAxis[0] * i + graphRange[1] * xAxis[0], 
                 yAxis[1] * i + graphRange[1] * xAxis[1]);
      dg.endShape();
    }
    //draw y axis markers
    dg.stroke(255,0,0);
    for(int i = graphRange[0]; i < graphRange[1]+1; i++)
    {
//      println(i + " 3333 " + (xAxis[0] * i + graphRange[0] * yAxis[0]) + ", " + (xAxis[1] * i + graphRange[0] * yAxis[1]) );
//      println(i + " 3333 " + (xAxis[0] * i + graphRange[1] * yAxis[0]) + ", " + (xAxis[1] * i + graphRange[1] * yAxis[1]) );
      dg.beginShape(LINES);
      dg.vertex( xAxis[0] * i + graphRange[0] * yAxis[0], 
                 xAxis[1] * i + graphRange[0] * yAxis[1]);
                
      dg.vertex( xAxis[0] * i + graphRange[1] * yAxis[0], 
                 xAxis[1] * i + graphRange[1] * yAxis[1]);
      dg.endShape();
    }
    
    //draw Labels
    dg.stroke(0);
    dg.fill(color(255,255,255));
    dg.textSize(10);
    for(int i = graphRange[0]; i < graphRange[1]+1; i++)
    {
      for(int j = graphRange[0]; j < graphRange[1]+1; j++)
      {
        dg.pushMatrix();
        String posString = ""+ i + "," + j; 
        dg.translate((i+.5)*xAxis[0]+(j+.5)*yAxis[0], 
                     (i+.5)*xAxis[1]+(j+.5)*yAxis[1]);
        if(!ROTATE_DISPLAY){dg.rotate(-PI/2); dg.translate(-14,0);}        
        dg.text(posString,0,0 );
        dg.popMatrix();
      }
    }
    dg.popMatrix();
    
    
    dg.fill(255);
    dg.textSize(50);
    dg.pushMatrix();
      dg.translate(70,height/2+ 200);
      dg.rotate(-PI/2);
      dg.text("TOP OF CANVAS",0,0);
    dg.popMatrix();
    
   dg.pushMatrix();
     if(!ROTATE_DISPLAY)
     {
       dg.translate(height,height/2 + 200);
     }
     else
     { 
       dg.translate(width,height/2 + 200);
     }
     dg.rotate(-PI/2);
     dg.text("BASE OF CANVAS",0,0);
   dg.popMatrix();
  }
  

  //***************************************************************
  //saves a bunch of template pngs out to the 'sizes' folder
  //***************************************************************
  void generateCutouts()
  {
    for(int x = 1; x  <= 4; x++)
    {
      for(int y = 1; y <= 4; y++)
      {
        // c    d
        // 
        // a    b
        float[] a = new float[]{ 0 * xAxis[0] + 0 * yAxis[0], 
                                 0 * xAxis[1] + 0 * yAxis[1]};
                                 
        float[] b = new float[]{ x * xAxis[0] + 0 * yAxis[0], 
                                 x * xAxis[1] + 0 * yAxis[1]};
                                 
        float[] c = new float[]{ 0 * xAxis[0] + y * yAxis[0], 
                                 0 * xAxis[1] + y * yAxis[1]};
                                 
        float[] d = new float[]{ x * xAxis[0] + y * yAxis[0], 
                                 x * xAxis[1] + y * yAxis[1]};
        float[] boundingBox = getBoundingBox(a,b,c,d);
  //      println("boundingBox: [" +  boundingBox[0] + ", " + boundingBox[1] + ", " + boundingBox[2] + ", " + boundingBox[3] + "]");
        int[] bufferDims = {(int)(boundingBox[2]-boundingBox[0] + .5),
                              (int)(boundingBox[3]-boundingBox[1] + .5)};
  
        PGraphics buffer = createGraphics(bufferDims[0],bufferDims[1],P2D);    
         
               
        //calls to 'buffer' will crash if the dims are less than or equal to 0! << undocumented feature alert!                                        
        if(bufferDims[0] > 0 && bufferDims[1] > 0)
        {
          buffer.beginDraw();
          buffer.smooth();
          buffer.clear();
          buffer.noStroke();
          buffer.fill(255);
          buffer.translate(-boundingBox[0],-boundingBox[1]);
          buffer.beginShape(TRIANGLE_STRIP);
            buffer.vertex(a[0],a[1]);
            buffer.vertex(b[0],b[1]);
            buffer.vertex(c[0],c[1]);
            buffer.vertex(d[0],d[1]);
          buffer.endShape();
          buffer.endDraw();
  //        buffer.save("sakdjha.png");
          buffer.save("sizes/"+x+"x"+y+"-" + int(-boundingBox[0]) + "x"  + int(-boundingBox[1]) + ".png");
          dg.image(buffer,random(width),random(height));
        }
      }  
    }
  }

}

//***************************************************************
//takes four xy coords (float arrays) and returns the axis aligned 
//bounding box {left,top,right,bottom} (also a float array...)
//basically a helper method for the generate cutouts method
//***************************************************************
float[] getBoundingBox(float[] a,float[] b,float[] c,float[] d)
{
  float minX = min(a[0],min(b[0],min(c[0],d[0])));
  float minY = min(a[1],min(b[1],min(c[1],d[1])));
  float maxX = max(a[0],max(b[0],max(c[0],d[0])));
  float maxY = max(a[1],max(b[1],max(c[1],d[1])));
  return new float[]{minX,minY,maxX,maxY};
}


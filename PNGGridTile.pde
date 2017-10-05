static HashMap<String, PImage> imageFileCache = new HashMap<String, PImage>();

//***************************************************************
// helper function, checks if the image file has been loaded,
// uses already loaded object iff it has.  Loads file and stores
// it in the hash map if not, and returns it.
//***************************************************************
PImage loadCachedPNGFile(String filename) {
  PImage imageFile;
  //println("loadCachedPNGFile: " + filename);
  if(imageFileCache.containsKey(filename)) {
    //println("loading from cache.");
    imageFile = imageFileCache.get(filename);
  } else {
    //println("loading from disk.");
    imageFile = loadImage(filename);
    imageFileCache.put(filename, imageFile);
  }

  return imageFile;
}

//***************************************************************
// uses a static png to render a tile
//***************************************************************
class PNGGridTile extends BaseGridTile
{
  //offset to line png up with grid
  float offset[];
  PImage img;

  //***************************************************************
  //origin construtor
  //***************************************************************
  public PNGGridTile(int x, int y)
  {
    super(x,y);
  }
  
  
  
  //***************************************************************
  // XML constructor
  //***************************************************************
  public PNGGridTile(XML xml)
  {
    super(xml);
  }
  
  //***************************************************************
  // 
  //***************************************************************
  public PNGGridTile(int[] pos, int[] sz, float[] offs, String fileName )
  {
    super(pos[0],pos[1],sz[0],sz[1]);
    offset = offs;
    img = loadCachedPNGFile(fileName);

  }
  
  //***************************************************************
  // actually draw a PNG tile
  //***************************************************************
  public void draw()
  {
    //fill me in
    dg.pushStyle();
    dg.tint(tintColor);
    dg.image(img, -offset[0], -offset[1]);
    dg.popStyle();
  }
  
  
 
  // <PNGGridTile
  //  ...
  //  file=""
  //  offsetX=""
  //  offsetY=""
  // />
  //***************************************************************
  // load with XML
  //***************************************************************
  void loadWithXML(XML xml)
  {
    String filename = null;
    super.loadWithXML(xml);
    println("XML: Initializing " + this.getClass().getName());

    filename = xml.getString("file");
    if (null == filename) {
      println("XML: loadWithXML file attribute not found in xml!");
    } else {
      img = loadCachedPNGFile(filename);
    }
    
    offset = new float[2];
    
    if (xml.hasAttribute("offsetX")) {
      offset[0] = xml.getInt("offsetX");
    } else {
      println("XML: loadWithXML offsetX not found in xml!");
    }

    if (xml.hasAttribute("offsetY")) {
      offset[1] = xml.getInt("offsetY");
    } else {
      println("XML: loadWithXML offsetY not found in xml!");
    }

    println("offset: " + offset[0] + ", " + offset[1]);

  }
}

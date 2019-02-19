float x;
float y;

float lander_w = 19;
float lander_h = 18;

float w;
float h;
float velX = 0;
float velY = 0;
float angle = 0;

ArrayList<MapLine> map = new ArrayList<MapLine>();
PImage lander;
PImage landerFiring;
PImage fireSymbol;

boolean wPressed = false;

// CONSTANTS
final float thrust =  0.005;
final float gravity = 0.00162;
final int mapPieceSize = 20;

void setup() {
  background(0);
  w = 1500;
  h = 750;
  createMap();
  lander = loadImage("lander.png");
  landerFiring = loadImage("lander-firing.png");
  fireSymbol = loadImage("firesymbol.png");
  size(1500, 750);
  x = w/2;
  y = h/2;
} 



void createMap() {
  map.clear();
  landingPad();
}

// Map 1
void landingPad(){
  for (int i = 0; i < w/3.0; i+= mapPieceSize) {
    float xo = (float)i;
    float x = (float)(i + mapPieceSize);

    float yo = map.size() == 0 ? h : map.get((i/mapPieceSize) - 1).y;
    float y = yo - 5;
    MapLine newLine = new MapLine(xo, x, yo, y); 
    map.add(newLine);
  }
 for (int i = (int)(w/3.0); i < (2.0/3) * w; i+= mapPieceSize) {
    float xo = (float)i;
    float x = (float)(i + mapPieceSize);

    float yo = map.size() == 0 ? h : map.get((i/mapPieceSize) - 1).y;
    float y = yo;
    MapLine newLine = new MapLine(xo, x, yo, y); 
    map.add(newLine);
  }
 for (int i = (int)((2.0/3) * w); i < w; i+= mapPieceSize) {
    float xo = (float)i;
    float x = (float)(i + mapPieceSize);
    float yo = map.size() == 0 ? h : map.get((i/mapPieceSize) - 1).y;
    float y = yo + 5;
    MapLine newLine = new MapLine(xo, x, yo, y); 
    map.add(newLine);
  }
}

//Randomly generated terrain map
void randomMap(){
  for (int i = 0; i < w; i+= mapPieceSize) {
    float xo = (float)i;
    float x = (float)(i + mapPieceSize);
    float yo = map.size() == 0 ? h : map.get((i/mapPieceSize) - 1).y;
    float y = Math.min((yo + (float)(Math.random() * 100) - 55),h);
    if(Math.random() > 0.9){
      y = yo;
    }
    
    MapLine newLine = new MapLine(xo, x, yo, y); 
    map.add(newLine);
  }
}

void renderMap() {
  for (MapLine line : map) {
    stroke(255);
    line(line.xo, line.yo, line.x, line.y);
  }
}

void renderLander() {
  pushMatrix();
  imageMode(CENTER);
  translate(x, y);
  rotate(radians(angle));
  if (wPressed) {
    image(landerFiring, 0, 0);
  } else {
    image(lander, 0, 0);
  }
  popMatrix();
}

void processIO() {
  if (keyPressed) {
    if (key == 'a') {
      angle -= 1;
    } else if (key =='d') {
      angle += 1;
    }

    if (key == 'l') {
      x += 1;
    } else if (key =='j') {
      x += -1;
    }
  }
  if (mousePressed) {
    velX += thrust * Math.sin(radians(angle));
    velY -= thrust * Math.cos(radians(angle));
    wPressed = true;
  } else {
    wPressed = false;
  }
}

ArrayList<MapLine> getLanderBorders() {
  ArrayList<MapLine> borders = new ArrayList<MapLine>();
  MapLine left = new MapLine(x - lander_w/2, x - lander_w/2, y + lander_h/2, y - lander_h/2);
  MapLine right = new MapLine(x + lander_w/2, x + lander_w/2, y + lander_h/2, y - lander_h/2);
  MapLine top = new MapLine(x - lander_w/2, x + lander_w/2, y + lander_h/2, y + lander_h/2);
  MapLine bottom = new MapLine(x - lander_w/2, x + lander_w/2, y - lander_h/2, y - lander_h/2);
  borders.add(left);
  borders.add(right);
  borders.add(top);
  borders.add(bottom);
  for(MapLine ml : borders){
    //println(ml);
  }
  return borders;
}

boolean isColliding() {
  ArrayList<MapLine> landerBorders = getLanderBorders();
  for (MapLine mapline : map) {
    for (MapLine border : landerBorders) {
      float x_intersection;
      float y_intersection;
      if(border.isVertical || mapline.isVertical){
        x_intersection = border.isVertical ? border.x : mapline.x;
        y_intersection = border.isVertical ? mapline.m * x_intersection + mapline.b : border.m * x_intersection + border.b;
      }else{
        x_intersection = (mapline.b - border.b)/(border.m - mapline.m);
        y_intersection = border.m * x_intersection + border.b;
      }
      
      boolean intersectingLander =  x_intersection <= max(border.x,border.xo)   && x_intersection >= min(border.x,border.xo)  && y_intersection <= max(border.y,border.yo)  && y_intersection >= min(border.y,border.yo);
      boolean intersectingTerrain = x_intersection <= max(mapline.x,mapline.xo) && x_intersection >= min(mapline.x,mapline.xo) && y_intersection <= max(mapline.y,mapline.yo) && y_intersection >= min(mapline.y,mapline.yo); 
        
      if (intersectingLander && intersectingTerrain) {
        fill(255, 0, 0);
        stroke(255, 0, 0);
        line(mapline.xo, mapline.yo, mapline.x, mapline.y);
        noStroke();
        //ellipse(x_intersection, y_intersection, 5, 5);
        return true;

      } else {
        fill(0, 255, 0);
        noStroke();
        //ellipse(x_intersection, y_intersection, 2, 2);
      }
      
    }
  }


  return false;
}

void processPhysics(){
  if(isColliding()){
    velY = min(0,velY);
    //velX = velX == 0 ? 0 : (velX < 0 ?  velX + 0.01 : velX - 0.01);
    velX = 0;
  }else{
    velY += gravity;
  }
  x += velX;
  y += velY;
  
}

void calculateLandingFireDistance(){
  MapLine pieceUnderLander = map.get((int)(x/mapPieceSize));
  float distance = (float)Math.pow(velY,2)/(2*(thrust-gravity));
  float display_y = pieceUnderLander.getY(x) - distance;
  imageMode(CENTER);
  image(fireSymbol,x + 20,display_y);
  textSize(10);
  text(("" + distance).substring(0,min(("" + distance).length(),4)), x + 30,display_y);
}

void draw() {
  if (keyPressed && key =='r') {
    x = w/2;
    y = h/2;
    velX = 0;
    velY = 0;
  }
  background(0);
  renderMap();
  renderLander();
  processIO();
  text("x:" + (mouseX), mouseX, mouseY);
  text("y:" + (mouseY), mouseX, mouseY + 10);
  processPhysics();
  fill(255);
  textSize(26);
  text("x velocity: " + velX, 0, 20);
  text("y velocity: " + velY, 0, 40);
  calculateLandingFireDistance();
  

}

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

boolean wPressed = false;

// CONSTANTS
final float thrust =  0.005;
final float gravity = 0.00162;

void setup(){
  background(0);
  createMap();
  lander = loadImage("lander.png");
  landerFiring = loadImage("lander-firing.png");
  w = 1500;
  h = 750;
  size(1500,750);
  x = w/2;
  y = h/2;
} 

void createMap(){
  map.clear();
  for(int i = 0; i < 1500; i+= 10){
    float xo = (float)i;
    float x = (float)(i + 10);
    float yo = map.size() == 0 ? 750 : map.get((i/10) - 1).y;
    float y = yo + (float)(Math.random() * 100) - 50;
    
    MapLine newLine = new MapLine(xo,x,yo,y); 
    map.add(newLine);
  }
}

void renderMap(){
  for(MapLine line : map){
    stroke(255);
    line(line.xo,line.yo,line.x,line.y);
  }
}

void renderLander(){
  pushMatrix();
  imageMode(CENTER);
  translate(x,y);
  rotate(radians(angle));
  if(wPressed){
    image(landerFiring,0,0);
  }else{
    image(lander,0,0);
  }
  popMatrix();
}

void processIO(){
  if (keyPressed){
    if (key == 'w'){
      velX += thrust * Math.sin(radians(angle));
      velY -= thrust * Math.cos(radians(angle));
      wPressed = true;
    }
    if(key == 'a'){
      angle -= 1;
    } else if(key =='d'){
      angle += 1; 
    }
    
    if(key == 'l'){
      x += 1;
    } else if(key =='j'){
      x += -1; 
    }
  }else{
    wPressed = false;
  }
}

ArrayList<MapLine> getLanderBorders(){
  ArrayList<MapLine> borders = new ArrayList<MapLine>();
  MapLine left = new MapLine(x - lander_w/2,x - lander_w/2,y + lander_h/2, y - lander_h/2);
  MapLine right = new MapLine(x + lander_w/2,x + lander_w/2,y + lander_h/2, y - lander_h/2);
  MapLine top = new MapLine(x - lander_w/2,x + lander_w/2,y + lander_h/2, y + lander_h/2);
  MapLine bottom = new MapLine(x - lander_w/2,x + lander_w/2,y - lander_h/2, y - lander_h/2);
  borders.add(left);
  borders.add(right);
  borders.add(top);
  borders.add(bottom);
  return borders;
}

boolean isColliding(){
  ArrayList<MapLine> landerBorders = getLanderBorders();
  for(MapLine mapline : map){
     for(MapLine border : landerBorders){
       if(border.m - mapline.m != 0){
         float x_intersection = (mapline.b - border.b)/(border.m - mapline.m);
         float y_intersection = border.m * x_intersection + border.b;
         if(x_intersection <= border.x && x_intersection >= border.xo && y_intersection <= border.y && y_intersection >= border.yo && x_intersection <= mapline.x && x_intersection >= mapline.xo && y_intersection <= mapline.y && y_intersection >= mapline.yo){
           fill(255,0,0);
           stroke(255,0,0);
           line(mapline.xo, mapline.yo, mapline.x, mapline.y);
           noStroke();
           ellipse(x_intersection, y_intersection, 2,2);
           
           return true;
         }else{
           fill(0,255,0);
           noStroke();
           ellipse(x_intersection, y_intersection, 2,2);
         }
       }
     }
  }
  
  
  return false;
}

void draw(){
  if (keyPressed && key =='r'){
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
  if(isColliding()){
    fill(255,0,0);
    text("COLLIDING",5,20);
  }
  x += velX;
  y += velY;
  velY += gravity;
}

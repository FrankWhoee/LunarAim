public class MapLine{
 public float xo;
 public float x;
 public float yo;
 public float y;
 
 public float m;
 public float b;
  public boolean isVertical= false;
 
 public MapLine(float xo, float x, float yo, float y){
   this.xo = xo;
   this.x = x;
   this.yo = yo;
   this.y = y;
   if(x - xo == 0){
     this.isVertical = true;
   }
   this.m = (y - yo)/(x - xo);
   this.b = y - (this.m * x);
 }
 
 public float getY(float x){
   return m * x + b;
 }
 
 @Override
 public String toString(){
   return  "(" + xo +"," + yo + ") to ("+ x +"," + y + ") Slope: " + m +", Y-Inter: " + b;
 }
}

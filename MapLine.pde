public class MapLine{
 public float xo;
 public float x;
 public float yo;
 public float y;
 
 public float m;
 public float b;
 
 
 public MapLine(float xo, float x, float yo, float y){
   this.xo = xo;
   this.x = x;
   this.yo = yo;
   this.y = y;
   
   m = (y - yo)/(x - xo);
   b = y - (m * x);
 }
 
 @Override
 public String toString(){
   return  "(" + xo +"," + yo + ") to ("+ x +"," + y + ")";
 }
}

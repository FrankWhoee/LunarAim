public class Toggle{
  private boolean state;
  
  public Toggle(){
    this.state = false;
  }
  
  public void toggle(){
      state = !state;
  }
  
  public boolean state(){
    return state;
  }
  
}

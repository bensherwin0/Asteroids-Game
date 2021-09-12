public class Bullet
{
  private float theta;  
  private PVector pos;
  private float speed;
  private boolean alive;
  
  public Bullet(Ship s)
  {
    theta = radians(s.direction);
    pos = new PVector(s.pos.x-20*cos(theta), s.pos.y-20*sin(theta));
    speed = 10;
    alive = true;
  }
  
  public void update()
  {
    pos.x -= speed*cos(theta);
    pos.y -= speed*sin(theta);
  }
  
  public void show()
  {
    stroke(0, 255, 0);
    strokeWeight(8);
    line(pos.x, pos.y, pos.x-20*cos(theta), pos.y-20*sin(theta));
  }
  
  public void collide()
  {
    for(Asteroid a : AsteroidField.getField())
    {
      if (pos.dist(a.pos) < a.getRadius())
      {
        a.health = 0;
        alive = false;
      }
    }
    if(pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height)
    {
      alive = false; 
    }
  }
}

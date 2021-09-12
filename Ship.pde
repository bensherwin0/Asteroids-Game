public class Ship
{
  private PVector pos;
  private PVector velocity;
  private float direction; //angle with 0 being right (positive x)
  private float spinVel;
  private float theta;
  private boolean alive;
  private float speed;
  private float explode;
  private ArrayList<Bullet> fired;
  private int cooldown = 20;
  private int que = 0;

  public Ship(float x, float y, float s)
  {
    pos = new PVector(x, y);
    velocity = new PVector(0, 0);
    spinVel = 0;
    alive = true;
    speed = s;
    direction = 90;
    theta = radians(direction);
    explode = 15;
    fired = new ArrayList<Bullet>();
  }

  public void update()
  {
    theta = radians(direction);
    if (up) velocity.add(
      new PVector(-1*speed*cos(theta), -1*speed*sin(theta))
      );
    if (left) spinVel -= 2*speed;
    if (right) spinVel += 2*speed;
    direction += spinVel;
    if (space && que == 0)
    {
      que ++;
    }
    if (frameCount % cooldown == 0 && que > 0)
    {
      fired.add(new Bullet(this)); 
      que = 0;
      velocity.add(
      new PVector(1*speed*cos(theta), 1*speed*sin(theta))
      );
    }

    pos.add(velocity);
    if (pos.x < 0) pos.x = width;
    if (pos.x > width) pos.x = 0;
    if (pos.y < 0) pos.y = height;
    if (pos.y > height) pos.y = 0;

    for (Asteroid a : AsteroidField.getField())
    {
      if (dist(pos.x, pos.y, a.pos.x, a.pos.y) < a.getRadius())
      {
        alive = false;
      }
    }
  }

  public void show()
  {
    if (alive)
    {
      if (up) 
      {
        stroke(255, 100, 100);
        strokeWeight(10);
        line(pos.x, pos.y, pos.x+15*cos(theta), pos.y+15*sin(theta));
      }
      if (right)
      {
        stroke(255, 100, 100);
        strokeWeight(6);
        line(pos.x-5*cos(theta), pos.y-5*sin(theta), pos.x+15*cos(theta+PI/2), pos.y+15*sin(theta+PI/2));
      }
      if (left)
      {
        stroke(255, 100, 100);
        strokeWeight(6);
        line(pos.x-5*cos(theta), pos.y-5*sin(theta), pos.x+15*cos(theta-PI/2), pos.y+15*sin(theta-PI/2));
      }
      
      for (int i = fired.size() - 1; i >= 0; i--)
      {
        Bullet b = fired.get(i);
        if (b.alive)
        {
          b.update();
          b.show();
          b.collide();
        } else
        {
          fired.remove(i);
        }
      }
      fill(255);
      noStroke();
      triangle(pos.x-30*cos(theta), pos.y-30*sin(theta), 
        pos.x-15*cos(theta+2*PI/3), pos.y-15*sin(theta+2*PI/3), 
        pos.x-15*cos(theta-2*PI/3), pos.y-15*sin(theta-2*PI/3));
    } else 
    {
      noStroke();
      fill(255, 0, 0);
      circle(pos.x, pos.y, explode);
      explode += 3;
    }
  }

  public boolean isAlive()
  {
    return alive;
  }
}

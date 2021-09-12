public static class AsteroidField
{
  static int n = 0;
  static ArrayList<Asteroid> field = new ArrayList<Asteroid>();
  public static void addAsteroid(Asteroid a)
  {
    field.add(a);
    n++;
  }
  public static void removeAsteroid(Asteroid a)
  {
    field.remove(a);
  }
  public static int getSize()
  {
    return field.size(); 
  }
  
  public static ArrayList<Asteroid> getField()
  {
    return field; 
  }
}

public class Asteroid extends AsteroidField
{
  private PVector pos;
  private int level;//from 3 (largest) to 1 (smallest)
  private int radius;
  private float speed;
  private float theta;
  private PVector vel;
  private float health;
  private float[] shape;

  public Asteroid(int l, PVector p, float t, float s)
  {
    level = l;
    health = 100;
    speed = s;
    theta = t;
    radius = level * 50 - 10;
    shape = new float[360];
    for (int i = 0; i < 360; i ++)
    {
      shape[i] = 50 * level - 15*level*noise(i/8 + 100*n);
    }
    pos = new PVector(p.x + (float)(-10*Math.random()), p.y + (float)(-10*Math.random()));

    vel = new PVector(-1*speed*cos(theta), -1*speed*sin(theta));
  }

  public Asteroid(int l)
  {
    level = l;
    health = 100;
    speed = (float)(Math.random()*3);
    theta = (float) (Math.random()*TWO_PI);
    
    radius = level * 50 - 10;
    shape = new float[360];
    for (int i = 0; i < 360; i ++)
    {
      shape[i] = 50 * level - 15*level*noise(i/8 + 100*n);
    }
    int rand = (int) (4*Math.random());
    if (rand == 0) {
      pos = new PVector((float)(width*Math.random()), 0);
    } else if (rand == 1)
    {
      pos = new PVector((float)(width*Math.random()), height-1);
    } else if (rand == 2) {
      pos = new PVector(0, (float)(height*Math.random()));
    } else if (rand == 3)
    {
      pos = new PVector(width-1, (float)(height*Math.random()));
    }

    vel = new PVector(-1*speed*cos(theta), -1*speed*sin(theta));
  }

  public void update()
  {
    if (isDead()) divide();

    this.pos.add(this.vel);
    if (pos.x < 0) pos.x = width;
    if (pos.x > width) pos.x = 0;
    if (pos.y < 0) pos.y = height;
    if (pos.y > height) pos.y = 0;
  }

  public void show()
  {
    fill(175);
    noStroke();
    beginShape();
    for (int i = 0; i < 360; i++)
    {
      vertex(pos.x + shape[i]*cos(radians(i)), pos.y + shape[i]*sin(radians(i)));
    }
    endShape();
  }

  public void divide()
  {
    if (level > 1)
    {
      AsteroidField.addAsteroid(new Asteroid(level-1, pos, theta + PI/8, speed*.9));
      AsteroidField.addAsteroid(new Asteroid(level-1, pos, theta - PI/8, speed*.9));
    }
    field.remove(this);
    score += 500;
  }
  
  public void hit()
  {
    health -= 2; 
  }

  public boolean isDead()
  {
    return health <= 0;
  }
  
  public int getRadius()
  {
    return radius; 
  }
  
  public PVector intersects(float x1, float y1, float x2, float y2)
  {
    float m = (y2-y1)/(x2-x1);
    float m2 = (x1-x2)/(y2-y1);
    float xn = (pos.y+m*x1-m2*pos.x-y1)/(m-m2);
    float yn = m*(xn-x1)+y1;
    //circle(xn, yn, 20);
    return new PVector(xn,yn);
  }
}

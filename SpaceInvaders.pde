boolean right = false, left = false, up = false, down = false, space = false;
Ship hero;
PVector[] stars;
Zbutton start;
Zbutton reset;
int stage; //0 is menu, 1 is reset, 2 is game
int interval;
int shakeTimer;
int score;
PFont f;

void setup()
{
  //size(800, 800);
  fullScreen();
  hero = new Ship(width/2, height/2, .05);
  start = new Zbutton(width/2-80, height/2-50, 150, 80, "START");
  reset = new Zbutton(width/2-80, height/2-50, 200, 80, "Play Again");
  stars = new PVector[80];
  for (int i = 0; i < stars.length; i++)
  {
    stars[i] = new PVector(random(0, width), random(0, height));
  }
  for (int i = 0; i < 3; i++)
  {
    AsteroidField.addAsteroid(new Asteroid((int)(3*Math.random()+1)));
    while (AsteroidField.getField().get(i).pos.dist(hero.pos) < AsteroidField.getField().get(i).getRadius() + 300)
    {
      AsteroidField.getField().remove(i);
      AsteroidField.addAsteroid(new Asteroid((int)(3*Math.random()+1)));
    }
  }
  stage = 0;
  interval = 400;
  shakeTimer = 30;
  f = createFont("Arial", 26, true);
}

void draw()
{
  if (stage == 0)
  {
    background(0);
    noStroke();
    fill(200);
    for (int i = 0; i < stars.length; i++)
    {
      ellipse(stars[i].x, stars[i].y, 5, 5);
    }
    start.show();
  } else if (stage == 1)
  {
    background(0);
    reset.show();
    textFont(f, 36);
    fill(255);
    text("SCORE: " + score, width/2 - 100, height/2 + 100);
  } else if (stage == 2)
  {
    background(0);

    if (hero.isAlive())
    {
      score++;
      if (frameCount % interval == 0)
      {
        AsteroidField.addAsteroid(new Asteroid((int)(3*Math.random()+1)));
        while (AsteroidField.getField().get(AsteroidField.getSize()-1).pos.dist(hero.pos) < AsteroidField.getField().get(AsteroidField.getSize()-1).getRadius() + 300)
        {
          AsteroidField.getField().remove(AsteroidField.getSize()-1);
          AsteroidField.addAsteroid(new Asteroid((int)(3*Math.random()+1)));
        }
        if (interval > 120)interval -= 5;
      }

      noStroke();
      fill(200);
      for (int i = 0; i < stars.length; i++)
      {
        ellipse(stars[i].x, stars[i].y, 5, 5);
      }

      for (int i = 0; i < AsteroidField.field.size(); i++)
      {
        Asteroid a = AsteroidField.field.get(i);
        if (!a.isDead())
        {
          a.update();
          a.show();
        } else a.update();
      }

      hero.update();
      hero.show();

      textFont(f, 26);
      fill(255);
      text("Score: " + score, width/2 - 70, 30);
    } else
    {
      if (shakeTimer > 0)
      {
        frameRate(20);
        int shake = 10;
        translate(random(-shake, shake), random(-shake, shake));
        shakeTimer--;
        for (Asteroid a : AsteroidField.getField())
        {
          a.show();
        }
        hero.show();
      } else 
      { 
        stage = 1;
        translate(0, 0);
        frameRate(60);
      }
    }
  }
}

void keyPressed() {
  switch(key) {
  case 'd': 
    right = true; 
    break;
  case 'a': 
    left = true; 
    break;
  case 'w': 
    up = true; 
    break;
  case 's': 
    down = true; 
    break;
  case ' ':
    space = true;
    break;
  }
}
void keyReleased() {
  switch(key) {
  case 'd': 
    right = false; 
    break;
  case 'a': 
    left = false; 
    break;
  case 'w': 
    up = false; 
    break;
  case 's': 
    down = false; 
    break;
  case ' ':
    space = false;
    break;
  }
}

void mousePressed()
{
  if (reset.isOver())
  {
    reset.unShow();
    stage = 0;
    AsteroidField.getField().clear();
    score = 0;
    setup();
  } else if (start.isOver())
  {
    stage = 2;
    start.unShow();
  }
}

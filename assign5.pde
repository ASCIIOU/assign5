PImage start2;
PImage start1;
PImage treasure;
PImage fighter;
PImage enemy;
PImage end2;
PImage end1;
PImage bullet;
PImage bg1;
PImage bg2;
PImage hp;


float m; 
PFont board; 
int scoreNum = 0; 
 

int gameState; 
final int Game_START = 0; 
final int Game_RUN = 1; 
final int Game_END = 2; 
 
int enemyState; 
final int enemyStraight = 0; 
final int enemySlope = 1; 
final int enemyDaimond = 2; 
 
int life; 
 


PImage [] enemyPosition = new PImage [5]; 
float enemyC [][] = new float [5][2];        
float enemyB [][] = new float [5][2]; 
float enemyA [][] = new float [8][2];   
float spacingX; 
float spacingY; 
 

int flameNum; 
int flameCurrent; 
PImage [] hit = new PImage [5]; 
float hitPosition [][] = new float [5][2];  
 
float treasureX, treasureY, fighterX, fighterY, enemyY; 
float [] bulletX = new float [5]; 
float [] bulletY = new float [5]; 
 
float fighterSpeed; 
float enemySpeed; 
int bulletSpeed; 
 
boolean upPressed = false; 
boolean downPressed = false; 
boolean leftPressed = false; 
boolean rightPressed = false; 
 

int bulletNum = 0; 
boolean [] bulletLim = new boolean[5]; 
 
void setup () {     
  size (640,480) ; 
  frameRate(60);  
  for ( int i = 0; i < 5; i++ ){ 
  hit[i] = loadImage ("img/flame" + (i+1) + ".png" );} 
  
  start2 = loadImage ("img/start2.png"); 
  start1 = loadImage ("img/start1.png");   
  bg1 = loadImage ("img/bg1.png"); 
  bg2 = loadImage ("img/bg2.png"); 
  hp = loadImage ("img/hp.png"); 
  treasure = loadImage ("img/treasure.png"); 
  fighter = loadImage ("img/fighter.png"); 
  enemy = loadImage ("img/enemy.png");   
  end2 = loadImage ("img/end2.png"); 
  end1 = loadImage ("img/end1.png"); 
  bullet = loadImage ("img/shoot.png"); 
   
 gameState = Game_START; 
 enemyState = 0; 
 life = 40;  
 treasureX = floor( random(50, width - 40) ); 
 treasureY = floor( random(50, height - 60) ); 
 fighterX = width - 65 ; 
 fighterY = height / 2 ;  
 

  fighterSpeed = 5; 
  enemySpeed = 5; 
  bulletSpeed = 6; 
   

  flameNum = 0; 
  flameCurrent = 0; 
  for ( int i = 0; i < hitPosition.length; i ++){ 
    hitPosition[i][0] = 2000; 
    hitPosition[i][1] = 2000; 
  } 


  for (int i =0; i < bulletLim.length ; i ++){ 
    bulletLim[i] = false; 
  } 


  spacingX = 0;   
  spacingY = -60;  
  enemyY = floor(random(80, 400));     
  for (int i = 0; i < 5; i++){ 
   enemyPosition [i] = loadImage ("img/enemy.png");   
   enemyC [i][0] = spacingX; 
   enemyC [i][1] = enemyY;  
   spacingX -= 80; 
  } 
    
  board = createFont("Times New Roman", 24); 
  textFont(board, 24); 
  textAlign(LEFT); 
} 
 
 
 
void draw() {   
  switch (gameState) { 
    case Game_START: 
      image(start2,0,0); 
    if(mousePressed) { 
      gameState = Game_RUN;}else { 
        if(mouseX >= width/3 && mouseX <= 2*width/3 && mouseY >=380 && mouseY <=415) { 
          image(start1,0,0); 
        } 
  } 
   break; 
     case Game_RUN: 

      image (bg2, m, 0); 
      image (bg1, m-640, 0); 
      image (bg2, m-1280, 0);  
       
      m += 1; 
      m %= 1280; 
       

      image (treasure, treasureX, treasureY);     
       

      image(fighter, fighterX, fighterY); 
       
      if (upPressed && fighterY > 0) { 
        fighterY -= fighterSpeed ; 
      } 
      if (downPressed && fighterY < 480 - 50) { 
        fighterY += fighterSpeed ; 
      } 
      if (leftPressed && fighterX > 0) { 
        fighterX -= fighterSpeed ; 
      } 
      if (rightPressed && fighterX < 640 - 50) { 
        fighterX += fighterSpeed ; 
      }   
          

      image(hit[flameCurrent], hitPosition[flameCurrent][0], hitPosition[flameCurrent][1]);       
      flameNum ++; 
      if ( flameNum % 6 == 0){ 
        flameCurrent ++; 
      }  
      if ( flameCurrent > 4){ 
        flameCurrent = 0; 
      } 

      if(flameNum > 31){ 
        for (int i = 0; i < 5; i ++){ 
          hitPosition[i][0] = 1000; 
          hitPosition[i][1] = 1000; 
        } 
      }    
        
     //bullet 
      for (int i = 0; i < 5; i ++){ 
        if (bulletLim[i] == true){ 
          image (bullet, bulletX[i], bulletY[i]); 
          bulletX[i] -= bulletSpeed; 
        } 
        if (bulletX[i] < - bullet.width){ 
          bulletLim[i] = false; 
        } 
      } 
      

      switch (enemyState) {  
        case 0 :                
          for ( int i = 0; i < 5; i++ ){ 
            image(enemyPosition[i], enemyC [i][0], enemyC [i][1]); 

            for (int j = 0; j < 5; j++ ){ 
              if(getHit(bulletX[j], bulletY[j], bullet.width, bullet.height, enemyC[i][0], enemyC[i][1], enemy.width, enemy.height) == true && bulletLim[j] == true){ 
                for (int k = 0;  k < 5; k++ ){ 
                  hitPosition [k][0] = enemyC [i][0]; 
                  hitPosition [k][1] = enemyC [i][1]; 
                }     
                enemyC [i][1] = -1000; 
                enemyY = floor(random(30,240)); 
                bulletLim[j] = false; 
                flameNum = 0;  
                scoreChange(20); 
              } 
            }   

            if(getHit(fighterX, fighterY ,fighter.width, fighter.height,  enemyC[i][0], enemyC[i][1], enemy.width, enemy.height) == true){ 
              for (int j = 0;  j < 5; j++){ 
                hitPosition [j][0] = enemyC [i][0]; 
                hitPosition [j][1] = enemyC [i][1]; 
              } 
              life -= 40;           
              enemyC [i][1] = -1000; 
              enemyY = floor( random(30,240) ); 
              flameNum = 0;  
            }else if(life <= 0){ 
              life=0; 
              gameState = Game_END; 
              life = 40; 
              fighterX = (width - 65); 
              fighterY = height / 2 ; 
            } else { 
              enemyC [i][0] += enemySpeed; 
              enemyC [i][0] %= 1280; 
            }       
          } 

          if (enemyC [enemyC.length-1][0] > 640+100 ) {         
            enemyY = floor(random(30,240));             
            spacingX = 0;   
            for (int i = 0; i < 5; i++){ 
              enemyB [i][0] = spacingX; 
              enemyB[i][1] = enemyY - spacingX / 2; 
             spacingX -= 80;                  
            } 
            enemyState = 1; 
          } 
        break ;  
         
        case 1 : 
          for (int i = 0; i < 5; i++ ){ 
            image(enemyPosition[i], enemyB [i][0] , enemyB [i][1]); 

            for(int j = 0; j < 5; j++){ 
              if (getHit(bulletX[j], bulletY[j], bullet.width, bullet.height, enemyB [i][0], enemyB [i][1], enemy.width, enemy.height) == true && bulletLim[j] == true){ 
                for(int k = 0;  k < 5; k++ ){ 
                  hitPosition [k][0] = enemyB [i][0]; 
                  hitPosition [k][1] = enemyB [i][1]; 
                }      
                enemyB [i][1] = -1000; 
                enemyY = floor(random(30,240)); 
                bulletLim[j] = false; 
                flameNum = 0; 
                scoreChange(20); 
              } 
            }    

            if ( getHit(fighterX, fighterY ,fighter.width, fighter.height,  enemyB[i][0], enemyB[i][1], enemy.width, enemy.height) == true){ 
              for (int j = 0;  j < 5; j++ ){ 
                 hitPosition [j][0] = enemyB [i][0]; 
                 hitPosition [j][1] = enemyB [i][1]; 
               } 
              enemyB [i][1] = -1000; 
              enemyY = floor(random(200,280)); 
              flameNum = 0;  
              life -= 40; 
            }else if(life<=0){ 
              life=0; 
              gameState = Game_END; 
              life = 40; 
              fighterX = (width - 65); 
              fighterY = height / 2 ; 
            } else { 
              enemyB [i][0] += enemySpeed; 
              enemyB [i][0] %= 1280; 
            }          
          } 
            

          if (enemyB [4][0] > 640 + 100){ 
            enemyY = floor( random(200,280) ); 
            enemyState = 2;             
            spacingX = 0;   
            spacingY = -60;  
            for ( int i = 0; i < 8; i ++ ) { 
              if ( i < 3 ) { 
                enemyA [i][0] = spacingX; 
                enemyA [i][1] = enemyY - spacingX; 
                spacingX -= 60; 
              } else if ( i == 3 ){ 
                enemyA [i][0] = spacingX; 
                enemyA [i][1] = enemyY - spacingY; 
                spacingX -= 60; 
                spacingY += 60; 
              } else if ( i > 3 && i <= 5 ){ 
                  enemyA [i][0] = spacingX; 
                  enemyA [i][1] = enemyY + spacingY; 
                  spacingX += 60; 
                  spacingY -= 60; 
              } else { 
                  enemyA [i][0] = spacingX; 
                  enemyA [i][1] = enemyY + spacingY; 
                  spacingX += 60; 
                  spacingY += 60; 
              }             
            }      
          } 
        break ;         
          
        case 2 :   
          for( int i = 0; i < 8; i++ ){ 
            image(enemy, enemyA [i][0], enemyA [i][1]);      

            for( int j = 0; j < 5; j++ ){ 
              if ( getHit(bulletX[j], bulletY[j], bullet.width, bullet.height, enemyA[i][0], enemyA[i][1], enemy.width, enemy.height) == true && bulletLim[j] == true){ 
                for (int s = 0;  s < 5; s++){ 
                  hitPosition [s][0] = enemyA [i][0]; 
                  hitPosition [s][1] = enemyA [i][1]; 
                } 
                enemyA [i][1] = -1000; 
                enemyY = floor( random(30,240)); 
                bulletLim[j] = false; 
                flameNum = 0;  
                scoreChange(20); 
              } 
            }        

            if ( getHit(fighterX, fighterY ,fighter.width, fighter.height,  enemyA[i][0], enemyA[i][1], enemy.width, enemy.height) == true){  
              for ( int j = 0;  j < 5; j++ ){ 
                hitPosition [j][0] = enemyA [i][0]; 
                hitPosition [j][1] = enemyA [i][1]; 
              } 
              life -= 40; 
              enemyA [i][1] = -1000; 
              enemyY = floor(random(50,420)); 
              flameNum = 0;  
            } else if ( life <=0 ) { 
              life=0; 
              gameState = Game_END; 
              life = 40; 
              fighterX = 575 ; 
              fighterY = height/2 ; 
            } else { 
              enemyA [i][0] += enemySpeed; 
              enemyA [i][0] %= 1920; 
            }      
          } 
            

          if(enemyA [4][0] > 640 + 300 ){ 
            enemyY = floor(random(80,400)); 
            spacingX = 0;        
            for (int i = 0; i < 5; i++ ){ 
              enemyC [i][1] = enemyY;  
              enemyC [i][0] = spacingX; 
              spacingX -= 80; 
            }  
            enemyState = 0;             
          }   
        break ; 
      } 
 
      noStroke();
      fill(255,0,0);
      rect(30, 20, life, 28); 
      image(hp, 20, 20);    

      if(getHit(treasureX, treasureY, treasure.width, treasure.height, fighterX, fighterY, fighter.width, fighter.height) == true){     
              life += 20; 
              treasureX = floor(random(50,600));          
              treasureY = floor(random(50,420)); 
      } 
      if(life >= 200){ 
        life = 200; 
      } 
       
      fill(255); 
      text("Score:" + scoreNum, 10, 470); 
    break ;   
      
     
    case Game_END : 
      image(end2, 0, 0);      
      if ( mouseX > 200 && mouseX < 470  
        && mouseY > 300 && mouseY < 350){ 
            image(end1, 0, 0); 
            if(mousePressed){ 
              treasureX = floor( random(50,600) ); 
              treasureY = floor( random(50,420) );       
              enemyState = 0;       
              spacingX = 0;        
              for (int i = 0; i < 5; i++ ){ 
                hitPosition [i][0] = 1000; 
                hitPosition [i][1] = 1000; 
                bulletLim[i] = false; 
                enemyC [i][0] = spacingX; 
                enemyC [i][1] = enemyY;  
                spacingX -= 80; 
                scoreNum = 0; 
              } 
              gameState = Game_RUN; 
            } 
      } 
    break ; 
  }   
} 
 

 

void keyPressed (){ 
  if (key == CODED) { 
    switch ( keyCode ) { 
      case UP : 
        upPressed = true ; 
        break ; 
      case DOWN : 
        downPressed = true ; 
        break ; 
      case LEFT : 
        leftPressed = true ; 
        break ; 
      case RIGHT : 
        rightPressed = true ; 
        break ; 
    } 
  } 
} 
    
    
void keyReleased () { 
  if (key == CODED) { 
    switch ( keyCode ) { 
      case UP :  
        upPressed = false ; 
        break ; 
      case DOWN : 
        downPressed = false ; 
        break ; 
      case LEFT : 
        leftPressed = false ; 
        break ; 
      case RIGHT : 
        rightPressed = false ; 
        break ; 
    }   
  }   
  //shoot bullet 
  if ( keyCode == ' '){ 
    if (gameState == Game_RUN){ 
      if (bulletLim[bulletNum] == false){ 
        bulletLim[bulletNum] = true; 
        bulletX[bulletNum] = fighterX - 10; 
        bulletY[bulletNum] = fighterY + fighter.height/2; 
        bulletNum ++; 
      }    
      if ( bulletNum > 4 ) { 
        bulletNum = 0; 
      } 
    } 
  } 
} 
void scoreChange(int value){ 
  scoreNum += value; 
} 


boolean getHit(float ax, float ay, float aw, float ah, float bx, float by, float bw, float bh){ 
  if (ax >= bx - aw && ax <= bx + bw && ay >= by - ah && ay <= by + bh){ 
  return true; 
  } 
  return false; 
} 

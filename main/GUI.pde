//**************************** user actions ****************************
void keyPressed()  // executed each time a key is pressed: sets the Boolean "keyPressed" till it is released   
                    // sets  char "key" state variables till another key is pressed or released
    {
    //if(key=='~') ;
    //if(key=='!') ; 
    if(key=='@') recordingPDF=true; // to snap an image of the canvas and save as zoomable a PDF, compact, great quality, no background, but does not work for textures or 3D;
    if(key=='#') snapJPGpicture=true; // make a .PDF picture of the canvas, compact, poor quality;
    if(key=='$') snapTIFpicture=true; // make a .TIF picture of the canvas, better quality, but large file 
    //if(key=='%') ; 
    if(key=='^') easeInOut=!easeInOut;
    if(key=='&') showControlArrows=!showControlArrows;
    //if(key=='*') ;    
    //if(key=='(') ;
    //if(key==')') ;  
    if(key=='_') {makeArrows(Sites);}
    if(key=='+') arrowCount = 4;
 
    if(key=='`') for(int i=0; i<10; i++) showPart[i]=false; 
    int k = int(key); 
    if(47<k && k<58) 
      {
      partShown=int(key)-48;  println("v= ",partShown);
      showPart[partShown]=!showPart[partShown]; // toggle
      Sites.loadControlPointsFromFile("data/pts"+str(partShown));
      loadControlArrows("data/arrows"+str(partShown));  // loads sites for that part
      //setPointsToArrows(Sites); // for animation
      } 
    //if(key=='1') ; 
    //if(key=='2') ; 
    //if(key=='3') ; 
    //if(key=='4') ;
    //if(key=='5') ;
    //if(key=='6') ;
    //if(key=='7') ;
    //if(key=='8') ;
    //if(key=='9') ;
    //if(key=='0') ; 
    
    if(key=='-') filmingJPG=!filmingJPG; // filming on/off into IMAGES/MOVIE_FRAMES_JPG/ small size images, use https://gifmaker.me/ to make gif , view in browser
    if(key=='=') filmingTIF=!filmingTIF; // filming on/off into IMAGES/MOVIE_FRAMES_TIF/

    if(key=='a') animate=!animate; // start/stop animation
    //if(key=='b') ; 
    //if(key=='c') ; 
    if(key=='d') ; // used in keyPressed() to delete closest vertex
    //if(key=='e') ;
    //if(key=='f') ; // used for smoothing in myProject
    if(key=='g') ;
    if(key=='h') ; 
    if(key=='i') ; // used in mousePressed and mouseDragged to insert and move a vertex
    //if(key=='j') ;
    //if(key=='k') ;   
    //if(key=='l') ; 
    //if(key=='m') ; // used in mouseDragged to move (translate) all control points 
    //if(key=='n') ; // used in mousePressed to append new control point 
    if(key=='o') 
      {
      ArrowRed.resetBranch(); ArrowGreen.resetBranch(); 
      ArrowBlue.resetBranch(); ArrowMagenta.resetBranch();
      ArrowMetal.resetBranch(); ArrowBanana.resetBranch();
      Sites.resetPointsOnCircle(12);
      arrowCount = 6;
      makeArrows(Sites);
      }
    //if(key=='p') ;
    //if(key=='q') ; 
    if(key=='r') {currentFrame=0; currentTime=0;} 
    if(key=='s') ; // used in mouseDragged to swirl (rotate & zoom) control points
    if(key=='t') ; // used in mousePressed to tweak current time 
    //if(key=='u') ;
    //if(key=='v') ; 
    //if(key=='w') ;  
    //if(key=='x') ; 
    //if(key=='y') ;
    //if(key=='z') ; // 
 
    if(key=='A') showArrows=!showArrows;
    //if(key=='B') ; 
    if(key=='C') {MyText=getClipboard(); StartClip=P(Start); EndClip=P(End);} // text from clipboard written where mouse was when 'C' was pressed
    //if(key=='D') ;  
    //if(key=='E') ;
    //if(key=='F') ;
    //if(key=='G') ; 
    if(key=='H') showHexGrid=!showHexGrid; 
    if(key=='I') showIDs=!showIDs; 
    //if(key=='J') ;
    if(key=='K') showKagomeGrid=!showKagomeGrid;
    if(key=='L') Sites.loadControlPointsFromFile("data/pts"); // read current positions of control points from file;    
    //if(key=='M') ;
    //if(key=='N') ;
    //if(key=='O') ;
    //if(key=='P') ; 
    if(key=='Q') showQuadGrid=!showQuadGrid;  // quit application
    if(key=='R') Sites.resetRandomPoints(numberOfpoints);
    if(key=='S') Sites.saveControlPointsToFile("data/pts");  // write current positions of points to file;    CURRENT
    //if(key=='T') ;
    //if(key=='U') ;
    //if(key=='V') ;
    if(key=='W') showFaceWarp=!showFaceWarp; // *P3*
    //if(key=='X') ;  
    //if(key=='Y') ;
    //if(key=='Z') ;  

    if(key=='{') Sites.loadControlPointsFromFile("data/pts"+str(partShown)); 
    if(key=='}') Sites.saveControlPointsToFile("data/pts"+str(partShown));
    if(key=='|') {}
    if(key=='[') Sites.loadControlPointsFromFile("data/pts"); 
    if(key==']') Sites.saveControlPointsToFile("data/pts");

    if(key==':') {loadControlArrows("data/arrows"+str(partShown)); setPointsToArrows(Sites);}
    if(key=='"') saveControlArrows("data/arrows"+str(partShown));
    
    //if(key=='[') {loadControlArrows("data/arrows"); setPointsToArrows(Sites);}
    //if(key==']') saveControlArrows("data/arrows");
    //if(key=='\\') ;
    
    //if(key==':') ; 
    //if(key=='"') ; 
    
    //if(key==';') ; 
    //if(key=='\''); 
    
    //if(key=='<') ; // used in MyProject
    //if(key=='>') ;  // used in MyProject
    if(key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
   
    if(key==',') {numberOfpoints=max(numberOfpoints/2,4); Sites.resetRandomPoints(numberOfpoints);}
    if(key=='.') {numberOfpoints*=2; Sites.resetRandomPoints(numberOfpoints);}  
    //if(key=='/') ;
  
    //if(key==' ') ;
  
    //if (key == CODED) 
    //   {
    //   String pressed = "Pressed coded key ";
    //   if (keyCode == UP) {pressed="UP";   }
    //   if (keyCode == DOWN) {pressed="DOWN";   };
    //   if (keyCode == LEFT) {pressed="LEFT";   };
    //   if (keyCode == RIGHT) {pressed="RIGHT";   };
    //   if (keyCode == ALT) {pressed="ALT";   };
    //   if (keyCode == CONTROL) {pressed="CONTROL";   };
    //   if (keyCode == SHIFT) {pressed="SHIFT";   };
    //   println("Pressed coded key = "+pressed); 
    //   } 
  
    changed=true; // to make sure that we save a movie frame each time something changes
 //   println("key pressed = "+key+" = "+int(key));
    myKeyPressed(); // defined in TAB MyProject
    }

void mousePressed()   // executed when the mouse buttom was just pressed
  {
  Sites.pickPointClosestTo(Mouse()); // pick vertex closest to mouse: sets pv ("picked vertex") in pts
  if (keyPressed) 
     {
     if (key=='n')  Sites.addPoint(Mouse()); // appends vertex after the last one
     if (key=='s')  Sites.splitEdgeAtProjection(Mouse()); // inserts vertex at closest projection of mouse
     if (key=='d')  Sites.deletePickedPoint(); // deletes vertex closeset to mouse
     if (key=='i')  Sites.splitEdgeAtProjection(Mouse()); // deletes vertex closeset to mouse
     }  
  changed=true;
  myMousePressed(); // execute project specific actions specified in MyProject
  }

  
void mouseDragged() // executed when the mouse is dragged (while mouse buttom pressed)
  {
  if (keyPressed) {
      if (key=='e') Sites.dragPickedPoint();   // drag selected point with mouse
      if (key=='m') Sites.translate(); // move all vertices
      if (key=='z') Sites.swirlAroundScreenCenter(Mouse(),Pmouse()); // swirl all vertices around screen center
      if (key=='t') currentTime+=2.*float(mouseX-pmouseX)/width;  // adjust current time   
      }
  else Sites.dragPickedArrow();   // drag selected point with mouse
  changed=true;
  //myMouseDragged(); // execute project specific actions specified in MyProject
  }  

void mouseWheel(MouseEvent event) { // reads mouse wheel and uses to zoom
  float s = event.getCount();
  Sites.scaleAllPointsAroundCentroid(1.-s/100);
  changed=true;
  }

//**************************** menu  ****************************
String menu0="m/z:move/swirl A/&/e:arrows/control/edit I:IDs [/{:read/P ]/}:write/P";
String menu1="?:help, #:jpg ,/./R:more/less/random a:animate t/r:time/reset ^:ease GIF -:jpg =:tif W:warp C:clip";
//String menu1="n/s/d:new/split/del, m/z/o/I:move/swirl/circ/ID, A/W/e:arrows/warp/edit";
    
//**************************** SELF-GUIDED DEMO  ****************************
/*
a          stop animation
#          save jpg picture in /IMAGES/PICTURES_JPG
t+drag     change time
a          restart animation
^ ^ ^      toggle ease in/out
-          save frames for GIF in /IMAGES/MOVIE_FRAMES_JPG 
a          stop animation
drag       move whole arrow or end
e+drag     move arrow start or end
]          save control arrows to \data\arrows
W          hide face-warp
o          make 9 control arrows around a circle
+          use only 4 control arrows
[          load saved control arrows from \data\arrows
A          hide arrows
1          show demo of Phase 1
2          show demo of Phase 2
C          write content of clipboard on canvas
0          show sandbox
A          show arrows
m+drag     move all arrows
}          save control arrows to \data\arrows0
z          scale and rotation all arrows around screen center
}          load control arrows from \data\arrows0
3          show demo of Phase 3
a          stop animtion
t+drag     change time
*/

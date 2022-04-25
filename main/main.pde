// Course template for 2D projects provided by Prof. Jarek ROSSIGNAC
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
import java.awt.Toolkit;
import java.awt.datatransfer.*;

//**************************** global variables ****************************
// FONT TEXT
PFont font;
String MyText=""; // string copied from clipboard to be printed on canvas FAST
float stringX=0, stringY=0;

// Editable Control points or vertices of polyline,\ / polyloop
PNTS Sites = new PNTS(); // class containing array of points, used to standardize GUI
boolean showIDs = true;

// Arrows
ARROW ArrowRed=Arrow(), ArrowGreen=Arrow(), ArrowBlue=Arrow(), ArrowMagenta=Arrow(), ArrowMetal=Arrow(), ArrowBanana=Arrow();
boolean first=true; // used to distinguish creation and update of arrows
boolean showFaceWarp=false; // used to distinguish creation and update of arrows
boolean showControlArrows=false;
boolean showArrows=false;

// Animation
boolean animate=false;
float currentTime=0, warpedTime=0;  // current and warped time
int currentFrame=0; // frame to advance timing
int framesInAnimation=120; // intermediate frames for the whole animation 
int numberOfpoints=4;


//**************************** initialization ****************************
void setup()               // executed once at the begining 
  {
  //size(900, 900, P2D);     // window size (need P2D for texture mapping)
  size(1200, 1200, P2D);     // window size (need P2D for texture mapping)
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing for drawing curves
  PictureOfStudent1 = loadImage("data/pic1.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  PictureOfStudent2 = loadImage("data/pic2.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  Sites.declare(); // declares all ControlPoints. MUST BE DONE BEFORE ADDING POINTS 
  //ControlPoints.loadControlPointsFromFile("data/pts");  // loads points form file saved with this program
  //ControlPoints.resetPointsOnCircle(18); // uncomment to create new config with 8 or whatever number of points. Then edit them and save with 'S'
  declareArrows();
  loadControlArrows("data/arrows0");
  setPointsToArrows(Sites); 
  int i=0;
  colorMode(HSB, 360, 100, 100); // Hue, saturation, brightness
  textureMode(NORMAL);
  font = loadFont("ChalkboardSE-Regular-32.vlw"); textFont(font, 24);
  loadControlArrows("data/arrows"+str(partShown)); 
  Sites.loadControlPointsFromFile("data/pts"); 
  mySetup();
  } // end of setup

//**************************** display current frame ****************************
void draw()      // executed at each frame
  {
  int i=0;
  background(white); // clear screen by painting white background
  
  textAlign(CENTER,CENTER);

  // advance animation (controlled by 'a')
  if(animate) 
    {
    if(currentFrame==framesInAnimation) currentFrame=0;
    currentFrame++; 
    if (currentFrame>framesInAnimation) {currentFrame=0; animate=false;}
    float t = (float)currentFrame/framesInAnimation;
    float ct=(1.-cos(TWO_PI*t))/2;
    if(easeInOut) currentTime=easeInOut(0,0.5,1,ct); 
    else currentTime=ct;
    }

  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
  if(showQuadGrid) drawQuadGrid(50);
  if(showHexGrid) drawHexGrid(50);
  if(showKagomeGrid) drawKagomeGrid(50);


  // ============ arrows and images
  updateArrows(Sites);
  ARROW MovingArrow1 = SAM(Arrow[0],Arrow[1],currentTime);
  ARROW MovingArrow2 = SAM(Arrow[2],Arrow[3],currentTime);
  ARROW MovingArrow3 = SAM(Arrow[4],Arrow[5],currentTime);
  

  // Displays arrows
  PNT A = MovingArrow1.rP(), D = MovingArrow1.rQ(), 
      B = MovingArrow2.rP(), E = MovingArrow2.rQ(), 
      C = MovingArrow3.rP(), F = MovingArrow3.rQ(); 
      
      
      
      
  if(!showFaceWarp) showMyProject(A,B,C,D,E,F);
     
  //ControlPoints.writeIDsInEmptyDisks(); 


    // show animated face-warp comntrolled by two wiper-arrows, each animated using a steady similarity morph between two control arrows
  if(showFaceWarp && (!keyPressed || key!='e')) showBannerBetweenArrows(MovingArrow1, MovingArrow2, PictureOfStudent1, 64);

  if(showArrows)
    {
    show(MovingArrow1,dred);
    show(MovingArrow2,dgreen);
    show(MovingArrow3,blue);
    if(showControlArrows) 
      {
      showArrows(); 
      if(showIDs) showArrowIDs();
      }
    }

  //if(MyText.length()>0) P(stringX,stringY).writeLabel(MyText,red); // text from clipboard written where mouse was when 'C' was pressed
  showTextFromClipBoard();
  
  showPointer(); // show mouse pointer and mouse and key pressed (will not show on pictures)

  textAlign(LEFT,BOTTOM);
  f(red);
  scribeHeader("Part "+str(partShown)+": "+PartTitle[partShown],3);
  f(black);
  //scribeHeader("time = "+nf(currentTime,0,2),2);

  displayGuide(); // shows help for selected PART of myProject

  fill(black); displayHeader(); // displays header
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 
  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas


  if(filmingTIF && (animate || changed)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(filmingJPG && (animate || changed)) snapFrameToJPG(); // saves image on canvas as movie frame 
  if(snapTIFpicture) snapPictureToTIF();   
  if(snapJPGpicture) snapPictureToJPG();   
  changed=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw
  

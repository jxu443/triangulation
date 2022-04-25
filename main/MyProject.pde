// Class: CS 6491
// Semester: Spring 2022
// Project number: Project3
// Project title: Triangulation
// Student(s): Tian-Ruei Kuan, Jiaxi Xu

//======================= My global variables
PImage PictureOfStudent1, PictureOfStudent2; // picture of students' faces: data/pic1.jpgand data/pic2.jpg

boolean lerp=true, spiral=true; // toggles to display vector interpoations
float b=0, c=0.5, d=1; // initial knots
int partShown = 0;
boolean[] showPart = new boolean[10];
String [] PartTitle = new String[10];


int numberOfParts = PartTitle.length;
PNTS DrawnPoints = new PNTS(); // class containing array of points, used to standardize GUI
PNTS SmoothenedPoints = new PNTS(); // class containing array of points, used to standardize GUI
DUCKS DucksRow = new DUCKS(20);

//**************************** My text  ****************************
String title ="CS6491, Spring 2022, Project 3";            
Boolean team=true; // if team of 2 students
String name = "Jiaxi Xu, Tian-Ruei Kuan";
//String name ="Student: MyFirstName MY-LAST-NAME";

String subtitle = "Triangle-Mesh Processing";    
String guide="MyProject keys: '0' through '9' to select project parts"; // help info

boolean
  showTriangles=true,
  showVertices=true,
  showEdges=true,
  showVisitedTriangles=true,
  showCorner=true,
  showOpposite=false;


//======================= my setup, executed once at the beginning 
void mySetup()
  {
  //DrawnPoints.declare(); // declares all ControlPoints. MUST BE DONE BEFORE ADDING POINTS 
  ////SmoothenedPoints.declare(); // declares all ControlPoints. MUST BE DONE BEFORE ADDING POINTS 
  //DrawnPoints.empty(); // reset pont list P
  //SmoothenedPoints.empty(); // reset pont list P
  //initDucklings(); // creates Ducling[] points
  //loadControlArrows("data/arrows"+str(partShown));  // loads sites for that part
  //setPointsToArrows(Sites); // for animation

  M.reset();   
  M.loadVertices(Sites.G,Sites.pointCount); 

  //M.computeDelaunayTriangulation(); 
  //M.computeOfast();
  //M.labelVerticesAsInteriorOrBorder();
  for(int i=1; i<10; i++) showPart[i]=false; showPart[0]=true;
  }

//======================= called in main() and executed at each frame to redraw the canvas
void showMyProject(PNT A, PNT B, PNT C, PNT D, PNT E, PNT F) // four points used to define 3 vectors
  {
  M.reset();   
  M.loadVertices(Sites.G,Sites.pointCount); 
  if(showPart[0]) showPart0();
  if(showPart[1]) showPart1();
  if(showPart[2]) showPart2();
  if(showPart[3]) showPart3();
  if(showPart[4]) showPart4();
  if(showPart[5]) showPart5();
  if(showPart[6]) showPart6();
  if(showPart[7]) showPart7();
  if(showPart[8]) showPart8();
  if(showPart[9]) showPart9();
  cwF(dgreen,1); if(showIDs) Sites.writeIDsInEmptyDisks();
  //cwF(dred,1); if(showIDs) Sites.showPickedPoint(16);
  }

//====================================================================== PART 0
void showPart0() //
  {
  PartTitle[0] =    "Compute and show Delaunay triangulation"; 
  guide=" ";
  cwF(black,2); 
  //ControlPoints.drawPolyloop(); // draws polyline joining control points
  int n = Sites.pointCount();
  M.computeDelaunayTriangulation(); 
  M.computeOfast();
  M.labelVerticesAsInteriorOrBorder();   
  if(showTriangles) {cwf(dgreen,4,yellow); M.showTriangles();}
  if(showEdges) {cw(dgreen,4); M.showEdges(); }
  if(showEdges) {cw(dred,8); M.showBorderEdges();}
  if(showVertices) M.showVertices(6);
  cwF(grey,1); if(showOpposite) M.showOpposites();  

  fill(magenta); M.showCurrentCorner(5); 
  Sites.drawAllVerticesInColor(3,red); // draw dots at vertices
  if(showIDs) {cwF(blue,1); Sites.writeIDsInEmptyDisks(); }
  cwF(red,1); Sites.showPickedPoint(15);
  }

//====================================================================== PART 1
MESH mesh;
ArrayList<Integer> vertices = new ArrayList<Integer>();
HashMap<Integer, Integer> edges = new HashMap<Integer, Integer>();
int[] overwriteEdge = null;
boolean firstEdgePicked = false;
boolean mouseJustPressed = false;
boolean showSuggested = true;
int[] activeEdge = null;
void showPart1() //    
{
  PartTitle[1] =    "Polygon: User GUI"; 
  guide=" ";
  
  mesh = new MESH();
  mesh.reset();
  mesh.loadVertices(Sites.G,Sites.pointCount);
    
  for(int i = 0; i < vertices.size(); i++)
  {
    int v = vertices.get(i);
    activeEdge = getDefaultActiveEdge(v, mesh);
    if(edges.containsKey(i))
    {
      activeEdge = decompressEdge(edges.get(i), mesh);
    }
    
    addTriangleToMesh(activeEdge[0], activeEdge[1], v, mesh);
  }
  
  Sites.pickPointClosestTo(Mouse());
  if(!firstEdgePicked)
  {
    overwriteEdge = getProjectionEdge(Mouse(), mesh);
  }
  activeEdge = getDefaultActiveEdge(Sites.pv, mesh);
  
  if(overwriteEdge != null)
  {
    activeEdge = overwriteEdge;
  }

  
  // ******************
  Set<int[]> suggestions = new HashSet<int[]>();
  if(showSuggested)
  {
    suggestions = mesh.getSuggestions(activeEdge);
  }
  if(overwriteEdge == null)
  {
    for(int[] suggestion: suggestions)
    {
      if(Sites.pv == suggestion[0])
      {
        activeEdge = new int[]{suggestion[1], suggestion[2]};
      }
    }
  }
  
  if(overwriteEdge != null)
  {
    activeEdge = overwriteEdge;
  }
  
  boolean valid = isValid(Sites.pv, activeEdge, mesh) || !firstEdgePicked;
  
  if(mouseJustPressed)
  {
    if(!keyPressed)
    {
      if(overwriteEdge != null)
      {
        if(showSuggested)
        {
          if(mesh.getSuggestions(overwriteEdge).size() == 0)
          {
            showSuggested = false;
          }
        }
        
        if(firstEdgePicked)
        {
          boolean added = addTriangle(Sites.pv, overwriteEdge); //<>//
          if(vertices.size() > 0 && added)
          {
            overwriteEdge = null;
          }
        }

      }
      else
      {
        boolean useSeggestionEdge = false;
        for(int[] suggestion: suggestions)
        {
          if(Sites.pv == suggestion[0])
          {
            int[] seggestEdge = new int[]{suggestion[1], suggestion[2]};
            int[] defaultEdge = getDefaultActiveEdge(Sites.pv, mesh);
            if(!(defaultEdge[0] == seggestEdge[0] && defaultEdge[1] == seggestEdge[1] || defaultEdge[0] == seggestEdge[1] && defaultEdge[1] == seggestEdge[0]))
            {
              addTriangle(Sites.pv, seggestEdge); //<>//
              useSeggestionEdge = true;
              break;
            }
            
          }
        }
        if(!useSeggestionEdge)
        {        
           addTriangle(Sites.pv);
        }
      }
    }
    else if(key == 'b')
    {
      int[] projEdge = getProjectionEdge(Mouse(), mesh);
      if(overwriteEdge != null && projEdge != null && ((projEdge[0] == overwriteEdge[0] && projEdge[1] == overwriteEdge[1]) || (projEdge[0] == overwriteEdge[1] && projEdge[1] == overwriteEdge[0]))) //<>//
      {
        overwriteEdge = null; //<>// //<>//
      } //<>//
      else
      {
        overwriteEdge = projEdge;
      }
    }
    firstEdgePicked = true;
    if(overwriteEdge == null && vertices.size() == 0)
    {
      firstEdgePicked = false;
    }
    
    mouseJustPressed = false;
  }
  else if(!(keyPressed && key == 'b') && activeEdge != null && firstEdgePicked)
  {
    if(valid)
    {
      addTriangleToMesh(activeEdge[0], activeEdge[1], Sites.pv, mesh);
    }
  }
  
  if(keyPressed && key == 'l')
  {
     loadFile(); 
  }
  if(keyPressed && key == 'k')
  {
     saveFile(); 
  } //<>//
  
  if(showTriangles) {cwf(dgreen,4,yellow); mesh.showTriangles();}
  if(showEdges) {cw(dgreen,4); mesh.showEdges(); }
  if(showEdges) {cw(dred,8); mesh.showBorderEdges();}
  if(showVertices) mesh.showVertices(6);
  cwF(grey,1); if(showOpposite) mesh.showOpposites();  
  
  //fill(magenta); mesh.showCurrentCorner(5); 
  Sites.drawAllVerticesInColor(3,red); // draw dots at vertices
  if(showIDs) {cwF(blue,1); Sites.writeIDsInEmptyDisks(); }
  
  // ******************
  if(showSuggested)
  {
     for(int[] suggestion: suggestions)
     {
        cwF(blue, 3);
        show(Sites.G[suggestion[0]], 15);
     }
  }
  else
  {
    fill(blue);
    text("The Delaunay suggestion stops due to deviation", 600, 200);
  }

  
  
  if(valid)
  {
    cwF(red,1); Sites.showPickedPoint(15);
  }
  
  
  
  if((!(keyPressed && key == 'b') || overwriteEdge != null) && activeEdge != null)
  {
    cwF(black, 8);
    show(Sites.G[activeEdge[0]], Sites.G[activeEdge[1]]);
  }
  
  
  if((!mousePressed && keyPressed && key=='b'))
  {
    int[] previewEdge = getProjectionEdge(Mouse(), mesh);
    cwF(green, 8);
    if(previewEdge != null)
    {
      show(Sites.G[previewEdge[0]], Sites.G[previewEdge[1]]);
    }
  }  
}

boolean addTriangle(int vertax)
{
  if(!isValid(vertax, mesh))
  {
     return false; 
  }
  
  checkIsSuggested(vertax);
  vertices.add(vertax);
  return true;
}

boolean addTriangle(int vertax, int[] edge)
{
  if(!isValid(vertax, edge, mesh))
  {
     return false; 
  }
  
  checkIsSuggested(vertax);
  vertices.add(vertax);
  edges.put(vertices.size() - 1, compressEdge(edge, mesh));
  return true;
}

void checkIsSuggested(int vertax)
{
  if(!showSuggested)
  {
    return;
  }
  Set<int[]> suggestions = mesh.getSuggestions(activeEdge);
  for(int[] suggestion: suggestions)
  {
    if(vertax == suggestion[0])
    {
      int[] seggestEdge = new int[]{suggestion[1], suggestion[2]};
      if(!(activeEdge[0] == seggestEdge[0] && activeEdge[1] == seggestEdge[1] || activeEdge[0] == seggestEdge[1] && activeEdge[1] == seggestEdge[0])){
        showSuggested = false;
      }
      return;
    }
  }
  showSuggested = false;
}
  
int[] getDefaultActiveEdge(int pointIdx, MESH mesh)
{
  PNT point = mesh.G[pointIdx];
  return getProjectionEdge(point, mesh);
}

int[] getProjectionEdge(PNT point, MESH mesh)
{
  if(mesh.nt == 0)
  {
   return getCloestEdgeToMouse();
  }
  
  mesh.computeOfast();
  
  int corner = -1;
  float dist = 1e10;
  for(int c = 0; c < mesh.nc; c++)
  {
    if(mesh.isBeachFacing(c))
    {
      PNT edgeVertax1 = mesh.G[mesh.v(mesh.p(c))];
      PNT edgeVertax2 = mesh.G[mesh.v(mesh.n(c))];
      if(projectsBetween(point, edgeVertax1, edgeVertax2) && disToLine(point, edgeVertax1,  edgeVertax2) < dist)
      {
        corner = c;
        dist = disToLine(point, edgeVertax1, edgeVertax2);
      }
      
      if(d(point, edgeVertax1) < dist)
      {
        int rightEdgeCorner = mesh.rightBeachNeighbor(c);
        VCT bisect = V(V(edgeVertax1, edgeVertax2), V(edgeVertax1, mesh.G[mesh.v(mesh.p(rightEdgeCorner))]));
        if(det(V(edgeVertax1, point), bisect) * det(V(edgeVertax1, edgeVertax2), bisect) >= 0)
        {
          corner = c;
        }
        else
        {
          corner = rightEdgeCorner;
        }
        dist = d(point, edgeVertax1);
        
      }
      
      if(d(point, edgeVertax2) < dist)
      {
        int leftEdgeCorner = mesh.leftBeachNeighbor(c);
        VCT bisect = V(V(edgeVertax2, edgeVertax1), V(edgeVertax2, mesh.G[mesh.v(mesh.n(leftEdgeCorner))]));
        if(det(V(edgeVertax2, point), bisect) * det(V(edgeVertax2, edgeVertax1), bisect) >= 0)
        {
          corner = c;
        }
        else
        {
          corner = leftEdgeCorner;
        }
        dist = d(point, edgeVertax2);
      }
    }
  }
  
  return new int[] {mesh.v(mesh.p(corner)), mesh.v(mesh.n(corner))};
}

int[] getCloestEdgeToMouse()
{
  PNT point = Mouse();
  int[] edge = null;
  float minDist = 1e10;
  
  Sites.pickPointClosestTo(Mouse());
  
  
  for(int i = 0; i < Sites.pointCount(); i++)
  {
    for(int j = i + 1; j < Sites.pointCount(); j++)
    {
      if(projectsBetween(point, Sites.G[i], Sites.G[j]))
      {
        float dist = disToLine(point, Sites.G[i],  Sites.G[j]);
        if(dist < minDist)
        {
          minDist = dist;
          edge = new int[]{i, j};
        }
      }
    }
  }
  
  
  return edge;
}

void addTriangleToMesh(int v1, int v2, int v3, MESH mesh)
{
  if(ccw(mesh.G[v1], mesh.G[v2], mesh.G[v3]))
  {
    mesh.addTriangle(v1, v2, v3);
  }
  else
  {
    mesh.addTriangle(v1, v3, v2);
  }
  mesh.computeOfast();
}

boolean isValid(int vertax, MESH mesh)
{
  int[] edge = getDefaultActiveEdge(vertax, mesh);
  return isValid(vertax, edge, mesh);
}

boolean isValid(int vertax, int[] edge, MESH mesh)
{
  if(edge == null)
  {
     return false; 
  }
  if(vertax == edge[0] || vertax == edge[1])
  {
    return false; 
  }
  if(!isVertaxOnBoundary(vertax, mesh) && isVertaxInsideMesh(vertax, mesh))
  {
    return false; 
  }
  if(isTriangleIntersect(vertax, edge, mesh))
  {
    return false; 
  }
  if(isTriangleContainVertax(vertax, edge, mesh))
  {
    return false;
  }
  
  return true;
}

boolean isVertaxPartOfMesh(int vertax, MESH mesh)
{
  for(int i = 0; i < mesh.nt * 3; i++)
  {
    if(vertax == mesh.V[i])
    {
       return true; 
    }
    
  }
  return false;
}

boolean isVertaxInsideMeshAndNotPartOfTriangle(int vertax, MESH mesh)
{
 mesh.computeOfast();
 
 if(mesh.nt == 0)
 {
   return false; 
 }
  
 if(isVertaxPartOfMesh(vertax, mesh))
 {
   return false;
 }
 
 if(isVertaxInsideMesh(vertax, mesh))
 {
   return false;   
 }
 else
 {
   return true;
 }
}

boolean isVertaxInsideMesh(int vertax, MESH mesh)
{
 if(mesh.nt == 0)
 {
   return false; 
 }
 
 int boundaryCorner = -1;
 for(int i = 0; i < mesh.nc; i++)
 {
   if(mesh.isBeachFacing(i))
   {
     boundaryCorner = i;
     break;
   }
 }
 
 if(boundaryCorner == -1)
 {
  return true; 
 }
 
 int initCorner = boundaryCorner;
 int intersectCount = 0;
 while(true)
 {
   if(linSegmentIntersect(mesh.G[vertax], P(mesh.G[vertax], V(0, 1000000)), mesh.G[mesh.v(mesh.p(boundaryCorner))], mesh.G[mesh.v(mesh.n(boundaryCorner))]))
   {
     intersectCount += 1;     
   }
   boundaryCorner = mesh.rightBeachNeighbor(boundaryCorner);
   if(initCorner == boundaryCorner)
   {
      break;
   }
 }
 
 if(intersectCount % 2 == 1)
 {
   return true; 
 }
 else
 {
   return false;
 }
  
}

boolean linSegmentIntersect(PNT point11, PNT point12, PNT point21, PNT point22)
{
  return det(V(point11, point12), V(point11, point21)) * det(V(point11, point12), V(point11, point22)) < 0 && det(V(point21, point22), V(point21, point11)) * det(V(point21, point22), V(point21, point12)) < 0;
}

boolean isVertaxOnBoundary(int vertax, MESH mesh)
{
 if(mesh.nt == 0)
 {
   return false; 
 }
 
 int boundaryCorner = -1;
 for(int i = 0; i < mesh.nc; i++)
 {
   if(mesh.isBeachFacing(i))
   {
     boundaryCorner = i;
     break;
   }
 }
 if(boundaryCorner == -1)
 {
  return false; 
 }
 
 int initCorner = boundaryCorner;
 while(true)
 {
   if(mesh.v(mesh.p(boundaryCorner)) == vertax || mesh.v(mesh.n(boundaryCorner)) == vertax)
   {
     return true;    
   }
   boundaryCorner = mesh.rightBeachNeighbor(boundaryCorner);
   if(initCorner == boundaryCorner)
   {
      return false;
   }
 }
}

boolean isTriangleIntersect(int vertax, int[] edge, MESH mesh)
{
  for(int i = 0; i < mesh.nc; i++)
  {
    if(mesh.v(i) == vertax || mesh.v(mesh.p(i)) == vertax || mesh.v(mesh.n(i)) == vertax){
      if(mesh.v(i) == edge[0] || mesh.v(mesh.p(i)) == edge[0] || mesh.v(mesh.n(i)) == edge[0])
      {
        if(mesh.v(i) == edge[1] || mesh.v(mesh.p(i)) == edge[1] || mesh.v(mesh.n(i)) == edge[1])
        {
          return true;
        }
      }
    }
    
    if(!(mesh.v(mesh.p(i)) == edge[0] && mesh.v(mesh.n(i)) == edge[1]) || !(mesh.v(mesh.p(i)) == edge[1] && mesh.v(mesh.n(i)) == edge[0]))
    {
      if(linSegmentIntersect(mesh.G[edge[0]], mesh.G[vertax], mesh.G[mesh.v(mesh.p(i))], mesh.G[mesh.v(mesh.n(i))]))
      {
         return true; 
      }
      if(linSegmentIntersect(mesh.G[edge[1]], mesh.G[vertax], mesh.G[mesh.v(mesh.p(i))], mesh.G[mesh.v(mesh.n(i))]))
      {
         return true; 
      }
    }
  }
  return false;
}

boolean isTriangleContainVertax(int vertax, int[] edge, MESH mesh)
{
  PNT p1, p2, p3;
  if(ccw(mesh.G[vertax], mesh.G[edge[0]], mesh.G[edge[1]]))
  {
    p1 = mesh.G[vertax];
    p2 = mesh.G[edge[0]];
    p3 = mesh.G[edge[1]];
  }
  else
  {
    p1 = mesh.G[vertax];
    p2 = mesh.G[edge[1]];
    p3 = mesh.G[edge[0]];
  }
  
  for(int i = 0; i < mesh.nv; i++)
  {
    PNT p = mesh.G[mesh.V[i]];
    if(det(V(p1, p2), V(p1, p)) > 0 && det(V(p2, p3), V(p2, p)) > 0 && det(V(p3, p1), V(p3, p)) > 0 )
    {
       return true; 
    }
  }
  
  return false;
}

int compressEdge(int[] edge, MESH mesh)
{
  if(mesh.nt == 0)
  {
    return edge[0] + mesh.nv * edge[1];
  }
  
  int boundaryCorner = -1;
  
  for(int i = 0; i < mesh.nc; i++)
  {
     if(mesh.isBeachFacing(i))
     {
       boundaryCorner = i;
       break;
     }
  }
  if(boundaryCorner == -1)
  {
      return -1; 
  }
  int i = 0;
  int initCorner = boundaryCorner;
   while(true)
   {
     if(mesh.v(mesh.p(boundaryCorner)) == edge[0] && mesh.v(mesh.n(boundaryCorner)) == edge[1] || mesh.v(mesh.p(boundaryCorner)) == edge[1] && mesh.v(mesh.n(boundaryCorner)) == edge[0])
     {
       return i;    
     }
     boundaryCorner = mesh.rightBeachNeighbor(boundaryCorner);
     i += 1;
     if(initCorner == boundaryCorner)
     {
        return -1;
     }
   }
}


int[] decompressEdge(int edge, MESH mesh)
{
  if(mesh.nt == 0)
  {
    return new int[]{edge % mesh.nv, edge / mesh.nv};
  }
  
  int boundaryCorner = -1;
  
  for(int i = 0; i < mesh.nc; i++)
  {
     if(mesh.isBeachFacing(i))
     {
       boundaryCorner = i;
       break;
     }
  }
  if(boundaryCorner == -1)
  {
      return null; 
  }
  
  for(int i = 0; i < edge; i++)
  {
    
    boundaryCorner = mesh.rightBeachNeighbor(boundaryCorner);
    
  }
  
  return new int[]{mesh.v(mesh.p(boundaryCorner)), mesh.v(mesh.n(boundaryCorner))};
}

void saveFile()
{
  String[] vStringList = new String[vertices.size()];
  for(int i = 0; i < vertices.size(); i++)
  {
    vStringList[i] = vertices.get(i).toString();
  }
  
  String[] eStringList = new String[edges.size() * 2];
  int i = 0;
  for(Map.Entry e: edges.entrySet())
  {
    eStringList[i] = e.getKey().toString();
    i++;
    eStringList[i] = e.getValue().toString();
    i++;
  }
  saveStrings("data/save.txt", new String[]{join(vStringList, ','), join(eStringList, ',')});
}

void loadFile()
{
  String[] lines = loadStrings("data/save.txt");
  
  String[] vStringList = split(lines[0], ',');
  vertices = new ArrayList<Integer>();
  for(int i = 0; i < vStringList.length; i++)
  {
    vertices.add(int(vStringList[i]));
  }
  
  String[] eStringList = split(lines[1], ',');
  edges = new HashMap<Integer, Integer>();
  for(int i = 0; i < eStringList.length / 2; i++)
  {
    edges.put(int(eStringList[2 * i]), int(eStringList[2 * i + 1]));
  }
}


//====================================================================== PART 2
void showPart2() //
  {
  PartTitle[2] =    "Polygon: Our Delaunay Triangulation"; 
  guide=" ";
  
  MESH mesh = new MESH();
  mesh.reset();
  mesh.loadVertices(Sites.G,Sites.pointCount);
  //cwF(black,2); 
  //ControlPoints.drawPolyloop(); // draws polyline joining control points
  int n = Sites.pointCount();
  mesh.myDelaunayTriangulation();
  mesh.computeOfast();
  mesh.labelVerticesAsInteriorOrBorder();  
  
  if(showTriangles) {cwf(dgreen,4,yellow); mesh.showTriangles();}
  if(showEdges) {cw(dgreen,4); mesh.showEdges(); }
  if(showEdges) {cw(dred,8); mesh.showBorderEdges();}
  if(showVertices) mesh.showVertices(6);
  
  fill(magenta); mesh.showCurrentCorner(5); 
  Sites.drawAllVerticesInColor(3,red); // draw dots at vertices
  if(showIDs) {cwF(blue,1); Sites.writeIDsInEmptyDisks(); }
  cwF(red,1); Sites.showPickedPoint(15);
  }
 
//====================================================================== PART 3
void showPart3() //    
  {
  PartTitle[3] =    "Polygon: ???"; 
  guide=" ";
  }


//====================================================================== PART 4
void showPart4() //    
  {
  PartTitle[4] =    "Polygon: ???"; 
  guide=" ";
  }



//====================================================================== PART 5
void showPart5() //    
  {
  PartTitle[5] =    "Polygon: ???"; 
  guide=" ";
  }
  

//====================================================================== PART 5
void showPart6() //    
  {
  PartTitle[6] =    "Polygon: ???"; 
  guide=" ";
  }
  


  
  
//====================================================================== PART 7
void showPart7() //    
  {
  PartTitle[7] =   "Cubic interpolating motion";
  guide="";
  }


  
//====================================================================== PART 8
void showPart8() //    
  {
  PartTitle[8] =   "Arrows";
  guide="";
  updateArrows(Sites);
  ARROW MovingArrow1 = SAM(Arrow[0],Arrow[1],currentTime);
  ARROW MovingArrow2 = SAM(Arrow[2],Arrow[3],currentTime);
  ARROW MovingArrow3 = SAM(Arrow[4],Arrow[5],currentTime);
  

  // Displays arrows
  PNT A = MovingArrow1.rP(), D = MovingArrow1.rQ(), 
      B = MovingArrow2.rP(), E = MovingArrow2.rQ(), 
      C = MovingArrow3.rP(), F = MovingArrow3.rQ(); 
      

  }
    
//====================================================================== PART 9
void showPart9() //    
  {
  PartTitle[9] =   "Smoothing while I draw";
  guide="Place. Press RMB to erase&start. Hold LMB & drag. Wait till all ducks arrive. Release.";
  PNT SmoothP = DucksRow.move(Mouse());
  if(mousePressed && (mouseButton == RIGHT))
    {
    DrawnPoints.empty(); 
    SmoothenedPoints.empty(); 
    DucksRow.init(Mouse());
    }
  if(mousePressed && (mouseButton == LEFT))
    {
    DrawnPoints.addPoint(Mouse()); 
    SmoothenedPoints.addPoint(SmoothP); 
    }
  cwF(orange,1); DrawnPoints.drawCurve();
  cwF(blue,5); SmoothenedPoints.drawPolylineWithGaps(); // SmoothenedPoints.drawCurve(); 
  DucksRow.showRow();
  }
  
  


    
//======================= called when a key is pressed
void myKeyPressed()
  {
  //int k = int(key); if(47<k && k<58) partShown=int(key)-48;
  if(key=='<') {DucksRow.decrementCount(); }
  if(key=='>') {DucksRow.incrementCount(); }
  }
  
//======================= called when the mouse is dragged
void myMouseDragged()
  {
  if (keyPressed) 
    {
    //if (key=='b') b+=2.*float(mouseX-pmouseX)/width;  // adjust knot value b    
    //if (key=='c') c+=2.*float(mouseX-pmouseX)/width;  // adjust knot value c    
    //if (key=='d') d+=2.*float(mouseX-pmouseX)/width;  // adjust knot value a 
    }
  }

//======================= called when the mouse is pressed
void myMousePressed()
{
  mouseJustPressed = true;
  if(partShown == 1)
  {
    if(!keyPressed) 
    {
      
      /*Sites.pickPointClosestTo(Mouse());
      if(overwriteEdge != null)
      {
        addTriangle(Sites.pv, overwriteEdge);
        overwriteEdge = null;
      }
      else
      {
        addTriangle(Sites.pv);
      }
    }
    else
    {
      if(key=='b')
      {
        overwriteEdge = getProjectionEdge(Mouse(), mesh);
      }
      */
    }
    
  }
}
  

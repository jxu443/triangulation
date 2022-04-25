import java.util.*;

// TRIANGLE MESH
MESH M = new MESH(); // TRIANGLE MESH USED FOR THE PROJECT
int rb=100;
int rt =3;
int   mcc=10;
float  thickness=1;
float stepSize=5; // step size for locomotion

class MESH 
  {
  // VERTICES
  int nv=0, maxnv = 1000;  
  PNT[] G = new PNT [maxnv];   // geoemtry (vertex location) will be copied from Sites                     
  boolean[] isInterior = new boolean[maxnv];        // lable of the vertex indicating interior or border                              
  float[] sumOfWeights = new float[maxnv];          // for normalizing the weights

  // TRIANGLES 
  int nt = 0;
  int maxnt = maxnv*2;                           
  boolean[] visitedTriangles = new boolean[maxnt];                                      

  // CORNERS 
  int c=0;    // current corner                                                              
  int nc = 0; 
  int[] V = new int [3*maxnt];   
  int[] O = new int [3*maxnt];  
 
  MESH() {for (int i=0; i<maxnv; i++) G[i]=new PNT();}

  void reset() {nv=0; nt=0; nc=0;}               
  void resetVisitedTriangles() {for (int t=0; t<nt; t++) visitedTriangles[t]=false;}
  
  void loadVertices(PNT[] P, int n) {nv=0; for (int i=0; i<n; i++) addVertex(P[i]);}
  void writeVerticesTo(PNTS P) {for (int i=0; i<nv; i++) P.G[i].setTo(G[i]);}
  void addVertex(PNT P) { G[nv++].setTo(P); }                                             // adds a vertex to vertex table G
  void addTriangle(int i, int j, int k) {V[nc++]=i; V[nc++]=j; V[nc++]=k; nt=nc/3; }     // adds triangle (i,j,k) to V table

  // CORNER OPERATORS
  int c (int t) {return t*3;}                   // corner of triangle t
  int t (int c) {int r=int(c/3); return(r);}                   // triangle of corner c
  int n (int c) {int r=3*int(c/3)+(c+1)%3; return(r);}         // next corner
  int p (int c) {int r=3*int(c/3)+(c+2)%3; return(r);}         // previous corner
  int v (int c) {return V[c];}                                // vertex of c
  int o (int c) {return O[c];}                                // opposite corner
  int l (int c) {return o(n(c));}                             // left
  int s (int c) {return n(o(n(c)));}                             // left
  int u (int c) {return p(o(p(c)));}                             // left
  int r (int c) {return o(p(c));}                             // right
  PNT LocationOfVertexOfCorner (int c) {return G[V[c]];}                             // shortcut to get the point where the vertex v(c) of corner c is located
  PNT LocationOfCornerDot(int c) {return P(0.6,LocationOfVertexOfCorner(c),0.2,LocationOfVertexOfCorner(p(c)),0.2,LocationOfVertexOfCorner(n(c)));}   // computes offset location of point at corner c

  boolean isBeachFacing(int c) {return(O[c]==c);};  // a border (beach-facing) corner
  boolean isNotBeachFacing(int c) {return(O[c]!=c);};  // not a border corner

  // CURRENT CORNER OPERATORS
  void next() {c=n(c);}
  void previous() {c=p(c);}
  void opposite() {c=o(c);}
  void left() {c=l(c);}
  void right() {c=r(c);}
  void swing() {c=s(c);} 
  void unswing() {c=u(c);} 
  void printInfo() {println("c = "+c+", nc = "+nc+", 3nt = "+3*nt+", nt = "+nt+", nv="+nv);}

  // DISPLAY
  void showCurrentCorner(float r) { if(isBeachFacing(c)) cwf(black,1,red); else cwf(black,1,grey); show(LocationOfCornerDot(c),r); };   // renders corner c as small ball
  void showEdgeFacingCorner(int c) {w(rt); show(LocationOfVertexOfCorner(p(c)),LocationOfVertexOfCorner(n(c))); };  // draws edge of t(c) opposite to corner c
  void showVertices(float r) // shows all vertices green/yellow inside, red outside
    {
    for (int v=0; v<nv; v++) 
      {
      if(isInterior[v]) cwf(dgreen,2,yellow); else cwf(dred,2,red);
      show(G[v],r);
      }
    }                          
  void drawTriangles() // draws all triangles (edges, or filled)
    { 
    for (int c=0; c<nc; c+=3) show(LocationOfVertexOfCorner(c), LocationOfVertexOfCorner(c+1), LocationOfVertexOfCorner(c+2)); 
    }         
  void showTriangles() // shows nearly flat triangles in magenta
    { 
    for (int c=0; c<nc; c+=3) 
      {
      if(isFlatterThan(LocationOfVertexOfCorner(c), LocationOfVertexOfCorner(c+1), LocationOfVertexOfCorner(c+2), 10)) fill(magenta); 
      else fill(yellow);
      show(LocationOfVertexOfCorner(c), LocationOfVertexOfCorner(c+1), LocationOfVertexOfCorner(c+2)); 
      }
    }         // draws all triangles (edges, or filled)
  void showEdges() {for (int i=0; i<nc; i++) if(i<=o(i)) showEdgeFacingCorner(i); };         // draws all edges of mesh twice
  void showBorderEdges() {for (int i=0; i<nc; i++) {if (isBeachFacing(i)) {showEdgeFacingCorner(i);}; }; };         // draws all border edges of mesh
  void showNonBorderEdges() {for (int i=0; i<nc; i++) {if (!isBeachFacing(i)) {showEdgeFacingCorner(i);}; }; };         // draws all border edges of mesh

  
  
  void showVoronoiEdges () 
    {
    for (int b=0; b<nc; b++) 
      if (isNotBeachFacing(b)) 
        if (b<o(b)) show(triCircumcenter(b),triCircumcenter(o(b)));
    }

void computeDelaunayTriangulation() {     // performs Delaunay triangulation using a quartic algorithm
   c=0;                   // to reset current corner
   PNT X = new PNT(0,0);
   float r=1;
   for (int i=0; i<nv-2; i++) for (int j=i+1; j<nv-1; j++) for (int k=j+1; k<nv; k++)
     if(!isFlatterThan(G[i],G[j],G[k], thickness))
       {    
       X=CircumCenter(G[i],G[j],G[k]);  r = d(X,G[i]);
       boolean found=false; 
       for (int m=0; m<nv; m++) if ((m!=i)&&(m!=j)&&(m!=k)&&(d(X,G[m])<=r)) found=true;  
       if (!found) if (ccw(G[i],G[j],G[k])) addTriangle(i,j,k); else addTriangle(i,k,j); 
       }; 
   }  

// *** public helper methods***
void printVTable() {
  System.out.println("******printVTable nc = " + nc); //
  for (int i = 0; i < nc; i++) {
    System.out.println(V[i]);
  }
}

void printOTable() {
  System.out.println("******printOTable");
  for (int i = 0; i < nc; i++) {
    System.out.println(O[i]);
  }
}

// @return: Set of int[3] = {int vertex, int edgeV1, int edgeV2}  
Set<int[]> getSuggestions(int[] activeEdge) {
  System.out.println("*** get Suggestions ***");
  // new mesh s.t. the curr mesh is intact
  Set<int[]> result = new HashSet<>(); // to return 
  MESH tempMesh = new MESH();
  tempMesh.reset();
  tempMesh.loadVertices(G, nv);
  tempMesh.myDelaunayTriangulation();
  
  HashMap<Integer, Integer> borderEdges = new HashMap<>();
  Set<Integer> borderV = new HashSet<>();
  if(nt == 0) { // if edge only
    if (!validEdge(tempMesh, activeEdge)) return result; 
    borderV.add(activeEdge[0]);  
    borderV.add(activeEdge[1]);
    
    borderEdges.put(activeEdge[0],activeEdge[1]);
    borderEdges.put(activeEdge[1],activeEdge[0]);
  } else {
    for (int i=0; i< nc; i++) {
      if (isBeachFacing(i)) {
        borderV.add(v(p(i))); 
        borderV.add(v(n(i)));
       
        borderEdges.put(v(p(i)),v(n(i)));
      }
    }
  }
  System.out.println("borderEdges.size is " + borderEdges.size() );
  
  int[] verticesMatchPerTri = new int[tempMesh.nt];
  int[] suggestedC = new int[tempMesh.nt];
  for (int i = 0; i < tempMesh.nc; i++) { 
    if (borderV.contains(tempMesh.V[i])) verticesMatchPerTri[i/3]++;
    else suggestedC[i/3] = i;
  }
  
  HashMap<Integer, int[]> res = new HashMap<>();
  for (int i = 0; i  < verticesMatchPerTri.length; i++) {
    if (verticesMatchPerTri[i] == 2) {
      int c = suggestedC[i];
      int p = tempMesh.p(c);
      int n = tempMesh.n(c);
      int[] val = res.put(tempMesh.V[c], new int[]{tempMesh.V[p], tempMesh.V[n]});
      if (val != null ) {
        if (val[0] < tempMesh.V[p]) {
          res.put(tempMesh.V[c], val); 
        } else if (val[0] == tempMesh.V[p] &&  val[1] < tempMesh.V[n]) {
          res.put(tempMesh.V[c], val);
        }
      }
    }
  }
 
  // hashmap to set and check if val[0] val[1] is a valid edge;
  for(Map.Entry<Integer, int[]> entry : res.entrySet()) {
    Integer keyy = entry.getKey();
    int[] value = entry.getValue();
    if ((borderEdges.get(value[0]) != null && borderEdges.get(value[0]) == value[1]) 
       || (borderEdges.get(value[1]) != null && borderEdges.get(value[1]) == value[0])) {
       result.add(new int[]{keyy, value[0], value[1]});
    }
    // do what you have to do here
    // In your case, another loop.
  }
  
  for (int[] tri: result) {
    System.out.format("res contains {%d, %d, %d} \n", tri[0], tri[1], tri[2]);
  }
  return result;
}

boolean validEdge(MESH mesh, int[] edge) {
  for (int i = 0; i < mesh.nc; i++) {
    int edge0 = mesh.v(mesh.p(i)) ;
    int edge1 = mesh.v(mesh.n(i)) ;
    if (edge[0] == edge0 && edge[1] == edge1  ) return true;
    if (edge[1] == edge0 && edge[0] == edge1  ) return true;
  }
  return false; 
}

// *** Bowyer-Waston Delaunay Triangulation ***
List<Integer[]> triangulation = new LinkedList<>();  // addTriangulation(a, b, c, true)
List<Integer[]> badTriangulation = new LinkedList<>();    // addTriangulation(a, b, c, false)

void myDelaunayTriangulation() {
  findSuperTriangle(); 
  
  for (int i = 0; i < nv-3; i ++) { // i < nv-3
    int n = triangulation.size();
    //System.out.println(" i =  " + i + " and n = " + n);
    badTriangulation.clear();
    int[] triIdxToRemove = new int[n];
    int cnt = 0;
    for (int j = 0; j < n; j ++) { // for each triangulation, find bad ones
      //System.out.println("j is " + j);
      Integer[] Vert  = getTriangulation(j, true);
      PNT O = CircumCenter(G[Vert[0]],G[Vert[1]],G[Vert[2]]);  
      float radius = d(O,G[Vert[0]]);
      if (d(O, G[i]) < radius) { // add to bad triangle
        if (i == 3) {
          //System.out.format("bad tri vertices are %d, %d, %d \n",Vert[0], Vert[1], Vert[2]);
        }
        addTriangulation(Vert[0], Vert[1], Vert[2], false);
        triIdxToRemove[cnt++] = j;
      }
    }
   
    Set<String> polygon = new HashSet<>(); // Set cannot compare array equal
    int edgeCnt = 0;
    for (int j = 0; j < badTriangulation.size(); j ++) { // for each BAD triangulation
      Integer[] BadVert  = getTriangulation(j, false);
     
      for (int k = 0; k < 3; k++) {
        Integer[] edge =  {BadVert[k],BadVert[(k+1)%3]};
        if (BadVert[k] > BadVert[(k+1)%3]) {edge[0] = BadVert[(k+1)%3]; edge[1] = BadVert[k];}
        if (edge[0] == 0 && edge[1] == 12) edgeCnt++;
        
        String curr = Integer.toString(edge[0]) + '-' + Integer.toString(edge[1]); // "1-2"
        if (polygon.contains(curr))  { polygon.remove(curr); } 
        else { polygon.add(curr);}
      }
    }   
    
    for (int k = cnt-1; k >= 0; k--) { // remove badtriangle from end to beginning
      triangulation.remove(triIdxToRemove[k]);
    }
    
    for (String edge: polygon) {
      String[] edgeV = edge.split("-");  
      addTriangulation(i, Integer.parseInt(edgeV[0]),Integer.parseInt(edgeV[1]), true);
    }
  }
  
  for (int k = triangulation.size()-1; k >= 0 ; k--) { // remove super triangle from end to beginning 
    Integer[] Vert  = getTriangulation(k, true);
    int c = nv - 3;
    if (Vert[0] >= c || Vert[1] >= c || Vert[2] >= c ) triangulation.remove(k);
  }
  
  nv = nv - 3;
  for (int k = 0; k < triangulation.size(); k++) {
    Integer[] Vert  = getTriangulation(k, true);
    if (ccw(G[Vert[0]],G[Vert[1]],G[Vert[2]])) 
      addTriangle(Vert[0],Vert[1],Vert[2]); 
    else addTriangle(Vert[0],Vert[2],Vert[1]); 
  }
}

private void findSuperTriangle() {
  float max = Integer.MIN_VALUE;
  int maxIdx = 0;
  for (int i= 1; i < nv; i ++) {
    if (d (G[0], G[i]) > max) {
      max = d (G[0], G[i]);
      maxIdx = i;
    }
  }
  VCT vec = V(2, V(G[0], G[maxIdx]));
  for (int j = 0; j < 3; j++) {
    float radius = j * 2 * PI /3; // ccw
    PNT vertex = P(G[0], R(vec, radius));
    //System.out.format("super triangle vertices is (%f, %f) \n", vertex.x, vertex.y);
    G[nv++] = vertex;
  }
  //addTriangle(nv-3, nv-2, nv-1);
  addTriangulation(nv-3, nv-2, nv-1, true);
  
}

private void addTriangulation(int a, int b, int c, boolean addToTriangulation) {
  Integer[] x = {a, b, c};
  if (addToTriangulation) triangulation.add(x);
  else badTriangulation.add(x);
}

private Integer[] getTriangulation(int idx, boolean getFromTriangulation) {
  Integer[] x;
  if (getFromTriangulation) x = triangulation.get(idx);
  else x = badTriangulation.get(idx);
  return x;
}

  void computeO() {   // slow method to set the O table from the V table, assumes consistent orientation of tirangles
    for (int i=0; i<3*nt; i++) {O[i]=i;};  // init O table to -1: has no opposite (i.e. is a border corner)
    for (int i=0; i<3*nt; i++) {  for (int j=i+1; j<3*nt; j++) {       // for each corner i, for each other corner j
      if( (v(n(i))==v(p(j))) && (v(p(i))==v(n(j))) ) {O[i]=j; O[j]=i;};};}; // make i and j opposite if they match 
   }
  
  void computeOfast() // faster method for computing O
    {                                          
    int nIC [] = new int [maxnv];                            // number of incident corners on each vertex
    //println("COMPUTING O: nv="+nv +", nt="+nt +", nc="+nc );
    int maxValence=0;
    for (int c=0; c<nc; c++) {O[c]=c;};                      // init O table to -1: has no opposite (i.e. is a border corner)
    for (int v=0; v<nv; v++) {nIC[v]=0; };                    // init the valence value for each vertex to 0
    for (int c=0; c<nc; c++) {nIC[v(c)]++;}                   // computes vertex valences
    for (int v=0; v<nv; v++) {if(nIC[v]>maxValence) {maxValence=nIC[v]; };};  // println(" Max valence = "+maxValence+". "); // computes and prints maximum valence 
    int IC [][] = new int [maxnv][maxValence];                 // declares 2D table to hold incident corners (htis can be folded into a 1D table !!!!!)
    for (int v=0; v<nv; v++) {nIC[v]=0; };                     // resets the valence of each vertex to 0 . It will be sued as a counter of incident corners.
    for (int c=0; c<nc; c++) {IC[v(c)][nIC[v(c)]++]=c;}        // appends incident corners to corresponding vertices     
    for (int c=0; c<nc; c++) {                                 // for each corner c
      for (int i=0; i<nIC[v(p(c))]; i++) {                     // for each incident corner a of the vertex of the previous corner of c
        int a = IC[v(p(c))][i];      
        for (int j=0; j<nIC[v(n(c))]; j++) {                   // for each other corner b in the list of incident corners to the previous corner of c
           int b = IC[v(n(c))][j];
           if ((b==n(a))&&(c!=n(b))) {O[c]=n(b); O[n(b)]=c; };  // if a and b have matching opposite edges, make them opposite
           };
        };
      };
    } // end computeOfast  

  PNT triCenter(int c) {return P(LocationOfVertexOfCorner(c),LocationOfVertexOfCorner(n(c)),LocationOfVertexOfCorner(p(c))); }  // returns center of mass of triangle of corner c

  PNT triCircumcenter(int c) {return CircumCenter(LocationOfVertexOfCorner(c),LocationOfVertexOfCorner(n(c)),LocationOfVertexOfCorner(p(c))); }  // returns circumcenter of triangle of corner c

  void showOpposites()
    {
    for (int i=0; i<nc; i++) 
      if(!isBeachFacing(i)) 
        drawParabolaInHat(LocationOfCornerDot(i),P(LocationOfVertexOfCorner(n(i)),LocationOfVertexOfCorner(p(i))),LocationOfCornerDot(o(i)),5);
      
    }
  
  int countBorders()
    {
    int b=0;
    for (int c=0; c<3*nt; c++) if(isBeachFacing(c)) b++;
    return b;
    }

  int cornerIndexFromVertexIndex(int v) {for (int c=0; c<3*nt; c++) if(v(c)==v) return c; return -1;} 
 


//******************************************************** FOR 3451 PROJECT 4 2020 ********************************************************

  void labelVerticesAsInteriorOrBorder() 
    { 
    for (int v=0; v<nv; v++) isInterior[v]=true;
    for (int c=0; c<nc; c++) if(isBeachFacing(c)) isInterior[v(n(c))]=false;
    }               


  int leftBeachNeighbor(int cc)
    {
    if(isNotBeachFacing(cc)) return cc; // not beach facing
    int n = p(cc);
    while(isNotBeachFacing(n)) n=p(o(n));
    return n;
    }

  int rightBeachNeighbor(int cc)
    {
    if(isNotBeachFacing(cc)) return cc;
    int p = n(cc);
    while(isNotBeachFacing(p)) p=n(o(p));
    return p;
    }

  void showBeachNeighbors(float r)
    {
    if(isBeachFacing(c)) 
      {
      cwf(dgreen,1,green); show(LocationOfCornerDot(leftBeachNeighbor(c)),r);
      cwf(blue,1,cyan); show(LocationOfCornerDot(rightBeachNeighbor(c)),r);
      }
    }

  void validateSmoothenBorderWithCubicPredictor(float ratio) { // even interior vertiex locations
    VCT[] W = new VCT [nv];    // correction vectors
    for (int c=0; c<nc; c++) 
      if(isBeachFacing(c))
        {
        PNT A = LocationOfVertexOfCorner(n(leftBeachNeighbor(leftBeachNeighbor(c)))); 
        PNT B = LocationOfVertexOfCorner(n(leftBeachNeighbor(c))); 
        PNT C = LocationOfVertexOfCorner(n(c)); 
        PNT D = LocationOfVertexOfCorner(n(rightBeachNeighbor(c))); 
        PNT E = LocationOfVertexOfCorner(n(rightBeachNeighbor(rightBeachNeighbor(c)))); 
        float dAB = d(A,B), dBD = d(B,D), dDE = d(D,E); 
        float d=dBD/2, e=d+dDE;
        float b=-d,a=b-dAB;
        PNT P = L(a,A,b,B,d,D,e,E,0); 
        W[v(n(c))] = V(ratio,V(C,P)); 
        }
    cwf(magenta,2,magenta);
    for (int v=0; v<nv; v++) 
      if(!isInterior[v]) show(G[v],W[v]);
    }


  void smoothenBorderWithCubicPredictor(float ratio) { // even interior vertiex locations
    VCT[] W = new VCT [nv];    // correction vectors
    for (int c=0; c<nc; c++) 
      if(isBeachFacing(c))
        {
        PNT A = LocationOfVertexOfCorner(n(leftBeachNeighbor(leftBeachNeighbor(c)))); 
        PNT B = LocationOfVertexOfCorner(n(leftBeachNeighbor(c))); 
        PNT C = LocationOfVertexOfCorner(n(c)); 
        PNT D = LocationOfVertexOfCorner(n(rightBeachNeighbor(c))); 
        PNT E = LocationOfVertexOfCorner(n(rightBeachNeighbor(rightBeachNeighbor(c)))); 
        float dAB = d(A,B), dBD = d(B,D), dDE = d(D,E); 
        float d=dBD/2, e=d+dDE;
        float b=-d,a=b-dAB;
        PNT P = L(a,A,b,B,d,D,e,E,0); 
        W[v(n(c))] = V(ratio,V(C,P)); showThin(C,W[v(n(c))]);
        }
    for (int c=0; c<nc; c++) 
      if(isBeachFacing(c))
        {
        G[v(n(c))].translate(W[v(n(c))]);
        }        
    }

  void validateSmoothenBorderWithTuck(float ratio) { // even interior vertiex locations
    VCT[] W = new VCT [nv];    // correction vectors
    for (int c=0; c<nc; c++) 
      if(isBeachFacing(c))
        {
        PNT B = LocationOfVertexOfCorner(n(leftBeachNeighbor(c))); 
        PNT C = LocationOfVertexOfCorner(n(c)); 
        PNT D = LocationOfVertexOfCorner(n(rightBeachNeighbor(c))); 
        PNT P = P(B,D); // average
        W[v(n(c))] = V(ratio,V(C,P)); 
        }
    cwf(blue,2,blue);
    for (int v=0; v<nv; v++) 
      if(!isInterior[v]) show(G[v],W[v]);
    }


  void smoothenBorderWithTuck(float ratio) { // even interior vertiex locations
    VCT[] W = new VCT [nv];    // correction vectors
    for (int c=0; c<nc; c++) 
      if(isBeachFacing(c))
        {
        PNT B = LocationOfVertexOfCorner(n(leftBeachNeighbor(c))); 
        PNT C = LocationOfVertexOfCorner(n(c)); 
        PNT D = LocationOfVertexOfCorner(n(rightBeachNeighbor(c))); 
        PNT P = P(B,D); // average
        W[v(n(c))] = V(ratio,V(C,P)); 
        showThin(C,W[v(n(c))]);
        }
    for (int c=0; c<nc; c++) 
      if(isBeachFacing(c))
        {
        G[v(n(c))].translate(W[v(n(c))]);
        }        
    }

  void validateRedistributeInteriorVerticesTowardsNeighbors(float ratio)  // even interior vertiex locations
    {  
    VCT[] W = new VCT [nv];    // correction vectors
    for (int v=0; v<nv; v++) W[v]=V();
    for (int v=0; v<nv; v++) sumOfWeights[v]=0;
    cwf(blue,2,blue);
    for (int c=0; c<nc; c++) 
      if(isInterior[v(c)]) 
        {
        W[v(c)].add( V( LocationOfVertexOfCorner(c) , LocationOfVertexOfCorner(n(c)) ) );
        sumOfWeights[v(c)]+=1;
        }
    for (int v=0; v<nv; v++) 
      if(isInterior[v]) 
        if(sumOfWeights[v]>0.00001) W[v].scaleBy(ratio/sumOfWeights[v]);     
    for (int v=0; v<nv; v++) 
      if(isInterior[v]) show(G[v],W[v]);     
    }
    
  void redistributeInteriorVerticesTowardsNeighbors(float ratio)  // even interior vertiex locations
    {    
    VCT[] W = new VCT [nv];    // correction vectors
    for (int v=0; v<nv; v++) W[v]=V();
    for (int v=0; v<nv; v++) sumOfWeights[v]=0;
    for (int c=0; c<nc; c++) 
      if(isInterior[v(c)]) 
        {
        W[v(c)].add( V( LocationOfVertexOfCorner(c) , LocationOfVertexOfCorner(n(c)) ) );
        sumOfWeights[v(c)]+=1;
        }
    for (int v=0; v<nv; v++) 
      if(isInterior[v]) W[v].scaleBy(ratio/sumOfWeights[v]);     
    for (int v=0; v<nv; v++) 
      if(isInterior[v]) G[v].translate(W[v]);     
    }

  void validateRedistributeInteriorVerticesTowardsLink(float ratio)  // even interior vertiex locations
    {    
    VCT[] W = new VCT [nv];    // correction vectors
    for (int v=0; v<nv; v++) W[v]=V();
    for (int v=0; v<nv; v++) sumOfWeights[v]=0;
    for (int c=0; c<nc; c++) 
     if(isInterior[v(c)]) 
       {
       PNT C = LocationOfVertexOfCorner(c), A = LocationOfVertexOfCorner(n(c)), B = LocationOfVertexOfCorner(p(c));
       VCT N = R(U(B,A));
       float h = dot(N,V(C,A));
       float w = d(A,B);
       VCT V = V(h*w,N);
       W[v(c)].add(V);
       sumOfWeights[v(c)]+=w;
       }
    for (int v=0; v<nv; v++) 
      if(isInterior[v]) 
        if(sumOfWeights[v]>0.00001) W[v].scaleBy(ratio*2/sumOfWeights[v]);     
    cwf(magenta,2,magenta);
    for (int v=0; v<nv; v++) 
      if(isInterior[v]) show(G[v],W[v]);
    }

  void redistributeInteriorVerticesTowardsLink(float ratio)  // even interior vertiex locations
    {    
    VCT[] W = new VCT [nv];    // correction vectors
    for (int v=0; v<nv; v++) W[v]=V();
    for (int v=0; v<nv; v++) sumOfWeights[v]=0;
    for (int c=0; c<nc; c++) 
     if(isInterior[v(c)]) 
       {
       PNT C = LocationOfVertexOfCorner(c), A = LocationOfVertexOfCorner(n(c)), B = LocationOfVertexOfCorner(p(c));
       VCT N = R(U(B,A));
       float h = dot(N,V(C,A));
       float w = d(A,B);
       VCT V = V(h*w,N);
       W[v(c)].add(V);
       sumOfWeights[v(c)]+=w;
       }
    for (int v=0; v<nv; v++) 
      if(isInterior[v]) 
        G[v].translate(ratio*2/sumOfWeights[v],W[v]);     
    }


  }  
  
  
  
  
  

//************************************************************************
//**** CIRCLES
//************************************************************************
// create 
PNT CircumCenter (PNT A, PNT B, PNT C) // CircumCenter(A,B,C): center of circumscribing circle, where medians meet)
  {
  VCT AB = V(A,B); VCT AC = R(V(A,C)); 
  return P(A,1./2/dot(AB,AC),V(-n2(AC),R(AB),n2(AB),AC)); 
  }
  
float circumRadius (PNT A, PNT B, PNT C)     // radiusCircum(A,B,C): radius of circumcenter 
  {
  float a=d(B,C), b=d(C,A), c=d(A,B), 
  s=(a+b+c)/2, 
  d=sqrt(s*(s-a)*(s-b)*(s-c)); 
  return a*b*c/4/d;
  } 

// display 
void drawCircleFast(int n) 
  {  
  float x=1, y=0; float a=TWO_PI/n, t=tan(a/2), s=sin(a); 
  beginShape(); 
    for (int i=0; i<n; i++) 
      {
      x-=y*t; y+=x*s; x-=y*t; 
      vertex(x,y);
      } 
  endShape(CLOSE);
  }

void showArcSCE(PNT A, PNT O, PNT C) // start center end
  {
  float r=d(O,A);
  VCT OA=V(O,A), OC=V(O,C);
  float w = angle(OA,OC); 
  if(w<0) w += TWO_PI;
  beginShape(); 
    v(A); 
    for (float t=0; t<1.005; t+=0.01) v(R(A,t*w,O)); 
    v(C); 
  endShape();
  }

void showArcCVw(PNT C, VCT V, float w)
  {
  float e=w/30;
  int k = 30;
  beginShape();
  for(int i=0; i<k; i++) v(P(C,R(V,w*i/(k-1))));
  endShape();
  }

void sampleArcSCE(PNT A, PNT O, PNT C) // start center end
  {
  float r=d(O,A);
  VCT OA=V(O,A), OC=V(O,C);
  float w = angle(OA,OC); 
  if(w<0) w += TWO_PI;
  v(A); 
  for (float t=0; t<0.995; t+=0.01) v(R(A,t*w,O)); 
  v(C); 
  }


void showArcThrough (PNT A, PNT B, PNT C) 
  {
  if (abs(dot(V(A,B),R(V(A,C))))<0.01*d2(A,C)) {show(A,C); return;}
  PNT O = CircumCenter ( A,  B,  C); 
  float r=d(O,A);
  VCT OA=V(O,A), OB=V(O,B), OC=V(O,C);
  float b = angle(OA,OB), c = angle(OA,OC); 
  if(0<c && c<b || b<0 && 0<c)  c-=TWO_PI; 
  else if(b<c && c<0 || c<0 && 0<b)  c+=TWO_PI; 
  beginShape(); 
    v(A); 
    for (float t=0; t<1; t+=0.01) v(R(A,t*c,O)); 
    v(C); 
  endShape();
  }

void sampleArcThrough(PNT A, PNT B, PNT C) 
  {
  if (abs(dot(V(A,B),R(V(A,C))))<0.01*d2(A,C)) {show(A,C); return;}
  PNT O = CircumCenter ( A,  B,  C); 
  float r=d(O,A);
  VCT OA=V(O,A), OB=V(O,B), OC=V(O,C);
  float b = angle(OA,OB), c = angle(OA,OC); 
  if(0<c && c<b || b<0 && 0<c)  c-=TWO_PI; 
  else if(b<c && c<0 || c<0 && 0<b)  c+=TWO_PI; 
    v(A); 
    for (float t=0; t<1; t+=0.01) v(R(A,t*c,O)); 
    v(C); 
  }

PNT pointOnArcThrough (PNT A, PNT B, PNT C, float t) 
   { 
   if (abs(dot(V(A,B),R(V(A,C))))<0.001*d2(A,C)) {show(A,C); return L(A,C,t);}
   PNT O = CircumCenter ( A,  B,  C); 
   float r=(d(O,A) + d(O,B)+ d(O,C))/3;
   VCT OA=V(O,A), OB=V(O,B), OC=V(O,C);
   float b = angle(OA,OB), c = angle(OA,OC); 
   if(0<b && b<c) {}
   else if(0<c && c<b) {b=b-TWO_PI; c=c-TWO_PI;}
   else if(b<0 && 0<c) {c=c-TWO_PI;}
   else if(b<c && c<0) {b=TWO_PI+b; c=TWO_PI+c;}
   else if(c<0 && 0<b) {c=TWO_PI+c;}
   else if(c<b && b<0) {}
   return R(A,t*c,O);
   }
   
void drawCircleInHat(PNT PA, PNT B, PNT PC){
  float e = (d(B,PC)+d(B,PA))/2;
  PNT A = P(B,e,U(B,PA));
  PNT C = P(B,e,U(B,PC));
  VCT BA = V(B,A), BC = V(B,C);
  float d = dot(BC,BC) / dot(BC,V(BA,BC));
  PNT X = P(B,d,V(BA,BC));
  float r=abs(det(V(B,X),U(BA))); 
  VCT XA = V(X,A), XC = V(X,C); 
  float a = angle(XA,XC), da=a/60; 
   beginShape(); 
   if(a>0) for (float w=0; w<=a; w+=da) v(P(X,R(XA,w))); 
   else for (float w=0; w>=a; w+=da) v(P(X,R(XA,w)));
   endShape();
  }   
  
void sampleCircleInHat(PNT PA, PNT B, PNT PC){
  float e = (d(B,PC)+d(B,PA))/2;
  PNT A = P(B,e,U(B,PA));
  PNT C = P(B,e,U(B,PC));
  VCT BA = V(B,A), BC = V(B,C);
  float d = dot(BC,BC) / dot(BC,V(BA,BC));
  PNT X = P(B,d,V(BA,BC));
  float r=abs(det(V(B,X),U(BA))); 
  VCT XA = V(X,A), XC = V(X,C); 
  float a = angle(XA,XC), da=a/60; 
  if(a>0) for (float w=0; w<=a; w+=da) v(P(X,R(XA,w))); 
  else for (float w=0; w>=a; w+=da) v(P(X,R(XA,w)));
  }   

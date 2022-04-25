//************************************************************************
//**** TRIANGLES
//************************************************************************
float triangleThickness(PNT A, PNT B, PNT C) {float a = abs(disToLine(A,B,C)), b = abs(disToLine(B,C,A)), c = abs(disToLine(C,A,B)); return min (a,b,c); } 
boolean isFlatterThan(PNT A, PNT B, PNT C, float r) {return triangleThickness(A,B,C)<r; } 
boolean ccw(PNT A, PNT B, PNT C) {return det(V(A,B),V(A,C))>0 ;} // CLOCKWISE

// measures used for computing centroid and moment axis of polygon 
float triangleArea(PNT A, PNT B, PNT C) 
  {
  return dot(R(V(A,B)),V(A,C)) / 2; 
  }

float triangleMoment(PNT A, PNT B, PNT C) 
  {
  float b = d(A,B); 
  VCT T=U(A,B); 
  VCT N = R(T);
  VCT AC=V(A,C); 
  float h = dot(AC,N);
  float a = dot(AC,T);
  return ( b*b*b*h - a*b*b*h + a*a*b*h + b*h*h*h )/36.; 
  }
  
PNT TipOfEquilateralTriangle(PNT A, PNT B) {return P(A,R(V(A,B),PI/3));}

//===== PARABOLA
void drawParabolaInHat(PNT A, PNT B, PNT C, int rec) {
   if (rec==0) { show(A,B); show(B,C); } //if (rec==0) { beam(A,B,rt); beam(B,C,rt); } 
   else { 
     float w = (d(A,B)+d(B,C))/2;
     float l = d(A,C)/2;
     float t = l/(w+l);
     PNT L = L(A,t,B);
     PNT R = L(C,t,B);
     PNT M = P(L,R);
     drawParabolaInHat(A,L,M,rec-1); drawParabolaInHat(M,R,C,rec-1); 
     };
   };

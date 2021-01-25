import g4p_controls.*;

// Parameters
float canvasSize = 1000; //NOTE cant init canvas with variables, so make sure if you change these to also change the size() method
float toolbarWidth = 200;

// drawing fields
float outerHeight = 0.9, innerHeight = 0.65;
float outerWidth = 0.2, innerWidth = 0.1;

float outerCentreOffset = 0.18, outerCentreHandleLength = 0.2, outerEndHandleLength = 0.4;
float innerCentreOffset = 0.16, innerCentreHandleLength = 0.1;

float outerOrbRadius = 0.04, innerOrbRadius = 0.04;

float lineThickness = 6, orbThickness = 6;

//generated fields
float cX, cY;

float outerA, outerB;
float innerA, innerB;

// toolbar fields
float controlHeight = 50;
float controlPadding = 25;


// UI Controls
GButton test;
GButton saveButton;

GSlider outerWidthSlider;
GSlider outerHeightSlider;
GSlider innerWidthSlider;
GSlider innerHeightSlider;

GSlider outerCentreOffsetSlider;
GSlider outerCentreHandleLengthSlider;
GSlider outerEndHandleLengthSlider;

GSlider innerCentreOffsetSlider;
GSlider innerCentreHandleLengthSlider;

GSlider innerOrbRadiusSlider;
GSlider outerOrbRadiusSlider;

// Setup
void setup() {
  
  size(1200, 1000);
 
  Toolbar();
  
  Redraw();
}

void draw()
{
}

void Toolbar()
{
  //0 - Save button
  saveButton = new GButton(this, ControlX(), ControlY(0), ControlWidth(), ControlHeight(), "Save");
  saveButton.addEventHandler(this, "Save");
  
  // Sliders
  outerWidthSlider = CreateSlider(1, "Outer Width", outerWidth, "SetOuterWidth");
  outerHeightSlider = CreateSlider(2, "Outer Height", outerHeight, "SetOuterHeight");
  innerWidthSlider = CreateSlider(3, "Inner Width", innerWidth, "SetInnerWidth");
  innerHeightSlider = CreateSlider(4, "Inner Height", innerHeight, "SetInnerHeight");
  
  outerCentreOffsetSlider = CreateSlider(5, "Outer Centre Offset", outerCentreOffset, "SetOuterCentreOffset");
  outerCentreHandleLengthSlider = CreateSlider(6, "Outer Centre Handle Length", outerCentreHandleLength, "SetOuterCentreHandleLength");
  outerEndHandleLengthSlider = CreateSlider(7, "Outer End Handle Length", outerEndHandleLength, "SetOuterEndHandleLength");
  
  innerCentreOffsetSlider = CreateSlider(8, "Inner Centre Offset", innerCentreOffset, "SetInnerCentreOffset");
  innerCentreHandleLengthSlider = CreateSlider(9, "Inner Centre Handle Length", innerCentreHandleLength, "SetInnerCentreHandleLength");
  
  innerOrbRadiusSlider = CreateSlider(10, "Inner Orb Radius", innerOrbRadius, "SetInnerOrbRadius");
  outerOrbRadiusSlider = CreateSlider(11, "Outer Orb Radius", outerOrbRadius, "SetOuterOrbRadius");
}

GSlider CreateSlider(int index, String label, float value, String method){
  
  float py = ControlY(index);
  float h = ControlHeight() / 2.0;
  
  //Label
  new GLabel(this, ControlX(), py, ControlWidth(), h, label);
  
  //Slider
  GSlider slider = new GSlider(this, ControlX(), py + h, ControlWidth(), h, h);
  slider.setLimits(value, 0, 1);
  slider.setShowLimits(true);
  slider.setShowValue(true);
  slider.addEventHandler(this, method);
  return slider;
}

void Save(GButton button, GEvent event){
  String y = String.valueOf(year());
  String m = String.valueOf(month());
  String d = String.valueOf(day());
  String h = String.valueOf(hour());
  String mi = String.valueOf(minute());
  String s = String.valueOf(second());
  
  String filename = y + "-" + m + "-" + d + "_" + h + "-" + mi + "-" + s + ".png";
  
  save(filename);
}
void SetOuterWidth(GSlider slider, GEvent event){
  outerWidth = slider.getValueF();
  Redraw();
}
void SetOuterHeight(GSlider slider, GEvent event){
  outerHeight = slider.getValueF();
  Redraw();
}
void SetInnerWidth(GSlider slider, GEvent event){
  innerWidth = slider.getValueF();
  Redraw();
}
void SetInnerHeight(GSlider slider, GEvent event){
  innerHeight = slider.getValueF();
  Redraw();
}
void SetOuterCentreOffset(GSlider slider, GEvent event){
  outerCentreOffset = slider.getValueF();
  Redraw();
}
void SetOuterCentreHandleLength(GSlider slider, GEvent event){
  outerCentreHandleLength = slider.getValueF();
  Redraw();
}
void SetOuterEndHandleLength(GSlider slider, GEvent event){
  outerEndHandleLength = slider.getValueF();
  Redraw();
}
void SetInnerCentreOffset(GSlider slider, GEvent event){
  innerCentreOffset = slider.getValueF();
  Redraw();
}
void SetInnerCentreHandleLength(GSlider slider, GEvent event){
  innerCentreHandleLength = slider.getValueF();
  Redraw();
}
void SetInnerOrbRadius(GSlider slider, GEvent event){
  innerOrbRadius = slider.getValueF();
  Redraw();
}
void SetOuterOrbRadius(GSlider slider, GEvent event){
  outerOrbRadius = slider.getValueF();
  Redraw();
}

// Draw
void Redraw()
{
  background(255);
  stroke(0);

  cX = CanvasPointX(0.5);
  cY = CanvasPointY(0.5);

  outerA = cY - CanvasLength(0.5 * outerHeight);
  outerB = cY + CanvasLength(0.5 * outerHeight);

  innerA = cY - CanvasLength(0.5 * innerHeight);
  innerB = cY + CanvasLength(0.5 * innerHeight);

  DrawJoints();

  DrawInnerCurves();

  DrawOuterCurves();

  DrawOrbs();
}

void DrawJoints()
{
  strokeWeight(lineThickness);

  line(cX, outerA, cX, innerA);
  line(cX, outerB, cX, innerB);
}

void DrawInnerCurves()
{
  strokeWeight(lineThickness);
  noFill();

  float midA = cY - CanvasLength(innerCentreOffset), midB = cY + CanvasLength(innerCentreOffset);
  float l = cX - CanvasLength(0.5 * innerWidth), r = cX + CanvasLength(0.5 * innerWidth);
  float handleLength = CanvasLength(innerCentreHandleLength);

  //curve 1: innerA -> midA left -> centre -> midB right -> innerB
  bezier(cX, innerA, cX, innerA, l, midA - handleLength, l, midA);
  bezier(l, midA, l, midA + handleLength, cX, cY, cX, cY);
  bezier(cX, cY, cX, cY, r, midB - handleLength, r, midB);
  bezier(r, midB, r, midB + handleLength, cX, innerB, cX, innerB);

  //curve 2: innerA -> midA right -> centre -> midB left -> innerB
  bezier(cX, innerA, cX, innerA, r, midA - handleLength, r, midA);
  bezier(r, midA, r, midA + handleLength, cX, cY, cX, cY);
  bezier(cX, cY, cX, cY, l, midB - handleLength, l, midB);
  bezier(l, midB, l, midB + handleLength, cX, innerB, cX, innerB);
}

void DrawOuterCurves()
{
  strokeWeight(lineThickness);
  noFill();

  float midA = cY - CanvasLength(outerCentreOffset), midB = cY + CanvasLength(outerCentreOffset);
  float l = cX - CanvasLength(0.5 * outerWidth), r = cX + CanvasLength(0.5 * outerWidth);
  float centreHandleLength = CanvasLength(outerCentreHandleLength);
  float endHandleLength = CanvasLength(outerEndHandleLength);

  //curve 1: outerA -> midA left -> innerB
  bezier(cX, outerA, cX, outerA, l, midA - centreHandleLength, l, midA);
  bezier(l, midA, l, midA + centreHandleLength, cX, innerB - endHandleLength, cX, innerB);

  //curve 2: outerA -> midA right -> innerB
  bezier(cX, outerA, cX, outerA, r, midA - centreHandleLength, r, midA);
  bezier(r, midA, r, midA + centreHandleLength, cX, innerB - endHandleLength, cX, innerB);

  //curve 1: outerB -> midB left -> innerA
  bezier(cX, outerB, cX, outerB, l, midB + centreHandleLength, l, midB);
  bezier(l, midB, l, midB - centreHandleLength, cX, innerA + endHandleLength, cX, innerA);

  //curve 2: outerB -> midA right -> innerA
  bezier(cX, outerB, cX, outerB, r, midB + centreHandleLength, r, midB);
  bezier(r, midB, r, midB - centreHandleLength, cX, innerA + endHandleLength, cX, innerA);
}

void DrawOrbs() 
{
  ellipseMode(CENTER);
  
  strokeWeight(orbThickness);
  fill(255);
  
  float outerRadius = CanvasLength(outerOrbRadius);
  float innerRadius = CanvasLength(innerOrbRadius);
  
  ellipse(cX, outerA, outerRadius, outerRadius);
  ellipse(cX, outerB, outerRadius, outerRadius);
  
  ellipse(cX, innerA, innerRadius, innerRadius);
  ellipse(cX, innerB, innerRadius, innerRadius);  
}

// UTIL
float CanvasLength(float length)
{
  return length * canvasSize;
}
float CanvasPointX(float posX)
{
  return toolbarWidth + CanvasLength(posX);
}
float CanvasPointY(float posY)
{
  return CanvasLength(posY);
}

float ControlX()
{
  return controlPadding;
}
float ControlY(int index)
{
  return controlPadding + (index * (controlPadding + controlHeight));
}
float ControlWidth()
{
  return toolbarWidth - (2 * controlPadding);
}
float ControlHeight()
{
  return controlHeight;
}

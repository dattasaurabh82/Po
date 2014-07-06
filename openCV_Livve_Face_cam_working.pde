/****//******************************///
/****/import gab.opencv.*;/**********///
/****/import processing.video.*;/****/// //all the libraries you need to call
/****/import java.awt.*;/************///
/****/import processing.serial.*;/***/// //Serial librry
/****//******************************///

//******************//
/**/Capture video;/**/
/**/OpenCV opencv;/**/ // all the objects 
/**/Serial port;/****/ // serial object
//******************//

PImage small; 
int scaleFactor = 1;//play around with it.

int faceMid_X, faceMid_Y; //var to store mid points of faces

void setup() {
  size(640, 480, P2D); // window size

  println(Serial.list()); // List COM-ports
  port = new Serial(this, Serial.list()[2], 19200); // In my case it's COM9 and it's 2nd in the list
                                                    // Check outin your case and change
                                                    // Also the Baud rate can be played around with
                                                    // Try to keep it maximum so that there is no lag
                                                    // between face detection and servo's movement
  String[] cameras = Capture.list(); 
  // Since I'm playing with two external webcams
  // I need to assign them for different purposes
  // The above line prints out a list of available config cameras
  // choose one for you and use it below

  if (cameras == null) { // if there is no ext web camera 
    println("Failed to retrieve the list of available cameras, will try the default...");
    //use default one
    video = new Capture(this, 640, 480);
  }
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);// Printing all the list of cameras
    }

    video = new Capture(this, 640, 480, "HP Webcam 1300", 30); // camera name and  frame rate. It's my 9th camera in the config list
    opencv = new OpenCV(this, video.width/scaleFactor, video.height/scaleFactor);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);//saved config of frontal face
                                                   //comes with the lib
                                                   //you don't have to change anything

    small = createImage(opencv.width, opencv.height, ARGB);

    video.start();
  }
}

void draw() {

  image(video, 0, 0 );
  filter(GRAY);// greyscale filter
               // just for aesthetics.  

  small.copy(video, 0, 0, video.width, video.height, 0, 0, small.width, small.height);
  opencv.loadImage(small);

  //drawing the grid
  // I don't know why for loop was not working
  // Anybody can correct and shorten this part here?
  // Although it also adds up to the aesthetics
  noFill();
  strokeWeight(0.3);
  stroke(255, 255, 255);
  //vertical grid lines
  line(0, 0, 0, 480);
  line(80, 0, 80, 480);
  line(160, 0, 160, 480);
  line(160+80, 0, 160+80, 480);
  line(320, 0, 320, 480);
  line(320+80, 0, 320+80, 480);
  line(320+160, 0, 320+160, 480);
  line(320+240, 0, 320+240, 480);
  line(640, 0, 640, 480);
  //hor grid lines
  line(0, 0, 640, 0);
  line(0, 60, 640, 60);
  line(0, 120, 640, 120);
  line(0, 180, 640, 180);
  line(0, 240, 640, 240);
  line(0, 300, 640, 300);
  line(0, 360, 640, 360);
  line(0, 420, 640, 420);

  //Texts on the applet
  fill(255, 255, 0);
  text("FaceTracker", 18, 22);
  text("an open-source tool for", 18, 44);
  text("controlling servos with", 18, 56);
  text("frontal face position", 18, 69);
 // text()
  text("x_pos: ", 18, 120);
  text("y_pos: ", 18, 135);
  text("Iteracted by Saurabh Datta", 18, 460);



  scale(scaleFactor);

  Rectangle[] faces = opencv.detect();
 
  //println(faces.length); // checks if face is detected

  if (faces.length>0) {
    //if face detected i.e if faces.length==1
    fill(255, 0, 0);
    text("FACE DETECTED", 18, 100); // say face detecetd on the applet window

    for (int i = 0; i < faces.length; i++) {
      // Drawing bounding rectangle around the face
      // with cross hairs. (Aesthetics and function)
      stroke(255, 0, 0);
      strokeWeight(1);
      noFill();
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
      //println(faces[i].x, " " , faces[i].width);
      
      //face vertical mid cross hair
      stroke(255, 0, 0);
      strokeWeight(1);
      noFill();
      line(faces[i].x + ((faces[i].width)/2), faces[i].y, faces[i].x + ((faces[i].width)/2), faces[i].y + faces[i].height);
      
      //face horizontal mid cross hair
      stroke(255, 0, 0);
      strokeWeight(1);
      noFill();
      line(faces[i].x, (faces[i].y)+((faces[i].height)/2), faces[i].x+faces[i].width, (faces[i].y)+((faces[i].height)/2));
      
      // assigning Mid-points of the bounding rectangles. 
      int faceMid_X = (faces[i].x)+((faces[i].width)/2);
      int faceMid_Y = (faces[i].y)+((faces[i].height)/2);
      //println(faceMid_X);
      
      // putting the values of the mid-points on the applet window
      fill(255, 255, 0);
      text(faceMid_X, 60, 120);
      text(faceMid_Y, 60, 135);

     //*************************************
      // you can play with both this config for checking if the face's on 
      // middle of the window
      /*if(faces[i].x<260){
      port.write("d");
      }
      if(faces[i].x+faces[i].width>380){
      port.write("a");
      }*/
      if(faceMid_X<300){port.write("d");}
      if(faceMid_X>340){port.write("a");}
      //***********************************
    }
  } else {
    fill(0, 0, 0);
    text("NO FACE DETECETD", 18, 100);
  }
}

void captureEvent(Capture c) {
  c.read();
}


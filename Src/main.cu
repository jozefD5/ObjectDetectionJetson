/*
 * main.cu
 *
 *  Created on: 29 Dec 2021
 *  Author: J.Duda
 */


#include <iostream>
#include <vector>
#include <chrono>

#include "opencv2/core.hpp"
#include "opencv2/opencv.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/opencv_modules.hpp"

#include <opencv2/core/cuda.hpp>
#include <opencv2/cudaimgproc.hpp>
#include <opencv2/cudaarithm.hpp>
#include <opencv2/cudaobjdetect.hpp>


using std::cout;
using std::endl;
using std::vector;

using namespace cv;
using namespace std::chrono;





//global variables
uint8_t         camera_number = 0;          //camera selection value
VideoCapture    camera;                     //camera object
Mat             camera_frame;               //matrix object to store camera's image
cuda::GpuMat    frame_gpu, objbuf;          //gpu frame matrix and object matrix to store detected objects

vector<Rect>    faces_detect_vect;          //faces detect vector
Scalar draw_color = Scalar(255, 0, 0);      //colour to draw rectangle on detected faces

//string containing location of cascade pre-trained model
std::string            cascade_name = "/home/pepo/opencv/data/haarcascades_cuda/haarcascade_frontalface_default.xml";

//cascade classifier for object detection
Ptr<cuda::CascadeClassifier> cascade_gpu = cuda::CascadeClassifier::create(cascade_name);


// Timers for tracking fps and string for printing fps
high_resolution_clock::time_point    start_time, end_time;
milliseconds                         elapsed_time;
int                                  fps;
std::string                          fps_text;



int main()
{
	cout << "\n---Object Detection (Dev 1.0): Start---\n\n";
	cuda::printShortCudaDeviceInfo(0);
	cout << "\n\n";


	//open camera, and check if camera was opened successful
	camera.open(camera_number);

	if (!camera.isOpened()) {
		cout << "Camera Open: Error" << endl;
		return -1;
	}
	else {
		cout << "Camera Open: OK" << endl;
	}



	//set cascade classifier parameters
	cascade_gpu->setFindLargestObject(true);
	cascade_gpu->setScaleFactor(1.1);
	cascade_gpu->setMinNeighbors(4);
	cascade_gpu->setMinObjectSize(cv::Size(40,40));



	//video stream loop
	while(true){

		//get camera's frame (video stream
		camera >> camera_frame;

		//check if frame is empty
		if(!camera_frame.empty()){


			start_time = std::chrono::high_resolution_clock::now();  //get start time of the loop


			faces_detect_vect.clear();                               //clear face detect vector before use

			frame_gpu.upload(camera_frame);                          //upload standard Mat (frame) to cuda format

			cuda::equalizeHist(frame_gpu, frame_gpu);                //apply equaliser to frame, helps with object detection

			cascade_gpu->detectMultiScale(frame_gpu, objbuf);        //detect required objects in a frame

			cascade_gpu->convert(objbuf, faces_detect_vect);         //convert object array to standard array/vector

			frame_gpu.download(camera_frame);                        //download gpu frame format to standard Mat format


			//draw rectangle on detected objects
			for(int i=0; i < faces_detect_vect.size(); ++i){
				rectangle(camera_frame, faces_detect_vect[i], draw_color);
			}


			//calculate fps
			end_time = high_resolution_clock::now();
			elapsed_time = duration_cast<milliseconds>(end_time - start_time);
			fps = 1000 / elapsed_time.count();

			//print info on frame
			putText(
					camera_frame,
					"FPS: " +  std::to_string(fps) + "   Obj Detected: " + std::to_string(faces_detect_vect.size() ),
					Point(50,50),
					FONT_HERSHEY_DUPLEX,
					1,
					draw_color,
					2);


			//display processed frame
			imshow("Test Window", camera_frame);
		}


		//exit loop if any key is pressed
		if(waitKey(1) > 0){
			break;
		}
	}



	//close camera and window
	camera.release();
	destroyAllWindows();

	cout << "\n---Object Detection: Finished---" << endl;
	return 0;
}








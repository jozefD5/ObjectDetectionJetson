# ObjectDetectionJetson
Object Detection using OpenCV for Tegra and Jetson device with e-con camera. Project was developed using NVIDIA's Nsight (eclips) on ubuntu 18.06 for Jetson Nano Dev Kit with JetPack 4.6.

#Jetson SDK commonents should be installed via SDK manager. This provides cuda components for Jetson device.
#OpenCV (OpenCV for Tegra) provided by Nvidia's SDK manager will NOT work as it dosen't include cuda support. Therfore, 
instructions in following link should be used to install OpenCV with cuda support

https://qengineering.eu/install-opencv-4.5-on-jetson-nano.html



--- Project Setup Requirments ---

1)setup include directory path for OpenCV within nisght IDE Project -> Properties -> Build -> Settings -> Tools Settings -> NVCC Compiler -> Includes add following path for opencv in 'Include paths(-)' section /usr/include/opencv4


2)setup libraries within nisght IDE Project -> Properties -> Build -> Settings -> Tools Settings -> NVCC Linker -> Libraries add following library path within the 'Library search path (-L)' /user/lib

also add following libraries within the 'Libraries (-l)'

    opencv_core
    opencv_highgui
    opencv_imgproc
    opencv_video
    opencv_videoio 
    opencv_cudev
    opencv_cudaimgproc
    opencv_cudaobjdetect
    opencv_cudafilters 
    opencv_cudaarithm




Configure 'run configuration' this is used to start application remotly from host. Right click on project and sellect Run As -> Remote Configurations -> Enviroment and add following enviroment variable DISPLAY=:0











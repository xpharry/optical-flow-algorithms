# optical flow

This work is one part of replicating of the LRCN paper, following the guide in https://people.eecs.berkeley.edu/~lisa_anne/LRCN_video.

In the original paper, the optical flows is generated using Brox's Algorithm as shown in the folder "eccv2004Matlab".

We implement the optical flow algorithm in python with Farnback's Algorithm and hopefully it would be faster than in Matlab.

# eccv2004Matlab

This folder contains Matlab Mex-Function for running optical flow as presented at ECCV 2004 by Thomas Brox. [Download Source Code here.](http://lmb.informatik.uni-freiburg.de/resources/binaries/eccv2004Matlab.zip)

Also, the according C++ Library and Executables can be found in [Classical Variational Optical Flow](http://lmb.informatik.uni-freiburg.de/resources/software.php).

The guide for using can be found in its own "readme" file.

# Our Python Implementation

The code under the folder "py" are our python version and has been tested in Python 2.7.13 and OpenCV 3.2.

## Example Use

* For single test, run

    `create_optical_flow.py`

    which only accepts two frames for testing.

* For massive optical flow generating, run

    `create_flow_images_LRCN.py`

    which processes with RGB input specified the path in "base" and save the generated optical flow images into the folder specified in "save_base".

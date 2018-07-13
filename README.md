# Comparison of Disparity Estimation Algorithms

Stereo matching, which is the most profound understanding way of human vision system, is one of the key research areas in image processing, especially in terms of 3D reconstruction, depth estimation. We can divide these literature in two sub class which are monocular and binocular stereo vision. For monocular stereo vision, we can say depth from movement too. It means we use images which was taken from the same camera but in different time with some of translation. It is obvious that, this camera has to move. Unless we cannot take different pose of environment. In that scenario there are some more issues such as we have to estimate camera transformation from first timestamp to the second time stamp and this translation is not fixed. Binocular stereo vision system is about using two identical and same baseline camera, so we know the translation to left one to the right one. That is why binocular stereo system is more practical and relatively easy than another’s. 

Binocular stereo system is the one concentration point of us in that research. Calibrated camera and already rectified pair of images will be input of our system. For that reason, we will just focus on horizontal disparity within these two camera images. As the same in human being visual system as well, the closest object’s horizontal disparities’ are bigger than the farthest object’s disparities. So we can say the farthest object the lesser disparity. Within disparity calculation, we can reconstruct 3D model of the environment with this information. Depth information is very important especially in medical sciences, game industry, robotic and virtual reality application. 
By the first step which consist of camera calibration and rectifying, we can get the two image’s line scans represent almost the same part of the sensing environment. Second step is more crucial and important in stereo vision literature which consist of finding correspondence within the left and right image. In literature there are plenty of different methods and still most of the researches carry on to this subject. We do not make a profound literature review, but basically we can divide these method into two group named, feature based and region based methods. Briefly, region based method tries to match sub-region of both left and right images, but feature based method tries to match not all the pixels but just some more important pixels. To find best matches, we can use some distance measuring approach such as correlation or SSD measures. But every times find the best matches does not give us best performance for overall matching results. To gain overall best matching in literature there are dynamic programming approach and energy minimization approach called Markov Random Field. 

In this project, we implemented three disparity estimation algorithm which are simple block matching, block matching with dynamic programming approach and finally Stereo Matching using Belief Propagation algorithm.

## Simple Block Matching

To find corresponding points in stereo images, one of the common and benchmark method is obviously plain block matching. This algorithm is used in this research as the beginning algorithm to find corresponding points between the left and right images that used along the experimental of stereo matching. The block matching algorithm is used to minimize the matching errors between the blocks at any position into reference left image and right image. To find the most similar block we need to check all possible block in the right image which has the same row number but different columns. The searching space has to be in allowable disparity which has to be given once.  To measure similarity between reference block and the block checked, sum of absolute difference (SAD) was used in this research [1]. We can summarize this approach as following equation.

*diff(y,x)_d=∑_(-W≤j≤W) ∑_(-W≤i≤W) |I_left (y+j,x+i)-I_right (y+j,x+i+d)|,      for  d=[0,d_max]*

In that formula (y,x) refers pixel position of the image. Ileft and Iright shows reference (left) and right image. W refers the halh of the block size. As you can see the summing space is from –W to +W. So we need to calculate 2*W+1 rows and cols, which means the total of block size is 2*W+1. We need to calculate this sum of absolute value for every single pixel and for every d value in range of [0, dmax]. As a result we can assign disparirt value of pixel located (y,x) by following equation.

*disparity(y,x)=argmin┬d⁡(diff(y,x)_d)*

Which means, we need to select optimum d value which provide us minimum diff value which calculated for location (y,x) along the 2*W+1 block size.

## Block Matching with Dynamic Programming Approach

The most problematic side of simple block matching is it is lack of provide a spatial consistency which means the output of simple matching algorithm has big variation. That is why we can see too many artifact on the result. The main reason of that problem is simple block matching just tries to find best match blocks but not take into account the neighbor pixels disparity. To take the neighborhood pixel’s disparity into account, we implemented dynamic programming optimization algorithm which increase the cost of the match whose matching block is far away from expected position. In that approach we used the same block match approach and SAD error measure as simple method as well. But instead of just searching minimum SAD error block, we used cost value if neighborhood pixel’s disparity is different from each other. For example in any row suppose first block has match with 10pixels away block. That means, for second block, 10 pixel away block again should be expected block which has zero extra penalty. But 9 pixel away or 11 pixel away block has one unit cost in addition to SAD value of corresponding block. And also 8 pixel away and 12 pixel away block has two unit of cost in addition to their SAD error value and this calculation carries on so on. With using that schema, we provide the smooth disparities which means we take the neighborhood disparity in to account which means spatial consistency as well [2].  
In mathematically speaking, our dynamic programming implementation follows following steps.

*C_y (k,l)=∑_(-W≤j≤W)∑_(-W≤i≤W)|I_left (y+j,x+i+k)-I_right (y+j,x+i+l)|      k=[1..N],l=[k,..M]*

*C_y (k,l)=C_y (k,l)+min⁡(C_y (k-1,l-s:l+s)+γd_(k,l-s:l+s) )     k=[1..N],l=[k,..M]*

In first step we calculate certain rows (yth row) possible matching SAD value. C_y (k,l) indicates the SAD cost between kth column in the left image to lth column in the right image at yth row. In second step, we aggregate the error value with using actual SAD between blocks but also their disparity differences which refers by  d_kl, In that formula we add minimum of previous column SAD error plus disparity differences times cost value into actual SAD value. In that formula, γ indicates the unit penalty value if certain blocks has different disparity. As you can see we try to find minimum cost value in range of [-s +s] neighborhood. 
With using Dynamic programming Schema, we can find the best path with backtracking. Basically we start to find minimum aggregated cost value  C_y, and find the minimum path from the last column of concerned row to the first column. After all, the path shows us the calculated disparity with dynamic programming.

## Stereo Matching Using Belief Propagation

Disparity estimation is an image labeling problem. It is modeled by Markov Random Field (MRF), and the energy minimization task is solved by some popular global optimization methods, i.e. Graph Cut and Belief Propagation. There are two categories of global optimization such as one dimension and two dimension optimization methods. One dimension optimization is traditional method where its estimation on the disparity is focusing on a pixel that depending on other pixels on the same scanline but independent on disparity that focus on other scanlines as how our previous dynamic programming performs. One dimension is not considered as a truly global optimization as its smoothness technique is only focus on horizontal direction. However, one dimension optimization is still being used by some of the researchers due to its simple implementation and its effectiveness on the disparity maps outputs. On the part of disparity optimization, the global optimization algorithm that chosen for this research is using Belief Propagation method.
Belief propagation (BP) is one of powerful tools for learning low-level vision problems, such as motion analysis, unwrapping phase images, stereo matching, inferring shape and reflectance from photograph, or extrapolating image detail. The key idea of BP is simplified Bayes Net. It propagates information throughout a graphical model via a series of messages sent between neighboring nodes iteratively. The algorithm consists of simple local updates that can be executed and are guaranteed to converge to the correct probabilities. The term belief update is used to describe the scheme for computing the function of probabilistic belief. His algorithm is equivalent to schemes proposed independently in a wide range of fields including information theory, signal processing and optimal estimation. 
The disparity estimation problem can be modeled with MRFs and then solved by the BP algorithms [3]. Since the BP algorithm is computationally expensive, some algorithmic techniques are proposed in [3] to substantially improve the running time of the loopy BP approach. One of the techniques reduces the complexity of the inference algorithm to be linear rather than quadratic in the number of possible labels for each pixel. Another technique speeds up and reduces the memory requirements of BP on grid graphs. A third technique is a multi-grid method that makes it possible to obtain good results with a small fixed number of message passing iterations, independent of the size of the input images. In our project the third choice which is using multi scale techniques was used.
We can summarize implemented BP method as follows.

* Step1. Calculate full resolution pixel absolute differences under from 0 disparity to maximum disparity. Assume if possible maximum disparity is 16. It means we should calculate 16 different image matrix and each of them should the absolute differences between left image and shifted right image.

* Step2. Calculate the absolute error for every level. Each level’s resolution is half of the previous one. So if the first original resolution is 100x100. Second level has 50x50, third level has 25x25, so on so forth.

* Step3. Set the matrixes which keep, down, left and right pixel’s values from coarser level. First initialize all 4 matrix all zeros. Set level for coarser level (last level)

* Step4. Simulate message passing and update  both 4 matrix and repeat it for number of iter times.

* Step5. Decrease level by 1 and Go step 4. If the 1st level reach go step 6.

* Step6. Find sum of left, right, up, down and level 1 absolute difference value.

* Step 7. Find the displacement index where the value is minimum for concerned location.

* Step 8. Set fond index as disparity of concerned pixel.



## Reference
[1] Y.Chen, Y.Hung et al.2001.Fast Block Matching Algorithm Based on the Winner-Update Strategy. In IEEE, 10(8), pp.1212-1222
[2] Karathanasis, J., D. Kalivas, and J. Vlontzos. "Disparity estimation using block matching and dynamic programming." Electronics, Circuits, and Systems, 1996. ICECS'96., Proceedings of the Third IEEE International Conference on. Vol. 2. IEEE, 1996.
[3] Felzenszwalb, Pedro F., and Daniel P. Huttenlocher. "Efficient belief propagation for early vision." International journal of computer vision 70.1 (2006): 41-54.

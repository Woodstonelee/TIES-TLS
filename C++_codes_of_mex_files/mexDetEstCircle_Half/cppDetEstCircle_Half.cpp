#include "mexDetEstCircle_Half.h"

// !!!Matrix is converted to 1-D array in column major order, stored in vector class!!!
// !!!In Cpp* function, subscript based from 0 if no special explanation given. 

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// It is important to notice that when rasterizing point clouds
// in the function CppGridPts the center of the first pixel, 
// i.e. pixel at [1,1] locates at (minx, maxy)
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

/*	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	Used to create mexDetEstCircle_Half.mexw32.
	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

/*=================================================================
 * algorithm revised by Zhan Li, 2010-5, the size of image for rasterizing
 point cloud is determined according to the extension of points and 
 maximum possible radius given in input arguments. 
 *=================================================================*/

/*=================================================================
 * algorithm revised by Zhan Li, 2010-6, more information about 
 position relationship between circle center and scan position 
 is used to determine the ROI of points. Function CppMarkROI is revised
 to fullfill above algorithm, with function CppArcInfo revised as well. 
 *=================================================================*/

bool
CppArcInfo (vector < double >x, vector < double >y, vector < double >circle,
            double scanpos_x, double scanpos_y, vector < bool > &InSemiCircle,
            vector < double >&ArcInfo)
{
  // calculate the start and end angle of the arc formed by the input points, and also calculate the angle of arc.
  // circle: [yc, xc, r]
  // InSemiCircle: Np*1 bool vector, Np is the number of elements in x or y. It indicates whether points in the range of semicircle protruding to scan position. 
  // ArcInfo: [StartAngle, EndAngle, ArcAngle], all the angles in unit of radian. 
  //              if ArcAngle is zero, it indicates that no valid arc is detected from the points, with the information about its corresponding circle center and scan position. 

  if (circle.size () != 3) {
#ifdef MATLABPRINT
    mexPrintf ("CppArcInfo ==> circle must be vector with 3 elements!\n");
#endif
    ArcInfo.clear ();
    return false;
  }
  if (x.size () != y.size () || x.size () < 2) {
#ifdef MATLABPRINT
    mexPrintf
      ("CppArcInfo ==> x and y must be vectors with the same number of element, at least 2 elements!\n");
#endif
    ArcInfo.clear ();
    return false;
  }
  vector < double >angle (x.size (), -1.0);
  double minangle = 2 * PI, maxangle = 0.0, maxangleInPi =
    0.0, minangleOutPi = 2 * PI;
  double arrow[2];

  double arrow2scanpos[2];
  arrow2scanpos[0] = scanpos_x - circle[1];
  arrow2scanpos[1] = scanpos_y - circle[0];

  unsigned int pnum = 0;        // count the number of points in semicircle protruding to scan position. 

  InSemiCircle.clear ();
  InSemiCircle.resize (x.size (), false);

  // calculate the angle of vector (x-xc, y-yc) counterclockwise from x axis 
  // estimate the arc angle by rasterizing the radius angle into equal divisions and counting the points within each division.
  double AngleResolution = 0.01 / 180.0 * PI;   // the resolution of angle is 0.01 degree.
  int AngleNum = 36000;         //static_cast<int>(2*PI/AngleResolution)+1;
  int tempind;
  vector < bool > GetPts (AngleNum, false);
  vector < double >MinAngleInDiv (AngleNum, 2 * PI);
  vector < double >MaxAngleInDiv (AngleNum, 0);
  for (unsigned int i = 0; i < x.size (); i++) {
    arrow[0] = x[i] - circle[1];
    arrow[1] = y[i] - circle[0];
    if (arrow[0] == 0) {
      if (arrow[1] == 0) {
#ifdef MATLABPRINT
        mexPrintf
          ("CppArcInfo ==> circle center is at the same position with one point, wrong circle center!!\n");
#endif
        ArcInfo.clear ();
        return false;
      }
    }

    if (arrow[0] * arrow2scanpos[0] + arrow[1] * arrow2scanpos[1] > 0.0) {
      InSemiCircle[i] = true;
    } else {
      continue;
    }

    angle[i] = atan2 (arrow[1], arrow[0]);
    if (angle[i] < 0) {
      angle[i] += 2 * PI;
    }

    tempind = static_cast < int >(angle[i] / AngleResolution);
    GetPts[tempind] = true;
    if (angle[i] < MinAngleInDiv[tempind]) {
      MinAngleInDiv[tempind] = angle[i];
    }
    if (angle[i] > MaxAngleInDiv[tempind]) {
      MaxAngleInDiv[tempind] = angle[i];
    }

  }

  ArcInfo.clear ();
  ArcInfo.resize (3, 0.0);

  vector < int >StartAngleDiv, EndAngleDiv, BlankDivs;
  StartAngleDiv.clear ();
  EndAngleDiv.clear ();
  BlankDivs.clear ();
  bool blankflag = false;
  int blankdivnum = 0, blankblocknum = 0;
  int scancount = 0;
  // start from zero angle (counter-clockwise from x positive), search the consecutive blank angle divisions.
  for (int i = 0; i < 2 * AngleNum - 1 && scancount < AngleNum; i++) {
    if (!blankflag && GetPts[i % AngleNum] && !GetPts[(i + 1) % AngleNum]) {
      StartAngleDiv.push_back (i % AngleNum);
      blankflag = true;
      blankblocknum++;
      BlankDivs.push_back (0);

      scancount++;

      continue;
    }
    if (blankflag && !GetPts[i % AngleNum]) {
      BlankDivs[blankblocknum - 1]++;

      scancount++;

      if (GetPts[(i + 1) % AngleNum]) {
        EndAngleDiv.push_back ((i + 1) % AngleNum);
        blankflag = false;
      }

      continue;
    }

    if (GetPts[i % AngleNum]) {
      scancount++;
    }

  }

  if (BlankDivs.size () == 0) {
    if (!scancount) {
      ArcInfo[0] = 0;
      ArcInfo[1] = 0;
      ArcInfo[2] = mxGetInf ();
    } else {
      ArcInfo[0] = 0;
      ArcInfo[1] = 2 * PI;
      ArcInfo[2] = 2 * PI;
    }
    return true;
  }

  vector < int >::iterator MaxBlankDiv;
  MaxBlankDiv = max_element (BlankDivs.begin (), BlankDivs.end ());
  int MaxInd = static_cast < int >(MaxBlankDiv - BlankDivs.begin ());
  int MaxBlankDivCount =
    count (BlankDivs.begin (), BlankDivs.end (), *MaxBlankDiv);
  if (*MaxBlankDiv < 2) {
    ArcInfo[0] = 0;
    ArcInfo[1] = 2 * PI;
    ArcInfo[2] = 2 * PI;
  } else {
    if (MaxBlankDivCount > 1) {
      // This situation needs further processing to obtain more accurate arc angle.
      ArcInfo[0] = 0;
      ArcInfo[1] = 0;
      ArcInfo[2] = mxGetInf ();
    } else {
      ArcInfo[0] = MaxAngleInDiv[StartAngleDiv[MaxInd]];
      ArcInfo[1] = MinAngleInDiv[EndAngleDiv[MaxInd]];
      ArcInfo[2] = BlankDivs[MaxInd] * AngleResolution;
      ArcInfo[2] +=
        AngleResolution * (StartAngleDiv[MaxInd] + 1) - ArcInfo[0];
      ArcInfo[2] += ArcInfo[1] - AngleResolution * EndAngleDiv[MaxInd];
      ArcInfo[2] = 2 * PI - ArcInfo[2];
    }
  }

  return true;
}

/*
bool CppArcInfo(vector<double> x, vector<double> y, vector<double> circle, double scanpos_x, double scanpos_y, vector<bool> &InSemiCircle, vector<double> &ArcInfo)
{
	// calculate the start and end angle of the arc formed by the input points, and also calculate the angle of arc.
	// circle: [yc, xc, r]
	// InSemiCircle: Np*1 bool vector, Np is the number of elements in x or y. It indicates whether points in the range of semicircle protruding to scan position. 
	// ArcInfo: [StartAngle, EndAngle, ArcAngle], all the angles in unit of radian. 
	//		if ArcAngle is zero, it indicates that no valid arc is detected from the points, with the information about its corresponding circle center and scan position. 

	if (circle.size()!=3)
	{
#ifdef MATLABPRINT
		mexPrintf("CppArcInfo ==> circle must be vector with 3 elements!\n");
#endif
		ArcInfo.clear();
		return false;
	}
	if (x.size()!=y.size() || x.size()<2)
	{
#ifdef MATLABPRINT
		mexPrintf("CppArcInfo ==> x and y must be vectors with the same number of element, at least 2 elements!\n");
#endif
		ArcInfo.clear();
		return false;
	}
	vector<double> angle(x.size(), -1.0);
	double minangle=2*PI, maxangle=0.0, maxangleInPi=0.0, minangleOutPi=2*PI;
	double arrow[2];

	double arrow2scanpos[2];
	arrow2scanpos[0] = scanpos_x - circle[1];
	arrow2scanpos[1] = scanpos_y - circle[0];

	unsigned int pnum=0;	// count the number of points in semicircle protruding to scan position. 

	InSemiCircle.clear();
	InSemiCircle.resize(x.size(), false);

	// calculate the angle of vector (x-xc, y-yc) counterclockwise from x axis 
	for (unsigned int i=0; i<x.size(); i++)
	{
		arrow[0] = x[i]-circle[1];
		arrow[1] = y[i]-circle[0];
		if (arrow[0]==0)
		{
			if (arrow[1]==0)
			{
#ifdef MATLABPRINT
				mexPrintf("CppArcInfo ==> circle center is at the same position with one point, wrong circle center!!\n");
#endif
				ArcInfo.clear();
				return false;
			}
		}

		if ( arrow[0]*arrow2scanpos[0]+arrow[1]*arrow2scanpos[1]<=0.0 )
		{
			continue;
		}

		angle[i]=atan2(arrow[1], arrow[0]);
		if (angle[i]<0)
		{
			angle[i] += 2*PI;
		}

		minangle = angle[i]<minangle ? angle[i] : minangle;
		maxangle = angle[i]>maxangle ? angle[i] : maxangle;

		if (angle[i]<=PI && angle[i]>maxangleInPi)
		{
			maxangleInPi = angle[i];
		}
		if (angle[i]>PI && angle[i]<minangleOutPi)
		{
			minangleOutPi = angle[i];
		}

		InSemiCircle[i]=true;

		pnum++;
	}

	ArcInfo.clear();
	ArcInfo.resize(3, 0.0);

	// if no points in the semicircle, return all zeros.
	if (pnum==0)
	{
		return true;
	}

	if ((maxangle-minangle)<=PI)
	{
		ArcInfo[0]=minangle;
		ArcInfo[1]=maxangle;
		ArcInfo[2]=maxangle-minangle;
	}
	else
	{
		ArcInfo[0]=maxangleInPi;
		ArcInfo[1]=minangleOutPi;
		ArcInfo[2]=maxangleInPi + 2*PI - minangleOutPi;
	}

	return true;
}
*/

double
CppNeighborPtsDensity (vector < unsigned int >edgeImage,
                       vector < unsigned int >dim_img,
                       unsigned int windowsize, double rowc, double colc)
{
  // calculate the point density in the window defined by windowsize*windowsize centered at given point (rowc, colc).
  // rowc, colc: based from 0.
  if (windowsize % 2 == 0) {
#ifdef MATLABPRINT
    mexPrintf ("CppNeighborPtsDensity ==> windowsize must be odd!\n");
#endif
    return -1;
  }
  unsigned int relativecenter = windowsize / 2;
  double meanpnum = 0;
  // circle center at (rowc, cocl) derived by fitting might locate outside edgeImage
  if ((rowc > static_cast < double >(dim_img[0])) ||(rowc < 0)
      || (colc > static_cast < double >(dim_img[1])) ||(colc < 0)) {
    return mxGetInf ();
  }

  for (int c = -1 * relativecenter;
       c < static_cast < int >(relativecenter + 1); c++) {
    // if window pixel locates outside the image, its point number is assumed to be 0.
    if (((colc + c) > static_cast < double >(dim_img[1])) ||((colc + c) < 0)) {
      continue;
    }
    for (int r = -1 * relativecenter;
         r < static_cast < int >(relativecenter + 1); r++) {
      // if window pixel locates outside the image, its point number is assumed to be 0.
      if (((rowc + r) > static_cast < double >(dim_img[0])) ||((rowc + r) <
                                                               0)) {
        continue;
      }
      meanpnum +=
        edgeImage[MatrixLZ::
                  sub2ind (static_cast < unsigned int >(rowc + r),
                           static_cast < unsigned int >(colc + c), dim_img[0],
                           dim_img[1], MatrixLZ::ColMajor)];
    }
  }
  meanpnum /= windowsize * windowsize;
  return meanpnum;

}

// revised by LiZhan in 2010-6
bool
CppMarkROI (vector < unsigned int >edgeImage, vector < unsigned int >dim_img, vector < double >oneHTcircle, double scanpos_x, double scanpos_y, vector < double >xpix, vector < double >ypix, unsigned int sigmacoef, double Rsigma, vector < bool > &ROIimage, vector < double >&ROIxpix, vector < double >&ROIypix, vector < double >&OHCROIxpix, vector < double >&OHCROIypix)       // OHC: Outside Half Circle
{
  // oneHTcircle: [rowc, colc, rpix], based from 0.
  // xpix, ypix: based from 0.
  if (dim_img.size () != 2 || xpix.size () != ypix.size ()
      || oneHTcircle.size () != 3) {
#ifdef MATLABPRINT
    mexPrintf ("CppMarkROI ==> inputs are invalid, failed!\n");
#endif
    ROIimage.clear ();
    ROIimage.resize (edgeImage.size (), false);
    ROIxpix.clear ();
    ROIypix.clear ();
    return false;
  }
  double rowc, colc, rpix;
  rowc = oneHTcircle[0];
  colc = oneHTcircle[1];
  rpix = oneHTcircle[2];
  double minR, maxR;
  minR = rpix - sigmacoef * Rsigma;
  maxR = rpix + sigmacoef * Rsigma;
  int mincol, maxcol, minrow, maxrow;
  double octlen;
  ROIimage.clear ();
  ROIimage.resize (edgeImage.size (), false);
  // fill the external circle
  octlen = (maxR / sqrt (2.0));
  mincol = static_cast < int >(colc - octlen);
  mincol = mincol < 0 ? 0 : mincol;
  mincol = mincol < static_cast < int >(dim_img[1]) ? mincol : dim_img[1];
  maxcol = static_cast < int >(colc + octlen);
  maxcol =
    maxcol < static_cast < int >(dim_img[1] - 1) ? maxcol : (dim_img[1] - 1);
  maxcol = maxcol > 0 ? maxcol : 0;
  for (unsigned int cind = static_cast < unsigned int >(mincol);
       cind < static_cast < unsigned int >(maxcol + 1); cind++) {
    minrow =
      static_cast <
      int >(rowc - sqrt (maxR * maxR - (colc - cind) * (colc - cind)));
    maxrow =
      static_cast <
      int >(rowc + sqrt (maxR * maxR - (colc - cind) * (colc - cind)));
    minrow = minrow < 0 ? 0 : minrow;
    minrow =
      minrow < static_cast <
      int >(dim_img[0] - 1) ? minrow : (dim_img[0] - 1);
    maxrow =
      maxrow < static_cast <
      int >(dim_img[0] - 1) ? maxrow : (dim_img[0] - 1);
    maxrow = maxrow > 0 ? maxrow : 0;
    for (unsigned int rind = static_cast < unsigned int >(minrow);
         rind < static_cast < unsigned int >(maxrow + 1); rind++) {
      unsigned int temp;
      temp =
        MatrixLZ::sub2ind (rind, cind, dim_img[0], dim_img[1],
                           MatrixLZ::ColMajor);
      ROIimage[MatrixLZ::
               sub2ind (rind, cind, dim_img[0], dim_img[1],
                        MatrixLZ::ColMajor)] = true;
    }
  }
  minrow = static_cast < int >(rowc - octlen);
  minrow = minrow < 0 ? 0 : minrow;
  minrow =
    minrow < static_cast < int >(dim_img[0] - 1) ? minrow : (dim_img[0] - 1);
  maxrow = static_cast < int >(rowc + octlen);
  maxrow =
    maxrow < static_cast < int >(dim_img[0] - 1) ? maxrow : (dim_img[0] - 1);
  maxrow = maxrow > 0 ? maxrow : 0;
  for (unsigned int rind = static_cast < unsigned int >(minrow);
       rind < static_cast < unsigned int >(maxrow + 1); rind++) {
    mincol =
      static_cast <
      int >(colc - sqrt (maxR * maxR - (rowc - rind) * (rowc - rind)));
    maxcol = static_cast < int >(colc - octlen);
    mincol = mincol < 0 ? 0 : mincol;
    mincol =
      mincol < static_cast <
      int >(dim_img[1] - 1) ? mincol : (dim_img[1] - 1);
    maxcol =
      maxcol < static_cast <
      int >(dim_img[1] - 1) ? maxcol : (dim_img[1] - 1);
    maxcol = maxcol > 0 ? maxcol : 0;
    for (unsigned int cind = mincol;
         cind < static_cast < unsigned int >(maxcol + 1); cind++) {
      ROIimage[MatrixLZ::
               sub2ind (rind, cind, dim_img[0], dim_img[1],
                        MatrixLZ::ColMajor)] = true;
    }
    mincol = static_cast < int >(colc + octlen);
    maxcol =
      static_cast <
      int >(colc + sqrt (maxR * maxR - (rowc - rind) * (rowc - rind)));
    mincol = mincol < 0 ? 0 : mincol;
    mincol =
      mincol < static_cast <
      int >(dim_img[1] - 1) ? mincol : (dim_img[1] - 1);
    maxcol =
      maxcol < static_cast <
      int >(dim_img[1] - 1) ? maxcol : (dim_img[1] - 1);
    maxcol = maxcol > 0 ? maxcol : 0;
    for (unsigned int cind = mincol;
         cind < static_cast < unsigned int >(maxcol + 1); cind++) {
      ROIimage[MatrixLZ::
               sub2ind (rind, cind, dim_img[0], dim_img[1],
                        MatrixLZ::ColMajor)] = true;
    }
  }

  vector < double >initialROIxpix, initialROIypix;
  initialROIxpix.clear ();
  initialROIypix.clear ();
  double dis;
  for (unsigned int i = 0; i < xpix.size (); i++) {
    dis =
      sqrt ((xpix[i] - colc) * (xpix[i] - colc) +
            (ypix[i] - rowc) * (ypix[i] - rowc));
    if (dis <= maxR && dis >= minR) {
      initialROIxpix.push_back (xpix[i]);
      initialROIypix.push_back (ypix[i]);
    }
  }

  ROIxpix.clear ();
  ROIypix.clear ();
  OHCROIxpix.clear ();
  OHCROIypix.clear ();

  double arrow2scanpos[2];
  arrow2scanpos[0] = scanpos_x - oneHTcircle[1];
  arrow2scanpos[1] = scanpos_y - oneHTcircle[0];
  // calculate the arc angle and decide whether points locate in the range of semicircle protruding to scan position. 
  for (unsigned int i = 0; i < initialROIxpix.size (); i++) {
    if (arrow2scanpos[0] * (initialROIxpix[i] - oneHTcircle[1]) +
        arrow2scanpos[1] * (initialROIypix[i] - oneHTcircle[0]) > 0.0) {
      ROIxpix.push_back (initialROIxpix[i]);
      ROIypix.push_back (initialROIypix[i]);
    } else {
      OHCROIxpix.push_back (initialROIxpix[i]);
      OHCROIypix.push_back (initialROIypix[i]);
    }
  }

  return true;
}


double
CppRsigma (vector < unsigned int >edgerow, vector < unsigned int >edgecol,
           unsigned int rowc, unsigned int colc)
{
  // subscript based from 0
  if (edgerow.size () != edgecol.size ()) {
#ifdef MATLABPRINT
    mexPrintf ("CppRsigma ==> inputs are invalid, failed!\n");
#endif
    return -1;
  }
  vector < double >dis (edgerow.size ());
  for (unsigned int i = 0; i < edgerow.size (); i++) {
    dis[i] =
      (edgerow[i] - rowc) * (edgerow[i] - rowc) + (edgecol[i] -
                                                   colc) * (edgecol[i] -
                                                            colc);
    dis[i] = sqrt (dis[i]);
  }
  double meandis = 0.0;
  for (unsigned int i = 0; i < dis.size (); i++) {
    meandis += dis[i];
  }
  meandis = meandis / static_cast < double >(dis.size ());
  double variance = 0.0;
  for (unsigned int i = 0; i < dis.size (); i++) {
    variance += (dis[i] - meandis) * (dis[i] - meandis);
  }
  variance = variance / static_cast < double >(dis.size () - 1);
  return sqrt (variance);

}

double
CppSelectHTCircle (vector < unsigned int >edgeImage,
                   vector < unsigned int >dim_img,
                   vector < unsigned int >HTrow, vector < unsigned int >HTcol,
                   vector < unsigned int >HTr,
                   vector < double >&finalHTcircle,
                   vector < double >&allRsigma)
{
  // HTrow, HTcol finalHTcircle([rowc, colc, r], in unit of pixel), based from 0.
  if (HTrow.size () != HTcol.size () || HTcol.size () != HTr.size ()
      || HTrow.size () != HTr.size ()) {
#ifdef MATLABPRINT
    mexPrintf ("CppSelectHTCircle ==> inputs are invalid, failed!\n");
#endif
    finalHTcircle.clear ();
    allRsigma.clear ();
    return -1.0;
  }
  // subscript based from 0
  vector < unsigned int >edgerow, edgecol;
  unsigned int currentrow, currentcol;
  for (unsigned int i = 0; i < edgeImage.size (); i++) {
    if (edgeImage[i]) {
      currentrow =
        MatrixLZ::ind2subrow (i, dim_img[0], dim_img[1], MatrixLZ::ColMajor);
      currentcol =
        MatrixLZ::ind2subcol (i, dim_img[0], dim_img[1], MatrixLZ::ColMajor);
      edgerow.push_back (currentrow);
      edgecol.push_back (currentcol);
    }
  }

  allRsigma.clear ();
  allRsigma.resize (HTrow.size (), 0);
  for (unsigned int i = 0; i < HTrow.size (); i++) {
    allRsigma[i] = CppRsigma (edgerow, edgecol, HTrow[i], HTcol[i]);
  }
  vector < double >::iterator Iter_minsigma;
  Iter_minsigma = min_element (allRsigma.begin (), allRsigma.end ());
  double rowc = 0.0, colc = 0.0, rpix = 0.0;
  unsigned int count = 0;
  for (unsigned int i = 0; i < allRsigma.size (); i++) {
    if (allRsigma[i] == (*Iter_minsigma)) {
      rowc += HTrow[i];
      colc += HTcol[i];
      rpix += HTr[i];
      count += 1;
    }
  }
  rowc /= static_cast < double >(count);
  colc /= static_cast < double >(count);
  rpix /= static_cast < double >(count);
  finalHTcircle.clear ();
  finalHTcircle.resize (3, 0.0);
  finalHTcircle[0] = (rowc);
  finalHTcircle[1] = (colc);
  finalHTcircle[2] = (rpix);

  return *Iter_minsigma;
}


void
CppRasterCircle (unsigned int x0, unsigned int y0, unsigned int radius,
                 vector < unsigned int >&I, vector < unsigned int >&dim_I)
{
  // x0: colc, y0: rowc, based from 1!!!
  // I: based from 0
  // http://en.wikipedia.org/wiki/Midpoint_circle_algorithm
  int f = 1 - radius;
  int ddF_x = 1;
  int ddF_y = -2 * radius;
  int x = 0;
  int y = radius;

  if (y0 + radius < dim_I[0] + 1 && y0 + radius > 0) {
    I[(x0 - 1) * dim_I[0] + y0 + radius - 1] += 1;
  }
  if (y0 - radius > 0 && y0 - radius < dim_I[0] + 1) {
    I[(x0 - 1) * dim_I[0] + y0 - radius - 1] += 1;
  }
  if (x0 + radius < dim_I[1] + 1 && x0 + radius > 0) {
    I[(x0 + radius - 1) * dim_I[0] + y0 - 1] += 1;
  }
  if (x0 - radius > 0 && x0 - radius < dim_I[1] + 1) {
    I[(x0 - radius - 1) * dim_I[0] + y0 - 1] += 1;
  }

  while (x < y) {
    // ddF_x == 2 * x + 1;
    // ddF_y == -2 * y;
    // f == x*x + y*y - radius*radius + 2*x - y + 1;
    if (f >= 0) {
      y--;
      ddF_y += 2;
      f += ddF_y;
    }
    x++;
    ddF_x += 2;
    f += ddF_x;
    if (x0 + x < dim_I[1] + 1 && y0 + y < dim_I[0] + 1 && x0 + x > 0
        && y0 + y > 0) {
      I[(x0 + x - 1) * dim_I[0] + y0 + y - 1] += 1;
    }
    if (x0 - x < dim_I[1] + 1 && y0 + y < dim_I[0] + 1 && x0 - x > 0
        && y0 + y > 0) {
      I[(x0 - x - 1) * dim_I[0] + y0 + y - 1] += 1;
    }
    if (x0 + x < dim_I[1] + 1 && y0 - y < dim_I[0] + 1 && x0 + x > 0
        && y0 - y > 0) {
      I[(x0 + x - 1) * dim_I[0] + y0 - y - 1] += 1;
    }
    if (x0 - x < dim_I[1] + 1 && y0 - y < dim_I[0] + 1 && x0 - x > 0
        && y0 - y > 0) {
      I[(x0 - x - 1) * dim_I[0] + y0 - y - 1] += 1;
    }
    if (x0 + y < dim_I[1] + 1 && y0 + x < dim_I[0] + 1 && x0 + y > 0
        && y0 + x > 0) {
      I[(x0 + y - 1) * dim_I[0] + y0 + x - 1] += 1;
    }
    if (x0 - y < dim_I[1] + 1 && y0 + x < dim_I[0] + 1 && x0 - y > 0
        && y0 + x > 0) {
      I[(x0 - y - 1) * dim_I[0] + y0 + x - 1] += 1;
    }
    if (x0 + y < dim_I[1] + 1 && y0 - x < dim_I[0] + 1 && x0 + y > 0
        && y0 - x > 0) {
      I[(x0 + y - 1) * dim_I[0] + y0 - x - 1] += 1;
    }
    if (x0 - y < dim_I[1] + 1 && y0 - x < dim_I[0] + 1 && x0 - y > 0
        && y0 - x > 0) {
      I[(x0 - y - 1) * dim_I[0] + y0 - x - 1] += 1;
    }
  }
}

bool
CppIterCHT (vector < unsigned int >originImage,
            vector < unsigned int >dim_originImage, unsigned int maxR,
            vector < unsigned int >&edgeImage,
            vector < unsigned int >&dim_edgeImage,
            vector < unsigned int >&result_row,
            vector < unsigned int >&result_col,
            vector < unsigned int >&result_r,
            vector < unsigned int >&result_peak)
{
  // result_row, result_col: based from 0.

  //mxArray *prhs[1], *plhs[1];
  //double *tempGetPr;
  //mxLogical *tempGetLogicals;

  if (!(dim_originImage.size () == 2 && dim_edgeImage.size () == 2)) {
#ifdef MATLABPRINT
    mexPrintf ("CppIterCHT ==> inputs are invalid, failed!\n");
#endif
    return false;
  }

  edgeImage.clear ();
  edgeImage.resize (originImage.size ());
  copy (originImage.begin (), originImage.end (), edgeImage.begin ());
  dim_edgeImage[0] = dim_originImage[0];
  dim_edgeImage[1] = dim_originImage[1];

  vector < unsigned int >accumulator (edgeImage.size (), 0);
  vector < unsigned int >rarray (edgeImage.size (), 0),
    peakarray (edgeImage.size (), 0);
  unsigned int currentrow, currentcol, edgecellnum = 0;
  //prhs[0]=mxCreateDoubleMatrix(dim_edgeImage[0], dim_edgeImage[1], mxREAL);     // used for calling MATLAB function "imregionalmax"
  for (unsigned int rcount = 1; rcount <= maxR; rcount++) {
    accumulator.assign (accumulator.size (), 0);
    edgecellnum = 0;
    for (unsigned int pcount = 0; pcount < edgeImage.size (); pcount++) {
      if (edgeImage[pcount] != 0)       // the pixel is on the edge
      {
        // draw circle with center at the pixel and radius rcount in accumulator.
        currentrow =
          MatrixLZ::ind2subrow (pcount, dim_edgeImage[0], dim_edgeImage[1],
                                MatrixLZ::ColMajor);
        currentcol =
          MatrixLZ::ind2subcol (pcount, dim_edgeImage[0], dim_edgeImage[1],
                                MatrixLZ::ColMajor);
        CppRasterCircle (currentcol + 1, currentrow + 1, rcount, accumulator,
                         dim_edgeImage);
        edgecellnum += 1;
      }
    }

    for (unsigned int i = 0; i < accumulator.size (); i++) {
      if (accumulator[i] > peakarray[i]) {
        rarray[i] = rcount;
        peakarray[i] = accumulator[i];
      }
    }

    //tempGetPr=mxGetPr(prhs[0]);
    //for (unsigned i=0; i<accumulator.size(); i++)
    //{
    //      tempGetPr[i]=static_cast<double>(accumulator[i]);
    //}
    //mexCallMATLAB(1, plhs, 1, prhs, "imregionalmax");

    //tempGetLogicals=mxGetLogicals(plhs[0]);
    //for (unsigned int i=0; i<accumulator.size(); i++)
    //{
    //      if (tempGetLogicals[i] && accumulator[i]>peakarray[i])
    //      {
    //              rarray[i]=rcount;
    //              peakarray[i]=accumulator[i];
    //      }
    //}
    //mxDestroyArray(plhs[0]);

  }
  //mxDestroyArray(prhs[0]);

  unsigned int maxpeak;
  maxpeak = *(max_element (peakarray.begin (), peakarray.end ()));
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // the threshold used to determine whether local peak indicates a
  // circle. If the local peak value is no less than maximum local peak
  // value and no less than 0.1*(number of cells on edge), it is deemed to
  // be a circle center in the image. 
  result_row.clear ();
  result_col.clear ();
  result_r.clear ();
  result_peak.clear ();
  for (unsigned int i = 0; i < peakarray.size (); i++) {
    if (peakarray[i] >= 1 * maxpeak
        && peakarray[i] >= static_cast <
        unsigned int >(0.1 * edgecellnum + 0.5)) {
      currentrow =
        MatrixLZ::ind2subrow (i, dim_edgeImage[0], dim_edgeImage[1],
                              MatrixLZ::ColMajor);
      currentcol =
        MatrixLZ::ind2subcol (i, dim_edgeImage[0], dim_edgeImage[1],
                              MatrixLZ::ColMajor);
      result_row.push_back (currentrow);
      result_col.push_back (currentcol);
      result_r.push_back (rarray[i]);
      result_peak.push_back (peakarray[i]);
    }
  }

  return true;
}


void
CppCircleFitting (vector < double >&input_x, vector < double >&input_y,
                  vector < double >&circle)
{
  // circle: [yc, xc, r], if fitting failed, return empty vector.


  if (input_x.size () != input_y.size () || input_x.size () == 0) {
#ifdef MATLABPRINT
    mexPrintf
      ("CppCircleFitting ==> input x and y are not the same size or they are empty!\n");
#endif
    circle.clear ();
    return;
  }
  // translate the coordinate origin to the center of points, for preventing the failure of matrix division due to large input_x or input_y. 
  double meanx, meany;
  vector < double >x (input_x.size ()), y (input_y.size ());
  meanx =
    accumulate (input_x.begin (), input_x.end (),
                0.0) / static_cast < double >(input_x.size ());
  meany =
    accumulate (input_y.begin (), input_y.end (),
                0.0) / static_cast < double >(input_y.size ());
  for (unsigned int i = 0; i < input_x.size (); i++) {
    x[i] = input_x[i] - meanx;
    y[i] = input_y[i] - meany;
  }


  unsigned int n;
  n = x.size ();
  double sumxx, sumyy, sumxy, sumx, sumy;
  mxArray *mx_A, *mx_B;
  double *pt_A, *pt_B;

  mx_A = mxCreateDoubleMatrix (3, 3, mxREAL);
  pt_A = mxGetPr (mx_A);
  mx_B = mxCreateDoubleMatrix (3, 1, mxREAL);
  pt_B = mxGetPr (mx_B);

  vector < double >xx (n), yy (n), xy (n);
  transform (x.begin (), x.end (), x.begin (), xx.begin (),
             std::multiplies < double >());
  transform (y.begin (), y.end (), y.begin (), yy.begin (),
             std::multiplies < double >());
  transform (x.begin (), x.end (), y.begin (), xy.begin (),
             std::multiplies < double >());

  sumxx = accumulate (xx.begin (), xx.end (), 0.0);
  sumyy = accumulate (yy.begin (), yy.end (), 0.0);
  sumxy = accumulate (xy.begin (), xy.end (), 0.0);
  sumx = accumulate (x.begin (), x.end (), 0.0);
  sumy = accumulate (y.begin (), y.end (), 0.0);
  pt_A[0] = sumx;
  pt_A[3] = sumy;
  pt_A[6] = static_cast < double >(n);
  pt_A[1] = sumxy;
  pt_A[4] = sumyy;
  pt_A[7] = sumy;
  pt_A[2] = sumxx;
  pt_A[5] = sumxy;
  pt_A[8] = sumx;

  pt_B[0] = -1 * (sumxx + sumyy);
  pt_B[1] = inner_product (xx.begin (), xx.end (), y.begin (), 0.0);
  pt_B[1] += inner_product (yy.begin (), yy.end (), y.begin (), 0.0);
  pt_B[1] *= -1;
  pt_B[2] = inner_product (xx.begin (), xx.end (), x.begin (), 0.0);
  pt_B[2] += inner_product (xy.begin (), xy.end (), y.begin (), 0.0);
  pt_B[2] *= -1;

  mxArray *plhs[1], *prhs[2];
  prhs[0] = mx_A;
  prhs[1] = mx_B;
  mexCallMATLAB (1, plhs, 2, prhs, "mldivide");
  double *pt_a;
  pt_a = mxGetPr (plhs[0]);
  if (mxIsNaN (pt_a[0]) || mxIsNaN (pt_a[1]) || mxIsNaN (pt_a[2])) {
    circle.clear ();
  } else {
    circle.clear ();
    circle.resize (3, 0.0);
    circle[1] = (-0.5 * pt_a[0]);       //xc
    circle[0] = (-0.5 * pt_a[1]);       //yc
    circle[2] = (sqrt ((pt_a[0] * pt_a[0] + pt_a[1] * pt_a[1]) / 4 - pt_a[2])); //radius

    circle[0] += meany;
    circle[1] += meanx;
  }

  mxDestroyArray (mx_A);
  mxDestroyArray (mx_B);
  mxDestroyArray (plhs[0]);
}

bool
CppGridPts (vector < double >x, vector < double >y, double cellsize,
            unsigned int maxR, unsigned int minnumfit,
            vector < unsigned int >&img, vector < unsigned int >&dim_img,
            vector < double >&refmatrix,
            vector < unsigned int >&dim_refmatrix)
{
  if (!(dim_img.size () == 2 && dim_refmatrix.size () == 2)) {
#ifdef MATLABPRINT
    mexPrintf ("CppGridPts ==> inputs are invalid, failed!\n");
#endif
    return false;
  }
  if (x.size () < minnumfit) {
    // less than minnumfit points in given file, no image and refmatrix is generated.
#ifdef DEBUG
    mexPrintf ("CppGridPts ==> less than minnumfit points in inputs!\n");
#endif
    img.clear ();
    dim_img[0] = 0;
    dim_img[1] = 0;
    refmatrix.clear ();
    dim_refmatrix[0] = 0;
    dim_refmatrix[1] = 0;
    return true;
  }
  // call CppCircleFitting to get preliminary circle center and raius.
  vector < double >precircle;
  CppCircleFitting (x, y, precircle);
  if (precircle.size () != 3) {
    // circle fitting failed possibly due to singular matrix. It means that all the points can't fit a circle. 
#ifdef DEBUG
    mexPrintf
      ("CppGridPts ==> CppCircleFitting return empty, circle fitting failed with all the points!\n");
#endif
    img.clear ();
    dim_img[0] = 0;
    dim_img[1] = 0;
    refmatrix.clear ();
    dim_refmatrix[0] = 0;
    dim_refmatrix[1] = 0;
    return true;
  }
  vector < double >::iterator Iter_minx, Iter_miny, Iter_maxx, Iter_maxy;
  double minx, miny, maxx, maxy;
  unsigned int colnum, rownum;
  Iter_minx = min_element (x.begin (), x.end ());
  Iter_miny = min_element (y.begin (), y.end ());
  Iter_maxx = max_element (x.begin (), x.end ());
  Iter_maxy = max_element (y.begin (), y.end ());
  //minx=min(*Iter_minx, precircle[1]-precircle[2]);
  //miny=min(*Iter_miny, precircle[0]-precircle[2]);
  //maxx=max(*Iter_maxx, precircle[1]+precircle[2]);
  //maxy=max(*Iter_maxy, precircle[0]+precircle[2]);
  minx = min (*Iter_minx, precircle[1] - maxR * cellsize);
  miny = min (*Iter_miny, precircle[0] - maxR * cellsize);
  maxx = max (*Iter_maxx, precircle[1] + maxR * cellsize);
  maxy = max (*Iter_maxy, precircle[0] + maxR * cellsize);
  colnum = static_cast < unsigned int >((maxx - minx) / cellsize + 0.5) + 1;
  rownum = static_cast < unsigned int >((maxy - miny) / cellsize + 0.5) + 1;
  dim_img[0] = rownum;
  dim_img[1] = colnum;
  img.clear ();
  img.resize (rownum * colnum, 0);
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // It is important to notice that the center of 
  // the first pixel, i.e. pixel at [1,1] locates at (minx, maxy)
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  for (unsigned int i = 0, xpix, ypix; i < x.size (); i++) {
    xpix = static_cast < unsigned int >((x[i] - minx) / cellsize + 0.5);
    ypix = static_cast < unsigned int >((maxy - y[i]) / cellsize + 0.5);
    img[xpix * dim_img[0] + ypix] += 1;
  }

  mxArray *prhs[4], *plhs[1];
  double *tempGetPr;
  prhs[0] = mxCreateDoubleScalar (minx);
  prhs[1] = mxCreateDoubleScalar (maxy);
  prhs[2] = mxCreateDoubleScalar (cellsize);
  prhs[3] = mxCreateDoubleScalar (-1 * cellsize);
  mexCallMATLAB (1, plhs, 4, prhs, "makerefmat");
  tempGetPr = mxGetPr (plhs[0]);
  dim_refmatrix[0] = mxGetM (plhs[0]);
  dim_refmatrix[1] = mxGetN (plhs[0]);
  refmatrix.clear ();
  refmatrix.resize (dim_refmatrix[0] * dim_refmatrix[1], 0);
  for (unsigned int i = 0; i < refmatrix.size (); i++) {
    refmatrix[i] = tempGetPr[i];
  }

  mxDestroyArray (prhs[0]);
  mxDestroyArray (prhs[1]);
  mxDestroyArray (prhs[2]);
  mxDestroyArray (prhs[3]);
  mxDestroyArray (plhs[0]);

  return true;

}

bool
CppDetEstCircle3 (vector < double >x, vector < double >y, double cellsize, unsigned int maxR, unsigned int sigmacoef, double epsion, unsigned int maxIter, unsigned int minnumfit, vector < double >ScanPos, vector < double >&detectedcircle, vector < double >&mapfinalHTcircle, vector < double >&iterationdata, vector < double >&ArcInfo, vector < double >&finalx, vector < double >&finaly, vector < double >&TotalOHCx, vector < double >&TotalOHCy, vector < double >&DebugInfo)       // OHC: Outside Half Circle
{
  // based from 0.
  // detectedcircle: [yc, xc, r], in unit of meter.
  // mapfinalHTcircle: [rowc, colc, r], in unit of pixel.
  if (x.size () != y.size ()) {
#ifdef MATLABPRINT
    mexPrintf
      ("CppDetEstCircle ==> input x and y do not have the same length!\n");
#endif
    detectedcircle.clear ();
    mapfinalHTcircle.clear ();
    iterationdata.clear ();
    ArcInfo.clear ();
    finalx.clear ();
    finaly.clear ();
    TotalOHCx.clear ();
    TotalOHCy.clear ();
    DebugInfo.clear ();
    return false;
  }
  mxArray *mx_x, *mx_y, *mx_refmatrix;
  double *tempGetPr;

  vector < unsigned int >img, dim_img (2), dim_refmatrix (2);
  vector < double >refmatrix;
  // call CppGridPts to grid the points cloud into cellsize*cellsize cells
  bool callflag;
  callflag =
    CppGridPts (x, y, cellsize, maxR, minnumfit, img, dim_img, refmatrix,
                dim_refmatrix);
  if (!callflag) {
#ifdef MATLABPRINT
    mexPrintf ("CppDetEstCircle ==> calling CppGridPts failed!\n");
#endif
    // maybe inputs are invalid!
    detectedcircle.clear ();
    mapfinalHTcircle.clear ();
    iterationdata.clear ();
    ArcInfo.clear ();
    finalx.clear ();
    finaly.clear ();
    TotalOHCx.clear ();
    TotalOHCy.clear ();
    DebugInfo.clear ();
    return false;
  }
  if (img.size () == 0 || refmatrix.size () == 0) {
    // less than minnumfit points in this section
#ifdef DEBUG
    mexPrintf
      ("CppDetEstCircle ==> calling CppGridPts ==> less than minnumfit points in this section!\n");
#endif
    detectedcircle.clear ();
    mapfinalHTcircle.clear ();
    iterationdata.clear ();
    iterationdata.resize (4, 0.0);
    iterationdata[0] = 0.0;
    iterationdata[1] = mxGetNaN ();
    iterationdata[2] = mxGetNaN ();
    iterationdata[3] = static_cast < double >(x.size ());
    ArcInfo.clear ();
    ArcInfo.resize (3, 0.0);
    finalx.clear ();
    finaly.clear ();
    TotalOHCx.clear ();
    TotalOHCy.clear ();
    DebugInfo.clear ();
    return true;
  }
  // convert x, y to row and col by MATLAB function: map2pix
  // xpix, ypix: based from 0.
  vector < double >xpix (x.size ()), ypix (y.size ());
  mxArray *prhs[3], *plhs[2];
  mx_x = mxCreateDoubleMatrix (x.size (), 1, mxREAL);
  mx_y = mxCreateDoubleMatrix (y.size (), 1, mxREAL);
  mx_refmatrix =
    mxCreateDoubleMatrix (dim_refmatrix[0], dim_refmatrix[1], mxREAL);
  tempGetPr = mxGetPr (mx_x);
  for (unsigned int i = 0; i < x.size (); i++) {
    tempGetPr[i] = x[i];
  }
  tempGetPr = mxGetPr (mx_y);
  for (unsigned int i = 0; i < y.size (); i++) {
    tempGetPr[i] = y[i];
  }
  tempGetPr = mxGetPr (mx_refmatrix);
  for (unsigned int i = 0; i < refmatrix.size (); i++) {
    tempGetPr[i] = refmatrix[i];
  }
  prhs[1] = mx_x;
  prhs[2] = mx_y;
  prhs[0] = mx_refmatrix;
  mexCallMATLAB (2, plhs, 3, prhs, "map2pix");
  tempGetPr = mxGetPr (plhs[1]);
  for (unsigned int i = 0; i < x.size (); i++) {
    xpix[i] = tempGetPr[i] - 1;
  }
  tempGetPr = mxGetPr (plhs[0]);
  for (unsigned int i = 0; i < y.size (); i++) {
    ypix[i] = tempGetPr[i] - 1;
  }
  mxDestroyArray (mx_x);
  mxDestroyArray (mx_y);

  // convert x and y of scan position to xpix and ypix
  prhs[0] = mx_refmatrix;
  prhs[1] = mxCreateDoubleMatrix (1, 1, mxREAL);
  prhs[2] = mxCreateDoubleMatrix (1, 1, mxREAL);
  tempGetPr = mxGetPr (prhs[1]);
  tempGetPr[0] = ScanPos[0];
  tempGetPr = mxGetPr (prhs[2]);
  tempGetPr[0] = ScanPos[1];
  mexCallMATLAB (2, plhs, 3, prhs, "map2pix");
  double ScanPos_xpix, ScanPos_ypix;
  tempGetPr = mxGetPr (plhs[0]);
  ScanPos_ypix = tempGetPr[0] - 1;
  tempGetPr = mxGetPr (plhs[1]);
  ScanPos_xpix = tempGetPr[0] - 1;
  mxDestroyArray (prhs[1]);
  mxDestroyArray (prhs[2]);
  mxDestroyArray (plhs[0]);
  mxDestroyArray (plhs[1]);

  vector < double >estcircle;
  CppCircleFitting (xpix, ypix, estcircle);
  if (estcircle.size () == 0) {
#ifdef DEBUG
    mexPrintf ("CppDetEstCircle ==> CppCircleFitting return empty!\n");
#endif
    detectedcircle.clear ();
    mapfinalHTcircle.clear ();
    iterationdata.clear ();
    iterationdata.resize (4, 0.0);
    iterationdata[0] = 0.0;
    iterationdata[1] = mxGetNaN ();
    iterationdata[2] = mxGetNaN ();
    iterationdata[3] = static_cast < double >(x.size ());
    ArcInfo.clear ();
    ArcInfo.resize (3, 0.0);
    finalx.clear ();
    finaly.clear ();
    TotalOHCx.clear ();
    TotalOHCy.clear ();
    DebugInfo.clear ();
    return true;
  }
  if (estcircle[2] < 0) {
#ifdef DEBUG
    mexPrintf ("CppDetEstCircle ==> CppCircleFitting return negative!\n");
#endif
    detectedcircle.clear ();
    mapfinalHTcircle.clear ();
    iterationdata.clear ();
    iterationdata.resize (4, 0.0);
    iterationdata[0] = 0.0;
    iterationdata[1] = mxGetNaN ();
    iterationdata[2] = mxGetNaN ();
    iterationdata[3] = static_cast < double >(x.size ());
    ArcInfo.clear ();
    ArcInfo.resize (3, 0.0);
    finalx.clear ();
    finaly.clear ();
    TotalOHCx.clear ();
    TotalOHCy.clear ();
    DebugInfo.clear ();
    return true;
  }
  vector < double >precircle (3, mxGetInf ());
  vector < bool > ROIimage (img.size ());
  vector < double >ROIxpix, ROIypix, OHCROIxpix, OHCROIypix;
  vector < unsigned int >inputImage (img.size ());
  vector < unsigned int >edgeImage (img.size ());
  vector < unsigned int >HTrow, HTcol, HTr, HTpeak;
  vector < double >zeros (img.size (), 0.0);
  vector < double >finalHTcircle, allRsigma;
  unsigned int iterativecount = 0;
  bool fitflag = true;
  double centerchange, radiuschange, finalRsigma;
  transform (img.begin (), img.end (), zeros.begin (), ROIimage.begin (),
             std::not_equal_to < double >());
  centerchange =
    sqrt ((estcircle[0] - precircle[0]) * (estcircle[0] - precircle[0]) +
          (estcircle[1] - precircle[1]) * (estcircle[1] - precircle[1]));
  radiuschange = fabs (estcircle[2] - precircle[2]);
  OHCROIxpix.clear ();
  OHCROIypix.clear ();
  while (centerchange > epsion / cellsize || radiuschange > epsion / cellsize) {
    // In this while loop, estcircle and precircle are both in unit of pixel.

    // initially detect circle by Hough Transform.
    inputImage.clear ();
    inputImage.resize (img.size (), 0);
    transform (img.begin (), img.end (), ROIimage.begin (),
               inputImage.begin (), std::multiplies < unsigned int >());
    //int debugcount=0;
    //for (unsigned int i=0; i<img.size(); i++)
    //{
    //      if ( (img[i]!=0) && ROIimage[i] )
    //      {
    //              inputImage[i]=img[i];
    //              debugcount++;
    //      }
    //}
    HTrow.clear ();
    HTcol.clear ();
    HTr.clear ();
    HTpeak.clear ();
    if (!
        (CppIterCHT
         (inputImage, dim_img, maxR, edgeImage, dim_img, HTrow, HTcol, HTr,
          HTpeak)
)) {
#ifdef MATLABPRINT
      mexPrintf ("CppDetEstCircle ==> calling CppIterCHT failed!\n");
#endif
      return false;
    }
    if (HTrow.size () == 0) {
      // no circle detected by CHT
      fitflag = false;
      break;
    }
    // select one circle from the above derived by CHT. 
    finalHTcircle.clear ();
    allRsigma.clear ();
    finalRsigma =
      CppSelectHTCircle (edgeImage, dim_img, HTrow, HTcol, HTr, finalHTcircle,
                         allRsigma);
    if (finalRsigma < 0) {
#ifdef MATLABPRINT
      mexPrintf ("CppDetEstCircle ==> calling CppSelectHTCircle failed!\n");
#endif
      return false;
    }
    // mark ROI
    ROIimage.clear ();
    if (!
        (CppMarkROI
         (edgeImage, dim_img, finalHTcircle, ScanPos_xpix, ScanPos_ypix, xpix,
          ypix, sigmacoef, finalRsigma, ROIimage, ROIxpix, ROIypix,
          OHCROIxpix, OHCROIypix)
)) {
#ifdef MATLABPRINT
      mexPrintf ("CppDetEstCircle ==> calling CppMarkROI failed!\n");
#endif
      return false;
    }

    if (ROIxpix.size () < minnumfit) {
#ifdef DEBUG
      mexPrintf
        ("CppDetEstCircle ==> less than minnumfit points used to fit a circle!\n");
#endif
      fitflag = false;
      break;
    }
    precircle.clear ();
    precircle.resize (estcircle.size (), 0.0);
    copy (estcircle.begin (), estcircle.end (), precircle.begin ());
    // fit circles using points in ROI
    CppCircleFitting (ROIxpix, ROIypix, estcircle);
    if (estcircle.size () == 0) {
#ifdef DEBUG
      mexPrintf ("CppDetEstCircle ==> CppCircleFitting return empty!\n");
#endif
      fitflag = false;
      break;
    }
    if (estcircle[2] < 0) {
#ifdef DEBUG
      mexPrintf ("CppDetEstCircle ==> CppCircleFitting return negative!\n");
#endif
      fitflag = false;
      break;
    }
    // calculate change compared with previous circle
    centerchange =
      sqrt ((estcircle[0] - precircle[0]) * (estcircle[0] - precircle[0]) +
            (estcircle[1] - precircle[1]) * (estcircle[1] - precircle[1]));
    radiuschange = fabs (estcircle[2] - precircle[2]);
    iterativecount += 1;

    if (iterativecount == maxIter) {
      fitflag = true;
      break;
    }

  }

  // Now, we begin to check if estcircle(detectedcircle) is derived after the while loop and if the derived is valid. 
  // We check it from 3 aspects. 

  // 1st check: whether circle is derived, see if fitflag is true
  if (!fitflag) {
    detectedcircle.clear ();
    mapfinalHTcircle.clear ();
    iterationdata.clear ();
    iterationdata.resize (4, 0.0);
    iterationdata[0] = static_cast < double >(iterativecount);
    iterationdata[1] = centerchange * cellsize;
    iterationdata[2] = radiuschange * cellsize;
    iterationdata[3] = static_cast < double >(ROIxpix.size ());
    ArcInfo.clear ();
    ArcInfo.resize (3, 0.0);
    finalx.clear ();
    finaly.clear ();
    TotalOHCx.clear ();
    TotalOHCy.clear ();
    DebugInfo.clear ();
    return true;
  }
  //2nd check: 
  //see if the detectedcircle(or estcircle) locates within point
  //cloud of trunk, if true, this horizontal point cloud section is
  //unqualified, discard the detectedcircle. If in the 3*3 window
  //centered at detectedcircle point density in every cell is greater
  //than 1, we think the circle center locating within trunk. 
  double ptsdensity;
  ptsdensity =
    CppNeighborPtsDensity (img, dim_img, 3, estcircle[0], estcircle[1]);
  if (ptsdensity < 0) {
#ifdef MATLABPRINT
    mexPrintf ("CppDetEstCircle ==> calling CppNeighborPtsDensity failed!\n");
#endif
    return false;
  }
  if (mxIsInf (ptsdensity)) {
    // If ptsdensity is Inf, the derived center locates outside the rasterized image.

    detectedcircle.clear ();
    mapfinalHTcircle.clear ();
    detectedcircle.resize (3, 0.0);
    mapfinalHTcircle.resize (3, 0.0);
    prhs[0] = mx_refmatrix;
    prhs[1] = mxCreateDoubleMatrix (2, 1, mxREAL);
    prhs[2] = mxCreateDoubleMatrix (2, 1, mxREAL);
    tempGetPr = mxGetPr (prhs[1]);
    tempGetPr[0] = estcircle[0] + 1;
    tempGetPr[1] = finalHTcircle[0] + 1;
    tempGetPr = mxGetPr (prhs[2]);
    tempGetPr[0] = estcircle[1] + 1;
    tempGetPr[1] = finalHTcircle[1] + 1;
    mexCallMATLAB (2, plhs, 3, prhs, "pix2map");
    tempGetPr = mxGetPr (plhs[0]);      //xc
    detectedcircle[1] = tempGetPr[0];
    mapfinalHTcircle[1] = tempGetPr[1]; // xc
    tempGetPr = mxGetPr (plhs[1]);      //yc
    detectedcircle[0] = tempGetPr[0];
    mapfinalHTcircle[0] = tempGetPr[1]; // yc
    detectedcircle[2] = estcircle[2] * cellsize;
    mapfinalHTcircle[2] = finalHTcircle[2] * cellsize;  // r
    mxDestroyArray (prhs[1]);
    mxDestroyArray (prhs[2]);
    mxDestroyArray (plhs[0]);
    mxDestroyArray (plhs[1]);

    /*detectedcircle.assign(estcircle.begin(), estcircle.end());
       mapfinalHTcircle.assign(finalHTcircle.begin(), finalHTcircle.end()); */

    iterationdata.clear ();
    iterationdata.resize (4, 0.0);
    iterationdata[0] = static_cast < double >(iterativecount);
    iterationdata[1] = mxGetNaN ();
    iterationdata[2] = mxGetNaN ();
    iterationdata[3] = static_cast < double >(ROIxpix.size ());
    ArcInfo.clear ();
    ArcInfo.resize (3, 0.0);
    finalx.clear ();
    finaly.clear ();
    TotalOHCx.clear ();
    TotalOHCy.clear ();
    DebugInfo.clear ();
    return true;
  } else if (ptsdensity > 1) {
    // If ptsdensity is greater than 1, the derived center is on the trunk, not valid!
    detectedcircle.clear ();
    mapfinalHTcircle.clear ();
    iterationdata.clear ();
    iterationdata.resize (4, 0.0);
    iterationdata[0] = static_cast < double >(iterativecount);
    iterationdata[1] = centerchange * cellsize;
    iterationdata[2] = radiuschange * cellsize;
    iterationdata[3] = static_cast < double >(ROIxpix.size ());
    ArcInfo.clear ();
    ArcInfo.resize (3, 0.0);
    finalx.clear ();
    finaly.clear ();
    TotalOHCx.clear ();
    TotalOHCy.clear ();
    DebugInfo.clear ();
    return true;
  }
  // 3rd check: Iteration (while loop) ends possibly without getting right circle but due to reaching maximum iteration count or failed HT.
  // So here the estcircle derived from while loop is checked whether satisfying the right circle condition. 
  if (iterativecount == maxIter) {
    if (centerchange > epsion / cellsize || radiuschange > epsion / cellsize) {
      detectedcircle.clear ();
      mapfinalHTcircle.clear ();
      iterationdata.clear ();
      iterationdata.resize (4, 0.0);
      iterationdata[0] = static_cast < double >(maxIter);
      iterationdata[1] = centerchange * cellsize;
      iterationdata[2] = radiuschange * cellsize;
      iterationdata[3] = static_cast < double >(ROIxpix.size ());
      ArcInfo.clear ();
      ArcInfo.resize (3, 0.0);
      finalx.clear ();
      finaly.clear ();
      TotalOHCx.clear ();
      TotalOHCy.clear ();
      DebugInfo.clear ();
      return true;
    }
  }
  //After all checked, we can output the valid derived circle.
  detectedcircle.clear ();
  mapfinalHTcircle.clear ();
  detectedcircle.resize (3, 0.0);
  mapfinalHTcircle.resize (3, 0.0);
  prhs[0] = mx_refmatrix;
  prhs[1] = mxCreateDoubleMatrix (2, 1, mxREAL);
  prhs[2] = mxCreateDoubleMatrix (2, 1, mxREAL);
  tempGetPr = mxGetPr (prhs[1]);
  tempGetPr[0] = estcircle[0] + 1;
  tempGetPr[1] = finalHTcircle[0] + 1;
  tempGetPr = mxGetPr (prhs[2]);
  tempGetPr[0] = estcircle[1] + 1;
  tempGetPr[1] = finalHTcircle[1] + 1;
  mexCallMATLAB (2, plhs, 3, prhs, "pix2map");
  tempGetPr = mxGetPr (plhs[0]);        //xc
  detectedcircle[1] = tempGetPr[0];
  mapfinalHTcircle[1] = tempGetPr[1];   // xc
  tempGetPr = mxGetPr (plhs[1]);        //yc
  detectedcircle[0] = tempGetPr[0];
  mapfinalHTcircle[0] = tempGetPr[1];   // yc
  detectedcircle[2] = estcircle[2] * cellsize;
  mapfinalHTcircle[2] = finalHTcircle[2] * cellsize;    // r
  mxDestroyArray (prhs[1]);
  mxDestroyArray (prhs[2]);
  mxDestroyArray (plhs[0]);
  mxDestroyArray (plhs[1]);

  // convert ROIxpix, ROIypix to finalx, finaly
  finalx.clear ();
  finalx.resize (ROIxpix.size ());
  finaly.clear ();
  finaly.resize (ROIypix.size ());
  prhs[0] = mx_refmatrix;
  prhs[1] = mxCreateDoubleMatrix (ROIypix.size (), 1, mxREAL);
  prhs[2] = mxCreateDoubleMatrix (ROIxpix.size (), 1, mxREAL);
  tempGetPr = mxGetPr (prhs[1]);
  for (unsigned int i = 0; i < ROIypix.size (); i++) {
    tempGetPr[i] = ROIypix[i] + 1;
  }
  tempGetPr = mxGetPr (prhs[2]);
  for (unsigned int i = 0; i < ROIxpix.size (); i++) {
    tempGetPr[i] = ROIxpix[i] + 1;
  }
  mexCallMATLAB (2, plhs, 3, prhs, "pix2map");
  tempGetPr = mxGetPr (plhs[0]);        //finalx
  for (unsigned int i = 0; i < ROIxpix.size (); i++) {
    finalx[i] = tempGetPr[i];
  }
  tempGetPr = mxGetPr (plhs[1]);        //finaly
  for (unsigned int i = 0; i < ROIypix.size (); i++) {
    finaly[i] = tempGetPr[i];
  }
  mxDestroyArray (prhs[1]);
  mxDestroyArray (prhs[2]);
  mxDestroyArray (plhs[0]);
  mxDestroyArray (plhs[1]);

  iterationdata.clear ();
  iterationdata.resize (4, 0.0);
  iterationdata[0] = static_cast < double >(iterativecount);
  iterationdata[1] = centerchange * cellsize;
  iterationdata[2] = radiuschange * cellsize;
  iterationdata[3] = static_cast < double >(ROIxpix.size ());
  ArcInfo.clear ();
  vector < bool > InSemiCircle;
  if (!CppArcInfo
      (ROIxpix, ROIypix, estcircle, ScanPos_xpix, ScanPos_ypix, InSemiCircle,
       ArcInfo)) {
#ifdef MATLABPRINT
    mexPrintf ("CppDetEstCircle ==> calling CppArcInfo failed!\n");
#endif
    return false;
  }
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // Because when rasterizing point clouds
  // in the function CppGridPts the center of the first pixel, 
  // i.e. the pixel at [1,1] locates at (minx, maxy), 
  // we have to transform the angle in i-j(raster) coordinate system
  // to x-y(point clouds) coordinate system. 
  // In x-y coordinate system, y axis points to north, 
  // so angle is presented in counterclockwise. 
  // In contrast, in i-j coordinate system, 
  // i axis (i.e. y axis in raster) points to south, 
  // so angle is presented in clockwise.
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  ArcInfo[0] = 2 * PI - ArcInfo[0];
  ArcInfo[1] = 2 * PI - ArcInfo[1];

  //OHCROIxpix.clear();
  //OHCROIypix.clear();
  for (unsigned int i = 0; i < InSemiCircle.size (); i++) {
    if (!InSemiCircle[i]) {
      OHCROIxpix.push_back (ROIxpix[i]);
      OHCROIypix.push_back (ROIypix[i]);
    }
  }
  TotalOHCx.clear ();
  TotalOHCx.resize (OHCROIxpix.size ());
  TotalOHCy.clear ();
  TotalOHCy.resize (OHCROIypix.size ());
  prhs[0] = mx_refmatrix;
  prhs[1] = mxCreateDoubleMatrix (OHCROIypix.size (), 1, mxREAL);
  prhs[2] = mxCreateDoubleMatrix (OHCROIxpix.size (), 1, mxREAL);
  tempGetPr = mxGetPr (prhs[1]);
  for (unsigned int i = 0; i < OHCROIypix.size (); i++) {
    tempGetPr[i] = OHCROIypix[i] + 1;
  }
  tempGetPr = mxGetPr (prhs[2]);
  for (unsigned int i = 0; i < OHCROIxpix.size (); i++) {
    tempGetPr[i] = OHCROIxpix[i] + 1;
  }
  mexCallMATLAB (2, plhs, 3, prhs, "pix2map");
  tempGetPr = mxGetPr (plhs[0]);        //TotalOHCx
  for (unsigned int i = 0; i < OHCROIxpix.size (); i++) {
    TotalOHCx[i] = tempGetPr[i];
  }
  tempGetPr = mxGetPr (plhs[1]);        //TotalOHCy
  for (unsigned int i = 0; i < OHCROIypix.size (); i++) {
    TotalOHCy[i] = tempGetPr[i];
  }
  mxDestroyArray (prhs[1]);
  mxDestroyArray (prhs[2]);
  mxDestroyArray (plhs[0]);
  mxDestroyArray (plhs[1]);

  mxDestroyArray (mx_refmatrix);

  DebugInfo.clear ();
  DebugInfo.resize (1);
  DebugInfo[0] = finalRsigma * cellsize;

#ifdef DEBUG
  mexPrintf ("CppDetEstCircle ==> finally points used to fit a circle: %d!\n",
             ROIxpix.size ());
#endif

  return true;
}

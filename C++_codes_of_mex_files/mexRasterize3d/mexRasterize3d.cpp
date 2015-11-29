#define DEBUG

#include <valarray>
#include <algorithm>
#include <fstream>
#include <cmath>
#include <limits>

#include "mex.h"
#include "matrix.h"

using namespace std;

// IndexVector: based from 1.
bool CppRasterize3d(double *x, double *y, double *z, size_t np, 
					double cellx, double celly, double cellz, 
					char *tmpfilename, double *IndexVector, double *minmax, 
					double filtercellsize, char *demptsfilename, char *rasterinfofilename)
{
	valarray<double> valarray_x(np), valarray_y(np), valarray_z(np);
	for(size_t i=0;i<np;i++)
	{
		valarray_x[i]=x[i];
		valarray_y[i]=y[i];
		valarray_z[i]=z[i];
	}
	double minx, maxx, miny, maxy, minz, maxz;
	minx=valarray_x.min();
	maxx=valarray_x.max();
	miny=valarray_y.min();
	maxy=valarray_y.max();
	minz=valarray_z.min();
	maxz=valarray_z.max();
	minmax[0]=minx;minmax[1]=maxx;
	minmax[2]=miny;minmax[3]=maxy;
	minmax[4]=minz;minmax[5]=maxz;
	
	int xpixelnum, ypixelnum, zpixelnum;
	xpixelnum=static_cast<int>(floor((maxx-minx)/cellx))+1;
	ypixelnum=static_cast<int>(floor((maxy-miny)/celly))+1;
	zpixelnum=static_cast<int>(floor((maxz-minz)/cellz))+1;
	if (xpixelnum*ypixelnum*zpixelnum > numeric_limits<double>::max())
	{
		mexErrMsgTxt("Number of voxel exceeds the maximum of double!");
		return false;
	}
	ofstream tmpfstream;
	tmpfstream.open(tmpfilename, ios_base::out);
	if (!tmpfstream)
	{
		mexErrMsgTxt("Voxel File opened failed!");
		return false;
	}
	tmpfstream.precision(6);
	tmpfstream<<fixed;
	tmpfstream<<minx<<"\t"<<miny<<"\t"<<minz<<endl;
	tmpfstream<<maxx<<"\t"<<maxy<<"\t"<<maxz<<endl;
	tmpfstream<<cellx<<"\t"<<celly<<"\t"<<cellz<<endl;
	tmpfstream.precision(0);
	tmpfstream<<ypixelnum<<"\t"<<xpixelnum<<"\t"<<zpixelnum<<endl;
	//int xpixel, ypixel;
	//// layermatrix[][]: records the 2D raster at the same zpixel, i.e. the horizontal section of 3D raster.
	//int **layermatrix;
	//layermatrix = new int*[ypixelnum];
	//for(int i=0; i<ypixelnum; i++)
	//{
	//	layermatrix[i]=new int[xpixelnum];
	//	for(int j=0; j<xpixelnum; j++)
	//		layermatrix[i][j]=0;
	//}
	//// Along z axis, rasterizes points in each horizontal section, and records the voxels with points.
	//for(size_t zcount=0; zcount<static_cast<unsigned int>(zpixelnum); zcount++)
	//{
	//	for(size_t pcount=0; pcount<np; pcount++)
	//	{
	//		if(valarray_z[pcount]<(minz+zcount*cellz) || valarray_z[pcount]>=(minz+(zcount+1)*cellz))
	//		{
	//			continue;
	//		}
	//		xpixel=static_cast<int>(floor((valarray_x[pcount]-minx)/cellx));
	//		ypixel=static_cast<int>(floor((valarray_y[pcount]-miny)/celly));
	//		layermatrix[ypixel][xpixel]+=1;
	//		IndexVector[pcount]=zcount*ypixelnum*xpixelnum + xpixel*ypixelnum + ypixel + 1;	// index based from 1.
	//	}

	//	for(int i=0; i<ypixelnum; i++)
	//	{
	//		for(int j=0; j<xpixelnum; j++)
	//		{
	//			if(layermatrix[i][j]!=0)
	//			{
	//				tmpfstream<<(i+1)<<"\t"<<(j+1)<<"\t"<<(zcount+1)<<"\t"<<layermatrix[i][j]<<endl;
	//				layermatrix[i][j]=0;
	//			}
	//			
	//		}
	//	}
	//}
	//for(int i=0; i<ypixelnum; i++)
	//{
	//	delete [] layermatrix[i];
	//}
	//delete [] layermatrix;
	
	int ypixel, zpixel;
	// slicematrix[ypixel][zpixel]: records the 2D raster at the same xpixel, i.e. the vertical section of 3D raster.
	int ** slicematrix;
	slicematrix = new int*[ypixelnum];
	for(int i=0; i<ypixelnum; i++)
	{
		slicematrix[i]=new int[zpixelnum];
		for(int j=0; j<zpixelnum; j++)
			slicematrix[i][j]=0;
	}
	// Along x axis, rasterizes points in each vertical section, and records the voxels with points.
	for(size_t xcount=0; xcount<static_cast<unsigned int>(xpixelnum); xcount++)
	{
		for(size_t pcount=0; pcount<np; pcount++)
		{
			if(valarray_x[pcount]<(minx+xcount*cellx) || valarray_x[pcount]>=(minx+(xcount+1)*cellx))
			{
				continue;
			}
			ypixel=static_cast<int>(floor((valarray_y[pcount]-miny)/celly));
			zpixel=static_cast<int>(floor((valarray_z[pcount]-minz)/cellz));
			slicematrix[ypixel][zpixel]+=1;
			IndexVector[pcount]=zpixel*ypixelnum*xpixelnum + xcount*ypixelnum + ypixel + 1;	// index based from 1.
		}

		for(int i=0; i<ypixelnum; i++)
		{
			for(int j=0; j<zpixelnum; j++)
			{
				if(slicematrix[i][j]!=0)
				{
					tmpfstream<<(i+1)<<"\t"<<(xcount+1)<<"\t"<<(j+1)<<"\t"<<slicematrix[i][j]<<endl;
					slicematrix[i][j]=0;
				}
			}
		}
	}
	for(int i=0; i<ypixelnum; i++)
	{
		delete [] slicematrix[i];
	}
	delete [] slicematrix;
	tmpfstream.close();

	// output minmax and IndexVector to a text file. 
	ofstream rasterinfofstream;
	rasterinfofstream.open(rasterinfofilename, ios_base::out);
	if (!rasterinfofstream)
	{
#ifdef DEBUG
		mexErrMsgTxt("RasterInfo File opened failed!");
#endif
		return false;
	}
	rasterinfofstream.precision(6);
	rasterinfofstream<<fixed;
	rasterinfofstream<<minmax[0]<<"\t"<<minmax[2]<<"\t"<<minmax[4]<<endl;
	rasterinfofstream<<minmax[1]<<"\t"<<minmax[3]<<"\t"<<minmax[5]<<endl;
	rasterinfofstream<<cellx<<"\t"<<celly<<"\t"<<cellz<<endl;
	rasterinfofstream.precision(0);
	for (size_t pcount=0; pcount<np; pcount++)
	{
		rasterinfofstream<<IndexVector[pcount]<<endl;
	}
	rasterinfofstream.close();
	// ending of outputing minmax and IndexVector. 

	// search the lowest points in each cell in X-Y plane and output these points to a text file. 
	ofstream demptsfstream;
	demptsfstream.open(demptsfilename, ios_base::out);
	if (!demptsfstream)
	{
#ifdef DEBUG
		mexErrMsgTxt("DEM Points File opened failed!");
#endif
		return false;
	}
	demptsfstream.precision(6);
	demptsfstream<<fixed;
	demptsfstream<<"x"<<", "<<"y"<<", "<<"z"<<endl;
	if (!demptsfstream)
	{
#ifdef DEBUG
		mexErrMsgTxt("DEM Points File opened failed!");
#endif
		return false;
	}
	// xyplane records the z value of lowest points in X-Y plane
	double **xyplane;
	int filterxpixelnum, filterypixelnum;
	int currentindex;
	int currentxpix, currentypix;
	filterxpixelnum = static_cast<int>(floor((maxx-minx)/filtercellsize))+1;
	filterypixelnum = static_cast<int>(floor((maxy-miny)/filtercellsize))+1;
	xyplane=new double*[filterypixelnum];
	for(int i=0; i<filterypixelnum; i++)
	{
		xyplane[i]=new double[filterxpixelnum];
		for(int j=0; j<filterxpixelnum; j++)
		{
			xyplane[i][j]=numeric_limits<double>::infinity();
		}
	}
	// assign the xyplane with z value of lowest points by IndexVector. 
	for(size_t pcount=0; pcount<np; pcount++)
	{
		currentypix=static_cast<int>(floor((valarray_y[pcount]-miny)/filtercellsize));
		currentxpix=static_cast<int>(floor((valarray_x[pcount]-minx)/filtercellsize));
		if (xyplane[currentypix][currentxpix] > valarray_z[pcount])
		{
			xyplane[currentypix][currentxpix] = valarray_z[pcount];
		}
	}
	// output the lowest points. 
	for(int i=0; i<filterypixelnum; i++)
	{
		for(int j=0; j<filterxpixelnum; j++)
		{
			if (xyplane[i][j]!=numeric_limits<double>::infinity())
			{
				demptsfstream<<( minx+j*filtercellsize+filtercellsize*0.5 )<<", "<<( miny+i*filtercellsize+filtercellsize*0.5 )<<", "<<xyplane[i][j]<<endl;
			}
		}
	}
	// destroy the array. 
	for(int i=0; i<filterypixelnum; i++)
	{
		delete [] xyplane[i];
	}
	delete [] xyplane;
	demptsfstream.close();
	// ending of searching lowest points. 

	return true;
}



// mexRasterize3d used in MATLAB:
// SYNTAX:[IndexVector, minmax] = mexRasterize3d (x, y, z, cellsize, VoxelFileName, filtercellsize, DEMPtsFileName, RasterInfoFileName)
// INPUT:
//		x, y, z: coordinates of points, column-vector.
//		cellsize: 1*3 matrix, giving the cell size of voxels to be created along each axis, [cellx, celly, cellz].
//		VoxelFileName: a string giving the temporal file path and name recording the created 3D voxels, to be written.
//			File format: 
//			#1: minx \t miny \t minz
//			#2: maxx \t maxy \t maxz
//			#3: cellx \t celly \t cellz
//			#4: rownum(y) \t colnum(x) \t verticalnum(z)
//			#5-#end: row(y) \t col(x) \t vertica(z) \t point_num_in_voxel
//		filtercellsize: the cellsize used to find lowest points as ground. 
//		DEMPtsFileName: a string giving the file name(with path) recording the coordinates of points used to generate DEM (here, the lowest point in each cell on X-Y plane)
//			File format: 
//			#1-#end: x \t y \t z
//		RasterInfoFileName: a string giving the file name(with path) recording the minmax and IndexVector. 
//			File format: 
//			#1: minx \t miny \t minz
//			#2: maxx \t maxy \t maxz
//			#3: cellx \t celly \t cellz
//			#4-#end: IndexVector(each line corresponds to the points in x, y and z)
// OUTPUT:
//		IndexVector: for each point, the index in 3D raster of the voxel containing the point, based from 1.
//		minmax: 2*3 matrix, giving the minimum and maximum of x, y, z of all points, [minx, miny, minz; maxx, maxy, maxz].
// REQUIRED ROUTINES:
//		None.
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
	// check the number of input and output arguments.
	if (nrhs != 8)
	{
		mexErrMsgTxt("8 input arguments are required!");
	}
	if (nlhs > 2)
	{
		mexErrMsgTxt("No more than 2 output arguments!");
	}
	
	// check the type of input arguments.
	if (!(mxIsNumeric(prhs[0])))
	{
		mexErrMsgTxt("x is not numeric!");
	}
	if (!(mxIsNumeric(prhs[1])))
	{
		mexErrMsgTxt("y is not numeric!");
	}
	if (!(mxIsNumeric(prhs[2])))
	{
		mexErrMsgTxt("z is not numeric!");
	}
	if (!(mxIsNumeric(prhs[3])))
	{
		mexErrMsgTxt("cellsize is not numeric!");
	}
	else if (mxGetNumberOfElements(prhs[3]) != 3)
	{
		mexErrMsgTxt("cellsize does not give 3 numbers!");
	}
	if (!(mxIsChar(prhs[4])))
	{
		mexErrMsgTxt("VoxelFileName is not a string!");
	}
	if (!(mxIsNumeric(prhs[5])))
	{
		mexErrMsgTxt("filtercellsize is not numeric!");
	}
	else if ( mxGetNumberOfElements(prhs[5]) != 1)
	{
		mexErrMsgTxt("filtercellsize is not scalar!");
	}
	if (!(mxIsChar(prhs[6])))
	{
		mexErrMsgTxt("DEMPtsFileName is not a string!");
	}
	if (!(mxIsChar(prhs[7])))
	{
		mexErrMsgTxt("RasterInfoFileName is not a string!");
	}
	
	double *x, *y, *z;
	size_t length[3], np;	// the number of elements of x, i.e. number of points.
	double *cellsize, cellx, celly, cellz, filtercellsize;
	char *tmpfilename, *demptsfilename, *rasterinfofilename;

	length[0]=mxGetNumberOfElements(prhs[0]);
	length[1]=mxGetNumberOfElements(prhs[1]);
	length[2]=mxGetNumberOfElements(prhs[2]);
	if ( length[0] != length[1]
		|| length[0] != length[2]
		|| length[1] != length[2] )
	{
		mexErrMsgTxt("the lengths of x, y, z are not consistent!");
	}
	else
	{
		np=length[0];
	}

	x=mxGetPr(prhs[0]);
	y=mxGetPr(prhs[1]);
	z=mxGetPr(prhs[2]);
	cellsize=mxGetPr(prhs[3]);
	cellx=cellsize[0];
	celly=cellsize[1];
	cellz=cellsize[2];
	tmpfilename=mxArrayToString(prhs[4]);
	filtercellsize=mxGetScalar(prhs[5]);
	demptsfilename=mxArrayToString(prhs[6]);
	rasterinfofilename=mxArrayToString(prhs[7]);

	double *IndexVector, *minmax;
	switch (nlhs)
	{
	case 2:
		plhs[1]=mxCreateDoubleMatrix(2, 3, mxREAL);
		minmax=mxGetPr(plhs[1]);
		plhs[0]=mxCreateDoubleMatrix(np, 1, mxREAL);
		IndexVector=mxGetPr(plhs[0]);
		break;
	case 1:
		plhs[0]=mxCreateDoubleMatrix(np, 1, mxREAL);
		IndexVector=mxGetPr(plhs[0]);
		minmax= new double[2*3];
		break;
	case 0:
		IndexVector= new double[np*1];
		minmax= new double[2*3];
		break;
	default:
		break;
	}
	
	// Error: the following way does not work!
	//double *IndexVector, *minmax;
	//IndexVector=new double[np];
	//minmax=new double[2*3];

	if(!(CppRasterize3d(x, y, z, np, cellx, celly, cellz, tmpfilename, IndexVector, minmax, filtercellsize, demptsfilename, rasterinfofilename)))
	{
		switch (nlhs)
		{
		case 2:
			break;
		case 1:
			delete [] minmax;
			break;
		case 0:
			delete [] IndexVector;
			delete [] minmax;
			break;
		default:
			break;
		}
		mxFree(tmpfilename);
		mxFree(demptsfilename);
		mxFree(rasterinfofilename);
		mexErrMsgTxt("CppRasterize3d failed!");
	}

	//delete [] IndexVector;
	//delete [] minmax;

	switch (nlhs)
	{
	case 2:
		break;
	case 1:
		delete [] minmax;
		break;
	case 0:
		delete [] IndexVector;
		delete [] minmax;
		break;
	default:
		break;
	}
	mxFree(tmpfilename);
	mxFree(demptsfilename);
	mxFree(rasterinfofilename);

	return;

}

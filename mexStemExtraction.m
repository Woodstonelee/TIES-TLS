function mexStemExtraction (x, y, z, p2rInfo, VoxelArray, IndexVector, zflag, maxstemlength, DEM, DEMInfo, StemPtsFile, NonStemPtsFile)
% mexStemExtraction
% extract the points possibly from stem and remove those from canopy,
% ground and other objects. 
% SYNTAX: mexStemExtraction (x, y, z, p2rInfo, VoxelArray, IndexVector, zflag, maxstemlength, DEM, DEMInfo, StemPtsFile)
% INPUT:
%		x, y, z: coordinates of points, column-vector, each is np*1 matrix, np is the number of points.
%		p2rInfo: 3*3 matrix, giving the information of converting points cloud to raster, including:
%			minimum and maximum of x, y, z of all points and cell size along each axis, 
%			[minx, miny, minz; 
%			 maxx, maxy, maxz;
%			 cellx, celly, cellz].
%		VoxelArray: N*4 matrix, N is the number of voxels containing points, 
%			each row of matrix giving the position of this voxel and the number of points in that voxel:
%			[row(y), col(x), vertica(z), point_num]. based from 1.
%			the same row and column have to be in continuous in vector row and col.
%		IndexVector: np*1 matrix, np is the number of points, i.e. the length of x or y or z, 
%			for each point, giving the index in 3D raster of the voxel containing that point. based from 1.
%		zflag: scalar, the threshold of continuous voxel number along z axis used to identify stem voxels.
%		maxstemlength: the maximum stem length, points higher than this value will be removed as crown points.
%		DEM: a 2D matrix giving the height of ground, with cellsize given by p2rInfo, the number of rows and cols are the same with number of rows and cols indicated by VoxelArray
%		DEMInfo: a vector, [ncol, nrow, xllcorner, yllcorner, cellsize, nodata], xllcorner and yllcorner is the coordinate of left low corner of the left low cell, i.e. the minimum coordinates of x and y.  
%		StemPtsFile: a string, giving the stem points file path and name, to be written.
%       File format: 
%       #1-#end: x \t y \t z
%       NonStemPtsFile: OPTIONAL, a string, giving the non-stem points file
%       path and name, to be written.
%       File format: 
%       #1-#end: x \t y \t z \t 0
% OUTPUT:
%   None.
% REQUIRED ROUTINES:
%   None. 
% METHOD AND PROCESS: 
%   1. For each cell on the x-y plane, search the voxels along the Z axis.
%   If more than zflag voxels continuously exist and the distances along Z
%   axis from points in these voxels to their corresponding ground
%   (positions are given by DEM) are not greater than maxstemlength, these
%   points are thought to be from stems. 
end
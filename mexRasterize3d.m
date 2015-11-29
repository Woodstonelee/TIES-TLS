function [IndexVector, minmax] = mexRasterize3d (x, y, z, cellsize, VoxelFileName, filtercellsize, DEMPtsFileName, RasterInfoFileName)
% mexRasterize3d
% raster points to voxels. 
% SYNTAX:[IndexVector, minmax] = mexRasterize3d (x, y, z, cellsize, VoxelFileName, filtercellsize, DEMPtsFileName, RasterInfoFileName)
% INPUT:
%		x, y, z: coordinates of points, column-vector.
%		cellsize: 1*3 matrix, giving the cell size of voxels to be created along each axis, [cellx, celly, cellz].
%		VoxelFileName: a string giving the temporal file path and name recording the created 3D voxels, to be written.
%			File format: 
%			#1: minx \t miny \t minz
%			#2: maxx \t maxy \t maxz
%			#3: cellx \t celly \t cellz
%			#4: rownum(y) \t colnum(x) \t verticalnum(z)
%			#5-#end: row(y) \t col(x) \t vertica(z) \t point_num_in_voxel
%		filtercellsize: the cellsize used to find lowest points as ground. 
%		DEMPtsFileName: a string giving the file name(with path) recording the coordinates of points used to generate DEM (here, the lowest point in each cell on X-Y plane)
%			File format: 
%			#1-#end: x \t y \t z
%		RasterInfoFileName: a string giving the file name(with path) recording the minmax and IndexVector. 
%			File format: 
%			#1: minx \t miny \t minz
%			#2: maxx \t maxy \t maxz
%			#3: cellx \t celly \t cellz
%			#4-#end: IndexVector(each line corresponds to the points in x, y and z)
% OUTPUT:
%		IndexVector: for each point, the index in 3D raster of the voxel containing the point, based from 1.
%		minmax: 2*3 matrix, giving the minimum and maximum of x, y, z of all points, [minx, miny, minz; maxx, maxy, maxz].
% REQUIRED ROUTINES:
%		None.
% METHOED AND PROCESS: 
%   1. Rasterize the points to voxels. the minimums of x, y and z are set
%   to be the low left bottom corner of voxel [1, 1, 1]. Count the points
%   in each voxels and output the number to the file of VoxelFileName. 
%   2. Rasterize the x-y plane with raster size given by filtercellsize,
%   find the lowest points in each cell used as positions of ground and
%   output them to the file of DEMPtsFileName. 
end
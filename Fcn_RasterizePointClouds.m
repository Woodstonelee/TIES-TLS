function Fcn_RasterizePointClouds(PathName, PtsFileName, cellsize, filtercellsize, SavePathName)
% Rasterize the point clouds. 
% SYNTAX: 
%   None.
% INPUT: 
%   1. PathName, PtsFileName: name of original file containing point clouds
%   of forest scenes. 
%           File format:
%           #1-#end: x \t y \t z
%   2. cellsize: [cellx, celly, cellz]
%   3. filtercellsize: cell size along x and y used to find ground points
%   4. SavePathName: output directory
% OUTPUT: 
%   1. Text file descripting sparse 3-D matrix by rasterizing point clouds.
%		VoxelFileName: a string giving the temporal file path and name
%		recording the created 3D voxels, to be written.
%			File format: 
%			#1: minx \t miny \t minz
%			#2: maxx \t maxy \t maxz
%			#3: cellx \t celly \t cellz
%			#4: rownum(y) \t colnum(x) \t verticalnum(z)
%			#5-#end: row(y) \t col(x) \t vertica(z) \t point_num_in_voxel
%   2. Text file giving the raster information including: minimum and
%   maximum coordinates of x, y and z, and the IndexVector as well.
%		RasterInfoFileName: a string giving the file name(with path)
%		recording the minmax and IndexVector. 
%			File format: 
%			#1-#2: [minx, miny, minz; maxx, maxy, maxz]
%			#3: cellx \t celly \t cellz
%			#4-#end: IndexVector(each line corresponds to the points in x,
%			y and z)
%   3. Text file giving the lowest points. 
%		DEMPtsFileName: a string giving the file name(with path) recording
%		the coordinates of points used to generate DEM (here, the lowest
%		point in each cell on X-Y plane)
%			File format: 
%           #1: "x", "y", "z"
%			#2-#end: x, y, z
% REQUIRED ROUTINES:
%   1. mexRasterize3d.mexw32
% METHODS AND PROCESS: 
%   0. Preprocess the point clouds data: IN RiSCAN SOFTWARE, filter the
%   points within the range of 1~100 meter and export the points to an
%   ascii file with ONLY x, y, z. It is IMPORTANT to select suitable
%   SOP and COORDINATE SYSTEM (SOCS OR PRCS)!
%   1. Read point clouds data in ascii files. 
%   2. Using "mexRasterize3d", raster point clouds to voxels and save
%   sparse matrix in a text file "Voxels_.txt" and two variables,
%   "IndexVector" and "minmax" are output by this called routine. A text
%   file "LowestPts_.txt" recording lowest point in given raster size used
%   to generate DEM and another text file "RasterInfo_.txt" recording
%   IndexVector and minmax is output as well. 
% -------------------------------------------------------------------------
%   3. !!! IN ArcGIS !!!
%   Import the file of lowest points (DEMPtsFileName), generate DEM with
%   kriging interpolation with parameters as following: raster size
%   (1meter), number of points for search (the number of all lowest
%   points), others (default). And export the DEM to an ASCII file, DO
%   REMEMBER TO CHECK THE xllcorner AND yllcorner.

% -------------------------------------------------------------------------
tmpfilename=fullfile(SavePathName, ['Voxels_', PtsFileName]);
demptsfilename=fullfile(SavePathName, ['LowestPts_', PtsFileName]);
rasterinfofilename=fullfile(SavePathName, ['RasterInfo_', PtsFileName]);
% -------------------------------------------------------------------------
ParameterFileName=['Parameters_Fcn_RasterizePointClouds_', PtsFileName];
fid=fopen(fullfile(SavePathName, ParameterFileName), 'w');
fprintf(fid, [...
    'the original forest point clouds file: %s\r\n', ...
    'cell size along X (meter): %f\r\n', ...
    'cell size along Y (meter): %f\r\n', ...
    'cell size along Z (meter): %f\r\n', ...
    'cell size used to find lowest points, i.e. filter out non-ground points (meter): %f\r\n', ...
    '\r\nOutput directory: %s\r\n' ...
    ], ...
    fullfile(PathName, PtsFileName), ...
    cellsize(1), cellsize(2), cellsize(3), filtercellsize, ...
    SavePathName);
fclose(fid);

ptscldfid=fopen(fullfile(PathName, PtsFileName), 'r');
if ptscldfid<0
    msgbox('Cannot open input ascii file of original point clouds!');
    return;
end
data=textscan(ptscldfid,'%f %f %f');
fclose(ptscldfid);
x=data{1};
y=data{2};
z=data{3};
clear data;

% reshape x, y, z to column vector.
pointnum=length(x);
x=reshape(x, pointnum,1);
y=reshape(y, pointnum,1);
z=reshape(z, pointnum,1);

mexRasterize3d(x, y, z, cellsize, tmpfilename, filtercellsize, demptsfilename, rasterinfofilename);

clear functions;

end
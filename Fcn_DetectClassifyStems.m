function Fcn_DetectClassifyStems(PathName, PtsFileName, ...
    VoxelPathName, VoxelFileName, ...
    RasterInfoPathName, RasterInfoFileName, ...
    DEMPathName, DEMFileName, ...
    zflag, maxstemlength, cellsize, CutoffDis, minpoints, ...
    SavePathName)
% Mark point clouds with single stem (tree) No. 
% SYNTAX: 
%   None.
% INPUT: 
%   1. Original file containing point clouds of forest scenes. 
%           File format:
%           #1-#end: x \t y \t z
%   2. Text file descripting sparse 3-D matrix by rasterizing point clouds.
%		file name: VoxelFileName.
%			File format: 
%			#1: minx \t miny \t minz
%			#2: maxx \t maxy \t maxz
%			#3: cellx \t celly \t cellz
%			#4: rownum(y) \t colnum(x) \t verticalnum(z)
%			#5-#end: row(y) \t col(x) \t vertica(z) \t point_num_in_voxel
%   3. Text file giving the raster information including: minimum and
%       maximum coordinates of x, y and z, and the IndexVector as well.
%		file name: RasterInfoFileName.
%			File format: 
%			#1-#2: [minx, miny, minz; maxx, maxy, maxz]
%			#3-#end: IndexVector(each line corresponds to the points in x,
%			y and z)
%   4. Text file of DEM derived from the lowest points. 
%		file name: DEMFileName.
%           File format: (EXAMPLE)
%          "ncols         181
%           nrows         181
%           xllcorner     -90.496391
%           yllcorner     -86.518433
%           cellsize      1
%           NODATA_value  -9999
%           [nrows by ncols matrix]"
%   5. zflag: minimum continuous voxel number
%   6. maxstemlength: maximum stem length
%   7. cellsize: cell size used to rasterize X-Y plane to cluster tree
%   8. CutoffDis: maximum distance between points within the same tree
%   9. minpoints: minimum number of points to form a tree
%   10. SavePathName: Output directory
% OUTPUT:
%   1. Text file of point clouds deemed to be stems.
%       StemPts_*.txt
%       File format: 
%       #1-#end: x \t y \t z
%   2. Text file of tree table
%       TreeTable_*.txt
%       File format: 
%       #1-#end: x_of_tree_center \t  y_of_tree_center \t
%       number_of_points_in_this_tree \t NO_of_tree
%   3. Text file of stem points with tree ID
%       arrTree_*.txt
%       File format: 
%       #1-#end: x \t y \t z \t NO_of_tree
% REQUIRED ROUTINES:
%   1. mexStemExtraction.mexw32
%   2. mexTreeClusterClassifier.mexw32
% METHODS AND PROCESS: 
%   1. Using "mexStemExtraction", search the voxels deemed to be stems
%   (if number of continuous voxels along stem direction usually z
%   direction reach given value, zflag, and the points in this voxel is no
%   maxstemlength higher than ground given by DEM, these voxels are stems)
%   and output point clouds in these voxels to a text file "StemPts_*.txt".
%   2. Using "mexTreeClusterClassifier.mexw32", seperate the trees in stem
%   points file with cluster algorithm. Output tree table file
%   (TreeTable_*.txt) and a file of stem points with tree ID
%   (arrTree_*.txt). 

% -------------------------------------------------------------------------
stemptsfilename=fullfile(SavePathName, ['StemPts_', PtsFileName]);
nonstemptsfilename=fullfile(SavePathName, ['NonStemPts_', PtsFileName]);
% -------------------------------------------------------------------------
ParameterFileName=['Parameters_Fcn_DetectClassifyStems_', PtsFileName];
fid=fopen(fullfile(SavePathName, ParameterFileName), 'w');
fprintf(fid, [...
    'the original forest point clouds file: %s\r\n', ...
    'the voxel file: %s\r\n', ...
    'raster information file: %s\r\n', ...
    'the DEM file: %s\r\n', ...
    'minimum continuous voxel number: %f\r\n', ...
    'maximum stem length: %f\r\n', ...
    'cell size used to rasterize X-Y plane to cluster tree:%f\r\n', ...
    'maximum distance between points within the same tree:%f\r\n', ...
    'minimum number of points to form a tree:%f\r\n', ...
    '\r\nOutput directory: %s\r\n' ...
    ], ...
    fullfile(PathName, PtsFileName), ...
    fullfile(VoxelPathName, VoxelFileName), ...
    fullfile(RasterInfoPathName, RasterInfoFileName), ...
    fullfile(DEMPathName, DEMFileName), ...
    zflag, maxstemlength, ...
    cellsize, CutoffDis, minpoints, ...
    SavePathName);
fclose(fid);

ptscldfid=fopen(fullfile(PathName, PtsFileName), 'r');
if ptscldfid<0
    msgbox('Cannot open input ascii file of original point clouds!');
    return;
end
data=textscan(ptscldfid,'%f %f %f %*s');
fclose(ptscldfid);
x=data{1};
y=data{2};
z=data{3};

voxelfid=fopen(fullfile(VoxelPathName, VoxelFileName), 'r');
if voxelfid<0
    msgbox('Cannot open input ascii file of voxels!');
    return;
end
data=textscan(voxelfid,'%f %f %f %f', 'HeaderLines', 4);
fclose(voxelfid);
row=data{1};
col=data{2};
vertica=data{3};
pnum=data{4};
vnum=length(row);
row=reshape(row, vnum,1);
col=reshape(col, vnum,1);
vertica=reshape(vertica, vnum,1);
pnum=reshape(pnum, vnum, 1);
voxelarray=[row, col, vertica, pnum];

rasterinfofid=fopen(fullfile(RasterInfoPathName, RasterInfoFileName), 'r');
if rasterinfofid<0
    msgbox('Cannot open input ascii file of rasterizing information!');
    return;
end
data=textscan(rasterinfofid,'%f %f %f', 3);
p2rInfo=cell2mat(data);
data=textscan(rasterinfofid,'%f');
IndexVector=cell2mat(data);
fclose(voxelfid);

demfid=fopen(fullfile(DEMPathName, DEMFileName), 'r');
if demfid<0
    msgbox('Cannot open input ascii file of DEM!');
    return;
end
data=textscan(demfid, '%s %f', 6);
deminfo=data{1, 2};
formatstr=ones(1, deminfo(1)*3);formatstr=char(formatstr);
for i=1:deminfo(1)
    formatstr((i*3-2):(i*3))='%f ';
end
data=textscan(demfid,formatstr);
dem=cell2mat(data);
dem=flipud(dem);
fclose(demfid);

mexStemExtraction(x, y, z, p2rInfo, voxelarray, IndexVector, zflag, maxstemlength, dem ,deminfo, stemptsfilename, nonstemptsfilename);

stemptsfid=fopen(stemptsfilename, 'r');
data=textscan(stemptsfid,'%f %f %f');
fclose(stemptsfid);
stem_x=data{1};
stem_y=data{2};
stem_z=data{3};
clear data;
TtableFileName=fullfile(SavePathName, ['TreeTable_', PtsFileName]);
arrTFileName=fullfile(SavePathName, ['arrTree_', PtsFileName]);
mexTreeClusterClassifier(stem_x, stem_y, stem_z, cellsize, CutoffDis, minpoints, TtableFileName, arrTFileName)

clear functions;

end
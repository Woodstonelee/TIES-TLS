function mexTreeClusterClassifier (x, y, z, cellsize, CutoffDis, minpoints, TtableFileName, arrTFileName)
% mexTreeClusterClassifier
% seperate points of each single stem from that of all stems, mark each
% point with an ID of the tree. 
% SYNTAX: mexTreeClusterClassifier (x, y, z, cellsize, CutoffDis, minpoints, TtableFileName, arrTFileName)
% INPUT:
%		x, y, z: column-vector, coordinates of points.
%		cellsize: scalar, the cell size used to rasterize the x-y plane. 
%		CutoffDis: scalar, the maximum distance between cells within the same tree. 
%		minpoints: scalar, the minimum number of points in a single tree. 
%		TtableFileName: string, the complete name of file containing tree NOs and corresponding center coordinates. 
%			File format: 
%			#1-#end: x_of_tree_center \t  y_of_tree_center \t z_of_tree_center \t number_of_points_in_this_tree \t NO_of_tree
%		arrTFileName: string, the complete name of file containing the points and corresponding tree NO. 
%			File format:
%			#1-#end: x \t y \t z \t NO_of_tree
% OUTPUT:
%		None. 
% REQUIRED ROUTINES:
%       None. 
% METHOD AND PROCESS: 
%   1. For computing efficiency, firstly project the points to x-y plane
%   and rasterize x-y plane to grid with raster size given by cellsize. 
%   2. Cluster the cells with points. The mean positions (x, y) of all points
%   from a same stem are used as the position of this stem. For each cell
%   with points, search the nearest tree to it, if the distance between
%   them is not greater than the threshold given by CutoffDis, the points
%   within this cell are thought to be from this stem and update the
%   position of this stem with newly found points. If not, the points
%   within this cell are though to be from a new stem and create a new stem
%   and calculate the position of this stem. 
end
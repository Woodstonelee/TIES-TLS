%  mexDetEstCircle_Half: detect a circle and estimate its center position and
%  radius from a horizontal slice of stem points by iterative Hough
%  Transform and circle fitting.
%  "_Half" in the name means this algorithm process points from a single scan. Only part of the trunk is seen by the scanner and is recorded by the points
%   
%  SYNTAX: [detectedcircle, mapfinalHTcircle, iterationdata, ArcInfo, finalx, finaly, TotalOHCx, TotalOHCy, DebugInfo] =
%  mexDetEstCircle_Half(x, y, cellsize, maxR, sigmacoef, epsion, maxIter, minnumfit, scanpos)
%  
%  INPUT:
% 		x, y: the x, y coordinates of points, both NumPoints*1 matrices.
%       cellsize: cell size used to rasterize point clouds, unit(meter), prompt value: 0.01
%       maxR: the maximum possible radius of circle, unit(pixel), prompt value: 50
%       sigmacoef: coefficient used to define ROI, sigmacoef*radius_sigma, prompt value: 1
%       epsion: the permitted threshold of center position and radius changes, unit(meter), prompt value: 0.001
%       maxIter: the maximum iteration count, prompt value: 100
%       minnumfit: the minimum points required to do detection and estimation, prompt value: 9
%       scanpos: [scanpos_x, scanpos_y, scanpos_z], the scan position in
%       the same coordinate system as the coordinate system of given x and y, usually should be [0,0,0], the scan position is the origin of the point coordinate system
% 
%  OUTPUT:
%     detectedcircle: [yc, xc, r], in unit of meter.
%     mapfinalHTcircle: [yc, xc, r], in unit of meter.
%     iterationdata: [iterativecount, centerchange, radiuschange, number_of_points_in_circle_fitting_finally]
%     ArcInfo: [StartAngle, EndAngle, ArcAngle]
%     finalx, finaly: optional, the points selected out for circle fitting finally after all iterations. 
%     TotalOHCx, TotalOHCy: optional, the points outside half circle detected in last iteration. 
%     DebugInfo: optional, the sigma of radius of circle estimated in last
%     iteration. in the unit the same with input points.
% 
%  REQUIRED ROUTINES:
% 		None.
% 
% INTERPRETATION OF SPECIAL OUTPUT OF [detectedcircle, mapfinalHTcircle,
% iterationdata]: 
%   1. ( [], [], [0, NaN, NaN, number_of_points] ): no enough points(less than minnumfit) in
%   this section or first circle fitting failed before starting iteration. 
%   2. ( [], [], [0, Inf, Inf, number_of_points] ): in the first iteration, HT failed or no
%   enough points inside derived ROI or circle fitting failed. 
%   3. ( [], [], [IterCount, changecenter, changeradius, number_of_points] ): after running
%   iteration a few times, HT failed or no enough points inside derived ROI
%   or circle fitting failed in iterations, or derived circle is invalid
%   (point density in neighborhood of derived center is greater than 1, or
%   iterative count reaching maxIter but change not reaching epsion). 
%   4. ( [Fittingcircle], [HTcircle], [0, NaN, NaN, number_of_points] ): derived
%   circle center locates outside the rasterized image. 
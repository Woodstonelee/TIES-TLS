% Script3_Points2DEM
% Generate a DEM from ground points through two steps: 1, create a
% TIN from ground points; 2, rasterize the TIN and get a grid as
% DEM, written in ascii file with a format that can be imported
% directly into ArcGIS raster for display purpose. 
% Zhan Li, zhanli86@bu.edu
% 2013-5-27
%

% clear;
% % files to input
% GroundPtsPathName = '/projectnb/echidna/lidar/DWEL_Processing/CA2013June/CA2013_Site305/CA2013-Site305-PointClouds';
% GroundPtsFileName = ...
%     'June12_01_305_C_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points_ground.xyz';
% % files to output
% demfilename = ['/projectnb/echidna/lidar/DWEL_Processing/' ...
%                'CA2013June/CA2013_Site305/CA2013-Site305-' ...
%                'PointClouds/June12_01_305_C_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points_ground.dem'];
% % parameters to input
% cellsize = 0.2; % resolution of DEM, unit: same with input points
% nodata = -9999; % the value of no data
% maxTINedgelen = 10; % the maximum length of boundary edges of
% % TIN, unit: same with input points
% % Whether to fill the nodata area in the DEM from TIN with RANSAC fitting.
% fill_nodata = true;
% % whether to calculate extent again here in this script rather
% than use the extent from last step 'Script2_FilteringVarTIN'
% cal_extent = true;

% read in points
% fid = fopen(fullfile(GroundPtsPathName, GroundPtsFileName), 'r');
% data = textscan(fid, '%f %f %f');
data = dlmread(fullfile(GroundPtsPathName, GroundPtsFileName));
x = data(:,1);
y = data(:,2);
z = data(:,3);
% fclose(fid);
clear data;

% get the extent of x and y axis.
if cal_extent
    minx = min(x);
    maxx = max(x);
    miny = min(y);
    maxy = max(y);
else
    % The variable 'extent' is from the script of the last step
    % 'Script2_FilteringVarTIN.m' 
    minx = extent(1);
    maxx = extent(2);
    miny = extent(3);
    maxy = extent(4);
end
% set up a grid in this x and y extent.
nrows = round((maxy - miny) / cellsize);
ncols = round((maxx - minx) / cellsize);
[demx, demy] = meshgrid(((1:ncols)-0.5)*cellsize+minx, ((nrows:-1:1)-0.5)*cellsize+miny);
demx = demx(:);
demy = demy(:);
demz = ones(size(demx))*nodata;

% construct delaunay TIN. 
DT = delaunayTriangulation(x, y);
% in case of duplicate points in [x, y] detected and removed by
% delaunay triangulization
[tmpflag, tmploc] = ismember(DT.Points, [x, y], 'rows');
DT_z = z(tmploc(tmpflag));
DT_x = DT.Points(:, 1);
DT_y = DT.Points(:, 2);

% get the boundary of the TIN
fe = freeBoundary(DT);
% get the lengths of the boundary edges and find edges longer than
% the given maximum threshold. 
tmpflag = sum((DT.Points(fe(:,1),:) - DT.Points(fe(:,2),:)).^2, 2) > maxTINedgelen;
badedge = fe(tmpflag, :);
% if a cell center is in a bad triangle, no elevation will be
% returned. 
badtri = edgeAttachments(DT, badedge); 
% find which triangles the cell centers locate and barycentric
% coordinates of these centers
[ti, bc] = pointLocation(DT, demx, demy);
% for ponits outside the TIN
out_flag = isnan(ti);
% any ti is a member of badtri?
bad_flag = ismember(ti, cell2mat(badtri));
% bad triangles in ti are also marked in out_flag and will be
% excluded in the following z value interpolation
out_flag(bad_flag) = true;
% get the z values of the three vertices of each triangle
triVals = DT_z(DT(ti(~out_flag), :));
% the z value of a cell center is the dot product of barycentric
% coordinates of the center point and the z values of the three
% vertices of the triangle where the center locates
demz(~out_flag) = dot(bc(~out_flag, :)', triVals')';

if fill_nodata
    % ------------------------------------------------------------------------------
    % At far range of a scan, we still see a lot trunks but no returns from the
    % ground. The DEM from delaunay trianguligulization is not able to cover
    % those area. The trunk centers in those areas are lost while they are very
    % likely in overlapping areas with another scan and helpful for
    % registration. 
    % Here we use RANSAC to fit a plane to those DEM values filled by Delaunay
    % trangulization and fill the nodata area to make the whole scan XoY area
    % filled with DEM values. 
    [B, P, inliers] = ransacfitplane(([demx(~out_flag), demy(~out_flag), ...
                        demz(~out_flag)])', 1.0, 0);
    % [B, P, inliers] = ransacfitplane(([DT_x, DT_y, ...
    %                     DT_z])', 1.0, 0);
    if sum(out_flag(:))>0
        demz(out_flag) = -1*(B(1)*demx(out_flag) + B(2)*demx(out_flag) + B(4))/B(3);
    end
    % ------------------------------------------------------------------------------
end

% write dem to an ascii file as xyz format for easy display in some
% software as point clouds. 
fid = fopen([demfilename, '.xyz'], 'w');
fprintf(fid, 'x,y,z\n');
fprintf(fid, '%.3f,%.3f,%.3f\n', ([demx, demy, demz])');
fclose(fid);

% reshape the demz to a nrows by ncols matrix
demz_mat = reshape(demz, nrows, ncols);
% write dem to ascii file
fid = fopen(demfilename, 'w');
fprintf(fid, 'ncols\t%d\n', ncols);
fprintf(fid, 'nrows\t%d\n', nrows);
fprintf(fid, 'xllcorner\t%.6f\n', minx);
fprintf(fid, 'yllcorner\t%.6f\n', miny);
fprintf(fid, 'cellsize\t%f\n', cellsize);
fprintf(fid, 'NODATA_value\t%d\n', nodata);
fprintf(fid, [repmat('%.9g ', 1, ncols-1), '%.9g\n'], demz_mat');
fclose(fid);

fprintf('Script3_Points2DEM finished!\n');
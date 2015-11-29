% apply cluster algorithm of classifying stems and circle fitting with
% Hough transform to a layer above a given height from the ground (DEM)
% from a single scan. 

% clear;
% % parameters needed to be set beforehand. 
% % input: point cloud, ascii file. 
% ptsfilename = '/projectnb/echidna/lidar/DWEL_Processing/CA2013June/CA2013_Site305/CA2013-Site305-PointClouds/June12_01_305_C_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points.xyz';
% % input: DEM file from ArcGIS.
% demfilename = '/projectnb/echidna/lidar/DWEL_Processing/CA2013June/CA2013_Site305/CA2013-Site305-PointClouds/June12_01_305_C_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points_ground.dem';
% % output: feature points (trunk centers) extracted from a single
% % layer of point cloud. 
% fpfilename = '/projectnb/echidna/lidar/DWEL_Processing/CA2013June/CA2013_Site305/CA2013-Site305-PointClouds/June12_01_305_C_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points.fp';
% % for extracting the layer of points
% range = 50;
% height_clear = 1.4;
% % for circle fitting with Hough transform
% cellsize = 0.05;
% maxR = 30;
% sigmacoef = 1;
% epsion = 0.01;
% maxIter = 200;
% minnumfit = 9;

layerthickness = 0.1;
voxelsize = [0.2, 0.2, 0.2];
filtercellsize = 10;
zflag = 1.0/voxelsize(3);
maxstemlength = 10.0;

fprintf('Read points from %s ...\n', ptsfilename);
fid = fopen(ptsfilename, 'r');
data = textscan(fid, '%f %f %f');
x = data{1,1};
y = data{1,2};
z = data{1,3};
fclose(fid);
clear data;
tempindex = (x.^2 + y.^2)<=range^2;
x = x(tempindex);
y = y(tempindex);
z = z(tempindex);

% extract trunk ponits through vertical continuity of voxels with
% points.
fprintf('Voxelize the point cloud ...\n');
[pathstr, name, ~] = fileparts(ptsfilename);
% -----------------------------------------------------------------------
voxelfilename=fullfile(pathstr, ['tmpVoxels_', name, '.txt']);
demptsfilename=fullfile(pathstr, ['tmpLowestPts_', name, '.txt']);
rasterinfofilename=fullfile(pathstr, ['tmpRasterInfo_', name, 'txt']);
% -----------------------------------------------------------------------
% reshape x, y, z to column vector.
pointnum=length(x);
x=reshape(x, pointnum,1);
y=reshape(y, pointnum,1);
z=reshape(z, pointnum,1);
mexRasterize3d(x, y, z, voxelsize, voxelfilename, filtercellsize, demptsfilename, rasterinfofilename);
% -----------------------------------------------------------------------
stemptsfilename=fullfile(pathstr, ['StemPts_', name, '.txt']);
nonstemptsfilename=fullfile(pathstr, ['tmpNonStemPts_', name, '.txt']);
% -----------------------------------------------------------------------
voxelfid=fopen(voxelfilename, 'r');
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
% -----------------------------------------------------------------------
rasterinfofid=fopen(rasterinfofilename, 'r');
data=textscan(rasterinfofid,'%f %f %f', 3);
p2rInfo=cell2mat(data);
data=textscan(rasterinfofid,'%f');
IndexVector=cell2mat(data);
fclose(voxelfid);
% -----------------------------------------------------------------------
fid = fopen(demfilename, 'r');
data=textscan(fid, '%s %f', 6);
deminfo=data{1, 2};
formatstr = repmat('%f ', 1, deminfo(1));
data=textscan(fid,formatstr);
dem=cell2mat(data);
dem=flipud(dem);
fclose(fid);
clear data;
% -----------------------------------------------------------------------
fprintf('Search stems through continuity ...\n');
mexStemExtraction(x, y, z, p2rInfo, voxelarray, IndexVector, zflag, maxstemlength, dem ,deminfo, stemptsfilename, nonstemptsfilename);
delete(voxelfilename, demptsfilename, rasterinfofilename, nonstemptsfilename);
% -----------------------------------------------------------------------
fid = fopen(stemptsfilename, 'r');
data = textscan(fid, '%f %f %f');
x = data{1,1};
y = data{1,2};
z = data{1,3};
fclose(fid);
clear data;
% end of extracting trunk points.

fprintf('Extract the layer above the ground ...\n');
N = length(x);
trunk = zeros(N, 3);
n = 0;
for i = 1 : N;
    xpix = fix( ( x(i) - deminfo(3) ) / deminfo(5) ) + 1;
    ypix = fix( ( y(i) - deminfo(4) ) / deminfo(5) ) + 1;

    if xpix > 0 && xpix <= deminfo(1) && ypix > 0 && ypix <= deminfo(2) && dem(ypix, xpix)~=deminfo(6)
        height = z(i) - dem(ypix, xpix);
        if height < height_clear + layerthickness/2.0 && height > height_clear - layerthickness/2.0;
            n = n + 1;
            trunk(n, :) = [x(i), y(i), z(i)];
        end
    end
end
trunk = trunk(1 : n, :);

[pathstr, name, ext] = fileparts(ptsfilename);

% % ---for debugging-----------------------------
% TrunkFileName = fullfile(pathstr, ['Trunk_', name, ext]);
% fid = fopen(TrunkFileName, 'w');
% fprintf(fid, '%f\t%f\t%f\r\n', trunk');
% fclose(fid);
% % ---------------------------------------------

fprintf('Classify stems: ...\n');
TtableFileName = fullfile(pathstr, ['Ttable_', name, ext]);
arrTFileName = fullfile(pathstr, ['arrT_', name, ext]);
mexTreeClusterClassifier(trunk(:,1), trunk(:,2), trunk(:,3), 0.1, 1.0, 0, TtableFileName, arrTFileName);

fid = fopen(arrTFileName, 'r');
data = textscan(fid, '%f %f %f %f');
arrTpts = cell2mat(data);
fclose(fid);
clear data;

fprintf('Estimate trunk center with circle fitting ...\n');
treeno = unique(arrTpts(:,4));
fparr = zeros(length(treeno), 6);
validfpflag = false(length(treeno), 1);
n = 0;
m = 0;
numtree = length(treeno);
for i = 1:1:numtree
    ino = treeno(i);
    tempindex = arrTpts(:, 4)==ino;
    if sum(tempindex)<minnumfit
        fparr(i, 6) = -1;
        m = m + 1;
        continue;
    end
    selectx = arrTpts(tempindex, 1);
    selecty = arrTpts(tempindex, 2);
    selectz = arrTpts(tempindex, 3);
    [detectedcircle, finalHT, iterationdata, arcinfo] = mexDetEstCircle_Half(selectx, selecty, cellsize, maxR, sigmacoef, epsion, maxIter, minnumfit, [0, 0, 0]);
    if ~( isempty(detectedcircle) || isempty(finalHT) || arcinfo(3)==0 || isinf(arcinfo(3)) )
        xc = detectedcircle(2);
        yc = detectedcircle(1);
        xpix = fix( ( xc - deminfo(3) ) / deminfo(5) ) + 1;
        ypix = fix( ( yc - deminfo(4) ) / deminfo(5) ) + 1;
        if xpix > 0 && xpix <= deminfo(1) && ypix > 0 && ypix <= deminfo(2) && dem(ypix, xpix)~=deminfo(6)
            n = n + 1;
            % the last column of fparr is a flag. 1: trunk center
            % from circle fitting, highest reliability. 0: trunk
            % center from mean position of stem cluster, lower
            % reliability. -1: no trunk center found within the
            % extent of DEM. 
            fparr(i, :) = [xc, yc, height_clear+dem(ypix, xpix), ...
                           ino, detectedcircle(3), 1]; 
            validfpflag(i) = true;
        else 
            fparr(i, :) = [xc, yc, mean(selectz), ...
                           ino, detectedcircle(3), -1];
            m = m + 1;
            validfpflag(i) = true;
        end
    else
        xc = mean(selectx);
        yc = mean(selecty);
        zc = mean(selectz);
        fparr(i, :) = [xc, yc, zc, ...
                       ino, 0, 1-1/length(selectx)];
        validfpflag(i) = true;
    end
end
fparr = fparr(validfpflag, :);

fid = fopen(fpfilename, 'w');
fprintf(fid, 'x,y,z,TreeNO,radius,reliability\n');
fprintf(fid, '%f,%f,%f,%d,%f,%g\n', (fparr(:, 1:6))');
fclose(fid);

% delete(TtableFileName, arrTFileName);
delete(TtableFileName);

fprintf('Script4_TrkCtrSingleScanLayer finished!\n');

% % check by plotting
% figure('Name', name);
% plot(fparr(:,1), fparr(:, 2), '.r');
% hold on;
% anglearr = 0:2*pi/100:2*pi;
% for i=1:n
%     tempx = fparr(i, 5)*cos(anglearr) + fparr(i,1)*ones(size(anglearr));
%     tempy = fparr(i, 5)*sin(anglearr) + fparr(i,2)*ones(size(anglearr));
%     plot(tempx, tempy, '-g');
% end
% axis image;
% % end of check

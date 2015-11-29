% apply cluster algorithm of classifying stems and circle fitting with
% Hough transform to a layer above a given height from the ground (DEM)
% from multiple scans. 
% 
% Step 2

% arrTFileName = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/multi-scan-qsm/new_arrT_HFHD_20140503_5aligned_dual_cube_bsfix_pxc_update_atp2_ptcl_points_kmeans_canupo_class_xyz.txt';
% fpfilename = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/multi-scan-qsm/HFHD_20140503_5aligned_dual_cube_bsfix_pxc_update_atp2_ptcl_points_kmeans_canupo_class_xyz.fp';
% demfilename = '/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/spectral-points-by-union/HFHD20140503-dual-points-clustering/merging/multi-scan-qsm/HFHD_20140503_5aligned_dual_cube_bsfix_pxc_update_atp2_ptcl_points_kmeans_canupo_class_xyz_ground.dem';
% height_clear = 1.4;

% for circle fitting with Hough transform
cellsize = 0.05;
maxR = 30;
sigmacoef = 1;
epsion = 0.01;
maxIter = 200;
minnumfit = 9;

fid = fopen(demfilename, 'r');
data=textscan(fid, '%s %f', 6);
deminfo=data{1, 2};
formatstr = repmat('%f ', 1, deminfo(1));
data=textscan(fid,formatstr);
dem=cell2mat(data);
dem=flipud(dem);
fclose(fid);
clear data;

fid = fopen(arrTFileName, 'r');
data = textscan(fid, '%f %f %f %f', 'Delimiter', ',', 'HeaderLines', 1);
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
            % reliability. -1: trunk center found outside the
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

fprintf('Script4_TrkCtrMultiScanLayer_2 finished!\n');

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

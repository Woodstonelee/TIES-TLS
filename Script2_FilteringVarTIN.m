% filter points with variant TIN method

% clear;
% % parameters needed to be set beforehand
% files to input:
% InPtsPathName = '/net/modis3/fs/modis318/modis/Lidar/PointClouds/Bartlett_SugarMaple_2009';
% InPtsFileName = 'SugarMaple_C_AN_apprefl_BIP_points_xyz.txt';
% files to output:
% GroundPtsPathName = '/net/modis3/fs/modis318/modis/Lidar/PointClouds/Bartlett_SugarMaple_2009';
% GroundPtsFileName = 'GroundPts_SugarMaple_C_AN_apprefl_BIP_points_xyz.txt';
% RefineGround = false;

scale = [4.0000; 2.0000; 1.0000; 0.5000];
door = [3.0000; 1.5000; 0.5000; 0.2000];
% MaxRange and deltaz is to refine the ground point extraction at
% the end by fitting a plane to points within MaxRange and remove
% points with vertical distances to the plane larger than deltaz. 
MaxRange = 10; 
deltaz = 0.25;

fprintf('InPtsPathName: %s\n', InPtsPathName);
fprintf('InPtsFileName: %s\n', InPtsFileName);
fprintf('GroundPtsPathName: %s\n', GroundPtsPathName);
fprintf('GroundPtsFileName: %s\n', GroundPtsFileName);

fid = fopen(fullfile(InPtsPathName, InPtsFileName), 'r');
tempdata = textscan(fid, '%f %f %f');
fclose(fid);
tempdata = cell2mat(tempdata);
xlim(1) = min(tempdata(:, 1));
xlim(2) = max(tempdata(:, 1));
ylim(1) = min(tempdata(:, 2));
ylim(2) = max(tempdata(:, 2));
clear tempdata;

NewCutH = mexFilterVarScaleTIN(InPtsPathName, InPtsFileName, ...
                  GroundPtsPathName, GroundPtsFileName, ...
                  scale, door, ...
                  xlim, ylim, ...
                  nan(1,1), [0.2, 4], ...
                  [], [], []); 
clear functions;

if RefineGround
    % add a procedure to remove some false ground points in the area far from
    % the scan position.
    gpfid=fopen(fullfile(GroundPtsPathName, GroundPtsFileName), 'r');
    rawdata=textscan(gpfid,'%f %f %f');
    fclose(gpfid);
    datax=rawdata{1};
    datay=rawdata{2};
    dataz=rawdata{3};
    clear rawdata;
    % reshape x, y, z to column vector.
    ndata=length(datax);
    datax=reshape(datax, ndata,1);
    datay=reshape(datay, ndata,1);
    dataz=reshape(dataz, ndata,1);
    [newx, newy, newz] = Fcn_RefineGroundPoints(datax, datay, dataz, MaxRange, deltaz);
    newgpfid=fopen(fullfile(GroundPtsPathName, GroundPtsFileName), 'w');
    % fprintf(newgpfid, 'x,y,z\r\n');
    fprintf(newgpfid, '%.3f %.3f %.3f\r\n', ([newx, newy, newz])');
    fclose(newgpfid);
    % end of this refinement of ground points
end

% % delete the InPtsFile, the input point clouds file that is simply
% % reformated from the orginal EVI_b ptcld.log file
% delete(fullfile(InPtsPathName, InPtsFileName));

extent = [xlim(1), xlim(2), ylim(1), ylim(2)];
fprintf('XoY bounding box: \nminx\tmaxx\tminy\tmaxy\n%.3f\t%.3f\t%.3f\t%.3f\n', ...
        extent')

fprintf('Script2_FilteringVarTIN finished!\n');

clear datax datay dataz newx newy newz;
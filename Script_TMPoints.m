% Script_TMPoints.m 
% script, transform the points into another coordinate system with a given
% translation (offset, in the same unit with point clouds) and rotation (in
% unit of degree)
% Zhan Li, zhanli86@bu.edu
% Created: 2013
% Last modified: 2014-5-29

% % files to input
% % point cloud data format is simply the output from EVI/DWEL
% % point cloud generation program. 
% inptcldpathname = '/net/casfsb.bu.edu/vol/Data11/zhanli86/EVI_b_Bartlett_SugarMaple_2009/ptcld';
% inptcldfilename = 'Bartlett_sugarmaple_4mradStep_5mradBeam_ND015_Scan_02_NW_cube_basefix_nu_satfix_pfilter_at_project_ptcl.log';
% % files to output
% outptcldpathname = '/net/casfsb.bu.edu/vol/Data11/zhanli86/EVI_b_Bartlett_SugarMaple_2009/ptcld';
% outptcldfilename = 'Bartlett_sugarmaple_Registered_Scan_02_NW_ptcl.txt';
% 
% % --------------------------------------------------------------------------------------------------------
% % input registration parameters through a paramter file. 
% parampathname = '/net/modis3/fs/modis318/modis/Lidar/PointClouds/Bartlett_SugarMaple_2009';
% paramfilename =
% 'Parameters_Fcn_RegExplicitlyMatchedPoints_TM_arrT_Bartlett_sugarmaple_02_NW-01_CN.txt';
% % --------------------------------------------------------------------------------------------------------
% % --------------------------------------------------------------------------------------------------------
% % input registration parameters directly
% offset = []; % offset along x, y and z axis
% rotation = []; % rotation angles around x, y, and z axis
% % end of inputting registration parameters
% % --------------------------------------------------------------------------------------------------------

if exist('parampathname') & exist(paramfilename)
    % get registration paramters (3 offset paramters and 3 rotation
    % parameters) from a given paramter file
    fprintf('Input parameter file of translation and rotation: %s\n', ...
            fullfile(parampathname, paramfilename));
    fid = fopen(fullfile(parampathname, paramfilename), 'r');
    n = 0;
    while n<5
        linestr = fgetl(fid);
        n = n+1;
    end
    offset = sscanf(linestr, '%f %f %f');
    while n<7
        linestr = fgetl(fid);
        n = n+1;
    end
    rotation = sscanf(linestr, '%f %f %f %f');
    fclose(fid);
    % end of getting registration parameters from a given paramter
    % file
end
if ~(exist('offset') & exist('rotation'))
    fprintf('No registration parameters or parameter files are given!\n');
    return;
end

fprintf('Input point cloud data to be reposed: %s\n', fullfile(inptcldpathname, ...
                                                  inptcldfilename));
fprintf('Output transformed point cloud data: %s\n', ...
        fullfile(outptcldpathname, outptcldfilename));
fprintf('offset: %f, %f, %f', offset(1), offset(2), offset(3));
fprintf('rotation (deg): %f, %f, %f', rotation(1), rotation(2), rotation(3));

roll = rotation(1);
pitch = rotation(2);
yaw = rotation(3);
roll = roll/180.0*pi;
pitch = pitch/180.0*pi;
yaw = yaw/180.0*pi;

data = csvread(fullfile(inptcldpathname, inptcldfilename), 3, 0);
x = data(:, 1);
y = data(:, 2);
z = data(:, 3);
I = data(:, 4:end);

R = [1, 0.0, 0.0; ...
    0.0, cos(roll), -sin(roll); ...
    0.0, sin(roll), cos(roll)];
R = [cos(pitch), 0.0, sin(pitch); ...
    0.0, 1.0, 0.0; ...
    -sin(pitch), 0.0, cos(pitch)]*R;
R = [cos(yaw), -sin(yaw), 0.0; ...
    sin(yaw), cos(yaw), 0.0; ...
    0.0, 0.0, 1.0]*R;

T = reshape(offset, 3, 1);

npoints = length(x);
data = [x, y, z];
newdata = R*data' + repmat(T, 1, npoints);
newdata = newdata'; % now, newdata is N*3 matrix.

ncol = size(I, 2);

fid = fopen(fullfile(outptcldpathname, outptcldfilename), 'w');
infid = fopen(fullfile(inptcldpathname, inptcldfilename));
linestr = fgetl(infid);
fprintf(fid, ['%s [Reposed by registration params, offset [%f,%f,%f], ' ...
              'roll [%f,%f,%f]]\n'], linestr, offset(1), offset(2), ...
        offset(3), rotation(1), rotation(2), rotation(3));
linestr = fgetl(infid);
fprintf(fid, '%s; [Reposed run at %s]\n', linestr, datestr(clock));
linestr = fgetl(infid);
fprintf(fid, '%s\n', linestr);
fclose(infid);
fprintf(fid, ['%f,%f,%f', repmat(',%f', 1, ncol), '\n'], ([newdata, I])');
fclose(fid);

fprintf('Script_TMPoints finished!\n');

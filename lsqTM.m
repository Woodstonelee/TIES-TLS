function [R, T, EA, DistRMS, exitflag] = lsqTM(model, data, param0, lb, ub)
% SYNTAX
% [R, T, EA, DistRMS] = lsqTM(model, data, param0, lb, ub)
% Calculate transform matrix with given explicit matched point pairs by
% minimizing the sum of square of distance between tie points. 
% model: N*D matrix, N is the number of points and D is the dimension
% data: N*D matrix, N is the number of points and D is the dimension
% param0: [roll, x0; pitch, y0; yaw, z0], angle unit: radian, distance
% unit: meter
% model = R*data + T
% EA: [roll, pitch, yaw]
% REQUIRED ROUTINES: 
    
    if isempty(param0)
        param0 = zeros(3, 2);
    end
    if isempty(lb)
        lb = [ ...
            -2*pi, -Inf; ...
            -2*pi, -Inf; ...
            -2*pi, -Inf];
    end
    if isempty(ub)
        ub = [ ...
            2*pi, Inf; ...
            2*pi, Inf; ...
            2*pi, Inf];
    end

    objfunhandle = PkBgErr(model, data);
    
    options = optimset('Algorithm','active-set', 'MaxFunEvals', 2000);
    [estparam, fval, exitflag] = ...
        fmincon(objfunhandle, param0, [], [], [], [], lb, ub, [], options);
    DistRMS = sqrt( fval/size(model, 1) );
    T = estparam(:, 2);
    
    roll = estparam(1, 1);
    pitch = estparam(2, 1);
    yaw = estparam(3, 1);
    EA = [roll, pitch, yaw];
    R = [1, 0.0, 0.0; ...
        0.0, cos(roll), -sin(roll); ...
        0.0, sin(roll), cos(roll)];
    R = [cos(pitch), 0.0, sin(pitch); ...
        0.0, 1.0, 0.0; ...
        -sin(pitch), 0.0, cos(pitch)]*R;
    R = [cos(yaw), -sin(yaw), 0.0; ...
        sin(yaw), cos(yaw), 0.0; ...
        0.0, 0.0, 1.0]*R;

end

function h = PkBgErr(model, data) 
% PKBGERR returns function handle of objective function.
% model: N*D matrix, N is the number of points and D is the dimension
% data: N*D matrix, N is the number of points and D is the dimension

    h = @errFcn;
    % nested, i.e. objective function.
    function err = errFcn(param) 
        sizeparam=size(param);
        if sizeparam(2)~=2 || sizeparam(1)~=3
            error('PkBgErr, size of estParams is wrong, have to be 3*2!');
        end
        npoints = size(model, 1);
        if size(data, 1)~=npoints
            error('model and data does not have the same number of points!');
        end
        
        roll = param(1, 1);
        pitch = param(2, 1);
        yaw = param(3, 1);
        R = [1, 0.0, 0.0; ...
            0.0, cos(roll), -sin(roll); ...
            0.0, sin(roll), cos(roll)];
        R = [cos(pitch), 0.0, sin(pitch); ...
            0.0, 1.0, 0.0; ...
            -sin(pitch), 0.0, cos(pitch)]*R;
        R = [cos(yaw), -sin(yaw), 0.0; ...
            sin(yaw), cos(yaw), 0.0; ...
            0.0, 0.0, 1.0]*R;
        T = param(:, 2);
        
        newdata = R*data' + repmat(T, 1, npoints);
        newdata = newdata'; % now, newdata is N*D matrix.
        
        distsquare = sum( (model - newdata).^2,  2);
        
        err = sum(distsquare);
        
    end
    % nested function
end
function [R, T, EA, DistRMS, exitflag] = lsqTM2D(model, data, param0, lb, ub)
% SYNTAX
% [R, T, EA, DistRMS] = lsqTM(model, data, param0, lb, ub)
% Calculate transform matrix with given explicit matched point pairs by
% minimizing the sum of square of distance between tie points. 
% model: N*2 matrix, N is the number of points and 2 is the dimension
% data: N*2 matrix, N is the number of points and 2 is the dimension
% param0: [x0; y0; yaw], angle unit: radian, distance
% unit: meter
% model = R*data + T
% EA: [roll=0, pitch=0, yaw]
% REQUIRED ROUTINES: 
    
    if isempty(param0)
        param0 = zeros(3, 1);
    end
    if isempty(lb)
        lb = [ ...
            -Inf; ...
            -Inf; ...
            -2*pi];
    end
    if isempty(ub)
        ub = [ ...
            Inf; ...
            Inf; ...
            2*pi];
    end

    objfunhandle = PkBgErr(model, data);
    
    options = optimset('Algorithm','active-set', 'MaxFunEvals', 2000);
    [estparam, fval, exitflag] = ...
        fmincon(objfunhandle, param0, [], [], [], [], lb, ub, [], options);
    DistRMS = sqrt( fval/size(model, 1) );
    T = [estparam(1:2); 0];
    roll = 0;
    pitch = 0;
    yaw = estparam(3);
    EA = [0, 0, yaw];
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
        if sizeparam(2)~=1 || sizeparam(1)~=3
            error('PkBgErr, size of estParams is wrong, have to be 3*2!');
        end
        npoints = size(model, 1);
        if size(data, 1)~=npoints
            error('model and data does not have the same number of points!');
        end
        
        yaw = param(3);
        R = [cos(yaw), -sin(yaw); ...
            sin(yaw), cos(yaw)];
        T = param(1:2);
        
        newdata = R*data' + repmat(T, 1, npoints);
        newdata = newdata'; % now, newdata is N*D matrix.
        
        distsquare = sum( (model - newdata).^2,  2);
        
        err = sum(distsquare);
        
    end
    % nested function
end
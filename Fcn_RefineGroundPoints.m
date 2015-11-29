function [newx, newy, newz] = Fcn_RefineGroundPoints(x, y, z, MaxRange, deltaz)
    selectflag = (x.^2 + y.^2) < MaxRange^2 * ones(size(x));
    [A, B, C] = FitPlane( x(selectflag), y(selectflag), z(selectflag));
    newptsflag = z < (A*x + B*y + C*ones(size(x)) + deltaz*ones(size(x)));
    newptsflag = newptsflag & ( z > (A*x + B*y + C*ones(size(x)) - deltaz*ones(size(x))) );
    newx = x(newptsflag);
    newy = y(newptsflag);
    newz = z(newptsflag);
end

function [A, B, C] = FitPlane(x, y, z)
    % Fit a plane to points: z = A*x + B*y + C
    errFcn=PkBgErr(x,y,z);
    estParams = [0, 0, 0];
    fitParams = lsqnonlin(errFcn,estParams);
    A = fitParams(1);
    B = fitParams(2);
    C = fitParams(3);    
end

function h = PkBgErr(x,y,z) %PKBGERR returns function handle.
    h = @errFcn;
    function err = errFcn(param) %nested
        % param: [A, B, C]
        sizeparam=size(param);
        if sizeparam(2)~=3 || sizeparam(1)~=1
            error('PkBgErr, size of estParams is wrong!');
        end
        A=param(1,1);B=param(1,2);C=param(1,3);
               
        err = sqrt( A*x + B*y + C*ones(size(x)) -z );
        
    end %nested function
end
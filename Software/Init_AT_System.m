function sys = Init_AT_System(type,Num,WperT)
%INITSPINS Initialize a configuration of spins.
%   spin = INITSPINS(numSpinsPerDim, p) returns a configuration of spins
%   with |numSpinsPerDim| spins along each dimension and a proportion |p|
%   of them pointing upwards. |spin| is a matrix of +/- 1's.
%   Copyright 2020 Jinyeop Song.

sys=AT_System;

%% linear 1D
if(type=="linear1D")
    p=0.5;
    sys.type="linear1D";
    sys.WperT=WperT;
    sys.Tnum=Num;
    sys.T=(rand(1,sys.Tnum)>p);
    sys.T_position=struct;
    sys.T_position.x=linspace(1,1*sys.Tnum,sys.Tnum);
    sys.T_position.y=zeros(1,sys.Tnum);
    sys.T_position.z=zeros(1,sys.Tnum);
    sys.W_relation=[];
    sys.T2W=zeros(1,sys.Tnum);
    wi=0;
    for i=1:sys.Tnum
        for j=(i+1):sys.Tnum
            if(DistanceBtwTwoTargets(sys,i,j)<1.5)
                wi=wi+1;
                sys.W_relation = [sys.W_relation ; [i,j]];
            end
        end
    end
    sys.W=zeros(1,size(sys.W_relation,1));
end
%% circle 1D 
if(type=="circular1D")
    p=0.5;
    sys.type="circular1D";
    sys.WperT=WperT;    
    sys.Tnum=Num;
    sys.T=(rand(1,sys.Tnum)>p);
    sys.T_position=struct;
    sys.T_position.x=sys.Tnum/2/pi*cos(linspace(0,2*pi,sys.Tnum));
    sys.T_position.y=sys.Tnum/2/pi*sin(linspace(0,2*pi,sys.Tnum));
    sys.T_position.z=zeros(1,sys.Tnum);
    sys.W_relation=[];
    sys.T2W=zeros(1,sys.Tnum);
    wi=0;
    for i=1:sys.Tnum
        for j=(i+1):sys.Tnum
            if(DistanceBtwTwoTargets(sys,i,j)<1.2)
                wi=wi+1;
                sys.W_relation = [sys.W_relation ; [i,j]];
            end
        end
    end
    sys.W=zeros(1,size(sys.W_relation,1));
end

%% Square 2D
if(type=="square2D")
    p=0.5;
    sys.type="square2D";
    Num=round(Num^0.5);
    sys.WperT=WperT;
    sys.Tnum=Num*Num;
    sys.T=(rand(1,sys.Tnum)>p);
    sys.T_position=struct;
    [X,Y]=meshgrid(linspace(1,1*Num,Num),linspace(1,1*Num,Num));
    sys.T_position.x=X(:);
    sys.T_position.y=Y(:);
    sys.T_position.z=zeros(1,sys.Tnum);
    sys.W_relation=[];
    sys.T2W=zeros(1,sys.Tnum);
    wi=0;
    for i=1:sys.Tnum
        for j=(i+1):sys.Tnum
            if(DistanceBtwTwoTargets(sys,i,j)<1.2)
                wi=wi+1;
                sys.W_relation = [sys.W_relation ; [i,j]];
            end
        end
    end
    sys.W=zeros(1,size(sys.W_relation,1));
end
%% hexgagonal Sphere 2D
if(type=="hexagonalSphere2D")
    p=1;
    sys.type="hexagonalSphere2D";
    sys.WperT=WperT;
    sys.Tnum=Num;
    sys.T=(rand(1,sys.Tnum)>p);
    sys.T_position=struct;

        
    Mnum=0;
    while Mnum<Num | Mnum>Num+2
    tNum=floor(Num/3)+3
    [V,Tri,~,Ue]=ParticleSampleSphere('N',tNum);
    r_eff=(1*tNum/4/pi*(3^0.5/2))^0.5;
    V=r_eff*V;
    
    index_list=[1]
    confirmed_index_list=[];
    x=[];
    y=[];
    z=[];
    
    for i=1:tNum-1
        for j=i+1:tNum
            if sqrt((V(i,1)-V(j,1))^2+(V(i,2)-V(j,2))^2+(V(i,3)-V(j,3))^2)<1.3
                x=[x (V(i,1)+V(j,1))/2];
                y=[y (V(i,2)+V(j,2))/2];
                z=[z (V(i,3)+V(j,3))/2];
            end
        end
    end
    Mnum=size(x,2);

    end
    
    while size(x,2)>Num
        ind=randi(size(x,2));
        x(ind)=[];
        y(ind)=[];
        z(ind)=[];

    end
    disp(size(x))
        
    coef=2
    sys.T_position.x=coef*x';
    sys.T_position.y=coef*y';
    sys.T_position.z=coef*z';
    sys.W_relation=[];
    sys.T2W=zeros(1,sys.Tnum);
    wi=0;
    for i=1:sys.Tnum
        for j=(i+1):sys.Tnum
            if(DistanceBtwTwoTargets(sys,i,j)<1.05)
                wi=wi+1;
                sys.W_relation = [sys.W_relation ; [i,j]];
            end
        end
    end
    sys.W=zeros(1,size(sys.W_relation,1));
end

%% Triangular Sphere 2D
if(type=="triangularSphere2D")
    p=0.5;
    sys.type="triangularSphere2D";
    sys.WperT=WperT;
    sys.Tnum=Num;
    sys.T=(rand(1,sys.Tnum)>p);
    sys.T_position=struct;
    [V,Tri,~,Ue]=ParticleSampleSphere('N',Num);
    r_eff=(1*sys.Tnum/4/pi*(3^0.5/2))^0.5;
    V=r_eff*V;
    sys.T_position.x=V(:,1)';
    sys.T_position.y=V(:,2)';
    sys.T_position.z=V(:,3)';
    sys.W_relation=[];
    sys.T2W=zeros(1,sys.Tnum);
    wi=0;
    for i=1:sys.Tnum
        for j=(i+1):sys.Tnum
            if(DistanceBtwTwoTargets(sys,i,j)<1.3)
                wi=wi+1;
                sys.W_relation = [sys.W_relation ; [i,j]];
            end
        end
    end
    sys.W=zeros(1,size(sys.W_relation,1));
end
%% Cubic Sphere 2D
if(type=="cubicSphere2D")
    p=0.5;
    sys.type="cubicSphere2D";
    sys.WperT=WperT;
    fv=QuadCubeMesh;
    while size(fv.vertices,1)<Num
        fv=SubdivideSphericalMesh(fv,1);
    end
    sys.Tnum=size(fv.vertices,1);

    sys.T=(rand(1,sys.Tnum)>p);
    sys.T_position=struct;
    V=fv.vertices;
    r_eff=(1*sys.Tnum/4/pi)^0.5;
    V=r_eff*V;
    sys.T_position.x=V(:,1)';
    sys.T_position.y=V(:,2)';
    sys.T_position.z=V(:,3)';
    sys.W_relation=[];
    sys.T2W=zeros(1,sys.Tnum);
    wi=0;
    for i=1:sys.Tnum
        for j=(i+1):sys.Tnum
            if(DistanceBtwTwoTargets(sys,i,j)<1.1)
                wi=wi+1;
                sys.W_relation = [sys.W_relation ; [i,j]];
            end
        end
    end
    sys.W=zeros(1,size(sys.W_relation,1));
end
%% Cubic Sphere 2D
if(type=="grided2D")
    p=0.5;
    sys.type="grided2D";
    sys.WperT=WperT;
    fv=QuadCubeMesh;
    while size(fv.vertices,1)<Num
        fv=SubdivideSphericalMesh(fv,1);
    end
    sys.Tnum=size(fv.vertices,1);

    sys.T=(rand(1,sys.Tnum)>p);
    sys.T_position=struct;
    V=fv.vertices;
    r_eff=(1*sys.Tnum/4/pi)^0.5;
    V=r_eff*V;
    sys.T_position.x=V(:,1)';
    sys.T_position.y=V(:,2)';
    sys.T_position.z=V(:,3)';
    sys.W_relation=[];
    sys.T2W=zeros(1,sys.Tnum);
    wi=0;
    for i=1:sys.Tnum
        for j=(i+1):sys.Tnum
            if(DistanceBtwTwoTargets(sys,i,j)<1.6)
                wi=wi+1;
                sys.W_relation = [sys.W_relation ; [i,j]];
            end
        end
    end
    sys.W=zeros(1,size(sys.W_relation,1));
end
%% etc
if(type=='etc')
end

disp(sys)
end


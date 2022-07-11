function sys = Init_AT_System_RS(type, L, density, WperT)

% RandomSurface AT system initiation , Jul-20-2020

%   Copyright 2020 Jinyeop Song.

sys=AT_System;

%% randomUniformFlat2D
if(type=="randomUniformFlat2D")
    p=0.5;
    sys.type="randomUniformFlat2D";
    sys.WperT=WperT;
    sys.Tnum=floor((L)*density);
    sys.T=(rand(1,sys.Tnum)>p);
    sys.T_position=struct;
    
    sys.T_position.x=(L^0.5)*rand(sys.Tnum,1);
    sys.T_position.y=(L^0.5)*rand(sys.Tnum,1);
    sys.T_position.z=zeros(sys.Tnum,1);
    
    disp(sys.T_position)
    sys.W_relation=[];
    sys.T2W=zeros(sys.Tnum,1);

    wi=0;
    
    
    for i=1:sys.Tnum
        for j=(i+1):sys.Tnum
            if(DistanceBtwTwoTargets(sys,i,j)<1.01)
                wi=wi+1;
                sys.W_relation = [sys.W_relation ; [i,j]];
            end
        end
    end
    sys.W=zeros(1,size(sys.W_relation,1));
end

%% randomUniformSphere2D
if(type=="randomUniformSphere2D")
    p=0.5;
    sys.type="randomUniformSphere2D";
    sys.WperT=WperT;
    sys.Tnum=floor((L)*density);
    sys.T=(rand(1,sys.Tnum)>p);
    sys.T_position=struct;
    
    
    theta=acos(1-2*rand(sys.Tnum,1));
    phi=2*3.141592*rand(sys.Tnum,1);
    radius=(L/4/3.141592)^0.5;
    sys.T_position.x=radius*sin(theta).*cos(phi);
    sys.T_position.y=radius*sin(theta).*sin(phi);
    sys.T_position.z=radius*cos(theta);
    
    sys.W_relation=[];
    sys.T2W=zeros(sys.Tnum,1);
    wi=0;
    
    
    for i=1:sys.Tnum
        for j=(i+1):sys.Tnum
            if(DistanceBtwTwoTargets(sys,i,j)<1.01)
                wi=wi+1;
                sys.W_relation = [sys.W_relation ; [i,j]];
            end
        end
    end
    sys.W=zeros(1,size(sys.W_relation,1));
end
%% etc

%% randomQuasiFlat2D
if(type=="randomQuasiFlat2D")
    p=0.5;
    sys.type="randomQuasiFlat2D";    
    sys.WperT=WperT;
    sys.Tnum=floor((L)*density);
    sys.T=(rand(1,sys.Tnum)>p);
    sys.T_position=struct;
    
    p = haltonset(2,'Skip',floor(1e3*(1+rand())),'Leap',1e2);
    p = scramble(p,'RR2');
    X0 = net(p,sys.Tnum);

    sys.T_position.x=(L^0.5)*X0(:,1);
    sys.T_position.y=(L^0.5)*X0(:,2);
    sys.T_position.z=zeros(sys.Tnum,1);
    
    sys.W_relation=[];
    sys.T2W=zeros(sys.Tnum,1);
    wi=0;
    
    
    for i=1:sys.Tnum
        for j=(i+1):sys.Tnum
            if(DistanceBtwTwoTargets(sys,i,j)<1.0001)
                wi=wi+1;
                sys.W_relation = [sys.W_relation ; [i,j]];
            end
        end
    end
    sys.W=zeros(1,size(sys.W_relation,1));
end

%% randomQuasiSphere2D
if(type=="randomQuasiSphere2D")
    p=0.5;
    sys.type="randomQuasiSphere2D";
    sys.WperT=WperT;
    sys.Tnum=floor((L)*density);
    sys.T=(rand(1,sys.Tnum)>p);
    sys.T_position=struct;
    
    
    p = haltonset(2,'Skip',floor(1e3*(1+rand())),'Leap',1e2);
    p = scramble(p,'RR2');
    X0 = net(p,sys.Tnum);

    sys.T_position.x=(L^0.5)*X0(:,1);
    
    theta=acos(1-2*X0(:,1));
    phi=2*3.141592*X0(:,2);
    radius=(L/4/3.141592)^0.5;
    sys.T_position.x=radius*sin(theta).*cos(phi);
    sys.T_position.y=radius*sin(theta).*sin(phi);
    sys.T_position.z=radius*cos(theta);
    
    sys.W_relation=[];
    sys.T2W=zeros(sys.Tnum,1);
    wi=0;
    
    
    for i=1:sys.Tnum
        for j=(i+1):sys.Tnum
            if(DistanceBtwTwoTargets(sys,i,j)<1.0001)
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

%% randomQuasiFlat2D
if(type=="randomQuasiFlatRepeatedBoundary2D")
    p=0.5;
    sys.type="randomQuasiFlatRB2D";    
    sys.WperT=WperT;
    sys.Tnum=floor((L)*density);
    sys.T=(rand(1,sys.Tnum)>p);
    sys.T_position=struct;
    
    p = haltonset(2,'Skip',floor(1e3*(1+rand())),'Leap',1e2);
    p = scramble(p,'RR2');
    X0 = net(p,sys.Tnum);

    sys.T_position.x=(L^0.5)*X0(:,1);
    sys.T_position.y=(L^0.5)*X0(:,2);
    sys.T_position.z=zeros(sys.Tnum,1);
    
    sys.W_relation=[];
    sys.T2W=zeros(sys.Tnum,1);
    wi=0;
    
    
    for i=1:sys.Tnum
        for j=(i+1):sys.Tnum
            if(DistanceBtwTwoTargets_flatRB(sys,i,j,L^0.5)<1.0001)
                wi=wi+1;
                sys.W_relation = [sys.W_relation ; [i,j]];
            end
        end
    end
    sys.W=zeros(1,size(sys.W_relation,1));
end


disp(sys)

end

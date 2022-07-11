%%
function Amplification = Distance_Kd_map_uniform(D_BS_list,D_Linker,resolution)

Amplification=zeros(size(D_BS_list));
for j=1:size(D_BS_list,2)
    D_BS=D_BS_list(j);
    N_avogadro=6.02*10^23;

%     %x=D_BS-D_Linker:resolution:D_Linker;
%     x=-D_Linker:resolution:D_BS+D_Linker;
%     y=-D_Linker:resolution:D_Linker;
%     z=-D_Linker:resolution:D_Linker;
%     [X,Y,Z] = meshgrid(x,y,z);
%     r=sqrt(X.^2+Y.^2+Z.^2);
%     func=@(x) p_uniform(x,D_Linker);
%     p1=arrayfun(func,r);
%     p1=p1/sum(p1(:));
%     r=sqrt((X-D_BS).^2+Y.^2+Z.^2);
%     func=@(x) p_uniform(x,D_Linker);
%     p2=arrayfun(func,r);
%     p2=p2/sum(p2(:));
%     p12=p1.*p2;
%     disp(sum(p12(:))*resolution^3);
%     overlap=sum(p12(:))/resolution^3*(10^-27)*(10^27*10^-3/N_avogadro)^2;

    x=-D_Linker:resolution:D_Linker+D_BS;
    y=-D_Linker:resolution:D_Linker;
    z=-D_Linker:resolution:D_Linker;
    [X,Y,Z] = meshgrid(x,y,z);
    r=sqrt(X.^2+Y.^2+Z.^2);
    func=@(x) p_uniform(x,D_Linker);
    p1=arrayfun(func,r);
    r=sqrt((X-D_BS).^2+Y.^2+Z.^2);
    func=@(x) p_uniform(x,D_Linker);
    p2=arrayfun(func,r);
    p12=p1.*p2;
    vol1=sum(p12(:))*resolution^3*(10^-27)*10^3;
    vol2=4/3*pi*D_Linker^3*(10^-27)*10^3;
    coeff=1/N_avogadro/vol2^2*vol1;
    Amplification(j)=1/coeff;
end
end

%%
function p=p_uniform(r,rmax)
    if r<rmax
        p=1;
    else
        p=0;
    end
end

function p=p_WLC(r,rmax,r_p)
    if r<rmax-0.001
        p=1/(1-(r^2)/(rmax^2))^(9/2)*exp(-9*rmax/8/r_p*(1/(1-(r^2)/(rmax^2))));
    else
        p=0;
    end
end
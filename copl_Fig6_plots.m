%%
% Written by Jinyeop Song, 2020/07/20
% This is the demo code for Antibody_ThermoCalc_JY.
% To run the code, follow the description of each sections.
clc; clear;

% To change
addpath(genpath('D:\JY_matlab\210601_Antibody_v2\210601_Antibody_v2')) % Add the entire path of Antibody_ThermoCalc_JY
cmap=0.85*hsv(9);
Project_title_ = "Fig6_extended";
Project_title = Project_title_;



%% binding %
cd(Project_title+'_')
load(Project_title+"_\data.mat")
Project_title = Project_title_;
figure('Renderer', 'painters', 'Position', [10 10 700 600])
Legend=[];
k=0;
excel=[];

for idx=1
    k=k+1;
    aa_list=["Square"]
    NN=idx
    color_idx=0;

    %load(datapath)
    color_idx=color_idx+1;
    X=Kd2_list;
    Y=mean(ProbS(NN,1,:,:),4)./Tnum;
    Z=std(ProbS(NN,1,:,:),0,4)./Tnum
    semilogx(X,Y(:),'-o','Color',cmap(k,:),'MarkerEdgeColor',cmap(k,:),'Linewidth', 3)
    dataname=aa_list(idx)% Change dataname
    Legend=[Legend dataname];
    hold on;
    %mean(ProbS(j, 2:size(Kd2_list,2),:),3)/Tnum,'-o','Color',cmap(k,:),'MarkerEdgeColor',cmap(k,:))
    excel=[excel [X(:) Y(:) Z(:)]];

end 
xl = xlim;
X=linspace(xl(1),xl(2),size(X,2));
Y=0.1+0*X;
semilogx(X,Y,'--')
hold on;
dataname="control(no tether)"
Legend=[Legend dataname];
hold on;
excel=[excel [X(:) Y(:)]];

title(["1"])
xlabel("$p_{tethering}$",'Interpreter','latex')
ylabel("$\frac{N_{bound}}{N_{total}}$",'Interpreter','latex')
ylim([0 1])
xlim([10^-10 10^-3])


    
saveas(gcf,['figure_patterend_' '.fig']);
export_fig(['figure_patterend_' '.tif'],'-m5.0','-transparent')
legend(Legend) %"Control" "Self Cohesion" ], 'Location','northeast')
export_fig(['figure_patterned_' '_legend.tif'],'-m5.0','-transparent')
writematrix(excel,'figure_patterend.xls')

cd ..

%% kdeff %
%% binding %
cd(Project_title+'_')
load(Project_title+"_\data.mat")
Project_title = Project_title_;
figure('Renderer', 'painters', 'Position', [10 10 700 600])
Legend=[];
k=0;
excel=[];
for idx=1:3
    k=k+1;
    aa_list=["Hexagonal","Triangular","Square"]
    NN=idx
    color_idx=0;

    %load(datapath)
    color_idx=color_idx+1;
    X=Kd2_list;
    Y=mean(ProbS(NN,1,:,:),4)./Tnum;
    Z=std(ProbS(NN,1,:,:),0,4)./Tnum;
    Z=pA*(Z)./Y+pA*(1-Y)./Y./Y.*Z
    Y=pA*(1-Y)./(Y)
    loglog(X,Y(:),'-o','Color',cmap(k,:),'MarkerEdgeColor',cmap(k,:),'Linewidth', 3)
    dataname=aa_list(idx)% Change dataname
    Legend=[Legend dataname];
    hold on;
    %mean(ProbS(j, 2:size(Kd2_list,2),:),3)/Tnum,'-o','Color',cmap(k,:),'MarkerEdgeColor',cmap(k,:))
    excel=[excel [X(:) Y(:) Z(:)]];


end 
xl = xlim;
X=linspace(xl(1),xl(2),size(X,2));
Y=10^-8+0*X;
semilogx(X,Y,'--')
hold on;
dataname="control(no tether)"
Legend=[Legend dataname];
hold on;
excel=[excel [X(:) Y(:)]];



title(["2"])
xlabel("$p_{tethering}$",'Interpreter','latex')
ylabel("Kd_{eff}")
xlim([10^-11 10^-6])
ylim([10^-10.5 10^-7.5])
set(gca, 'YDir','reverse')

    
saveas(gcf,['figure_patterend_Kd_' '.fig']);
export_fig(['figure_patterend_Kd_' '.tif'],'-m5.0','-transparent')
legend(Legend) %"Control" "Self Cohesion" ], 'Location','northeast')
export_fig(['figure_patterned_Kd_' '_legend.tif'],'-m5.0','-transparent')
writematrix(excel,'figure_patterend_Kd.xls')


cd ..



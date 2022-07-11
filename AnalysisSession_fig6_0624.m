%%
set(0,'defaultAxesFontSize',25)
clear; close all;
session_name="Experiment_0627_random_Figure6_062022_"
datafolder="/Users/jysong/Desktop/MATLAB/220622_Antibody_JY/Data/"+session_name;
load(datafolder+"/Experiment_specification.mat")

if ~isfolder("Analysis/"+session_name)
    mkdir("Analysis/"+session_name)
end


if ~isfile("Analysis/"+session_name+"/processed_data"+".mat")
    list=dir(datafolder+"/*.csv")
    
    data=zeros(length(Experiment_specification.IDX),2);
    for i=1:length(list)
        filename=list(i).folder+"/"+list(i).name;
        idx=sscanf(list(i).name,'Result_%d.csv');
        o=readtext_AB(Experiment_specification,filename)
        data(idx,1)= mean(o(:,1))/mean(o(:,2))
        data(idx,2)=1
        %snum=Experiment_specification.parameterlist1(Experiment_specification.IDX(idx,1));
        %[M,a,b,c] = readtext_GV(Experiment_specification, filename,snum);
        %data(idx,:)=mean(M);
    end
    
    save(strcat("Analysis/",session_name,"/","processed_data_1",".mat"), 'data')
else
    load(strcat("Analysis/",session_name,"/","processed_data_1",".mat"))
end
%%

%% binding %
cmap=0.85*hsv(9);

figure('Renderer', 'painters', 'Position', [10 10 700 600])
Legend=[];
k=0;
excel=[];
color_idx=0;
for idx=1:4
    k=k+1;
    aa_list=["p=8.45","p=16.9","p=25.35","p=33.8"]
    range=(idx-1)*40+1:(idx)*40

    %load(datapath)
    color_idx=color_idx+1;
    X=Experiment_specification.Kd2_list;
    Y=data(range,1);
    O=logical(data(range,2))
    semilogx(X(O),Y(O),'-o','Color',cmap(k,:),'MarkerEdgeColor',cmap(k,:),'Linewidth', 3)
    dataname=aa_list(idx)% Change dataname
    Legend=[Legend dataname];
    hold on;
    %mean(ProbS(j, 2:size(Kd2_list,2),:),3)/Tnum,'-o','Color',cmap(k,:),'MarkerEdgeColor',cmap(k,:))
    excel=[excel [X(:) Y(:)]];

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
xlim([10^-8 10^-2])

writematrix(excel,strcat("Analysis/",session_name,"/","excel_BSoccupancy",".xlsx"),'Sheet',1,'Range','D1')


%% binding %
cmap=0.85*hsv(9);

figure('Renderer', 'painters', 'Position', [10 10 700 600])
Legend=[];
k=0;
excel=[];
color_idx=0;
for idx=1:4
    k=k+1;
    aa_list=["p=8.45","p=16.9","p=25.35","p=33.8"]
    range=(idx-1)*40+1:(idx)*40

    %load(datapath)
    color_idx=color_idx+1;
    X=Experiment_specification.Kd2_list;
    Y=data(range,1);
    Y=Experiment_specification.pA*(1-Y)./(Y)
    O=logical(data(range,2))
    loglog(X(O),Y(O),'-o','Color',cmap(k,:),'MarkerEdgeColor',cmap(k,:),'Linewidth', 3)
    dataname=aa_list(idx)% Change dataname
    Legend=[Legend dataname];
    hold on;
    %mean(ProbS(j, 2:size(Kd2_list,2),:),3)/Tnum,'-o','Color',cmap(k,:),'MarkerEdgeColor',cmap(k,:))
    excel=[excel [X(:) Y(:)]];

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
xlabel("$kD_{catenator}$",'Interpreter','latex')
ylabel("kD_{eff}")
xlim([10^-8 10^-2])
ylim([10^-14.5 10^-7.5])
set(gca, 'YDir','reverse')
legend(Legend)

writematrix(excel,strcat("Analysis/",session_name,"/","excel_KDeff",".xlsx"),'Sheet',1,'Range','D1')


%%

function o=readtext_AB(Experiment_specification, filename)
    fileID = fopen(filename);
    fmt=strcat('%d %d\n');
    data=textscan(fileID,fmt);
    fclose(fileID);
    o=[data{1} data{2}];
end


function ExperimentSession_fig6_0624(SLURM_ARRAY_TASK_ID,MAX_TASK_ID, D_BS)
    rehash toolboxcache
    set(0,'defaultAxesFontSize',20)
    addpath(genpath('Software'))
    Experiment_specification=struct;
    
    Experiment_specification.filename=sprintf('Experiment_0624_Figure6_%s_%s', datestr(now,'mmyyyy'),num2str(D_BS));
    Experiment_specification.foldername=sprintf('%s/%s/%s', pwd, "Data", Experiment_specification.filename);
    Experiment_specification.Kd1=10*10^-9;
    Experiment_specification.Kd1_list=[10^-9*exp(log(10))];


    Experiment_specification.Kd2_list=exp(log(10)*(-5+linspace(-3,3,40)));

% To change
    Experiment_specification.pA=10^-9; % antibody concentration

% To change
    Experiment_specification.type="cubicSphere2D"%["hexagonalSphere2D", "triangularSphere2D","cubicSphere2D"]
% To change 
    Experiment_specification.WperT=2; % number of Weak-binding tether per an antigen
    Experiment_specification.Wlen=1; % length of weak teather, in relative scale

% To change 
    Experiment_specification.isSC=0; % set 1 for considering self-cohesion, 0 for not considering

    Experiment_specification.L=30; % total area of the surface
    Experiment_specification.Tnum=384;
    Experiment_specification.D_Linker_list=7.0;  %nm
    Experiment_specification.D_BS_list=D_BS; %nm
    Experiment_specification.disres=2; %when > 1, it is just no res
    Experiment_specification.Amplification = Distance_Kd_map_uniform(Experiment_specification.D_BS_list,Experiment_specification.D_Linker_list,0.2);
    Experiment_specification.MCMC_steps=5; %% Number of MCMC steps, typically set >5.
    
    Experiment_specification.parametertype=["Kd2_list"];
    Experiment_specification.parameterlist1=Experiment_specification.Kd2_list;
    %Experiment_specification.parameterlist2=Experiment_specification.type_List;
    %Experiment_specification.IDX = fullfact([length(Experiment_specification.parameterlist1) length(Experiment_specification.parameterlist2) length(Experiment_specification.parameterlist3)]);
    Experiment_specification.IDX = fullfact([length(Experiment_specification.parameterlist1)]) 
    
    %% Setting MCMC step Parameters
    Experiment_specification.repNum=4*2^10;

    if ~isfolder(Experiment_specification.foldername)
        mkdir(Experiment_specification.foldername)
        save(strcat(Experiment_specification.foldername,"/Experiment_specification.mat"),'Experiment_specification');
    end
    
    
    IDX=Experiment_specification.IDX;
    IDX_num=length(IDX);
    Nodes_num=MAX_TASK_ID;%40
    Interval=ceil(IDX_num/Nodes_num);

    if Interval*SLURM_ARRAY_TASK_ID+1>IDX_num
        return ;
    end

    SpecifiedIDX=Interval*SLURM_ARRAY_TASK_ID+1 : min(Interval*SLURM_ARRAY_TASK_ID+Interval,IDX_num);
    % Recieve j from bash
    % parfor idx=79*j+1:79*j+79 -> Akshit
    disp(SpecifiedIDX);
    
    for idx=SpecifiedIDX
        Experiment_Metropolis_structured(idx,Experiment_specification);
    end
end

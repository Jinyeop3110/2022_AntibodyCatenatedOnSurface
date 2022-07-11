function ExperimentSession_structured_0624(SLURM_ARRAY_TASK_ID,MAX_TASK_ID, D_BS)
    rehash toolboxcache
    set(0,'defaultAxesFontSize',20)
    addpath(genpath('Software'))
    Experiment_specification=struct;
    
    Experiment_specification.filename=sprintf('Experiment_0624_Figure6_%s_%s', datestr(now,'mmyyyy'),num2str(D_BS));
    Experiment_specification.foldername=sprintf('%s/%s/%s', pwd, "Data", Experiment_specification.filename);
    Experiment_specification.Kd1=10*10^-9;
    Experiment_specification.Kd1_list=[10^-9*exp(log(10))];


    Experiment_specification.Kd2_list=[10^-8]%exp(log(10)*(-5+linspace(-3,3,40)));

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

%%
function sys=Experiment_Metropolis_random(idx, Experiment_specification)

outputfile=[Experiment_specification.foldername '/Result_' num2str(idx) '.csv'];
fileID = fopen(outputfile,'w');

Experiment_specification.RemainRatio_pA=1;

Kd2_eff=Experiment_specification.parameterlist1(Experiment_specification.IDX(idx,1));
BSdensity=Experiment_specification.parameterlist2(Experiment_specification.IDX(idx,2));
L= Experiment_specification.L(Experiment_specification.IDX(idx,2));

%disp("start simulation for kD2="+ string(kD2))
for ii=1:Experiment_specification.repNum
    if rem(ii,1000)==1
        disp(sprintf('Start_index %s th over %s', int2str(ii), int2str(Experiment_specification.repNum)))
    end
    sys = Init_AT_System_RS(Experiment_specification.type,L,BSdensity, Experiment_specification.WperT);
    disp(sys.Tnum)
    for j=1:Experiment_specification.MCMC_steps
       sys = Metropolis_withW(sys,Experiment_specification.Kd1,Experiment_specification.Amplification*Kd2_eff,Experiment_specification.disres,Experiment_specification.pA);
    end
    fprintf(fileID,'%.3f %.3f\n', CalculateBindingNum(sys), sys.Tnum);
end
fclose(fileID)
end
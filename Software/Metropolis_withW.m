function sys = Metropolis_withW(sys, Kd1, Kd2_eff_list, dis_res, pA)
numIters = 2^10 * numel(sys.Tnum);

maxdisind=size(Kd2_eff_list,2);

p_iter2=2*ceil(size(sys.W_relation,1)/sys.Tnum);
p1=min(pA/Kd1,1);
p2=min(Kd1/pA,1);
for iter1 = 1 : numIters
    % Pick a random target
    Ind = randi(sys.Tnum);
    % convert target
    if sys.T2W(Ind)==0
        if sys.T(Ind)==0
            if rand()<p1;
                sys.T(Ind)=1;
            end
        elseif sys.T(Ind)==1
            if rand()<p2;
                sys.T(Ind)=0;
            end
        end
    end
    
    for iter2 = 1 : p_iter2
        Ind = randi(size(sys.W_relation,1));
        dis=DistanceBtwTwoTargets(sys,sys.W_relation(Ind,1),sys.W_relation(Ind,2));
        disind=floor(dis/dis_res)+1;
        if disind>maxdisind
            continue
        end
        Kd2_eff=Kd2_eff_list(disind);
        p3=min(1/Kd2_eff,1);
        p4=min(Kd2_eff,1);
        if(sys.T(sys.W_relation(Ind,1)) & sys.T(sys.W_relation(Ind,2)))
            if sys.W(Ind)==0
                if rand()<p3 & sys.T2W(sys.W_relation(Ind,1))< sys.WperT & sys.T2W(sys.W_relation(Ind,2))< sys.WperT
                    sys.W(Ind)=1;
                    sys.T2W(sys.W_relation(Ind,1))=sys.T2W(sys.W_relation(Ind,1))+1;
                    sys.T2W(sys.W_relation(Ind,2))=sys.T2W(sys.W_relation(Ind,2))+1;
                end
            elseif sys.W(Ind)==1
                if rand()<p4;
                    sys.W(Ind)=0;
                    sys.T2W(sys.W_relation(Ind,1))=sys.T2W(sys.W_relation(Ind,1))-1;
                    sys.T2W(sys.W_relation(Ind,2))=sys.T2W(sys.W_relation(Ind,2))-1;
                end
            end
        end
    end
end

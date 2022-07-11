%%
%%
function d=Cohesion(Kd2, pA, WperT)
    d=roots([1 -2-Kd2/pA/2/(WperT)^2 1]);
    d=d(2);
end

classdef AT_System
   properties
      type AT_SystemType %2D trigonal, 1D linear, etc..
      Tnum {mustBeNumeric}
      T 
      W
      T_position
      W_relation
      T2W
      WperT
   end
   methods
       function r = CalculateBindingNum(sys)
           r = sum(sys.T);
       end
       function r = CalculateBindingEfficiency(sys)
           r = sum(sys.T)/sys.Tnum;
       end
       
       function r = DistanceBtwTwoTargets(sys,i,j)
           r = sum((sys.T_position.x(i)-sys.T_position.x(j))^2+...
               (sys.T_position.y(i)-sys.T_position.y(j))^2+...
               (sys.T_position.z(i)-sys.T_position.z(j))^2)^0.5;
       end
       
       function r = DistanceBtwTwoTargets_flatRB(sys,i,j,d)
           temp=[]
           x=min([(sys.T_position.x(i)-sys.T_position.x(j))^2,(-d+sys.T_position.x(i)-sys.T_position.x(j))^2,(d+sys.T_position.x(i)-sys.T_position.x(j))^2])
           y=min([(sys.T_position.y(i)-sys.T_position.y(j))^2,(-d+sys.T_position.y(i)-sys.T_position.y(j))^2,(d+sys.T_position.y(i)-sys.T_position.y(j))^2])
           z=min([(sys.T_position.z(i)-sys.T_position.z(j))^2,(-d+sys.T_position.z(i)-sys.T_position.z(j))^2,(d+sys.T_position.z(i)-sys.T_position.z(j))^2])
           r = (x+y+z)^0.5
       end
       
       function sys = Reinitialize(sys)
           p=0.5;
           sys.T=(rand(1,sys.Tnum)>p);
           sys.W=zeros(size(sys.W));
           sys.WperT=sys.WperT;
       end
       
       function r= Visualize(sys)
           figure()
           colorindex=(sys.T'*[0,0,1]+(1-sys.T')*[0.7,0.7,0.7]);
           scatter3(sys.T_position.x,sys.T_position.y,sys.T_position.z,10,colorindex,'filled');
           hold on;
           wlist=find(sys.W==1);
           if ~isempty(wlist)
               for i=1:size(wlist,2)
                   x=[sys.T_position.x(sys.W_relation(wlist(i),1)),sys.T_position.x(sys.W_relation(wlist(i),2))];
                   y=[sys.T_position.y(sys.W_relation(wlist(i),1)),sys.T_position.y(sys.W_relation(wlist(i),2))];
                   z=[sys.T_position.z(sys.W_relation(wlist(i),1)),sys.T_position.z(sys.W_relation(wlist(i),2))];
                   line(x,y,z);
                   hold on;
               end
           end
           
           
       end
      

   end
end

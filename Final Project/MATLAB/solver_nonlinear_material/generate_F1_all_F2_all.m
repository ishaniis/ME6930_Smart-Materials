function [F1_all, F2_all] = generate_F1_all_F2_all(epsilon1,epsilon2,ne)

F1=[1 epsilon1; 0 1]; F2=[1 epsilon2; 0 1]; 
%F1=[1+epsilon epsilon; 0 1]; F2=[1-epsilon -epsilon; 0 1]; 

F1_all=repmat(F1,[1 1 ne]); 
F2_all=repmat(F2,[1 1 ne]);

end


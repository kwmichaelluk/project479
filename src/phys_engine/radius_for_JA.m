function [JA_BL,JA_TR] = radius_for_JA(nb,r_vec)

%rr = [1;2;3;4;5;6];
r_BL = triu(repmat(r_vec,1,nb),1)';
r_BL = r_BL(:);
r_BL_i = r_BL ~= 0;
r_BL = r_BL(r_BL_i);
r_BL2 = repmat(r_BL,1,3)';
JA_BL = r_BL2(:);

r_TR = tril(repmat(r_vec,1,nb),-1);
r_TR = r_TR(:);
r_TR_i = r_TR ~= 0;
r_TR = r_TR(r_TR_i);
r_TR2 = repmat(r_TR,1,3)';
JA_TR = r_TR2(:);
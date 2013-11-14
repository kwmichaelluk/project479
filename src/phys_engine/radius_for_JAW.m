function [JAW_BL] = radius_for_JAW(nw,r_vec)

%r_vec = [1;2;3];
%nw = 6;

r_BL = (repmat(r_vec,1,nw*3))';
JAW_BL = r_BL(:);
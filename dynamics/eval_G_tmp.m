function G = eval_G_tmp(g,l1,l2,l3,m1,m2,m3,q1,q2,q3)
%EVAL_G_TMP
%    G = EVAL_G_TMP(G,L1,L2,L3,M1,M2,M3,Q1,Q2,Q3)

%    This function was generated by the Symbolic Math Toolbox version 8.1.
%    16-Oct-2018 12:38:07

G = [g.*l1.*sin(q1).*(m1+m2.*2.0+m3.*2.0).*(-1.0./2.0);g.*l2.*m2.*sin(q2).*(-1.0./2.0);g.*l3.*m3.*sin(q3).*(-1.0./2.0)];
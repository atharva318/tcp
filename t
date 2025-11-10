//Error and Corrected error:-
clear;
clc;
dmin = 5
s=dmin-1;
printf("i)Number of detected errors \n\n \t s<=%d ",s);
t=(dmin-1)/2;
printf("\n\n ii)Number of corrected errors \n\n \t t<=%d",t);

//information Theory:-
clear;
clc;
B = 3.4*10^3;
SNR = 30
SN = 10^(SNR/10);
C = B*log2(1+SN)
printf("Information capacity of telephone is \n\n \tC = %2fkbps",C/1000);

//Source entropy and information rate:-
clear;
clc;
px1 = 1/2;
px2 = 1/4;
px3 = 1/8;
px4 = 1/16;
px5 = 1/16;
Tb = 10^-3;
HX = px1*log2(1/px1)+px2*log2(1/px2)+px3*log2(1/px3)+px4*log2(1/px4)+px5*log2(1/px5);
printf("i)source entropy \n\n \tH(X) = %2f bits/symbol\n",HX);
r = 1/Tb;
R=r*HX;
printf("\n\n ii)information rate \n\n \t R = %d bits/sec",R);

//Error Coding:-
clear;
clc;
D=poly(0,'D');
g1D = 1+D+D^2;
g2D = 1+D^2;
mD = 1+0+0+D^3+D^4;
x1D = g1D*mD;
x2D = g2D*mD;
x1 = coeff(x1D);
x2 = coeff(x2D);
disp(modulo(x1,2),'Top Output Sequence')
disp(modulo(x2,2),'Bottom Output Sequence')

//Probability of error:-
clear;
clc;
p=0.1
P_undeterr1 = 6*(p^2)*((1-p)^2)+(p^4)
disp('Probability of error in detection for p = 0.1 is'+string(P_undeterr1))
p=0.01
P_undeterr2 = 6*(p^2)*((1-p)^2)+(p^4)
disp('Probability of error in detection for p = 0.01 is '+string(P_undeterr2))

//Efficicency and redundancy:-
clear;
clc;
pa1 = 0.81;
pa2 = 0.09;
pa3 = 0.09;
pa4 = 0.01;
n1 = 1;
n2 = 2;
n3 = 3;
n4 = 3;
L = pa1*n1+pa2*n2+pa3*n3+pa4*n4;
HX2=pa1*log2(1/pa1)+pa2*log2(1/pa2)+pa3*log2(1/pa3)+pa4*log2(1/pa4);
n=HX2/L;
printf("\n\ncode efficiency = %2f ",n*100);
disp("    %");
r=(1-n);
printf("\n\n\tcode redundancy = %1f", r*100);
disp("   %");





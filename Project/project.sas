
DATA one;
input TEL TEW TSL TSW CLL CLW CBL CBW VOLT;
* Data extracted from Saleem & Soma(2015);
lines; 
1 1 1 1 1 1 1 1 18.5
-1 1 -1 1 1 1 -1 -1 48
-1 -1 1 -1 1 1 1 -1 32
1 -1 -1 1 -1 1 1 1 36
-1 1 -1 -1 1 -1 1 1 32.8
-1 -1 1 -1 -1 1 -1 1 38.4
-1 -1 -1 1 -1 -1 1 -1 57.8
1 -1 -1 -1 1 -1 -1 1 22.5
1 1 -1 -1 -1 1 -1 -1 23.2
1 1 1 -1 -1 -1 1 -1 15.4
-1 1 1 1 -1 -1 -1 1 31.8
1 -1 1 1 1 -1 -1 -1 21
;
Proc glm;
class TEL TEW TSL TSW CLL CLW CBL CBW;
model VOLT=TEL TEW TSL TSW CLL CLW CBL CBW;
Estimate 'TEL' TEL -1 1;
Estimate 'TEW' TEW -1 1;
Estimate 'TSL' TSL -1 1;
Estimate 'TSW' TSW -1 1;
Estimate 'CLL' CLL -1 1;
Estimate 'CLW' CLW -1 1;
Estimate 'CBL' CBL -1 1;
Estimate 'CBW' CBW -1 1;
run;

DATA two;
input effect;
lines;
-17.3666667
-6.3333333
-10.5333333
8.1333333
-4.6333333
2.4666667
1.2666667
-2.9000000
;
*normal probability plot for the effects;
proc rank data=two normal=blom;
ranks neffect;
var effect;
proc gplot;
plot neffect*effect;
run;

*Half normal probability plot;
DATA three;
input effect;
abseffect=abs(effect);
datalines;
-17.3666667
-6.3333333
-10.5333333
8.1333333
-4.6333333
2.4666667
1.2666667
-2.9000000
;

proc sort data = three;
by abseffect;
proc univariate plot normal;
var abseffect;
proc rank data=three normal=blom;
ranks neffect;
var abseffect;
proc gplot;
plot neffect*abseffect;
run;
*Initial model;
Proc glm data=one;
class TEL TEW TSL TSW;
model VOLT=TEL TEW TSL TSW;
Estimate 'TEL' TEL -1 1;
Estimate 'TEW' TEW -1 1;
Estimate 'TSL' TSL -1 1;
Estimate 'TSW' TSW -1 1;
run;
*Refined model;
Proc glm data=one;
class TEL TSL TSW;
model VOLT=TEL TSL TSW;
Estimate 'TEL' TEL -1 1;
Estimate 'TSL' TSL -1 1;
Estimate 'TSW' TSW -1 1;
output out=new2 p=yhat r=resid;
run;

*Model adequency checking: Refined model;
proc univariate plot normal;
var resid;

proc plot data=new2;
plot resid*yhat;
run;

*main effect plot for TEL; 
Proc sort data=one;
by TEL;
proc means noprint;
var VOLT;
by TEL;
output out=a mean=ybar1;
data new2; set one a;
label ybar1='average VOLT';
proc gplot data=new2;
plot ybar1*TEL='TEL';
*main effect plot for TSL; 
Proc sort data=one;
by TSL;
proc means noprint;
var VOLT;
by TSL;
output out=a mean=ybar1;
data new2; set one a;
label ybar1='average VOLT';
proc gplot data=new2;
plot ybar1*TSL='TSL';
*main effect plot for TSW; 
Proc sort data=one;
by TSW;
proc means noprint;
var VOLT;
by TSW;
output out=a mean=ybar1;
data new2; set one a;
label ybar1='average VOLT';
proc gplot data=new2;
plot ybar1*TSW='TSW';

*regression model;
proc glm data= one;
model VOLT = TEL TSL TSW; 
run;
*contour plot for TEL and TSL;
proc glm data = one;
model VOLT = TEL TSL TEL*TSL;
run;
*contour plot for TSL and TSW;
proc glm data = one;
model VOLT = TSL TSW TSW*TSL;
run;
*contour plot for TEL and TSW;
proc glm data = one;
model VOLT = TEL TSW TEL*TSW;
run;
*Response surface of TEL & TSL;
data one;
do TEL= -1 to 1 by 0.1;
do TSL= -1 to 1 by 0.1;
VOLT= 31.45-8.68333*TEL - 5.266667*TSL;
output;
end;
end;

proc g3d;
plot TEL*TSL=VOLT;
run;
*Response surface of TSL & TSW;
data one;
do TSL= -1 to 1 by 0.1;
do TSW= -1 to 1 by 0.1;
VOLT = 31.45- 5.266667*TSL+4.066667*TSW;
output;
end;
end;

proc g3d;
plot TSL*TSW=VOLT;
run;

*Response surface of TEL & TSW;
data one;
do TEL= -1 to 1 by 0.1;
do TSW= -1 to 1 by 0.1;
VOLT= 31.45-8.68333*TEL+4.066667*TSW;
output;
end;
end;

proc g3d;
plot TEL*TSW=VOLT;
run;
*95% CI and PI for each cases;
proc reg data=one;
	model VOLT = TEL TSL TSW/cli clm;
	id TEL TSL TSW;
run;

*Response Surface Method: Box-Benken Design;

DATA FINAL;
INPUT ORDER TEL TEW TSL TSW VOLT;
DATALINES;
1 0 +1 +1 0 19.5
2 +1 0 0 -1 16.4
3 +1 0 +1 0 16.8
4 0 -1 -1 0 35.6
5 0 +1 -1 0 29.4
6 -1 0 0 +1 38.5
7 0 0 +1 -1 18.4
8 -1 -1 0 0 38.4
9 0 0 +1 +1 24
10 0 +1 0 +1 27.8
11 0 -1 0 +1 34
12 -1 0 -1 0 44
13 +1 0 0 +1 22.2
14 0 0 0 0 27.2
15 0 -1 0 -1 24
16 +1 0 -1 0 24.8
17 +1 -1 0 0 21.5
18 -1 0 0 -1 29
19 -1 0 +1 0 28.8
20 0 +1 0 -1 19.4
21 0 0 0 0 27.2
22 0 -1 +1 0 24
23 +1 +1 0 0 17.6
24 0 0 0 0 27.2
25 -1 +1 0 0 31.2
26 0 0 -1 +1 36.2
27 0 0 -1 -1 36
;

*fitting second-order model;
PROC GLM data=FINAL;
MODEL VOLT=TEL TSL TSW TEL*TEL TSL*TSL TSW*TSW TEL*TSL TSL*TSW TEL*TSW;
RUN;


*contour plots for TEL and TSL;
data FIVE; set FINAL;
do TEL= -2 to 2 by 0.05;
do TSL= -2 to 2 by 0.05;
VOLT=26.581481-7.550000*TEL-6.208333*TSL +0.386111*TEL*TEL+1.423611*TSL*TSL+1.800000*TSL*TEL;
output;
end;
end;

proc gcontour;
TITLE'CONTOUR PLOT of TEL & TSL';
label VOLT='Estimated Response Function';
plot TEL*TSL=VOLT;
RUN;

*contour plots for TSL and TSW;
data SIX; set FINAL;
do TSL= -3 to 3 by 0.05;
do TSW= -3 to 3 by 0.05;
VOLT=26.581481-6.208333*TSL+3.291667*TSW+1.423611*TSL*TSL-0.026389 *TSW*TSW+1.350000*TSL*TSW;
output;
end;
end;

proc gcontour;
TITLE'CONTOUR PLOT of TSL & TSW';
label VOLT='Estimated Response Function';
plot TSL*TSW=VOLT;
RUN;
*contour plots for TEL and TSW;
data SEVEN; set FINAL;
do TEL= -2 to 2 by 0.05;
do TSL= -2 to 2 by 0.05;
VOLT=26.581481-7.550000*TEL+3.291667*TSW+ +0.386111*TEL*TEL-0.026389 *TSW*TSW-0.925000*TSW*TEL;
output;
end;
end;

proc gcontour;
TITLE'CONTOUR PLOT of TEL & TSW';
label VOLT='Estimated Response Function';
plot TEL*TSW=VOLT;
RUN;

PROC RSREG DATA=FINAL;
MODEL VOLT=TEL TSL TSW/lackfit;
RUN;

*Response Surface;

proc rsreg data=FINAL;
   model VOLT = TEL TSL TSW / lackfit;
run;
ods graphics on;
*response surface for TEL & TSL;
proc rsreg data=FINAL 
           plots(only unpack)=surface(3d);
   model VOLT = TEL TSL TSW;
   ods select 'TEL * TSL = Pred';
run;
ods graphics off;

ods graphics on;
*response surface for TSL & TSW;
proc rsreg data=FINAL 
           plots(only unpack)=surface(3d);
   model VOLT = TEL TSL TSW;
   ods select 'TSL * TSW = Pred';
run;
ods graphics off; 

ods graphics on;
*response surface for TEL & TSW;
proc rsreg data=FINAL
           plots(only unpack)=surface(3d);
   model VOLT = TEL TSL TSW;
   ods select 'TEL * TSW = Pred';
run;
ods graphics off; 

 


libname xptadam xport "&fpath.\data\adam\xpt\adtte.xpt";

proc copy inlib=xptadam outlib=work;
run;

proc format;
	value $_trt 
		'0'='Placebo'
		'54'='Drug A'
		'81'='Drug B';
run;


ods graphics on;
ods output survivalplot=surv1;
proc lifetest data=adtte plots=survival(atrisk=0 to 200 by 20);
	time aval*cnsr(1);
	strata trtan;
run;
ods graphics off;


proc datasets noprint;
	modify surv1;
	format stratum $_trt.;
	label time='Study day';
quit;

ods listing style=htmlblue image_dpi=300 gpath="&fpath.\output"; 

ods graphics / reset width=8in height=6in imagename='kmplot01';

title 'KM Plot 1';
proc sgplot data=surv1;
	step x=time y=survival / group=stratum lineattrs=(pattern=solid) name='s';
	scatter x=time y=censored / markerattrs=(symbol=plus) name='c';
	scatter x=time y=censored / markerattrs=(symbol=plus) group=stratum;
	xaxistable atrisk / x=tatrisk location=inside class=stratum colorgroup=stratum 
		separator valueattrs=(size=7 weight=bold) labelattrs=(size=8);
	xaxis values=(0 to 200 by 20) ;
	keylegend 'c' / location=inside position=topright;
	keylegend 's';
run;

ods graphics off;


(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



BeginPackage[$CommonPackage];


LFun::usage="LFun[\!\(\*
StyleBox[\"f\",\nFontSlant->\"Italic\"]\),d,n] constructs an \!\(\*
StyleBox[\"n\",\nFontSlant->\"Italic\"]\)-th order Laurent approximation of \!\(\*
StyleBox[\"f\",\nFontSlant->\"Italic\"]\) over the domain d, which is either a Circle or the real line Line[{-\[Infinity],\[Infinity]}]\!\(\*
StyleBox[\".\",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"  \",\nFontSlant->\"Italic\"]\)If f is a constructed LFun, then\!\(\*
StyleBox[\" \",\nFontSlant->\"Italic\"]\)\!\(\*
StyleBox[\"f\",\nFontSlant->\"Italic\"]\)[x] evaluates the approximation at the point x. Operations that can be applied to an LFun include standard mathematical functions (Abs,Sin,Exp,etc.) and operators Integrate (returning the indefinite integral) and Derivative[k].";

Options[LFun]:={InterpolationPrecision->$MachineTolerance};


Ellipse::usage=
"Ellipse[{a_,b_},r] represents the Bernstein ellipse arond the interval (a,b).";



LaurentCoefficients::usage="Gives the Laurent coefficients of an LFun over a circle.";
TaylorCoefficients;

Centre::usage=
"Centre is a possible parameter for Line used in determining the conformal map.";


ComplexMapToCircle::usage=
"MapToInterval[d,x] maps the point x via the conformal map that maps the domain d to the unit interval. If d is an IFun, then it is equivalent to MapToInterval[Domain[d],x].";

UnitCircle::usage=
"The unit circle Circle[0.,1.].";

ToUnitCircle::usage=
"ToUnitCircle[lfun] maps lfun to an LFun defined over the unit circle.";


CircleDomainQ::usage=
"Test whether something is a domain mapped from the unit circle.";


ZeroAtInfinityLFun::usage="Constructs a LFun with the default value of zero at infinity";

FFTPlot::usage="LogPlots the norm of the Fourier coefficients of an LFun";


LeftEvenPoints::usage="Evenly spaced points on the unit interval.";
NLeftEvenPoints;
FFT::usage=
"Returns a ShiftList of Laurent coefficients of a LFun or its value list.";
InverseFFT::usage=
"Returns values that a ShiftList of Laurent coefficients would take on the unit circle.";

Begin["Private`"];


LeftEvenPoints[n_]:=Range[-1,(n-1)/n,2/n];
LeftEvenPoints[n_,a_,b_]:=a+(b-a)(1+ LeftEvenPoints[n])/2;
NLeftEvenPoints[v__]:=N[LeftEvenPoints[v]];
FFT[f:{__?ScalarQ}]:=Module[{c,cc,n,scale,k},
n=Length[f];
scale=First[Fourier[(1&)/@LeftEvenPoints[n]]];
cc=-Reverse[AlternatingVector[n]]/scale (f//Fourier);
c[0]=(-1)^n cc[[1]];
c[k_]/;k<0:=(-1)^n cc[[1-k]];
c[k_]/;k>0:=cc[[-k]];

If[EvenQ[n],
	ShiftList[Table[c[k],{k,-n/2,-1}],Table[c[k],{k,0,n/2-1}]],
	ShiftList[Table[c[k],{k,-(n-1)/2,-1}],Table[c[k],{k,0,(n-1)/2}]]]
];
InverseFFT[c:ShiftList[{__?ScalarQ},_]]:=Module[{scale,cc,cf,j,n},
n=Length[c];
scale=First[Fourier[(1&)/@LeftEvenPoints[n]]];

-Reverse[AlternatingVector[n]]scale If[EvenQ[n],
	RotateLeft[c//ToList//Reverse,(n-2)/2],
	RotateLeft[ShiftList[(-1)^n OneVector[(n-1)/2],Join[{(-1)^n},OneVector[(n-1)/2]]]c//ToList//Reverse,(n-1)/2]
]
//InverseFourier];

FFT[f:{__?ArrayQ}]:=Map[FFT,ToArrayOfLists[f],{-2}]//ToShiftListOfArrays;
InverseFFT[sl:ShiftList[{__?ArrayQ},_]]:=ArrayMap[InverseFFT,ToArrayOfShiftLists[sl]]//ToListOfArrays;
End[];





CircleToPeriodicInterval;
RealLineToPeriodicInterval;
PeriodicIntervalToRealLine;

MakeFFTIndexRange;

UnitCircleFunQ::usage="Tests whether an object is an LFun whose domain is the unit circle.";

MapToCircle::usage="MapToCircle[d,z] maps z via the conformal map from the domain d to the unit circle.";
MapFromCircle::usage="MapToCircle[d,z] maps z via the conformal map from the unit circle to the domain d.";
MapToCircleD::usage="MapToCircleD[d,z] is the derivative of MapToCircle[d,z].";
MapFromCircleD::usage="MapFromCircleD[d,z] is the derivative of MapFromCircle[d,z].";



RealLine::usage="The real line Line[{-\[Infinity],\[Infinity]}]";
Orientation;

Begin["Private`"];


CircleToPeriodicInterval[z_]:=-I Log[z];
RealLineToPeriodicInterval[x_]:=CircleToPeriodicInterval[RealLineToCircle[x]];
PeriodicIntervalToRealLine[t_]:=CircleToRealLine[Exp[I t]];
IntervalToPositivePeriodicInterval[x_]:=ArcCos[x];
IntervalToNegativePeriodicInterval[x_]:=-ArcCos[x];



CircleDomainQ[_]:=False;
DomainMemberQ[d_?CircleDomainQ,x_]:=Abs[Abs[MapToCircle[d,x]]-1]<=10 $MachineTolerance;
DomainQ[d_?CircleDomainQ]:=True;


UnitCircle=Circle[0,1];
UnitCircleFunQ[f_LFun]:=N[Domain[f]]==N[UnitCircle];
UnitCircleFunQ[_]:=False;

CircleDomainQ[_Circle]:=True;


SetAttributes[ComplexMapToCircle,Listable];
SetAttributes[MapToCircle,Listable];
SetAttributes[MapFromCircle,Listable];

MapToCircle[Circle[a_,r_],z_]:=(z-a)/r;
MapFromCircle[Circle[a_,r_],z_]:=r z+a;
MapToCircleD[Circle[a_,r_],z_]:=1/r;
MapFromCircleD[Circle[a_,r_],z_]:=r ;

MapToCircle[Circle[a_,r_,Orientation->1],z_]:=(z-a)/r;
MapFromCircle[Circle[a_,r_,Orientation->1],z_]:=r z+a;
MapToCircleD[Circle[a_,r_,Orientation->1],z_]:=1/r;
MapFromCircleD[Circle[a_,r_,Orientation->1],z_]:=r ;

MapToCircle[Circle[a_,r_,Orientation->-1],z_]:=r/(z-a);
MapFromCircle[Circle[a_,r_,Orientation->-1],z_]:=r/ z+a;
MapToCircleD[Circle[a_,r_,Orientation->-1],z_]:=-r/(z-a)^2;
MapFromCircleD[Circle[a_,r_,Orientation->-1],z_]:=-r /z^2;



RealLine=Line[{-\[Infinity],\[Infinity]}];

CircleDomainQ[RealLine]:=True;
IntervalDomainQ[RealLine]:=False;

MapFromCircle[RealLine,_?(#~NEqual~-1.&)]:=\[Infinity];
MapFromCircle[RealLine,z_]:=(-I z +I)/(z +1);
MapToCircle[RealLine,_?InfinityQ]:=-1.;
MapToCircle[RealLine,_?(#~NEqual~(-I)&)]:=\[Infinity];
MapToCircle[RealLine,t_]:=(I-t)/(I+t);

MapFromCircleD[RealLine,z_]:=-((2 I)/(1+z)^2);
MapToCircleD[RealLine,t_]:=-((2 I)/(I+t)^2);


MapFromCircle[Line[{-\[Infinity],\[Infinity]},Stretch->L_],_?(#~NEqual~-1.&)]:=\[Infinity];
MapFromCircle[Line[{-\[Infinity],\[Infinity]},Stretch->L_],z_]:=-((I (-1+z))/(L (1+z)));

MapToCircle[Line[{-\[Infinity],\[Infinity]},Stretch->L_],_?InfinityQ]:=-1.;
MapToCircle[Line[{-\[Infinity],\[Infinity]},Stretch->L_],t_]:=( I-L t)/( I+L t);

MapFromCircleD[Line[{-\[Infinity],\[Infinity]},Stretch->L_],z_]:=-((2 I)/(L (1+z)^2));
MapToCircleD[Line[{-\[Infinity],\[Infinity]},Stretch->L_],t_]:=-((2 I L)/(I+L t)^2);


MapFromCircle[Line[{-\[Infinity],\[Infinity]},Stretch->L_,Centre->a_],_?(#~NEqual~-1.&)]:=\[Infinity];
MapFromCircle[Line[{-\[Infinity],\[Infinity]},Stretch->L_,Centre->a_],z_]:=a-(I (-1+z))/(L (1+z));
MapToCircle[Line[{-\[Infinity],\[Infinity]},Stretch->L_,Centre->a_],_?InfinityQ]:=-1.;
MapToCircle[Line[{-\[Infinity],\[Infinity]},Stretch->L_,Centre->a_],t_]:=( I-L (t-a))/( I+L (t-a));

MapFromCircle[Line[{-\[Infinity] I,\[Infinity] I},Stretch->L_,Centre->a_],_?(#~NEqual~-1.&)]:=\[Infinity];
MapFromCircle[Line[{-\[Infinity] I,\[Infinity] I},Stretch->L_,Centre->a_],z_]:=a-I (I (-1+z))/(L (1+z));
MapToCircle[Line[{-\[Infinity] I,\[Infinity] I},Stretch->L_,Centre->a_],_?InfinityQ]:=-1.;
MapToCircle[Line[{-\[Infinity] I,\[Infinity] I},Stretch->L_,Centre->a_],t_]:=( I+I L (t-a))/( I- I L (t-a));

MapFromCircle[Line[{\[Infinity] I,-\[Infinity] I},Stretch->L_,Centre->a_],_?(#~NEqual~-1.&)]:=\[Infinity];
MapFromCircle[Line[{\[Infinity] I,-\[Infinity] I},Stretch->L_,Centre->a_],z_]:=a-I (I (-1+1/z))/(L (1+1/z));
MapToCircle[Line[{\[Infinity] I,-\[Infinity] I},Stretch->L_,Centre->a_],_?InfinityQ]:=-1.;
MapToCircle[Line[{\[Infinity] I,-\[Infinity] I},Stretch->L_,Centre->a_],t_]:= (I- I L (t-a))/(I+I L (t-a));


PeriodicInterval=Line[{-\[Pi],\[Pi]}];
MapFromCircle[PeriodicInterval,z_]:=CircleToPeriodicInterval[z];
MapToCircle[PeriodicInterval,z_]:=Exp[I z];
MapFromCircleD[PeriodicInterval,z_]:=CircleToPeriodicInterval'[z];
MapToCircleD[PeriodicInterval,z_]:=I Exp[I z];

MapFromCircle[l_Line,z_]:=MapFromInterval[l,MapFromCircle[PeriodicInterval,z]/\[Pi]];
MapToCircle[l_Line,z_]:=MapToCircle[PeriodicInterval,MapToInterval[l,z] \[Pi] ];
MapFromCircleD[l_Line,z_]:=MapFromIntervalD[l,MapFromCircle[PeriodicInterval,z]/\[Pi]] MapFromCircleD[PeriodicInterval,z]/\[Pi];
MapToCircleD[l_Line,z_]:=MapToCircleD[PeriodicInterval,MapToInterval[l,z] \[Pi] ] MapToIntervalD[l,z] \[Pi];


Ellipse[r_]:=Ellipse[{-1,1},r];
CircleDomainQ[_Ellipse]:=True;
IntervalDomainQ[_Ellipse]:=False;


MapFromCircle[Ellipse[{a_,b_},r_],z_]:=MapFromInterval[Line[{a,b}],CircleToInterval[MapFromCircle[Circle[0,r],z]]];
MapToCircle[Ellipse[{a_,b_},r_],z_]:=MapToCircle[Circle[0,r],IntervalToInnerCircle[MapToInterval[Line[{a,b}],z]]];
MapFromCircleD[Ellipse[{a_,b_},r_],z_]:=MapFromIntervalD[Line[{a,b}],CircleToInterval[MapFromCircle[Circle[0,r],z]]]CircleToInterval'[MapFromCircle[Circle[0,r],z]]MapFromCircleD[Circle[0,r],z];
MapToCircleD[Ellipse[{a_,b_},r_],z_]:=MapToCircleD[Circle[0,r],IntervalToInnerCircle[MapToInterval[Line[{a,b}],z]]]IntervalToInnerCircle'[MapToInterval[Line[{a,b}],z]]MapToIntervalD[Line[{a,b}],z];

End[];



Begin["Private`"];



CirclePoints[n_]:=Exp[I \[Pi] LeftEvenPoints[n]];
NCirclePoints[n_]:=CirclePoints[n]//N;

Points[d_?CircleDomainQ,n_]:=MapFromCircle[d,NCirclePoints[n]];

End[];



Begin["Private`"];


DomainPlot[Circle[z0_,r_],opts___]:=
Graphics[{Thick,Blue,PointSize[Large],Arrowheads[Medium],
Arrow[{z0+r Exp[I 0.2] //{Re[#],Im[#]}&,z0 + r Exp[I 0.2001]//{Re[#],Im[#]}&}],
Circle[{Re[#],Im[#]}&[z0],r]},opts,Axes->True];
DomainPlot[Circle[z0_,r_,Orientation->1],opts___]:=
DomainPlot[Circle[z0,r],opts];
DomainPlot[Circle[z0_,r_,Orientation->-1],opts___]:=
Graphics[{Thick,Blue,PointSize[Large],Arrowheads[Medium],
Arrow[{z0 + r Exp[I 0.2001]//{Re[#],Im[#]}&,z0+r Exp[I 0.2] //{Re[#],Im[#]}&}],
Circle[{Re[#],Im[#]}&[z0],r]},opts,Axes->True];


DomainPlot[ell_Ellipse,opts___]:=Module[{t},
Show[ComplexPlot[MapFromCircle[ell,Exp[I t]],{t,-\[Pi],\[Pi]},PlotStyle->Thick],Graphics[{Thick,Blue,PointSize[Large],Arrowheads[Medium],
Arrow[{MapFromCircle[ell,Exp[I 0.2]]//{Re[#],Im[#]}&,MapFromCircle[ell,Exp[I 0.2001]]//{Re[#],Im[#]}&}]},opts,Axes->True]]];


LFun[l_List,d_][z_]:=MapDot[MapToCircle[d,z]^#&,FFT[l]];
LFun[f_,d_,n_]:=LFun[f/@MapFromCircle[d,Points[UnitCircle,n]],d];
LFun[l_ShiftList,d_]:=LFun[l//MakeFFTIndexRange//InverseFFT,d];


LFun[a_]:=LFun[a,UnitCircle];

Values[LFun[l_List,_]]:=l;
Domain[LFun[_,d_]]:=d;

SetupFun[LFun];


FFT[if_LFun]:=if//Values//FFT;

LaurentCoefficients[lf:LFun[_,_Circle]]:=MapOuter[MapToCircleD[lf,0]^#&,FFT[lf]];
TaylorCoefficients[lf_?UnitCircleFunQ]:=lf//FFT//NonNegativeList[#]~Join~((-1)^Length[lf] NegativeList[#])&;


Mean[f_LFun]^:=FFT[f][[0]];

MeanZero[sl_ShiftList]:=sl-sl[[0]] BasisShiftList[sl,0];


ComplexMapToCircle[f_?FunQ,z_]:=ComplexMapToCircle[f//Domain,z];

MapToCircle[f_LFun,z_]:=MapToCircle[f//Domain,z];
MapToCircleD[f_LFun,z_]:=MapToCircleD[f//Domain,z];
MapFromCircle[f_LFun,z_]:=MapFromCircle[f//Domain,z];
MapFromCircleD[f_LFun,z_]:=MapFromCircleD[f//Domain,z];


Points[lf_LFun]:=MapFromCircle[lf//Domain,Points[UnitCircle,lf//Length]];

FinitePoints[if:LFun[_,Line[{-\[Infinity],\[Infinity]},___]]]:=if//Points//Rest;
FinitePoints[if_LFun]:=if//Points;
FiniteValues[if_LFun]:=Last/@Select[Thread[{Points[if],Values[if]}],!InfinityQ[First[#]]&];

FiniteRealPoints[if_LFun]:=if//FinitePoints//Re;

Format[f:LFun[l_List,_]]:=ReImLinePlot[f,Sequence@@$FunFormat];



LFun/:Derivative[0][if_LFun]:=if;
LFun/:Derivative[1][f_LFun]:=
	LFun[PadRight[ShiftLeft[MapOuter[#&,FFT[f]]],Length[f]+2]//InverseFFT,Domain[f]]//# LFun[MapToCircleD[f,#]&,f//Domain,#//Length]&;
LFun/:Derivative[k_?Positive][if_LFun]:=Derivative[1][Derivative[k-1][if]];
LFun/:Derivative[if_LFun]:=if';


DomainIntegrate[if_LFun?(Domain[#][[1]]=={-\[Infinity],\[Infinity]}&)]:=((Values[if] Values[LFun[If[#==-1.,0,MapFromCircleD[if,#]]&,UnitCircle,if//Length]])//FFT)[[-1]] (2 \[Pi]\[NonBreakingSpace]I);
DomainIntegrate[if_LFun]:=((Values[if] Values[LFun[MapFromCircleD[if,#]&,UnitCircle,if//Length]])//FFT)[[-1]] (2 \[Pi]\[NonBreakingSpace]I);


MakeFFTIndexRange[sl_ShiftList]:=SetIndexRange[sl,{-1,1}(IndexRange[sl]//Abs//Max)];

BoundedIntegrate[lf_LFun?UnitCircleFunQ]:=LFun[MapOuter[If[ZeroQ[#],0,1/#]&,lf//FFT//ShiftRight]//MakeFFTIndexRange//InverseFFT,lf//Domain];

BoundedIntegrate[lf_LFun]:=SetDomain[BoundedIntegrate[ToUnitCircle[lf] LFun[\[Piecewise]{
 {0, InfinityQ[MapFromCircle[lf,#]]},
 {MapFromCircleD[lf,#], True}
}&,UnitCircle,lf//Length]],lf//Domain];

Integrate[lf_LFun,z_]^:=BoundedIntegrate[lf][z]+DomainIntegrate[lf](Log[MapToCircle[lf,z]]/(2 \[Pi]\[NonBreakingSpace]I) -\!\(\*
TagBox[GridBox[{
{"\[Piecewise]", GridBox[{
{
RowBox[{
RowBox[{"-", "1"}], "/", "2"}], 
RowBox[{
RowBox[{"MapToCircle", "[", 
RowBox[{"lf", ",", "\[Infinity]"}], "]"}], "~", "NEqual", "~", 
RowBox[{"-", "1"}]}]},
{
RowBox[{
RowBox[{"Log", "[", 
RowBox[{"MapToCircle", "[", 
RowBox[{"lf", ",", "\[Infinity]"}], "]"}], "]"}], "/", 
RowBox[{"(", 
RowBox[{"2", " ", "\[Pi]", "\[NonBreakingSpace]", "I"}], ")"}]}], "True"}
},
AllowedDimensions->{2, Automatic},
Editable->True,
GridBoxAlignment->{"Columns" -> {{Left}}, "ColumnsIndexed" -> {}, "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
GridBoxItemSize->{"Columns" -> {{Automatic}}, "ColumnsIndexed" -> {}, "Rows" -> {{1.}}, "RowsIndexed" -> {}},
GridBoxSpacings->{"Columns" -> {Offset[0.27999999999999997`], {Offset[0.84]}, Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {Offset[0.2], {Offset[0.4]}, Offset[0.2]}, "RowsIndexed" -> {}},
Selectable->True]}
},
GridBoxAlignment->{"Columns" -> {{Left}}, "ColumnsIndexed" -> {}, "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
GridBoxItemSize->{"Columns" -> {{Automatic}}, "ColumnsIndexed" -> {}, "Rows" -> {{1.}}, "RowsIndexed" -> {}},
GridBoxSpacings->{"Columns" -> {Offset[0.27999999999999997`], {Offset[0.35]}, Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {Offset[0.2], {Offset[0.4]}, Offset[0.2]}, "RowsIndexed" -> {}}],
"Piecewise",
DeleteWithContents->True,
Editable->False,
SelectWithContents->True,
Selectable->False]\));

End[];


NegativePart;
NonNegativePart;
PositivePart;
NonPositivePart;

NonNegativeEvaluate;
NegativeEvaluate;
PositiveEvaluate;
NonPositiveEvaluate;

Begin["Private`"];

NegativePart[lf_LFun]:=LFun[lf//FFT//NegativeShiftList//InverseFFT,lf//Domain];
NonNegativePart[lf_LFun]:=LFun[lf//FFT//NonNegativeShiftList//InverseFFT,lf//Domain];
PositivePart[lf_LFun]:=LFun[lf//FFT//PositiveShiftList//InverseFFT,lf//Domain];
NonPositivePart[lf_LFun]:=LFun[lf//FFT//NonPositiveShiftList//InverseFFT,lf//Domain];

NonNegativeEvaluate[f_LFun,z_]/;NZeroQ[MapToCircle[f,z]]:=(f//FFT)[[0]];
NonNegativeEvaluate[f_LFun,z_]:=MapDot[MapToCircle[f,z]^#&,f//FFT//NonNegativeShiftList];
NegativeEvaluate[f_LFun,z_]/;InfinityQ[MapToCircle[f,z]]:=0 First[Values[f]];
NegativeEvaluate[f_LFun,z_]:=MapDot[MapToCircle[f,z]^#&,f//FFT//NegativeShiftList];
PositiveEvaluate[f_LFun,z_]:=MapDot[MapToCircle[f,z]^#&,f//FFT//PositiveShiftList];
PositiveEvaluate[f_LFun,z_]/;NZeroQ[MapToCircle[f,z]]:=0 First[Values[f]];
NonPositiveEvaluate[f_LFun,z_]:=MapDot[MapToCircle[f,z]^#&,f//FFT//NonPositiveShiftList];
NonPositiveEvaluate[f_LFun,z_]/;InfinityQ[MapToCircle[f,z]]:=(f//FFT)[[0]];
End[];


SetLength;


Begin["Private`"];


SetLength[if_LFun,n_?OddQ]:=LFun[SetIndexRange[if//FFT,{(1-n)/2,(n-1)/2}]//InverseFFT,if//Domain];
SetLength[if_LFun,n_?EvenQ]:=LFun[SetIndexRange[if//FFT,{-(n/2),n/2-1}]//InverseFFT,if//Domain];




LFun[f_IFun]:=LFun[Join[Values[f],Reverse[Values[f]][[2;;-2]]],UnitCircle];

ToUnitCircle[lf_LFun]:=SetDomain[lf,UnitCircle];



Reverse[lf:LFun[_,Line[{-\[Infinity],\[Infinity]},___]]]^:=LFun[{Values[lf][[1]]}~Join~(lf//Values//Rest//Reverse),lf//Domain]



ChopDrop[cf_LFun,prec_]:=LFun[ChopDrop[cf//FFT,prec]//Which[Length[#]==0,ShiftList[{0,0,0},2],IndexRange[#]=={0,0}, ShiftList[{0 #[[0]],#[[0]],0 #[[0]]},2],True,#]&//SetIndexRange[#,{-Max[Abs[IndexRange[#]]],Max[Abs[IndexRange[#]]]}]&//InverseFFT,cf//Domain];
ChopDrop[cf_LFun]:=LFun[ChopDrop[cf//FFT]//Which[Length[#]==0,ShiftList[{0,0,0},2],IndexRange[#]=={0,0}, ShiftList[{0 #[[0]],#[[0]],0 #[[0]]},2],True,#]&//SetIndexRange[#,{-Max[Abs[IndexRange[#]]],Max[Abs[IndexRange[#]]]}]&//InverseFFT,cf//Domain];




Options[AdaptiveLFun]:={InterpolationPrecision->$MachineTolerance};
AdaptiveLFun[m_Integer,f_,d_,pars:OptionsPattern[]]:=Module[{prec},
prec=InterpolationPrecision/.{pars}/.Options[AdaptiveLFun];
LFun[f,
d,Length[ChopDrop[LFun[f,d,m]//If[(ToList[FFT[#]][[{1,2,-1,-2}]]//Flatten//Abs//Max)<prec,#,AdaptiveLFun[2m,f,d,pars]]&,prec]]]
];


LFun[f_?NotListOrPatternQ,d_,opts:OptionsPattern[]]:=AdaptiveLFun[8,f,d,opts];



End[];



Begin["Private`"];


FromValueList[f_LFun?ScalarFunQ,ls_]:=ZeroAtInfinityLFun[ls,Domain[f]];
FromValueList[f_LFun?MatrixFunQ,ls_]:=MatrixMap[ZeroAtInfinityLFun[#,Domain[f]]&,PartitionList[Partition[ls,FiniteLength[f]],f//Dimensions]]//ToArrayFun;
FromValueList[f_LFun?VectorFunQ,ls_]:=ZeroAtInfinityLFun[#,Domain[f]]&/@Partition[ls,FiniteLength[f]]//ToArrayFun;


End[];





TransformMatrix;
DerivativeMatrix;
IntegrateMatrix;
FiniteTransformMatrix;
BoundedIntegrateMatrix;
ReduceDimensionMatrix;


Begin["Private`"];


FFTTransformMatrix[n_Integer]:=ColumnMap[ToList[FFT[#]]&,IdentityMatrix[n]];

TransformMatrix[_?CircleDomainQ,n_Integer]:=FFTTransformMatrix[n];

FiniteTransformMatrix[RealLine,n_Integer]:=TransformMatrix[RealLine,n][[All,2;;]];


DiagonalMatrix[f_LFun]^:=f//Values//DiagonalMatrix;
IdentityMatrix[f_LFun]^:=f//Length//IdentityMatrix;


BoundedIntegrateMatrix[lf_LFun?UnitCircleFunQ]:=Module[{T,IM,i,n},
n=lf//Length;
T=TransformMatrix[lf];
IM=SparseArray[{i_,j_}/;j==i-1->If[FirstIndex[FFT[lf]]==1-i,0,1/(i-1+FirstIndex[FFT[lf]])],{n,n}];
Inverse[T].IM.T];
BoundedIntegrateMatrix[lf_LFun]:=BoundedIntegrateMatrix[lf//ToUnitCircle].DiagonalMatrix[LFun[MapFromCircleD[lf,#]&,UnitCircle,lf//Length]];


ComplexRoots[lf_LFun]:=ComplexRoots[lf//Domain,ChopDrop[lf//FFT,$MachineTolerance]];

ComplexRoots[d_,fft_ShiftList?(Length[#]==1&)]:=
Which[Index[fft]==1,
{},
Index[fft]>1,
\[Infinity],
True,
0
];
ComplexRoots[d_,fft_ShiftList?(Length[#]==2&)]:=Module[{dct},
dct=fft//ToList;
{-(dct[[1]]/dct[[2]])}
];

ComplexRoots[d_,fft_ShiftList]:=Module[{dct},
dct=fft//ToList;
MapFromCircle[d,
Join[Transpose[SparseArray[{i_,j_}/;j==i-1->1,{Length[dct]-1, Length[dct]-2}]],-{Most[dct]}/Last[dct]]//Transpose//Normal//N//Eigenvalues]];

Roots[lf_LFun]^:=Module[{dct},
dct=Chop[lf//FFT,$MachineTolerance]//RemoveZeros//ToList;
MapFromCircle[lf,
Select[Join[Transpose[SparseArray[{i_,j_}/;j==i-1->1,{Length[dct]-1, Length[dct]-2}]],-{Most[dct]}/Last[dct]]//Transpose//Eigenvalues,
Abs[Abs[#]-1]<10.^(-6)&]]];





Fun[f_,d_?CircleDomainQ,opts___]:=LFun[f,d,opts];

ZeroAtInfinityLFun[f_?NotListOrPatternQ,d_,opts___]:=LFun[If[InfinityQ[#],0 f[0.],f[#]/.Underflow[]->0]&,d,opts];
ZeroAtInfinityLFun[f_List,RealLine]:=LFun[Join[{0 f[[1]]},f],RealLine];
ZeroAtInfinityLFun[f_List,d_]:=LFun[f,d];
ZeroAtInfinityFun[f_List,d_?CircleDomainQ]:=ZeroAtInfinityLFun[f,d];



FFTPlot[f_LFun,opts:OptionsPattern[]]:=ListLineLogPlot[Norm/@(f//FFT),opts];



CircleDomainQ[Curve[_LFun]]:=True;





MapFromCircle[Curve[cr_LFun],z_]:=MapDot[z^#&,FFT[cr]];
MapFromCircleD[Curve[cr_LFun],z_]:=MapDot[z^#&,FFT[cr']];
MapToCircle[Curve[cr_],z_?InfinityQ]:=z;
MapFromCircle[Curve[cr_],z_?InfinityQ]:=z;
MapFromCircle[Curve[cr_],z_?ZeroQ]:=0;
MapToCircle[Curve[cr_],z_]:=cr-z//Roots//First;
MapToCircleD[cr:Curve[_],z_]:=1/MapFromCircleD[cr,MapToCircle[cr,z]];
ComplexMapToCircle[Curve[cr_],z_]:=ComplexRoots[UnitCircle,IncreaseIndexRange[RemoveNZeros[FFT[cr]],{0,0}]//#-z  BasisShiftList[#,0]&];




ComplexPlot[cf_LFun,opts:OptionsPattern[]]:=ListLinePlot[{Re[#],Im[#]}&/@cf//Values,opts];


AdaptiveTimes[f_LFun,g_LFun]:=
ChopDrop[LFun[IncreaseIndexRange[f//FFT,g//FFT//IndexRange],f//Domain] LFun[IncreaseIndexRange[g//FFT,f//FFT//IndexRange],g//Domain] ,$MachineTolerance];
AdaptivePlus[f_LFun,g_LFun]:=
ChopDrop[LFun[IncreaseIndexRange[f//FFT,g//FFT//IndexRange],f//Domain] +LFun[IncreaseIndexRange[g//FFT,f//FFT//IndexRange],g//Domain] ,$MachineTolerance];


LFun/:ToeplitzMatrix[lf_LFun,n_Integer]:=ToeplitzMatrix[lf//FFT,n];
ShiftList/:HankelMatrix[sl_ShiftList,n_Integer]:=HankelMatrix[PadRight[PositiveList[sl],n]]//Transpose;
LFun/:HankelMatrix[lf_LFun,n_Integer]:=HankelMatrix[lf//FFT,n];


End[];
EndPackage[];

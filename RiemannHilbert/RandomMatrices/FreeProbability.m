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



BeginPackage["RiemannHilbert`RandomMatrices`",{"RiemannHilbert`","RiemannHilbert`Common`"}];


FreePlus;
FreePlusNewton;
FreeTimes;
FreeCompress;
TTransform;
TTransformInverseFunction;
SlitUpperPlanePoints;
CullPoints;
BoundedCauchyInverseMatrix;


Begin["Private`"];
Stieljes[\[Lambda]_ ArcSin,z_]:=1/(Sqrt[z+\[Lambda]] Sqrt[z-\[Lambda]]);
StieljesInverseFunction[\[Lambda]_ ArcSin,y_]:=Sqrt[1+\[Lambda]^2 y^2]/y;
StieljesInverseFunctionD[\[Lambda]_ ArcSin,y_]:=-(1/(y^2 Sqrt[1+\[Lambda]^2 y^2]));
StieljesInverseFunctionD[2][\[Lambda]_ ArcSin,y_]:=(2 +3 \[Lambda]^2 y^2)/(y^3 (1+\[Lambda]^2 y^2)^(3/2));
SlitPlanePoints[\[Lambda]_ ArcSin,n_]:=SlitPlanePoints[Line[{-\[Lambda],\[Lambda]}],n];
End[];



Begin["Private`"];


EvenEvenDiskPoints[n_]:=Table[Points[Circle[0,r],n],{r,1/(n-1),1.,1/(n-1)}]//Flatten;
EvenHalfChebDiskPoints[n_]:=Points[Circle[0,#],n]&/@Rest[Points[Line[{0,1}],n]]//Flatten//Union;
EvenChebDiskPoints[n_]:=# Exp[I \[Pi] Range[-1.,-1/n,1/n]]&/@Select[Points[Line[{-1,1}],n],!NZeroQ[#]&]//Flatten;

DiskPoints[n_]:=EvenChebDiskPoints[n];

SlitPlanePoints[pf_PFun,n_]:=Domain[pf][[1]]+Join[DiskPoints[n],1/DiskPoints[n]];
SlitPlanePoints[lf_List,n_]:=(SlitPlanePoints[#,n/Length[lf]//Ceiling]&/@lf)//Flatten//Union;
SlitPlanePoints[lf_LFun,n_]:=Select[MapFromCircle[lf,Join[EvenEvenDiskPoints[n+1],1/EvenEvenDiskPoints[n+1]]],FiniteQ];
SlitPlanePoints[if_IFun,n_]:=MapFromInterval[if, DiskPoints[n]//CircleToInterval];
SlitPlanePoints[d_?IntervalDomainQ,n_]:=MapFromInterval[d,DiskPoints[n]//CircleToInterval];
SlitPlanePoints[sf_SingFun,n_]:=SlitPlanePoints[sf//First,n];

SlitUpperPlanePoints[sf_,n_]:=Select[Chop[SlitPlanePoints[sf,n],$MachineTolerance],Im[#]>=0&]


CullPoints[sIpts_,GAB_,xia_,xib_]:=Module[{ret},
(((ret=GAB[#];
If[!NumberQ[ret]||NZeroQ[Im[#]]&&(Re[#]<xia || Re[#]>xib)||!NZeroQ[Im[#]]&&(Sign[Im[#]]==Sign[Im[ret]]),
Null,
{#,ret}])&/@sIpts)/.Null->Sequence[])//Transpose
];
CullPoints[sIpts_,GAB_]:=Module[{ret},
(((ret=GAB[#];
If[Sign[Im[#]]==Sign[Im[ret]]||!NumberQ[ret],Null,{#,ret}])&/@sIpts)/.Null->Sequence[])//Transpose];

CullPoints[sIpts_,GAB_,GABD_]:=Module[{ret},
(((ret=GAB[#];
If[!NumberQ[ret]||NZeroQ[Im[#]]&&(GABD[#]>0)||!NZeroQ[Im[#]]&&(Sign[Im[#]]==Sign[Im[ret]]),Null,{#,ret}])&/@sIpts)/.Null->Sequence[])//If[#=={},{},Transpose[#]]&
];





BoundedCauchyInverseMatrix[{a_,b_},m_,gpts_]:=Table[BoundedCauchyInverseBasis[Line[{a,b}],k,gpts],{k,m}]//Transpose;
FreeInverseStieljes[GAB_,{-\[Infinity],\[Infinity]},m_,sIpts_]:=Module[{ret,sgpts,gpts,AB},
{sgpts,gpts}=CullPoints[sIpts,GAB];
LFun[LeastSquares[-2 \[Pi]\[NonBreakingSpace]I (CauchyBasisS[+1,RealLine,1;;m,#])&/@gpts,sgpts]//ShiftList[Reverse[#//Conjugate],Join[{2 Re[#.AlternatingVector[Length[#]]]},#]]&,RealLine]
];

Bisection::notopp="Input not opposite signs";
Bisection[f_,{a0_,b0_}]:=Module[{a,b,fa,fb,val,c,fc},
a=a0;b=b0;
fa=f[a];
fb=f[b];


Which[Sign[fa]==Sign[fb],
Message[Bisection::notopp],
fa>0&&fb<0,
Bisection[f,{b,a}],
True,
val=fa;
While[Abs[val]>$MachineTolerance&&Abs[a-b]>$MachineTolerance,
c=.5(b+a);
fc=f[c];
If[fc>0,
fb=val=fc;
b=c;,
fa=val=fc;
a=c;
];
];
c
]
];


FreeInverseStieljes[GAB_,GABD_,{oa0_,ob0_},m_,sIpts_]:=Module[{xia,xib,a,b,oa,ob},
oa=oa0+10$MachineTolerance;
ob=ob0-10$MachineTolerance;
{xia,xib}=Which[
Re[GABD[ob]]<0&& Re[GABD[oa]]<0,
{oa,ob},
Re[GABD[ob]]<0,
{Bisection[GABD,{oa,-.001}],ob},
Re[GABD[oa]]<0,
{oa,Bisection[GABD,{.001,ob}]},
True,
{Bisection[GABD,{oa,-.001}],Bisection[GABD,{.001,ob}]}
];

FreeInverseStieljes[GAB,{xia,xib},m,sIpts]
];

FreeInverseStieljesNewton[GAB_,GABD_,GABDD_,m_,sIpts_]:=Module[{xia,xib,a,b},
{xia,xib}={NewtonMethod[GABD,GABDD,-.1],NewtonMethod[GABD,GABDD,.1]};
FreeInverseStieljes[GAB,{xia,xib},m,sIpts]
];


FreeInverseStieljes[GAB_,{xia_,xib_},m_,sIpts_]:=Module[{ret,sgpts,gpts,AB,a,b},
{a,b}=GAB/@{xia,xib}//Re;
{sgpts,gpts}=CullPoints[sIpts,GAB,xia,xib];
AB=SingFun[IFun[RealLeastSquares[BoundedCauchyInverseMatrix[{a,b},m,gpts],sgpts]//InverseDCT,Line[{a,b}]],{0,0}];
-1/(2 \[Pi])HilbertInverse[AB]
]





FreePlus[sfA_,sfB_,m_:80,n_:19]/;Domain[sfA]==RealLine||Domain[sfB]==RealLine:=Quiet[
Module[{GAB,GABD,GABDD,xia,xib,Apts,Bpts,sIptsA,sIptsB,sIpts,sgpts,gpts,ret,AB,a,b},
GAB[y_]:=StieljesInverseFunction[sfA,y]+StieljesInverseFunction[sfB,y]-1/y;

Apts=SlitUpperPlanePoints[sfA,n];
(sIpts=Stieljes[sfA,Apts]);

FreeInverseStieljes[GAB,{-\[Infinity],\[Infinity]},m,sIpts]
],
{First::first,Thread::tdlen}];

FreePlus::onesing="One singular endpoint is not implented yet";
FreePlus[sfA_,sfB_,m_:50,n_:30]:=Quiet[
Module[{GAB,GABD,GABDD,oa0,ob0,Apts,sIpts},
GAB[y_]:=StieljesInverseFunction[sfA,y]+StieljesInverseFunction[sfB,y]-1/y;
GABD[y_]:=StieljesInverseFunctionD[sfA,y]+StieljesInverseFunctionD[sfB,y]+1/y^2//Re;

Apts=SlitUpperPlanePoints[sfA,n];
(sIpts=Stieljes[sfA,Apts]);

ob0=Min[Re[Stieljes[sfA,sfA//RightEndpoint]],Re[Stieljes[sfB,sfB//RightEndpoint]]];

oa0=Max[Re[Stieljes[sfA,sfA//LeftEndpoint]],Re[Stieljes[sfB,sfB//LeftEndpoint]]];

FreeInverseStieljes[GAB,GABD,{oa0,ob0},m,sIpts]
],
{First::first,Thread::tdlen}];


FreePlusNewton[sfA_,sfB_,m_:50,n_:30]:=Quiet[
Module[{GAB,GABD,GABDD,xia,xib,Apts,Bpts,sIptsA,sIptsB,sIpts,sgpts,gpts,ret,AB,a,b},
GAB[y_]:=StieljesInverseFunction[sfA,y]+StieljesInverseFunction[sfB,y]-1/y;
GABD[y_]:=StieljesInverseFunctionD[sfA,y]+StieljesInverseFunctionD[sfB,y]+1/y^2//Re;
GABDD[y_]:=StieljesInverseFunctionD[2][sfA,y]+StieljesInverseFunctionD[2][sfB,y]-2/y^3//Re;

Apts=SlitUpperPlanePoints[sfA,n];
(sIpts=Stieljes[sfA,Apts]);

FreeInverseStieljesNewton[GAB,GABD,GABDD,m,sIpts]
],
{First::first,Thread::tdlen}];



TTransform[if_LFun,z_]:=Stieljes[if ZeroAtInfinityLFun[#&,if//Domain,Length[if]],z];
TTransformInverseFunction[if_LFun,z_]:=StieljesInverseFunction[if ZeroAtInfinityLFun[#&,if//Domain,Length[if]],z];


TTransform[SingFun[if_IFun,{1/2,1/2}],z_]:=Stieljes[SingFun[IncreaseDimension[if] Fun[#&,if//Domain,Length[if]+1],{1/2,1/2}],z];

TTransformInverseFunction[SingFun[if_IFun,{1/2,1/2}],z_]:=StieljesInverseFunction[SingFun[IncreaseDimension[if] Fun[#&,if//Domain,Length[if]+1],{1/2,1/2}],z];

TTransform[if_IFun,z_]:=Stieljes[if ZeroAtInfinityIFun[#&,if//Domain,Length[if]],z];

TTransformInverseFunction[if_IFun,z_]:=StieljesInverseFunction[if ZeroAtInfinityIFun[#&,if//Domain,Length[if]],z];


TTransformInverseFunctionD[SingFun[if_IFun,{1/2,1/2}],z_]:=StieljesInverseFunctionD[SingFun[IncreaseDimension[if] Fun[#&,if//Domain,Length[if]+1],{1/2,1/2}],z];
TTransformInverseFunctionD[j_][SingFun[if_IFun,{1/2,1/2}],z_]:=StieljesInverseFunctionD[j][SingFun[IncreaseDimension[if] Fun[#&,if//Domain,Length[if]+1],{1/2,1/2}],z];

FreeTimes[sfA_,sfB_,m_:50,n_:30]:=Quiet[
Module[{GAB,GABD,GABDD,xia,xib,Apts,Bpts,sIptsA,sIptsB,sIpts,sgpts,gpts,ret,AB,a,b,Sf},
GAB[y_]:=TTransformInverseFunction[sfA,y]TTransformInverseFunction[sfB,y] y/(1+y);
GABD[y_]:=TTransformInverseFunctionD[sfA,y]TTransformInverseFunction[sfB,y] y/(1+y)+TTransformInverseFunction[sfA,y]TTransformInverseFunctionD[sfB,y] y/(1+y)+TTransformInverseFunction[sfA,y]TTransformInverseFunction[sfB,y] 1/(1+y)^2//Re;
GABDD[y_]:=TTransformInverseFunctionD[2][sfA,y]TTransformInverseFunction[sfB,y] y/(1+y)+2TTransformInverseFunctionD[sfA,y]TTransformInverseFunctionD[sfB,y] y/(1+y)+TTransformInverseFunctionD[sfA,y]TTransformInverseFunction[sfB,y] 1/(1+y)^2+TTransformInverseFunction[sfA,y]TTransformInverseFunctionD[2][sfB,y] y/(1+y)+TTransformInverseFunction[sfA,y]TTransformInverseFunctionD[sfB,y] 1/(1+y)^2+TTransformInverseFunctionD[sfA,y]TTransformInverseFunction[sfB,y] 1/(1+y)^2+TTransformInverseFunction[sfA,y]TTransformInverseFunctionD[sfB,y] 1/(1+y)^2+
TTransformInverseFunction[sfA,y]TTransformInverseFunction[sfB,y](-(2/(1+y)^3))//Re;

Apts=SlitUpperPlanePoints[sfA,n];
(sIpts=TTransform[sfA,Apts]);


Sf=FreeInverseStieljesNewton[GAB,GABD,GABDD,m,sIpts];


SingFun[Sf[[1]] //# Fun[1/#&,#//Domain,#//Length]&,{1/2,1/2}]
],
{First::first,Thread::tdlen}];


FreeCompress[sfA_SingFun,\[Alpha]_,m_:31,n_:30]:=Quiet[
Module[{GAB,GABD,GABDD,xia,xib,Apts,Bpts,sIptsA,sIptsB,sIpts,sgpts,gpts,ret,AB,a,b},
GAB[y_]:=StieljesInverseFunction[sfA,\[Alpha] y]+(1-1/\[Alpha] )/y;
GABD[y_]:=\[Alpha] StieljesInverseFunctionD[sfA,\[Alpha] y]-(1-1/\[Alpha] )/y^2//Re;
GABDD[y_]:=\[Alpha]^2 StieljesInverseFunctionD[2][sfA,\[Alpha] y]+2 (1-1/\[Alpha] )/y^3//Re;

Apts=SlitUpperPlanePoints[sfA,n];
(sIpts=Stieljes[sfA,Apts]);


FreeInverseStieljesNewton[GAB,GABD,GABDD,m,sIpts]
],
{First::first,Thread::tdlen}];

FreeCompress[sfA_LFun,\[Alpha]_,rng_:80,n_:10]:=Quiet[
Module[{GAB,GABD,GABDD,xia,xib,Apts,Bpts,sIptsA,sIptsB,sIpts,sgpts,gpts,ret,AB,a,b},
GAB[y_]:=StieljesInverseFunction[sfA,\[Alpha] y]+(1-1/\[Alpha] )/y;

Apts=SlitUpperPlanePoints[sfA,n];


(sIpts=Stieljes[sfA,Apts]);


FreeInverseStieljes[GAB,{-\[Infinity],\[Infinity]},rng,sIpts]
],
{First::first,Thread::tdlen}];


End[];
EndPackage[];

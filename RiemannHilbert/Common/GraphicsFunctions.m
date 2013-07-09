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


ComplexPlot::usage=
"ComplexPlot[f[t],{t,a,b}] plots the trajectory in the complex plane of f from a to b.";
ComplexArrowPlot::usage=
"ComplexArrowPlot[f[t],{t,a,b}] plots the trajectory in the complex plane of f from a to b with an arrow showing flow.";
ComplexPlot3D::usage=
"ComplexPlot3D[f[z],{z,a,b}] plots absolute value, real and imaginary parts in the complex plane in the rectangle defined by {{Re[a],Im[a]}, {Re[b],Im[b]}}";
TablePlot::usage=
"TablePlot[h[k],{k,v}] plots the data points {k,h[k]} for k over range v.";
TableLogPlot::usage=
"TableLogPlot[h[k],{k,v}] plots the data points {k,h[k]} for k over range v with a logarithmic scale.";

ReImTablePlot::usage=
"ReImTablePlot[h[k],{k,v}] plots the real and imaginary points of h[k].";

ReImPlot::usage=
"ReImPlot[h[x],{x,v}] plots the real and imaginary points of h[x].";

DotPlot::usage=
"Plots a list of real points.";
ComplexDotPlot::usage=
"Plots a list of complex points.";
ComplexLinePlot::usage=
"Plots a list of complex points, connected with lines.";

ListLineLogPlot::usage=
"Like LineLogPlot, but with a logarithmic scale";


TablePlot3D::usage=
"TablePlot3D[h[i,k],{i,v1},{k,v2}] plots the data points {i,k,h[i,k]} for i over range v1 and k over range v2.";


DarkYellow=RGBColor[0.6,0.6,0.1];
DarkGreen=RGBColor[0.0,0.6,0.1];
DarkRed=RGBColor[0.8,0.2,0.1];

DefaultFontSize;RomanFont;ItalicFont;


ReImComplexContourPlot;
CirclePlot;
LogPlot3D;
ComplexLogPlot3D;

PseudospectraPlot;
SVDPlot;

Begin["Private`"];
Options[ComplexPlot]=Options[ParametricPlot];
ComplexPlot[hlis_,b_List,opts:OptionsPattern[]]:=Module[{h,hlist},
hlist={hlis}//Flatten;
Map[Function[h,
ParametricPlot[{Re[h],Im[h]},b,opts]],
hlist]//Show
]

ComplexArrowPlot[hlis_,b_,opts___]:=Show[ComplexPlot[hlis,b,opts],Graphics[{Arrowheads[Large],Hue[0.67`,0.6`,0.6`],{hlis/.First[b]->(Last[b]+0.000001 Sign[Second[b]-Last[b]])//{Re[#],Im[#]}&//N,hlis/.First[b]->(Last[b])//{Re[#],Im[#]}&//N}//Arrow}]]

SetAttributes[ReImComplexContourPlot,HoldFirst];

ReImComplexContourPlot[h_,yv_,tv_,opts___]:=Module[{hl},
hl =Hold[ h]/.First[yv]->Last[yv];
ReImPlot[hl//ReleaseHold,tv,opts]];

SetAttributes[CirclePlot,HoldFirst];
CirclePlot[h_,{z_,a_,r_},opts___]:=Module[{h2,t},
h2=Hold[h]/.z->a+r Exp[I t];
ReImPlot[h2//ReleaseHold,{t,-\[Pi],\[Pi]},opts]];
CirclePlot[h_,{z_,r_},opts___]:=CirclePlot[h,{z,0,r},opts];
CirclePlot[h_,z_,opts___]:=CirclePlot[h,{z,1},opts];


Options[ComplexPlot3D]=Options[Plot3D];
ComplexPlot3D[h_,v_,opts:OptionsPattern[]]:=Module[{x,y,h2,xv,yv},
	h2=h/.First[v]->x+I y;
	xv={x,Re[v[[2]]],Re[Last[v]]};
	yv={y,Im[v[[2]]],Im[Last[v]]};

	Plot3D[h2//Abs,Evaluate[xv],Evaluate[yv],PlotLabel->Abs,opts]//Print;
	Plot3D[h2//Re,Evaluate[xv],Evaluate[yv],PlotLabel->Re,opts]//Print;
	Plot3D[h2//Im,Evaluate[xv],Evaluate[yv],PlotLabel->Im,opts]//Print;
];
ReComplexPlot3D[h_,v_,opts___]:=Module[{x,y,h2,xv,yv},
	h2=h/.First[v]->x+I y;
	xv={x,Re[v[[2]]],Re[Last[v]]};
	yv={y,Im[v[[2]]],Im[Last[v]]};

	Plot3D[h2//Re,Evaluate[xv],Evaluate[yv],PlotLabel->Re,opts]//Print;
]


LogPlot3D[h_,opts___]:=Module[{x,y,h2,xv,yv},
Plot3D[h//Log10,opts]
]


ComplexLogPlot3D[h_,v_,opts___]:=Module[{x,y,h2,xv,yv},
	h2=h/.First[v]->x+I y;
	xv={x,Re[v[[2]]],Re[Last[v]]};
	yv={y,Im[v[[2]]],Im[Last[v]]};

	LogPlot3D[h2//Abs,Evaluate[xv],Evaluate[yv],PlotLabel->Abs,opts]//Print;
	LogPlot3D[h2//Re//Abs,Evaluate[xv],Evaluate[yv],PlotLabel->Re,opts]//Print;
	LogPlot3D[h2//Im//Abs,Evaluate[xv],Evaluate[yv],PlotLabel->Im,opts]//Print;
]


AnalyticityPlot[h_,v_,opts___]:=
Module[{f,rf,if,x,y,z,anal1,anal2},
f[x_,y_]:=Assuming[x\[Element]Reals&&y\[Element]Reals,h/.First[v]->x+I y//ExpandAll//Simplify];
anal1[x_,y_]=Re[Derivative[1,0][f][x,y]]-Im[Derivative[0,1][f][x,y]];
anal2[x_,y_]=Im[Derivative[1,0][f][x,y]]+Re[Derivative[0,1][f][x,y]];
Plot3D[anal1[x,y],{x,Re[v[[2]]],Re[Last[v]]},{y,Im[v[[2]]],Im[Last[v]]},opts]//Print;
Plot3D[anal2[x,y],{x,Re[v[[2]]],Re[Last[v]]},{y,Im[v[[2]]],Im[Last[v]]},opts]
]
End[];


ListLineLogLogPlot;
TableLogLogPlot;
ReImLogPlot;
AbsLogPlot;
ReImTableLogPlot;
ReImListLinePlot;
ReImListLinePlot;
ReImListLineLogPlot;

ReImListPlot;
ReImListLogPlot;
ReImListLineLogLogPlot;
ReImListLogLogPlot;

Begin["Private`"];
JoinedPlot=ListLinePlot;
SetAttributes[ListLineLogPlot,HoldFirst];
ListLineLogPlot[h_,opts___]:=ListLogPlot[h,Joined->True,opts];
SetAttributes[ListLineLogLogPlot,HoldFirst];
ListLineLogLogPlot[h_,opts___]:=ListLogLogPlot[h,Joined->True,opts];




ThreadIfList[l:{{_,{_,_}}..}]:=Thread[Thread/@l];
ThreadIfList[l_]:=l;

SetAttributes[TablePlot,HoldFirst];
TablePlot[h_,sp_,opts___]:=ListLinePlot[Table[{First[sp],h},sp]//ThreadIfList,opts];
TablePlot[hl_List,sp_,opts___]:=ListLinePlot[Map[Function[h,Table[{First[sp],ReleaseHold[h]},sp]],Thread[Hold[hl]]],opts];
SetAttributes[TablePlot3D,HoldFirst];
TablePlot3D[h_,sp1_,sp2_,opts___]:=ListPlot3D[Flatten[Table[{First[sp1],First[sp2],h},sp1,sp2],1],opts];

SetAttributes[CArrayPlot,HoldFirst];
CArrayPlot[h_,sp_,opts___]:=ListLinePlot[Array[{#,h[#]}&,sp],opts];


SetAttributes[TableLogPlot,HoldFirst];
TableLogPlot[h_,sp_,opts___]:=
ListLineLogPlot[Table[{First[sp],h},sp],opts];
TableLogPlot[hl_List,sp_,opts___]:=ListLineLogPlot[Map[Function[h,Table[{First[sp],ReleaseHold[h]},sp]],Thread[Hold[hl]]],opts];

SetAttributes[TableLogLogPlot,HoldFirst];
TableLogLogPlot[h_,sp_,opts___]:=
ListLineLogLogPlot[Table[{First[sp],h},sp],opts];
TableLogLogPlot[hl_List,sp_,opts___]:=ListLineLogLogPlot[Map[Function[h,Table[{First[sp],ReleaseHold[h]},sp]],Thread[Hold[hl]]],opts];

SetAttributes[ArrayLogPlot,HoldFirst];
ArrayLogPlot[h_,sp_,opts___]:=ListLineLogPlot[Array[{#,h[#]}&,sp],opts];


SetAttributes[MonitorTable,HoldFirst];
MonitorTable[h_,{k_,i_,n_,sp_},cmd_,opts___]:=Module[{p,foo},
foo[p_]:=foo[p]=Hold[h]/.k->p//ReleaseHold;Monitor[cmd[foo[p],{p,i,n,sp},opts],cmd[foo[k],{k,i,p,sp},opts]]];
MonitorTable[h_,{k_,i_,n_},cmd_,opts___]:=MonitorTable[h,{k,i,n,1},cmd,opts];
MonitorTable[h_,{k_,n_},cmd_,opts___]:=MonitorTable[h,{k,1,n},cmd,opts];

SetAttributes[MonitorTableLogPlot,HoldFirst];
MonitorTableLogPlot[h_,sp_,opts___]:=MonitorTable[h,sp,TableLogPlot];
SetAttributes[MonitorTablePlot,HoldFirst];
MonitorTablePlot[h_,sp_,opts___]:=MonitorTable[h,sp,TablePlot];


SetAttributes[AbsLogPlot,HoldFirst];AbsLogPlot[h_,sp_,opts___]:=LogPlot[{h,-h},sp,opts];
SetAttributes[ReImLogPlot,HoldFirst];ReImLogPlot[h_,sp_,opts___]:=LogPlot[{Re[h],-Re[h],Im[h],-Im[h]},sp,opts];
SetAttributes[ReImPlot,HoldFirst];ReImPlot[h_,sp_,opts___]:=Plot[{Re[h],Im[h]},sp,opts];
SetAttributes[ReImTablePlot,HoldFirst];ReImTablePlot[h_,sp_,opts___]:=TablePlot[{Re[h],Im[h]},sp,opts];
SetAttributes[ReImTableLogPlot,HoldFirst];
ReImTableLogPlot[h_,sp_,opts___]:=TablePlot[{Re[h],-Re[h],Im[h],-Im[h]},sp,opts];
ReImListLinePlot[h_List,opts___]/;Depth[h]>2:=ListLinePlot[Thread[{{#[[1]],Re[#[[2]]]},{#[[1]],Im[#[[2]]]}}&/@h],opts];
ReImListLinePlot[h_List,opts___]:=ListLinePlot[Thread[{Re[#],Im[#]}&/@h],opts];
ReImListLineLogPlot[h_List,opts___]/;Depth[h]>2:=ListLineLogPlot[Thread[{{#[[1]],Max[0,Re[#[[2]]]]},{#[[1]],Max[0,-Re[#[[2]]]]},{#[[1]],Max[0,Im[#[[2]]]]},{#[[1]],Max[0,-Im[#[[2]]]]}}&/@h],opts];
ReImListLineLogPlot[h_List,opts___]:=ListLineLogPlot[Thread[{Max[0,Re[#]],Max[0,-Re[#]],Max[0,Im[#]],Max[0,-Im[#]]}&/@h],opts];

ReImListPlot[h_List,opts___]/;Depth[h]>2:=ListPlot[Thread[{{#[[1]],Re[#[[2]]]},{#[[1]],Im[#[[2]]]}}&/@h],opts];
ReImListPlot[h_List,opts___]:=ListPlot[Thread[{Re[#],Im[#]}&/@h],opts];
ReImListLogPlot[h_List,opts___]/;Depth[h]>2:=ListLogPlot[Thread[{{#[[1]],Max[0,Re[#[[2]]]]},{#[[1]],Max[0,-Re[#[[2]]]]},{#[[1]],Max[0,Im[#[[2]]]]},{#[[1]],Max[0,-Im[#[[2]]]]}}&/@h],opts];
ReImListLogPlot[h_List,opts___]:=ListLogPlot[Thread[{Max[0,Re[#]],Max[0,-Re[#]],Max[0,Im[#]],Max[0,-Im[#]]}&/@h],opts];

ReImListLineLogLogPlot[h_List,opts___]/;Depth[h]>2:=ListLineLogLogPlot[Thread[{{#[[1]],Max[0,Re[#[[2]]]]},{#[[1]],Max[0,-Re[#[[2]]]]},{#[[1]],Max[0,Im[#[[2]]]]},{#[[1]],Max[0,-Im[#[[2]]]]}}&/@h],opts];
ReImListLineLogLogPlot[h_List,opts___]:=ListLineLogLogPlot[Thread[{Max[0,Re[#]],Max[0,-Re[#]],Max[0,Im[#]],Max[0,-Im[#]]}&/@h],opts];

ReImListLogLogPlot[h_List,opts___]/;Depth[h]>2:=ListLogLogPlot[Thread[{{#[[1]],Max[0,Re[#[[2]]]]},{#[[1]],Max[0,-Re[#[[2]]]]},{#[[1]],Max[0,Im[#[[2]]]]},{#[[1]],Max[0,-Im[#[[2]]]]}}&/@h],opts];
ReImListLogLogPlot[h_List,opts___]:=ListLogLogPlot[Thread[{Max[0,Re[#]],Max[0,-Re[#]],Max[0,Im[#]],Max[0,-Im[#]]}&/@h],opts];



EigenballPlot[A_,opts___]:=Module[{n,i,j},
n=Length[A];Show[Graphics[Table[Circle[{Re[A[[i,i]]],Im[A[[i,i]]]},\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(j = 1\), \(i - 1\)]\(Abs[A[[i, j]]]\)\)+\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(j = i + 1\), \(n\)]\(Abs[A[[i, j]]]\)\)],{i,n}]],
Graphics[Map[Point[{Re[#],Im[#]}]&,Eigenvalues[A]]
],Axes->Automatic,opts]
]


DotPlot[pts_,opts:OptionsPattern[ListPlot]]:=ListPlot[Map[{#,0}&,pts],Axes->False,opts];
ComplexDotPlot[pts_,opts:OptionsPattern[ListPlot]]:=ListPlot[Map[{Re[#],Im[#]}&,pts],PlotStyle->Join[If[OptionValue[PlotStyle]===Automatic,{},{OptionValue[PlotStyle]}//Flatten],{PointSize[Large]}],opts];
ComplexLinePlot[pts_,opts:OptionsPattern[ListLinePlot]]:=ListLinePlot[Map[{Re[#],Im[#]}&,pts],opts];


Options[MoviePlot]={Plotter->Plot,Frames->15};

MoviePlot[f_,boundsAndOpts__]:=
	Module[{bounds,opts,plotter,var,a,b,t,h,frames,plotrange},
	bounds=Select[{boundsAndOpts},(Head[#]==List)&];
	opts=Select[{boundsAndOpts},(Head[#]=!=List)&];
	plotter=Plotter/.opts/.Options[MoviePlot];
	frames=Frames/.opts/.Options[MoviePlot];

	opts=Select[opts,(First[#]=!=Plotter &&First[#]=!=Frames)&];
	
	var=First[First[bounds]];
	a=First[bounds][[2]];
	b=Last[First[bounds]];
	h=(b-a)/frames;

	plotrange=PlotRange/.AbsoluteOptions[plotter[f,Evaluate[First[bounds]],Evaluate[Apply[Sequence,opts]]]];

	opts=Select[opts,(First[#]=!=PlotRange )&];



	Table[plotter[f,Evaluate[{var,a,t}],PlotRange->plotrange,Evaluate[Apply[Sequence,opts]]],{t,a+h,b,h}]
]


Simplex[2]:=Module[{x,y},{x+y<=1,{x,0,1},{y,0,1}}]


DefaultFontSize=12;$TextStyle={FontFamily->"Cmr12",FontSize->DefaultFontSize};RomanFont[str_,size_:DefaultFontSize]:=\!\(\*
TagBox[
FormBox[
RowBox[{"Style", "[", 
RowBox[{"str", ",", 
RowBox[{"FontFamily", "->", "\"\<Cmr12\>\""}], ",", 
RowBox[{"FontSize", "->", "size"}]}], "]"}],
TraditionalForm],
TraditionalForm,
Editable->True]\);
ItalicFont[str_,size_:DefaultFontSize]:=\!\(\*
TagBox[
FormBox[
RowBox[{"Style", "[", 
RowBox[{"str", ",", 
RowBox[{"FontFamily", "->", "\"\<Cmmi12\>\""}], ",", 
RowBox[{"FontSize", "->", "size"}]}], "]"}],
TraditionalForm],
TraditionalForm,
Editable->True]\);


PseudospectraPlot[M_,zmin_:(-1.-1.I),zmax_:(1.+1. I),h_:.1]:=Flatten[Table[{x,y,M-(x+I y) IdentityMatrix[M//Length]//SingularValueDecomposition//#[[2]]&//Diagonal//Min},{x,zmin//Re,zmax//Re,h},{y,zmin//Im,zmax//Im,h}],1]//ListContourPlot;
SVDPlot[m_,opts___]:=ComplexDotPlot[m//SingularValueDecomposition//#[[2]]&//Diagonal,opts];


End[];
EndPackage[];

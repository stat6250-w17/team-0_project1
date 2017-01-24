*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding free/reduced-price meals at CA public K-12 schools

Dataset Name: FRPM1516_analytic_file created in external file
STAT6250-01_w17-team-0_project1_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;
%let dataPrepFileName = STAT6250-01_w17-team-0_project1_data_preparation.sas;
%let sasUEFilePrefix = team-0_project1;

* load external file that generates analytic dataset FRPM1516_analytic_file
using a system path dependent on the host operating system, after setting the
relative file import path to the current directory, if using Windows;
%macro setup;
%if
	&SYSSCP. = WIN
%then
	%do;
		X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";			
		%include ".\&dataPrepFileName.";
	%end;
%else
	%do;
		%include "~/&sasUEFilePrefix./&dataPrepFileName.";
	%end;
%mend;
%setup



title1
"Research Question: What are the top twenty districts with the highest mean values of Percent Eligible FRPM for K-12?"
;
title2
"Rationale: This should help identify the school districts in the most need of outreach based upon child poverty levels."
;
*
Methodology: Use PROC MEANS to compute the mean of Percent_Eligible_FRPM_K12
for District_Name, and output the results to a temportatry dataset. Use PROC
SORT extract and sort just the means the temporary dateset, and use PROC PRINT
to print just the first twenty observations from the temporary dataset;
;
proc means mean noprint data=FRPM1516_analytic_file;
    class District_Name;
    var Percent_Eligible_FRPM_K12;
    output out=FRPM1516_analytic_file_temp;
run;

proc sort data=FRPM1516_analytic_file_temp(where=(_STAT_="MEAN"));
    by descending Percent_Eligible_FRPM_K12;
run;

proc print noobs data=FRPM1516_analytic_file_temp(obs=20);
    id District_Name;
    var Percent_Eligible_FRPM_K12;
run;



title1
"Research Question: How does the distribution of Percent Eligible FRPM for K-12 for charter schools compare to that of non-charter schools?"
;

title2
"Rationale: This would help inform whether outreach based upon child poverty levels should be provided to charter schools."
;
*
Methodolody: Compute five-number summaries by charter-school indicator variable
;
proc means min q1 median q3 max data=FRPM1516_analytic_file;
    class Charter_School;
    var Percent_Eligible_FRPM_K12;
run;


title1
"Research Question: Can Enrollment for K-12 be used to predict Percent Eligible FRPM for K-12?"
;

title2
"Rationale: This would help determine whether outreach based upon child poverty levels should be provided to smaller schools. E.g., if enrollment is highly correlated with FRPM rate, then only larger schools would tend to have high child poverty rates."
;
*
Methodology: Use proc means to study the five-number summary of each variable,
create formats to bin values of Enrollment_K12 and Percent_Eligible_FRPM_K12
based upon their spread, and use proc freq to cross-tabulate bins

Notes: A possible follow-up to this approach could use an inferential
statistical technique like beta regression
;
proc means min q1 median q3 max data=FRPM1516_analytic_file;
    var
        Enrollment_K12
        Percent_Eligible_FRPM_K12
    ;
run;
proc freq data=FRPM1516_analytic_file;
    table Enrollment_K12*Percent_Eligible_FRPM_K12
        / missing norow nocol nopercent
    ;
    format
        Enrollment_K12 Enrollment_K12_bins.
        Percent_Eligible_FRPM_K12 Percent_Eligible_FRPM_K12_bins.
    ;
run;

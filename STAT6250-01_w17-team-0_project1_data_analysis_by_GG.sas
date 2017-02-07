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

* macro to set output destination;
%macro setOutputDestination(destination);
    ods _all_ close;
    %if
        %upcase(&destination.) = HTML
    %then
        %do;
            ods html;
        %end;
    %else %if
        %upcase(&destination.) = LISTING
    %then
        %do;
            ods listing;
        %end;
    %else %if
        %upcase(&destination.) = PDF
    %then
        %do;
            ods pdf;
        %end;
    %else %if
        %upcase(&destination.) = RTF
    %then
        %do;
            ods rtf;
        %end;
    %else %if
        %upcase(&destination.) = EXCEL
    %then
        %do;
            ods excel;
        %end;
%mend;

* uncomment the line below to close all active output destinations and switch
  the current ODS destination to HTML output only;
/*%setOutputDestination(html)*/

* uncomment the line below to close all active output destinations and switch
  the current ODS destination to listing output only;
/*%setOutputDestination(listing)*/

* uncomment the line below to close all active output destinations and switch
  the current ODS destination to PDF output only;
/*%setOutputDestination(pdf)*/

* uncomment the line below to close all active output destinations and switch
  the current ODS destination to RTF output only;
/*%setOutputDestination(rtf)*/

* uncomment the line below to close all active output destinations and switch
  the current ODS destination to Excel output only;
/*%setOutputDestination(excel)*/


* load external file that generates analytic dataset FRPM1516_analytic_file
using a system path dependent on the host operating system, after setting the
relative file import path to the current directory, if using Windows;
%macro setup;
    %if
        &SYSSCP. = WIN
    %then
        %do;
            X
            "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))"""
            ;           
            %include ".\&dataPrepFileName.";
        %end;
    %else
        %do;
            %include "~/&sasUEFilePrefix./&dataPrepFileName.";
        %end;
%mend;
%setup


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
"Research Question: What are the top twenty districts with the highest mean values of Percent Eligible FRPM for K-12?"
;
title2
"Rationale: This should help identify the school districts in the most need of outreach based upon child poverty levels."
;
footnote1
"Based on the above output, 9 schools have 100% of their students eligible for free/reduced-price meals under the National School Lunch Program."
;
footnote2
"Moreover, we can see that virtually all of the top 20 schools appear to be elementary schools, suggesting increasing early childhood poverty."
;
footnote3
"Further analysis to look for geographic patterns is clearly warrented, given such high mean percentages of early childhood poverty."
;
*
Methodology: Use PROC MEANS to compute the mean of Percent_Eligible_FRPM_K12
for District_Name, and output the results to a temportatry dataset. Use PROC
SORT extract and sort just the means the temporary dateset, and use PROC PRINT
to print just the first twenty observations from the temporary dataset.
;
proc means
        mean
        noprint
        data=FRPM1516_analytic_file
    ;
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
title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
"Research Question: How does the distribution of Percent Eligible FRPM for K-12 for charter schools compare to that of non-charter schools?"
;
title2
"Rationale: This would help inform whether outreach based upon child poverty levels should be provided to charter schools."
;
footnote1
"Based on the above output, the distribution of percentage eligible for free/reduced-price meals under the National School Lunch Program appears to be roughly the same for Charter and Non-charter Schools."
;
footnote2
"However, Charter schools do appear to have slighly lower childhood poverty rates, overall, given the smaller first and second quartiles."
;
footnote3
"In addition, more analysis is needed for the group with value 'N/A', which has a significanly reduced child poverty distribution."
;
*
Methodology: Compute five-number summaries by charter-school indicator variable.
;
proc means
        min q1 median q3 max
        data=FRPM1516_analytic_file
    ;
    class Charter_School;
    var Percent_Eligible_FRPM_K12;
run;
title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
"Research Question: Can Enrollment for K-12 be used to predict Percent Eligible FRPM for K-12?"
;
title2
"Rationale: This would help determine whether outreach based upon child poverty levels should be provided to smaller schools. E.g., if enrollment is highly correlated with FRPM rate, then only larger schools would tend to have high child poverty rates."
;
footnote1
"Based on the above output, there's no clear inferential pattern for predicting the percentage eligible for free/reduced-price meals under the National School Lunch Program based on school enrollment since cell counts don't tend to follow trends for increasing or decreasing consistently."
;
footnote2
"However, this is an incredibly course analysis since only quartiles are used, so a follow-up analysis using a more sensitive instrument (like beta regression) might find useful correlations."
;
*
Methodology: Use proc freq to cross-tabulate bins, which were based on proc
means output for the five-number summary of each variable.

Notes: A possible follow-up to this approach could use an inferential
statistical technique like beta regression.
;
proc freq data=FRPM1516_analytic_file;
    table
         Enrollment_K12
        *Percent_Eligible_FRPM_K12
        / missing norow nocol nopercent
    ;
    format
        Enrollment_K12 Enrollment_K12_bins.
        Percent_Eligible_FRPM_K12 Percent_Eligible_FRPM_K12_bins.
    ;
run;
title;
footnote;

* set output destination back to default HTML output;
%setOutputDestination(html)

*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
This file prepares the dataset described below for analysis.

Dataset Name: Student Poverty Free or Reduced Price Meals (FRPM) Data

Experimental Units: California public K-12 schools

Number of Observations: 10,453

Number of Features: 28

Data Source: The file http://www.cde.ca.gov/ds/sd/sd/documents/frpm1516.xls was
downloaded and edited to produce file frpm1516-edited.xls by deleting worksheet
"Title Page", deleting row 1 from worksheet "FRPM School-Level Data",
reformatting column headers in "FRPM School-Level Data" to remove characters
disallowed in SAS variable names, and setting all cell values to "Text" format

Data Dictionary: http://www.cde.ca.gov/ds/sd/sd/fsspfrpm.asp or worksheet
"Data Field Descriptions" in file frpm1516-edited.xls

Unique ID: The columns County_Code, District_Code, and School_Code form a
composite key
;

* setup environmental parameters;
%let inputDatasetURL =
https://github.com/stat6250/team-0_project1/blob/master/frpm1516-edited.xls?raw=true
;

* create output formats;
proc format;
    value Enrollment_K12_bins
        low-262="Q1 Enrollment"
        263-510="Q2 Enrollment"
        511-740="Q3 Enrollment"
        741-high="Q4 Enrollment"
    ;
    value Percent_Eligible_FRPM_K12_bins
        low-<.36="Q1 FRPM"
        .36-<.67="Q2 FRPM"
        .67-<.86="Q3 FRPM"
        .86-high="Q4 FRPM"
    ;
run;


* load raw FRPM dataset over the wire, if it doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=url;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            filename tempfile TEMP;
            proc http
                method="get"
                url="&inputDatasetURL."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.
                ;
            run;
            filename tempfile clear;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(FRPM1516_raw,&inputDatasetURL.,xls)


* check raw FRPM dataset for duplicates with respect to its composite key;
proc sort
        nodupkey
        data=FRPM1516_raw
        dupout=FRPM1516_raw_dups
        out=_null_
    ;
    by
        County_Code
        District_Code
        School_Code
    ;
run;


* build analytic dataset from FRPM dataset with the least number of columns and
minimal cleaning/transformation needed to address research questions in
corresponding data-analysis files;
data FRPM1516_analytic_file;
    retain
        Percent_Eligible_FRPM_K12
        District_Name
        Charter_School
        Enrollment_K12
    ;
    keep
        Percent_Eligible_FRPM_K12
        District_Name
        Charter_School
        Enrollment_K12
    ;
    set FRPM1516_raw;
run;

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
https://github.com/stat6250-staging/team-0_project1/blob/master/frpm1516-edited.xls?raw=true
;

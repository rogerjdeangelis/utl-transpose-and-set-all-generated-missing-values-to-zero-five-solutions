Transpose and set all generated missing calues to zero  five solutions                                                           
                                                                                                                                 
     Five Solutions                                                                                                              
        a. proc corresp (least code)                                                                                             
        b. proc freq odsfrq macro                                                                                                
        c. proc transpose and proc stdize                                                                                        
        d. proc tabulate                                                                                                         
        e. proc report                                                                                                           
                                                                                                                                 
All solutions create an output SAS table.                                                                                        
Non require a datastep array                                                                                                     
                                                                                                                                 
github                                                                                                                           
https://tinyurl.com/y4yxhous                                                                                                     
https://github.com/rogerjdeangelis/utl-transpose-and-set-all-generated-missing-values-to-zero-five-solutions                     
                                                                                                                                 
SAS Forum                                                                                                                        
https://tinyurl.com/y66exx68                                                                                                     
https://communities.sas.com/t5/SAS-Programming/Creating-a-macro-variable-containing-a-list-of-codes-and-using/m-p/683985         
                                                                                                                                 
/*                   _                                                                                                           
(_)_ __  _ __  _   _| |_                                                                                                         
| | `_ \| `_ \| | | | __|                                                                                                        
| | | | | |_) | |_| | |_                                                                                                         
|_|_| |_| .__/ \__,_|\__|                                                                                                        
        |_|                                                                                                                      
*/                                                                                                                               
                                                                                                                                 
data have;                                                                                                                       
   input  personid code $ value;                                                                                                 
cards4;                                                                                                                          
1 22c 0.2                                                                                                                        
1 22b 1.3                                                                                                                        
2 22c 1.2                                                                                                                        
3 22b 2.4                                                                                                                        
3 22c 8.2                                                                                                                        
                                                                                                                                 
;;;;                                                                                                                             
run;quit;                                                                                                                        
                                                                                                                                 
WORK.HAVE total obs=5                                                                                                            
                                                                                                                                 
  PERSONID    CODE    VALUE                                                                                                      
                                                                                                                                 
      1       22c      0.2                                                                                                       
      1       22b      1.3                                                                                                       
      2       22c      1.2                                                                                                       
      3       22b      2.4                                                                                                       
      3       22c      8.2                                                                                                       
                                                                                                                                 
/*           _               _                                                                                                   
  ___  _   _| |_ _ __  _   _| |_                                                                                                 
 / _ \| | | | __| `_ \| | | | __|                                                                                                
| (_) | |_| | |_| |_) | |_| | |_                                                                                                 
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                                
                |_|                                                                                                              
*/                                                                                                                               
                                                                                                                                 
WORK.WANT total obs=3                                                                                                            
                                                                                                                                 
  PERSONID    _22c    _22b                                                                                                       
                                                                                                                                 
      1        0.2     1.3                                                                                                       
      2        1.2     0.0   ==> note set too zero                                                                               
      3        8.2     2.4                                                                                                       
                                                                                                                                 
/*         _       _   _                                                                                                         
 ___  ___ | |_   _| |_(_) ___  _ __  ___                                                                                         
/ __|/ _ \| | | | | __| |/ _ \| `_ \/ __|                                                                                        
\__ \ (_) | | |_| | |_| | (_) | | | \__ \                                                                                        
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/                                                                                        
  __ _      ___ ___  _ __ _ __ ___  ___ _ __                                                                                     
 / _` |    / __/ _ \| `__| `__/ _ \/ __| `_ \                                                                                    
| (_| |_  | (_| (_) | |  | | |  __/\__ \ |_) |                                                                                   
 \__,_(_)  \___\___/|_|  |_|  \___||___/ .__/                                                                                    
                                       |_|                                                                                       
*/                                                                                                                               
                                                                                                                                 
proc datasets lib=work;                                                                                                          
 delete want;                                                                                                                    
run;quit;                                                                                                                        
                                                                                                                                 
ods output observed=want;                                                                                                        
proc corresp data=have dim=1 observed;                                                                                           
tables personid, code;                                                                                                           
weight value;                                                                                                                    
run;quit;                                                                                                                        
                                                                                                                                 
/* output                                                                                                                        
Up to 40 obs from WANT total obs=4                                                                                               
                                                                                                                                 
Obs    Label    _22b    _22c     Sum                                                                                             
                                                                                                                                 
 1      1        1.3     0.2     1.5                                                                                             
 2      2        0.0     1.2     1.2                                                                                             
 3      3        2.4     8.2    10.6                                                                                             
 4      Sum      3.7     9.6    13.3                                                                                             
                                                                                                                                 
*/                                                                                                                               
/*                                __                                                                                             
| |__     _ __  _ __ ___   ___   / _|_ __ ___  __ _                                                                              
| `_ \   | `_ \| `__/ _ \ / __| | |_| `__/ _ \/ _` |                                                                             
| |_) |  | |_) | | | (_) | (__  |  _| | |  __/ (_| |                                                                             
|_.__(_) | .__/|_|  \___/ \___| |_| |_|  \___|\__, |                                                                             
         |_|                                     |_|                                                                             
*/                                                                                                                               
                                                                                                                                 
proc datasets lib=work nolist;                                                                                                   
 delete want;                                                                                                                    
run;quit;                                                                                                                        
                                                                                                                                 
options missing=0;                                                                                                               
%utl_odsfrq(setup);                                                                                                              
proc freq data=have;                                                                                                             
tables personid*code;                                                                                                            
weight value;                                                                                                                    
run;quit;                                                                                                                        
%utl_odsfrq(outdsn=want);                                                                                                        
options FORMCHAR='|----|+|---+=|-/\<>*';                                                                                         
                                                                                                                                 
proc print data=want (where=(rownam='COUNT'));                                                                                   
run;quit;                                                                                                                        
                                                                                                                                 
/*                                                                                                                               
   row                                                                                                                           
   Nam     level   _22b     _22c    TOTAL                                                                                        
                                                                                                                                 
  COUNT      1      1.3      0.2      1.5                                                                                        
  COUNT      2        0      1.2      1.2                                                                                        
  COUNT      3      2.4      8.2     10.6                                                                                        
*/                                                                                                                               
                                                                                                                                 
/*        _                                                                                                                      
  ___    | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___                                                                           
 / __|   | __| `__/ _` | `_ \/ __| `_ \ / _ \/ __|/ _ \                                                                          
| (__ _  | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/                                                                          
 \___(_)  \__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___|                                                                          
                                 |_|                                                                                             
*/                                                                                                                               
                                                                                                                                 
proc datasets lib=work nolist;                                                                                                   
 delete want;                                                                                                                    
run;quit;                                                                                                                        
                                                                                                                                 
proc transpose data=have out=xpo (drop=_name_);                                                                                  
   by personid;                                                                                                                  
   id code;                                                                                                                      
run;quit;                                                                                                                        
                                                                                                                                 
proc stdize data=xpo out=want reponly missing=0;                                                                                 
run;quit;                                                                                                                        
                                                                                                                                 
                                                                                                                                 
/*                                                                                                                               
Up to 40 obs from WANT total obs=3                                                                                               
                                                                                                                                 
Obs    PERSONID    _22c    _22b                                                                                                  
                                                                                                                                 
 1         1        0.2     1.3                                                                                                  
 2         2        1.2     0.0                                                                                                  
 3         3        8.2     2.4                                                                                                  
*/                                                                                                                               
                                                                                                                                 
/*   _     _        _           _       _                                                                                        
  __| |   | |_ __ _| |__  _   _| | __ _| |_ ___                                                                                  
 / _` |   | __/ _` | `_ \| | | | |/ _` | __/ _ \                                                                                 
| (_| |_  | || (_| | |_) | |_| | | (_| | ||  __/                                                                                 
 \__,_(_)  \__\__,_|_.__/ \__,_|_|\__,_|\__\___|                                                                                 
                                                                                                                                 
*/                                                                                                                               
                                                                                                                                 
%utl_odstab(setup);                                                                                                              
proc tabulate data=have;                                                                                                         
title "|Personid|_22b|_22c|";                                                                                                    
class personid code;                                                                                                             
var value;                                                                                                                       
table personid, code*value;                                                                                                      
run;quit;                                                                                                                        
%utl_odstab(outdsn=want,datarow=5);                                                                                              
                                                                                                                                 
/*                                                                                                                               
Up to 40 obs from WANT total obs=3                                                                                               
                                                                                                                                 
Obs    Personid    _22b    _22c                                                                                                  
                                                                                                                                 
 1         1        1.3     0.2                                                                                                  
 2         2        0.0     1.2                                                                                                  
 3         3        2.4     8.2                                                                                                  
*/                                                                                                                               
                                                                                                                                 
/*                                                         _                                                                     
  ___     _ __  _ __ ___   ___   _ __ ___ _ __   ___  _ __| |_                                                                   
 / _ \   | `_ \| `__/ _ \ / __| | `__/ _ \ `_ \ / _ \| `__| __|                                                                  
|  __/_  | |_) | | | (_) | (__  | | |  __/ |_) | (_) | |  | |_                                                                   
 \___(_) | .__/|_|  \___/ \___| |_|  \___| .__/ \___/|_|   \__|                                                                  
         |_|                             |_|                                                                                     
*/                                                                                                                               
proc datasets lib=work nolist;                                                                                                   
 delete want;                                                                                                                    
run;quit;                                                                                                                        
                                                                                                                                 
%utl_odsrpt(setup);                                                                                                              
options missing=0;                                                                                                               
proc report data=have box nowd noheader;                                                                                         
title "|Personid|_22b|_22c|";                                                                                                    
cols personid code, value;                                                                                                       
define personid / group;                                                                                                         
define code     / across ;                                                                                                       
define value / analysis;                                                                                                         
run;quit;                                                                                                                        
%utl_odsrpt(outdsn=want);                                                                                                        
                                                                                                                                 
                                                                                                                                 
Up to 40 obs WORK.WANT total obs=3                                                                                               
                                                                                                                                 
Obs    Personid    _22b    _22c                                                                                                  
                                                                                                                                 
 1         1        1.3     0.2                                                                                                  
 2         2        0.0     1.2                                                                                                  
 3         3        2.4     8.2                                                                                                  
                                                                                                                                 

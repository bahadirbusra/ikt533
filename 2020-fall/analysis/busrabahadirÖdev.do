use "C:\Users\kenan\Desktop\NEW7080 (1).dta"
rename v1 AGE
rename v2 AGEQ
rename v4 EDUC
rename v5 ENOCENT
rename v6 ESOCENT
rename v9 LWKLYWGE
rename v10 MARRIED
rename v11 MIDATL
rename v12 MT
rename v13 NEWENG
rename v16 CENSUS
rename v18 QOB
rename v19 RACE
rename v20 SMSA
rename v21 SOATL
rename v24 WNOCENT
rename v25 WSOCENT
rename v27 YOB
**********YOB dummies **********
replace YOB=YOB-1900 if YOB >=1900
foreach i of numlist 0/9 {
gen YR`i'=0
replace YR`i'=1 if YOB==20+`i' | YOB==30+`i' | YOB==40+`i' 
}
**********QOB dummies ***********
foreach i of numlist 1/4 {
gen QTR`i'=0
replace QTR`i'=1 if QOB==`i'
}
**********  QOB*YOB dummies ********
foreach j of numlist 1/3 {
foreach i of numlist 0/9 {
gen QTR`j'YR`i'=QTR`j'*YR`i'
}
}
**********  Select Particular Men Born ********
gen COHORT=2029
replace COHORT=3039 if YOB<=39 & YOB >=30
replace COHORT=4049 if YOB<=49 & YOB >=40
replace AGEQ=AGEQ-1900 if CENSUS==80
gen AGEQSQ= AGEQ*AGEQ
*******************
**************Cevap a)**********
*********Tablo III KODLARI********
********** Panel A********
sum LWKLYWGE if QTR1==1 & COHORT==2029
sum LWKLYWGE if QTR1!=1 & COHORT==2029
sum EDUC if QTR1==1 & COHORT==2029
sum EDUC if QTR1!=1 & COHORT==2029

reg LWKLYWGE QTR1 if COHORT==2029
reg EDUC QTR1 if COHORT==2029
sureg (eq1:  LWKLYWGE QTR1 ) (eq2:  EDUC QTR1 ) if COHORT==2029
nlcom ratio: [eq1]_b[QTR1]/[eq2]_b[QTR1]
reg LWKLYWGE EDUC if  COHORT==2029
**********
********** Panel B***********
sum LWKLYWGE if QTR1==1 & COHORT==3039
sum LWKLYWGE if QTR1!=1 & COHORT==3039
sum EDUC if QTR1==1 & COHORT==3039
sum EDUC if QTR1!=1 & COHORT==3039
reg LWKLYWGE QTR1 if COHORT==3039
reg EDUC QTR1 if COHORT==3039
sureg (eq1:  LWKLYWGE QTR1 ) (eq2:  EDUC QTR1 ) if COHORT==3039
nlcom ratio: [eq1]_b[QTR1]/[eq2]_b[QTR1]
reg LWKLYWGE EDUC if  COHORT==3039

********Cevap b)*********
******1920-1929 dönemi için********
keep if COHORT < 2030
ivregress 2sls LWKLYWGE (EDUC=QTR1)
ivregress 2sls LWKLYWGE YR0-YR8 RACE MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT AGEQ AGEQSQ (EDUC = QTR1YR0-QTR1YR9 QTR2YR0-QTR2YR9 QTR3YR0-QTR3YR9 YR0-YR8)
reg  LWKLYWGE EDUC
reg  LWKLYWGE EDUC RACE MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT YR0-YR8 AGEQ AGEQSQ

******1930-1939 dönemi için********

keep if COHORT>3000 & COHORT <3040
ivregress 2sls LWKLYWGE (EDUC = QTR1)
ivregress 2sls LWKLYWGE YR0-YR8 RACE MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT AGEQ AGEQSQ (EDUC = QTR1YR0-QTR1YR9 QTR2YR0-QTR2YR9 QTR3YR0-QTR3YR9 YR0-YR8)
reg  LWKLYWGE EDUC
reg  LWKLYWGE EDUC RACE MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT YR0-YR8 AGEQ AGEQSQ
*******************************
*********Cevap d**********
use "C:\Users\kenan\Desktop\NEW7080 (1).dta"
rename v4 EDUC
rename v5 ENOCENT
rename v6 ESOCENT
rename v9 LWKLYWGE
rename v10 MARRIED
rename v11 MIDATL
rename v12 MT
rename v13 NEWENG
rename v16 CENSUS
rename v18 QOB
rename v19 RACE
rename v20 SMSA
rename v21 SOATL
rename v24 WNOCENT
rename v25 WSOCENT
rename v27 YOB
**********  YOB dummies **********
replace YOB=YOB-1900 if YOB >=1900
foreach i of numlist 0/9 {
gen YR`i'=0
replace YR`i'=1 if YOB==20+`i' | YOB==30+`i' | YOB==40+`i' 
}
**********  QOB dummies ***********
foreach i of numlist 1/4 {
gen QTR`i'=0
replace QTR`i'=1 if QOB==`i'
}
**********  QOB*YOB dummies ********
foreach j of numlist 1/3 {
foreach i of numlist 0/9 {
gen QTR`j'YR`i'=QTR`j'*YR`i'
}
}
**********  Select Particular Men Born ********
gen COHORT=2029
replace COHORT=3039 if YOB<=39 & YOB >=30
replace COHORT=4049 if YOB<=49 & YOB >=40
***********
keep if COHORT>3000 & COHORT <3040
*********Sekil V**************
tab QOB, gen(Q)
gen AGE=((79-YOB)*4+5-QOB)/4
gen AGE2=AGE^2
collapse EDUC LWKLYWGE Q*, by(AGE)
gen YOB = 80-AGE
label var EDUC "Years of education"
label var LWKLYWGE "Log Weekly Earnings"
label var AGE "age"
label var YOB "Year of Birth"
twoway (line EDUC YOB) (scatter EDUC YOB if Q1 == 1) (scatter EDUC YOB if Q2 == 1) (scatter EDUC YOB if Q3 == 1) (scatter EDUC YOB if Q4 == 1, msym(Oh))
*********************
***********Cevap c)ZAYIF ARAÇ DEGISKEN******
sort Q1
by Q1: sum LWKLYWGE EDUC
reg LWKLYWGE Q1, robust
reg EDUC Q1, robust
*****COLUMN 1*******
reg LWKLYWGE  EDUC, robust
outreg2 EDUC using "C:\Users\kenan\Desktop\Table64.xls", replace bdec(3) sdec(3) noaster word
*********************
*****FIRST STAGE****
reg EDUC Q1
testparm Q1
local F = r(F)
*******COLUMN 2*****
ivregress 2sls LWKLYWGE (EDUC= Q1),  robust
outreg2 EDUC using "C:\Users\kenan\Desktop\Table5.xls", append bdec(3) sdec(3) noaster word addstat (F-stat, `F')
****COLUMN 3*****0
reg  LWKLYWGE EDUC i.YOB, robust
outreg2 EDUC using "C:\Users\kenan\Desktop\Table5.xls", append bdec(3) sdec(3) noaster word
**********************
******FIRST STAGE*****
reg EDUC Q1 i.YOB
testparm Q1
local F = r(F)
********COLUMN 4*******
ivregress 2sls LWKLYWGE (EDUC = Q1) i.YOB, robust
outreg2 s using "C:\Users\kenan\Desktop\Table5.xls",  append bdec(3) sdec(3) noaster word addstat(F-stat, `F')
**************************
*****FIRST STAGE*****
reg EDUC Q2 Q3 Q4 i.YOB
testparm Q2 Q3 Q4
local F = r(F)
********COLUMN 5*******
ivregress 2sls LWKLYWGE (EDUC = i.QOB) i.YOB, robust
outreg2 s using "C:\Users\kenan\Desktop\Table5.xls", append bdec(3) sdec(3) noaster word addstat(F-stat, `F')

use "C:\Users\kenan\Desktop\ikt533-main\2020-fall\data\raw\hia\hia2010.dta"
rename S7 birthplace
rename S3 gender
rename S6 age
rename S6_GRUP agegrup
rename S8B resideyear
rename S9B reside
rename S13 educ
rename S24 marital
rename S69 earning
rename S97 job
rename S42 security
rename S45 timejob
rename S37A firmsize
rename S33KOD industry
rename NUTS2 region
rename DURUM status
rename KIRKENT rural
rename S39 workstatus
rename FAKTOR faktor
keep FORMNO birthplace age agegrup resideyear reside gender educ rural marital earning region job security status faktor timejob firmsize industry workstatus 
gen year=2010
save 2010_ready, replace
*************************************************************
use "C:\Users\kenan\Desktop\ikt533-main\2020-fall\data\raw\hia\hia2011.dta"
rename S7 birthplace
rename S3 gender
rename S6 age
rename S6_GRUP agegrup
rename S8B resideyear
rename S9B reside
rename S13 educ
rename S24 marital
rename S69 wage
rename S70 add
rename S71 prim
rename S97 job
rename S42 security
rename S45 timejob
rename S37A firmsize
rename S33KOD industry
rename NUTS2 region
rename DURUM status
rename KIRKENT rural
rename S39 workstatus
rename FAKTOR faktor
gen earning=(wage+prim) if add==1
replace earning=wage if add==2
keep FORMNO birthplace age agegrup resideyear reside gender educ rural marital earning region job security status faktor timejob firmsize industry workstatus
gen year=2011
save 2011_ready, replace
*********************
use "C:\Users\kenan\Desktop\ikt533-main\2020-fall\data\raw\hia\hia2012.dta"
rename S7 birthplace
rename S3 gender
rename S6 age
rename S6_GRUP agegrup
rename S8B resideyear
rename S9B reside
rename S13 educ
rename S24 marital
rename S69 wage
rename S70 add
rename S71 prim
rename S97 job
rename S42 security
rename S45 timejob
rename S37A firmsize
rename S33KOD industry
rename NUTS2 region
rename DURUM status
rename KIRKENT rural
rename S39 workstatus
rename FAKTOR faktor
gen earning=(wage+prim) if add==1
replace earning=wage if add==2
keep FORMNO birthplace age agegrup resideyear reside gender educ rural marital earning region job security status faktor timejob firmsize industry workstatus 
gen year=2012
save 2012_ready, replace
**************************************************
use "C:\Users\kenan\Desktop\ikt533-main\2020-fall\data\raw\hia\hia2013.dta"
rename S7 birthplace
rename S3 gender
rename S6 age
rename S6_GRUP agegrup
rename S8B resideyear
rename S9B reside
rename S13 educ
rename S24 marital
rename S69 wage
rename S70 add
rename S71 prim
rename S97 job
rename S42 security
rename S45 timejob
rename S37A firmsize
rename S33KOD industry
rename NUTS2 region
rename DURUM status
rename KIRKENT rural
rename S39 workstatus
rename FAKTOR faktor
gen earning=(wage+prim) if add==1
replace earning=wage if add==2
keep FORMNO birthplace age agegrup resideyear reside gender educ rural marital earning region job security status faktor timejob firmsize industry workstatus 
gen year=2013
save 2013_ready, replace
*******************************************************
use 2010_ready, clear
append using 2011_ready
append using 2012_ready
append using 2013_ready
*********************
keep if region>=12
drop if region==14
drop if region==15
drop if region==16
drop if region==17
drop if region==18
drop if region==19
drop if birthplace==2 & resideyear>2009
drop if age<15
drop if age>=65
gen native=1
egen native_no=count(native) if native==1
bysort year: egen native_no_year=count(native) if native==1
count

*************************
gen time = (year>=2012) & !missing(year)
************************
gen treated=0
replace treated=1 if region==12
replace treated=1 if region==13
replace treated=1 if region==24
replace treated=1 if region==25
replace treated=1 if region==26
**************************************
***********INTERACTION TERM**********
gen did = time*treated
********************************
**************Covariates***************
**************TABLO 3****************************
gen men=0
replace men=1 if gender==1
*********
gen married=0
replace married=1 if marital==2
*****************
gen higheduc=0
replace higheduc=1 if educ>=4
**************
gen loweduc=0
replace loweduc=1 if educ<4
***********************
gen urban=0
replace urban=1 if rural==2
**************TABLO 4**************************
**************E/P**************
gen employed=0
replace employed=1 if status==1
bysort year: egen employed_no_year=count(employed) if employed==1
**************FE/P*************
gen formal=0
replace formal=1 if security==1
bysort year: egen formal_no=count(formal) if formal==1
**************IE/P*************
gen informal=0
replace informal=1 if security==2
bysort year: egen informal_no=count(informal) if informal==1
**************U/P*********
gen unemployed=0
replace unemployed=1 if status==2
bysort year: egen unemployed_no_year=count(unemployed) if unemployed==1
************LFP***********************
gen labforce=0
replace labforce=1 if status==1 | status==2
bysort year: egen labforce_no_year=count(labforce) if labforce==1
***********************
************Separation Probability************
gen sep_payda=0
replace sep_payda=1 if job==1 | job==2
bysort year treated: egen sep_payda_no=count(sep_payda) if sep_payda==1
gen sep_pay=0
replace sep_pay=1 if job==1 & status==2
replace sep_pay=1 if job==1 & status==3
bysort year treated: egen sep_pay_no=count(sep_pay) if sep_pay==1 
gen sep_prob= (sep_pay/sep_payda)
*************Finding Probability***************
gen find_payda=0
replace find_payda=1 if job==4
bysort year treated: egen find_payda_no=count(find_payda) if find_payda==1
gen find_pay=0
replace find_pay=1 if job==4 & status==1
bysort year treated: egen find_pay_no=count(find_pay) if find_pay==1
gen find_prob= (find_pay/find_payda)
*****************************
***********REAL WAGE************
replace earning=. if earning==0
gen deflator=.
replace deflator=100.00 if year==2010
replace deflator=108.2 if year==2011
replace deflator=116.2 if year==2012
replace deflator=123.5 if year==2013
gen earning_real=(earning*100)/deflator
gen log_realearning=ln(earning_real)

*******************************
***********TRADE*****************
gen trade=.
replace trade=5844492110 if region==12 & year==2010
replace trade=7307381877 if region==12 & year==2011
replace trade=7401514210 if region==12 & year==2012
replace trade=7116362611 if region==12 & year==2013

replace trade=6570045612 if region==13 & year==2010
replace trade=9513853658 if region==13 & year==2011
replace trade=9208529310 if region==13 & year==2012
replace trade=8868398744 if region==13 & year==2013

replace trade=7179075613 if region==24 & year==2010
replace trade=9706414143 if region==24 & year==2011
replace trade=10802489693 if region==24 & year==2012
replace trade=12315572549 if region==24 & year==2013

replace trade=625248290 if region==25 & year==2010
replace trade=669753552 if region==25 & year==2011
replace trade=580801904 if region==25 & year==2012
replace trade=830684948 if region==25 & year==2013

replace trade=1393980760 if region==26 & year==2010
replace trade=1991048522 if region==26 & year==2011
replace trade=2297100454 if region==26 & year==2012
replace trade=2536143886 if region==26 & year==2013

replace trade=79338628 if region==20 & year==2010
replace trade=107593112 if region==20 & year==2011
replace trade=140462590 if region==20 & year==2012
replace trade=108985121 if region==20 & year==2013

replace trade=250070876 if region==21 & year==2010
replace trade=260050452 if region==21 & year==2011
replace trade=220254009 if region==21 & year==2012
replace trade=302680535 if region==21 & year==2013

replace trade=486339827 if region==22 & year==2010
replace trade=493328908 if region==22 & year==2011
replace trade=491067722 if region==22 & year==2012
replace trade=689097489 if region==22 & year==2013

replace trade=390111167 if region==23 & year==2010
replace trade=452424226 if region==23 & year==2011
replace trade=482858238 if region==23 & year==2012
replace trade=443827288 if region==23 & year==2013
gen log_trade=ln(trade)
***************************
***********AGE DUMMIES**********
gen age_value=0
replace age_value=1 if agegrup==4 | agegrup==5
replace age_value=2 if agegrup==6 | agegrup==7
replace age_value=3 if agegrup==8 | agegrup==9
replace age_value=4 if agegrup==10| agegrup==11
replace age_value=5 if agegrup==12 | agegrup==13

**********AGE-EDUCATION INTERACTION DUMMIES*************
gen ageeduc=age_value*higheduc
*******************************************************
***********FULL TIME JOB DUMMIES*****************
gen timejob_dummy=.
replace timejob_dummy=1 if timejob==1
replace timejob_dummy=0 if timejob==2
**************************************************
**********
save main_ready

****************ANALİZ KODLARI***********************************
***************************************
use main_ready
**********TABLO 3****************
bysort year treated: summarize men age married higheduc urban [iweight=faktor]
estpost tabstat men age married higheduc urban, by(treated) statistics(mean) columns(statistics) listwise

**********TABLO 4*****************
bysort year treated: summarize employed formal informal unemployed labforce sep_prob find_prob earning_real
**********************************
**********TABLO 5***************************
eststo: reg informal did i.year i.region men married higheduc urban ageeduc i.age_value, robust
eststo: reg informal did i.year i.region men married higheduc urban ageeduc i.age_value log_trade, robust
eststo: reg informal did i.year i.region married higheduc urban ageeduc i.age_value log_trade if men==1, robust
eststo: reg informal did i.year i.region married higheduc urban ageeduc i.age_value log_trade if men==0, robust
eststo: reg informal did i.year i.region men married urban ageeduc i.age_value log_trade if higheduc==1, robust
eststo: reg informal did i.year i.region men married urban ageeduc i.age_value log_trade if loweduc==1, robust
esttab using deneme.tex, se r2 ar2  keep(did log_trade _cons) replace

************************************************
**********TABLO 6*******************************
eststo: reg labforce did i.year i.region men married higheduc urban ageeduc i.age_value, robust
eststo: reg labforce did i.year i.region men married higheduc urban ageeduc i.age_value log_trade, robust
eststo: reg labforce did i.year i.region married higheduc urban ageeduc i.age_value log_trade if men==1, robust
eststo: reg labforce did i.year i.region married higheduc urban ageeduc i.age_value log_trade if men==0, robust
eststo: reg labforce did i.year i.region men married urban ageeduc i.age_value log_trade if higheduc==1, robust
eststo: reg labforce did i.year i.region men married urban ageeduc i.age_value log_trade if loweduc==1, robust
esttab using deneme.tex, se r2 ar2  keep(did log_trade _cons) replace
**************************************************
**********TABLO 7*******************************
eststo: reg unemployed did i.year i.region men married higheduc urban ageeduc i.age_value, robust
eststo: reg unemployed did i.year i.region men married higheduc urban ageeduc i.age_value log_trade, robust
eststo: reg unemployed did i.year i.region married higheduc urban ageeduc i.age_value log_trade if men==1, robust
eststo: reg unemployed did i.year i.region married higheduc urban ageeduc i.age_value log_trade if men==0, robust
eststo: reg unemployed did i.year i.region men married urban ageeduc i.age_value log_trade if higheduc==1, robust
eststo: reg unemployed did i.year i.region men married urban ageeduc i.age_value log_trade if loweduc==1, robust
esttab using deneme.tex, se r2 ar2  keep(did log_trade _cons) replace
*************************************************
**********TABLO 8*******************************
eststo: reg formal did i.year i.region men married higheduc urban ageeduc i.age_value, robust
eststo: reg formal did i.year i.region men married higheduc urban ageeduc i.age_value log_trade, robust
eststo: reg formal did i.year i.region married higheduc urban ageeduc i.age_value log_trade if men==1, robust
eststo: reg formal did i.year i.region married higheduc urban ageeduc i.age_value log_trade if men==0, robust
eststo: reg formal did i.year i.region men married urban ageeduc i.age_value log_trade if higheduc==1, robust
eststo: reg formal did i.year i.region men married urban ageeduc i.age_value log_trade if loweduc==1, robust
esttab using deneme.tex, se r2 ar2  keep(did log_trade _cons) replace
*************************************************
**********TABLO 9*******************************
eststo: reg sep_prob did i.year i.region men married higheduc urban ageeduc i.age_value, robust
eststo: reg sep_prob did i.year i.region men married higheduc urban ageeduc i.age_value log_trade, robust
eststo: reg sep_prob did i.year i.region married higheduc urban ageeduc i.age_value log_trade if men==1, robust
eststo: reg sep_prob did i.year i.region married higheduc urban ageeduc i.age_value log_trade if men==0, robust
eststo: reg sep_prob did i.year i.region men married urban ageeduc i.age_value log_trade if higheduc==1, robust
eststo: reg sep_prob did i.year i.region men married urban ageeduc i.age_value log_trade if loweduc==1, robust
esttab using deneme.tex, se r2 ar2  keep(did log_trade _cons) replace
*************************************************
**********TABLO 10*******************************
eststo: reg find_prob did i.year i.region men married higheduc urban ageeduc i.age_value, robust
eststo: reg find_prob did i.year i.region men married higheduc urban ageeduc i.age_value log_trade, robust
eststo: reg find_prob did i.year i.region married higheduc urban ageeduc i.age_value log_trade if men==1, robust
eststo: reg find_prob did i.year i.region married higheduc urban ageeduc i.age_value log_trade if men==0, robust
eststo: reg find_prob did i.year i.region men married urban ageeduc i.age_value log_trade if higheduc==1, robust
eststo: reg find_prob did i.year i.region men married urban ageeduc i.age_value log_trade if loweduc==1, robust
esttab using deneme.tex, se r2 ar2  keep(did log_trade _cons) replace
*****************************************************
**********TABLO 11**********************************
*************LFP Regressions************************
eststo: reg labforce did i.year i.region men married higheduc urban ageeduc i.age_value , robust
eststo: reg labforce did i.year i.region men married higheduc urban log_trade if age_value==1, robust
eststo: reg labforce did i.year i.region men married higheduc urban log_trade if age_value==2, robust
eststo: reg labforce did i.year i.region men married higheduc urban log_trade if age_value==3, robust
eststo: reg labforce did i.year i.region men married higheduc urban log_trade if age_value==4, robust
eststo: reg labforce did i.year i.region men married higheduc urban log_trade if age_value==5, robust
esttab using deneme.tex, se  keep(did) replace
*************U/P Regressions*************************
eststo: reg unemployed did i.year i.region men married higheduc urban ageeduc i.age_value log_trade, robust
eststo: reg unemployed did i.year i.region men married higheduc urban log_trade if age_value==1, robust
eststo: reg unemployed did i.year i.region men married higheduc urban log_trade if age_value==2, robust
eststo: reg unemployed did i.year i.region men married higheduc urban log_trade if age_value==3, robust
eststo: reg unemployed did i.year i.region men married higheduc urban log_trade if age_value==4, robust
eststo: reg unemployed did i.year i.region men married higheduc urban log_trade if age_value==5, robust
esttab using deneme.tex, se  keep(did) replace
************IE/P Regressions*************************
eststo: reg informal did i.year i.region men married higheduc urban ageeduc i.age_value log_trade, robust
eststo: reg informal did i.year i.region men married higheduc urban log_trade if age_value==1, robust
eststo: reg informal did i.year i.region men married higheduc urban log_trade if age_value==2, robust
eststo: reg informal did i.year i.region men married higheduc urban log_trade if age_value==3, robust
eststo: reg informal did i.year i.region men married higheduc urban log_trade if age_value==4, robust
eststo: reg informal did i.year i.region men married higheduc urban log_trade if age_value==5, robust
esttab using deneme.tex, se (did) replace
************FE/P Regressions*************************
eststo: reg formal did i.year i.region men married higheduc urban ageeduc i.age_value log_trade, robust
eststo: reg formal did i.year i.region men married higheduc urban log_trade if age_value==1, robust
eststo: reg formal did i.year i.region men married higheduc urban log_trade if age_value==2, robust
eststo: reg formal did i.year i.region men married higheduc urban log_trade if age_value==3, robust
eststo: reg formal did i.year i.region men married higheduc urban log_trade if age_value==4, robust
eststo: reg formal did i.year i.region men married higheduc urban log_trade if age_value==5, robust
esttab using deneme.tex, se keep(did) replace
***********SP Regressions****************************
eststo: reg sep_prob did i.year i.region men married higheduc urban ageeduc i.age_value log_trade, robust
eststo: reg sep_prob did i.year i.region men married higheduc urban log_trade if age_value==1, robust
eststo: reg sep_prob did i.year i.region men married higheduc urban log_trade if age_value==2, robust
eststo: reg sep_prob did i.year i.region men married higheduc urban log_trade if age_value==3, robust
eststo: reg sep_prob did i.year i.region men married higheduc urban log_trade if age_value==4, robust
eststo: reg sep_prob did i.year i.region men married higheduc urban log_trade if age_value==5, robust
esttab using deneme.tex, se keep(did) replace
************JFP Regressions****************************
eststo: reg find_prob did i.year i.region men married higheduc urban ageeduc i.age_value log_trade, robust
eststo: reg find_prob did i.year i.region men married higheduc urban log_trade if age_value==1, robust
eststo: reg find_prob did i.year i.region men married higheduc urban log_trade if age_value==2, robust
eststo: reg find_prob did i.year i.region men married higheduc urban log_trade if age_value==3, robust
eststo: reg find_prob did i.year i.region men married higheduc urban log_trade if age_value==4, robust
eststo: reg find_prob did i.year i.region men married higheduc urban log_trade if age_value==5, robust
esttab using deneme.tex, se keep(did) replace
********************************************************
*************TABLO 13***********************************
eststo: reg log_realearning did i.year i.region men married higheduc urban ageeduc i.age_value timejob_dummy i.firmsize i.industry, robust
eststo: reg log_realearning did i.year i.region men married higheduc urban ageeduc i.age_value timejob_dummy i.firmsize i.industry log_trade, robust
eststo: reg log_realearning did i.year i.region married higheduc urban ageeduc i.age_value log_trade timejob_dummy i.firmsize i.industry if men==1, robust
eststo: reg log_realearning did i.year i.region married higheduc urban ageeduc i.age_value log_trade timejob_dummy i.firmsize i.industry if men==0, robust
eststo: reg log_realearning did i.year i.region men married urban ageeduc i.age_value log_trade timejob_dummy i.firmsize i.industry if higheduc==1, robust
eststo: reg log_realearning did i.year i.region men married urban ageeduc i.age_value log_trade timejob_dummy i.firmsize i.industry if loweduc==1, robust
esttab using deneme.tex, se r2 ar2  keep(did log_trade _cons) replace



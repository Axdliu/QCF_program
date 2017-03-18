/* Assignment 6.2 */


/* customer credit datasets */

PROC IMPORT out = BR1 datafile = "P:\assignment\6\6.2\data\LoanStats3a.csv" dbms = csv replace; RUN;
PROC IMPORT out = BR2 datafile = "P:\assignment\6\6.2\data\LoanStats3b.csv" dbms = csv replace; RUN;
PROC IMPORT out = BR3 datafile = "P:\assignment\6\6.2\data\LoanStats3c.csv" dbms = csv replace; RUN;
PROC IMPORT out = BR4 datafile = "P:\assignment\6\6.2\data\LoanStats3d.csv" dbms = csv replace; RUN;
PROC IMPORT out = BR5 datafile = "P:\assignment\6\6.2\data\LoanStats_2016Q1.csv" dbms = csv replace; RUN;
PROC IMPORT out = BR6 datafile = "P:\assignment\6\6.2\data\LoanStats_2016Q2.csv" dbms = csv replace; RUN;


DATA BR1_Select; SET BR1; MSLR = input(mths_since_last_record,8.); MSLMD = input(mths_since_last_major_derog, 8.); Drop mths_since_last_record mths_since_last_major_derog; RUN;
DATA BR2_Select; SET BR2; MSLR = input(mths_since_last_record,8.); MSLMD = input(mths_since_last_major_derog, 8.); Drop mths_since_last_record mths_since_last_major_derog; RUN;
DATA BR3_Select; SET BR3; MSLR = input(mths_since_last_record,8.); MSLMD = input(mths_since_last_major_derog, 8.); Drop mths_since_last_record mths_since_last_major_derog; RUN;
DATA BR4_Select; SET BR4; MSLR = input(mths_since_last_record,8.); MSLMD = input(mths_since_last_major_derog, 8.); Drop mths_since_last_record mths_since_last_major_derog; RUN;
DATA BR5_Select; SET BR5; MSLR = input(mths_since_last_record,8.); MSLMD = input(mths_since_last_major_derog, 8.); Drop mths_since_last_record mths_since_last_major_derog; RUN;
DATA BR6_Select; SET BR6; MSLR = input(mths_since_last_record,8.); MSLMD = input(mths_since_last_major_derog, 8.); Drop mths_since_last_record mths_since_last_major_derog; RUN;
 

DATA BR_full;
	Set BR1_Select BR2_Select BR3_Select BR4_Select BR5_Select BR6_Select;
RUN;


DATA BR_comp;

	SET BR_full;

	if length(issue_d) = 6 then year = ("20"||substr(issue_d, 1, 2)) + 0;
	else year = ("200"||substr(issue_d, 1, 1)) + 0;

	if substr(verification_status, 1, 3) = 'not' then verification = 0;
	else verification = 1;

	if grade = 'A' then grade_score = 5;
	else if grade = 'B' then grade_score = 0;
	else if grade = 'C' then grade_score = -5;
	else if grade = 'D' then grade_score = -10;
	else if grade = 'E' then grade_score = -15;
	else if grade = 'F' then grade_score = -20;
	else grade_score = -50;
	
	if home_ownership = "OWN" then home_score = 1;
	else home_score = 0;

	if pymnt_plan =. then pl_score = 0;
	else pl_score = 1;

	if substr(term, 1, 2) = 36 then term_score = 1;
	else term_score = 0;

	if loan_status = "Charged Off" or loan_status = "Default" then default = 1;
	else if loan_status = "Fully Paid" then default = 0;
	else delete;

	substr(int_rate, length(int_rate),1) = '';
	int_rate2 = int_rate/100;
	drop int_rate;
	rename int_rate2 = int_rate;

	substr(revol_util, length(revol_util),1) = '';
	revol_util2 = revol_util/100;
	drop revol_util;
	rename revol_util2 = revol_util;

	dti = dti/100.0;

	if mths_since_last_delinq =. then mths_since_last_delinq = 60;

	payment_pert = total_pymnt/funded_amnt;

	if verification = 1 then verified_dti = dti;
	else verified_dti = dti*3;

	acc_openrate = open_acc/total_acc;

	latefee_pert = total_rec_late_fee/funded_amnt;

	payment_speed = last_pymnt_amnt/installment;
	
RUN;

PROC sort DATA = BR_comp; by default; RUN;

%Let Parameters = payment_pert int_rate verified_dti inq_last_6mths pub_rec delinq_2yrs latefee_pert payment_speed verification;
/* payment_pert home_score int_rate revol_util term_score verified_dti inq_last_6mths pub_rec delinq_2yrs grade_score verification*/

DATA BR_select;
	SET BR_comp (keep = &Parameters year default); /* testing */
RUN;


PROC SORT DATA = BR_select; by year; RUN;


/* Analysis starts here */

/* Assignment tasks: 3 (insample from 2007-2016) */

ods pdf file = "P:\assignment\6\6.2\Assignemnt6.2_t3_report.pdf";

PROC logistic data = BR_select descending;
	model default = &Parameters; 
	output out = BR_select_log p = prob;
RUN;

Data BR_select_logselect;
	Set BR_select_log;
	if prob = . then delete;
	KEEP prob default;
RUN;

proc rank data = BR_select_logselect out = BR_select_logselect_rank groups = 10;
var prob;
ranks group;
run;

proc sort data = BR_select_logselect_rank; by group; run;
proc means data = BR_select_logselect_rank N sum; 
title "Model result";
by group;
ods output summary = BR_select_logselect_rank_Sta;
var prob default; run;

PROC SQL;
	CREATE TABLE data_logresult_rank_summary AS
	SELECT prob_N, prob_sum, default_sum, default_sum/sum(default_sum) as pert_default, prob_sum/sum(prob_sum) as pert_prob
	FROM BR_select_logselect_rank_Sta
QUIT;

Data data_logresult_rank_summaryF;
	SET data_logresult_rank_summary;
	pert_prob1 = put(pert_prob, percent8.2);
	pert_default1 = put(pert_default, percent8.2);
	drop pert_prob pert_default;
	label
		 prob_N = prob_N
		 prob_sum = prob_sum
		 default_sum = default_sum
		 pert_prob1 = total% of bankruptcy probability
		 pert_default1 = total% of default;
RUN;

Proc print data = data_logresult_rank_summaryF; RUN;
	
ods pdf close;




/* Assignment tasks: 4 (insample and outsample) */


%MACRO Hazard_BR;

%do i=2015 %to 2016; /* non-testing */

Data Year&i._train;
	set Br_comp;
	if year < &i;
RUN;

PROC logistic data = Year&i._train outest = beta_list2  descending noprint;
	model default = &Parameters; 
	output out = Year&i._logresult p = prob;
RUN;

/* Need to revise ***************************************************************************************************************************************** */
/* Parameters = payment_pert int_rate verified_dti inq_last_6mths pub_rec delinq_2yrs latefee_pert payment_speed verification */

Data Year&i._beta;
	set beta_list2;
	year = &i;
	rename 
		payment_pert = Beta_payment_pert
		int_rate = Beta_int_rate 
		verified_dti = Beta_verified_dti 
		inq_last_6mths = Beta_inq_last_6mths 
		pub_rec = Beta_pub_rec 
		delinq_2yrs = Beta_delinq_2yrs 
		verification = Beta_verification
		latefee_pert = Beta_latefee_pert
		payment_speed = Beta_payment_speed;
RUN;

Data Year&i._test;
	set Br_comp;
	if year = &i;
RUN;

Data temp_file;
	merge Year&i._test Year&i._beta;
	by year;
	Q = exp(intercept + payment_pert*Beta_payment_pert + int_rate*Beta_int_rate + verified_dti*Beta_verified_dti + inq_last_6mths*Beta_inq_last_6mths + pub_rec*Beta_pub_rec + 
			delinq_2yrs*Beta_delinq_2yrs + verification*Beta_verification + latefee_pert*Beta_latefee_pert + payment_speed*Beta_payment_speed);
	Prob = Q/(1+Q); 
	if Prob = . then delete;
RUN;

%if &i = 2015 %then %do;
	Data finalOutput;
		set temp_file;
	RUN;
	%end
%else %do;
	Data finalOutput;
		merge finalOutput temp_file;
		by year;
		if year = 0 then delete;
	RUN;
	%end

%END;

%MEND;

%Hazard_BR

ods pdf file = "P:\assignment\6\6.2\Assignemnt6.2_t4_report.pdf";

proc rank data = finalOutput out = finalOutput_rank groups = 10;
var prob;
ranks group;
run;

proc sort data = finalOutput_rank; by group; run;
proc means data = finalOutput_rank N sum; 
title "Model result out-sample";
by group;
ods output summary = finalOutput_rank_Sta;
var prob default; run;

PROC SQL;
	CREATE TABLE finalOutput_rank_summary AS
	SELECT prob_N, prob_sum, default_sum, default_sum/sum(default_sum) as pert_default, prob_sum/sum(prob_sum) as pert_prob
	FROM finalOutput_rank_Sta
QUIT;


Data finalOutput_rank_summaryF;
	SET finalOutput_rank_summary;
	pert_prob1 = put(pert_prob, percent8.2);
	pert_default1 = put(pert_default, percent8.2);
	drop pert_prob pert_default;
	label
		 prob_N = prob_N
		 prob_sum = prob_sum
		 default_sum = default_sum
		 pert_prob1 = total% of bankruptcy probability
		 pert_default1 = total% of default;
RUN;

Proc print data = finalOutput_rank_summaryF; RUN;

ods pdf close;

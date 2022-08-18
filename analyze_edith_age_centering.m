%% Code for analysing age-related effect of behaviour (CEBQ scores) on cortical thickness using age-centering approach

clear ;
clc ;

load Linda_CEBQ_146subjects
% load Linda_EDEQ_152subjects
load('mask_latest.mat')
load('avsurf_latest.mat')

load subj_bmi ;

[C,a,b] = intersect(subj_QC_behav_age_sex, subj) ;

subj  = subj_num(a) ;
age   = age_behav_sex(a) ;
sex   = sex_behav(a) ;
behav = CEBQ_CT_age_sex(:,36) ;                 %36-43: 36 = Food Responsiveness Score, 37 = Emotional Overeating Score, 38=EnjoymentofFoodScore, 39=DesiretoDrinkScore, 40=Satiety Responsiveness Score, 41 = Slowness in eating Score, 42=Emotional Under-Eating Score, 43=Food Fussiness Score
behav = behav(a) ;
bmi   = bmi(b) ; 
Y     = CT_behav_age_sex(a,:) ;

index = find(~isnan(behav)) ;
subj  = subj(index) ;
age   = age(index) ;
sex   = sex(index) ;
behav = behav(index) ;
bmi   = bmi(index) ;
Y     = Y(index,:) ;

p = [6, 7, 8, 9, 10, 11, 12, 13, 14] ;          % Different age ranges 
age = age - p ;                                 % Age-centering approach

Subj  = term(subj) ;
Age   = term(age) ;
Sex   = term(sex) ;
Behav = term(behav) ;
BMI   = term(bmi) ;

M = 1 + Age + Sex + BMI + Behav + Age*Behav + random(Subj) + I ;

slm = SurfStatLinMod(Y,M,avsurf) ;    
slm = SurfStatT(slm, behav) ;  

SurfStatView(slm.t.*mask, avsurf, 'T-map') ;
SurfStatColLim([-4 4])
figure; SurfStatView(SurfStatP(slm, mask), avsurf, 'RFT-corrected') ;
% figure; SurfStatView(SurfStatQ(slm, mask), avsurf, 'FDR-corrected') ;

%% Code for analysing interaction of behaviour (CEBQ scores) and sex on cortical thickness

clear ;
clc ;

load Linda_CEBQ_146subjects                     % data
% load Linda_EDEQ_152subjects
load('mask_latest.mat')
load('avsurf_latest.mat')

load subj_bmi ;

[C,a,b] = intersect(subj_QC_behav_age_sex, subj) ;

subj  = subj_num(a) ;
age   = age_behav_sex(a) ;
sex   = sex_behav(a) ;
behav = CEBQ_CT_age_sex(:,43) ;                 %36-43: 36 = Food Fusiness Score, 37 = Emotional Overeating Score, 41 = Slowness in eating Score
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

gender = cell(length(sex),1) ;
for i=1:length(sex)
    if sex(i)==1
       gender(i) = {'Male'} ;
    end
    if sex(i)==2
       gender(i) = {'Female'} ;
    end  
end

Subj  = term(subj) ;
Age   = term(age) ;
Sex   = term(sex) ;
Gender = term(gender) ;
Behav = term(behav) ;
BMI   = term(bmi) ;

M = 1 + Age + Gender + BMI + Behav + Behav*Gender + random(Subj) + I ;

contrast = Gender.Male - Gender.Female ;

slm = SurfStatLinMod(Y,M,avsurf) ; 
slm = SurfStatT(slm, behav.*contrast) ;  

SurfStatView(slm.t.*mask, avsurf, 'T-map') ;
SurfStatColLim([-4 4])
figure; SurfStatView(SurfStatP(slm, mask), avsurf, 'RFT-corrected') ;
figure; SurfStatView(SurfStatQ(slm, mask), avsurf, 'FDR-corrected') ;

% seed  = find(slm.t==max(slm.t)) ;
% Yseed = double(Y(:,seed));
% % figure; SurfStatPlot(behav,Yseed,[age,sex]) ;
% % figure; SurfStatPlot(behav, Yseed, 1, gender) ;
% figure; SurfStatPlot(behav, Yseed, 1, gender) ;

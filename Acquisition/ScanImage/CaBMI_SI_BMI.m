function CaBMI_SI_BMI

clear BMI_Data;
BMI_Data.time = 1;
BMI_Data.Frame = zeros(515,512)
counter = 1; Tstart = tic; 
out =  automatedGrab_BMI();

function outVec = getdeath_1(inputM, stage5ind,miStage, table,reduCol)

outVec = nan(length(stage5ind),1);  %make empty output vector to fill
age = inputM(:,1);
ckd = inputM(:,2);
gfr = inputM(:,3);
cvd = inputM(:,4);
diabetes = inputM(:,5);
ht = inputM(:,6);
micro = inputM(:,7);
macro = inputM(:,8);

%loop over individuals
for personNum = 1:length(age)
    correctRow = (age(personNum) == table(:,1)); %finds the row number in the table matches the age
    if micro(personNum)==1 || macro(personNum)==1
        if gfr(personNum)>=60
            coef = 1.77/1;
        elseif gfr(personNum)>=45
            coef = 2.36/1.03;
        else
            coef = 3.04/1.66;
        end
    else
        coef = 1;
    end
    %Normal or stage 1 and 2
    if ckd(personNum)==0 ||ckd(personNum)==1 ||ckd(personNum)==2
        outVec(personNum,1) = coef*(table(correctRow,7) + table(correctRow,8));
    end
    %first part of stage 3
    if gfr(personNum)>=45 && gfr(personNum)<=59
        outVec(personNum,1) = coef*(table(correctRow,9) +table(correctRow,10));
    end
    %second part of stage 3
    if gfr(personNum)>=30 && gfr(personNum)<45
        outVec(personNum,1) = coef*(table(correctRow,11) + table(correctRow,12));
    end
    %stage 4
    if ckd(personNum)==4
        outVec(personNum,1) = coef*(table(correctRow,13) + table(correctRow,14));
    end
    %first year stage 5
    if ckd(personNum)==5 && stage5ind(personNum)==1
        outVec(personNum,1) = coef*(table(correctRow,13) + table(correctRow,14));
    end
    %stage 5 after first year and get diabetes
    if ckd(personNum)==5 && stage5ind(personNum)>=2 && diabetes(personNum)==1
        outVec(personNum,1) = table(correctRow,15);
    end
    %stage 5 after first year and get both diabetes and hypertension, use
    %the maximum rate(diabetes)
    if ckd(personNum)==5 && stage5ind(personNum)>=2 && diabetes(personNum)==1 % && ht(personNum)==1
        outVec(personNum,1) = table(correctRow,15);
    end
    %stage 5 after first year and get hypertension
    if ckd(personNum)==5 && stage5ind(personNum)>=2 && ht(personNum)==1 && diabetes(personNum)==0
        outVec(personNum,1) = table(correctRow,16);
    end
    %neither
    if ckd(personNum)==5 && stage5ind(personNum)>=2 && diabetes(personNum)==0 && ht(personNum)==0
        outVec(personNum,1) = table(correctRow,17);
    end
    
    %if got mi
    if miStage(personNum)==1
        outVec(personNum,1) = outVec(personNum,1) + table(correctRow,18);
    end
    
    if miStage(personNum) >=2
        outVec(personNum,1) = outVec(personNum,1) + table(correctRow,19);
    end
    outVec(personNum,1) = (1-0.23)^(reduCol(personNum)) * outVec(personNum,1);
end
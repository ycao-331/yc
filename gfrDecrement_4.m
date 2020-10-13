function outcomeVec = gfrDecrement_4(ageid,raceid, femaleid, gfrScore, gfrThresh,gfrThresh_30, gfrThresh_15, macroStat,ht, diabetes, coefficient,reduction)
%enter entire gfr and proteinuria columns
%decrease gfr based on characteristics

for personNum = 1:length(gfrScore)
    if gfrThresh(personNum) == 1
        coef = 1;
    else
        if raceid(personNum) == 1
            if gfrThresh_30(personNum) == 1
                coef = 1.25;
            elseif gfrThresh_15(personNum) == 1
                coef = 1.5;
            else
                coef = 1;
            end
        else
            if gfrThresh_30(personNum) == 1
                coef = 0.875;
            elseif gfrThresh_15(personNum) == 1
                coef = 1;
            else
                coef = 1;
            end
        end
    end
    
    if femaleid(personNum) == 1
        gendercoef = 0.91/0.97;
    else
        gendercoef = 1;
    end
    %neither
    if ht(personNum)==0 && diabetes(personNum)==0
        newScore = gfrScore(personNum) - gendercoef*coef*((1-ageid(personNum))*(0.85*gfrThresh(personNum)*(1-macroStat(personNum))...
            + 0.85*(1-gfrThresh(personNum))*(1-macroStat(personNum))  ...
            + 0.935*gfrThresh(personNum)*macroStat(personNum) ...
            + 4.2*(1-gfrThresh(personNum))*macroStat(personNum)) ...
            + (ageid(personNum))*(1*gfrThresh(personNum)*(1-macroStat(personNum))...
            + 1*(1-gfrThresh(personNum))*(1-macroStat(personNum))  ...
            + 1.1*gfrThresh(personNum)*macroStat(personNum) ...
            + 4.2*(1-gfrThresh(personNum))*macroStat(personNum)));
        outcomeVec(personNum,1) = max(newScore*coefficient(personNum,1),0);  %writes new gfr to output vector
    end
    %for hyper tension
    if ht(personNum)==1 && diabetes(personNum)==0
        newScore = gfrScore(personNum) - gendercoef*coef*((1-ageid(personNum))*(0.935*gfrThresh(personNum)*(1-macroStat(personNum))...
            + 1.4*(1-gfrThresh(personNum))*(1-macroStat(personNum))  ...
            + 1.02*gfrThresh(personNum)*macroStat(personNum) ...
            + 3.9*(1-gfrThresh(personNum))*macroStat(personNum)) ...
            + (ageid(personNum))*(1.1*gfrThresh(personNum)*(1-macroStat(personNum))...
            + 1.4*(1-gfrThresh(personNum))*(1-macroStat(personNum))  ...
            + 1.2*gfrThresh(personNum)*macroStat(personNum) ...
            + 3.9*(1-gfrThresh(personNum))*macroStat(personNum)));
        outcomeVec(personNum,1) = max(newScore*coefficient(personNum,1),0);  %writes new gfr to output vector
    end
    %for diabetes
    if diabetes(personNum)==1
        newScore = gfrScore(personNum) - gendercoef*coef*((1-ageid(personNum))*(0.935*gfrThresh(personNum)*(1-macroStat(personNum))...
            + 2.8*(1-gfrThresh(personNum))*(1-macroStat(personNum))  ...
            + 4.1*gfrThresh(personNum)*macroStat(personNum) ...
            + 5.2*(1-gfrThresh(personNum))*macroStat(personNum)) ...
            + (ageid(personNum))*(1.1*gfrThresh(personNum)*(1-macroStat(personNum))...
            + 2.8*(1-gfrThresh(personNum))*(1-macroStat(personNum))  ...
            + 4.1*gfrThresh(personNum)*macroStat(personNum) ...
            + 5.2*(1-gfrThresh(personNum))*macroStat(personNum)));
        outcomeVec(personNum,1) = max(newScore*coefficient(personNum,1),0);  %writes new gfr to output vector
    end
    outcomeVec(personNum,1) = (1-0.327)^(reduction(personNum)) * outcomeVec(personNum,1);
end
end

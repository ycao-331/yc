function outVec = lookupProbs(Table, ages, genders, ht, diabetes,reduction)

outVec = nan(length(ages),1);  %make empty output vector to fill

%loop over individuals
for personNum = 1:length(ages)
    correctRow = (ages(personNum) == Table(:,1)); %finds the row number in the table matches the age
    tempvec = [4,2*ht(personNum)+4*diabetes(personNum)];%create a vector with two elements
    diseaseindx = min(tempvec);%finds the minumum of the vector tepvec and the result represents the shift in column while reading the table
    outVec(personNum,1) = Table(correctRow, genders(personNum)+1+diseaseindx);%writes probability to output vector; add 1 to offset age column
    if reduction(personNum) ==1
        prob = randscr(1,1,[0,1;0.45,0.55]);
        outVec(personNum,1) = Table((correctRow-(prob*1)), genders(personNum)+1+diseaseindx); 
end

end

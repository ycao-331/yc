clear
clear all
close all
clc
%directory name: C:\Users\User\Desktop\CKD_Recent\Simulation (2)\Simulation


%% initialize stateMatrix

%stateMatrix has all people information
size = 10000;

%initialize
format longG
microFile = 'microTESTcomplete.csv';
macroFile = 'macroIncidencecomplete.csv';
diabetesFile = 'diabetesIncidence.csv';
smokingFile = 'smokingPrev.csv';
noCkdSbpFile = 'noCkdSbp.csv';
yesCkdSbpFile = 'yesCkdSbp.csv';
deathFile = 'deathprobs_Validated.xlsx';
microTable = csvread(microFile);
macroTable = csvread(macroFile); %use csvread to read from a csv
diabetesPrevTable = csvread(diabetesFile);
smokingPrevTable = csvread(smokingFile);
noCkdSbpTable = csvread(noCkdSbpFile);
yesCkdSbpTable = csvread(yesCkdSbpFile);

%                {1   2  3  4  5  6  7  8  9    10  11   12  13 14 15 16 17 18 19 20
% stateMatrix = [55, 60, 1, 0, 1, 0, 1, 1, 135, 1,  230, 48,  0, 0, 1, 0, 0, 0, 0, 0;
%                31, 73, 1, 1, 1, 0, 1, 1, 135, 1,  230, 48,  0, 0, 0, 0, 0, 0, 0, 0;
%                30, 100, 0, 0, 1, 0,1, 1, 135, 1, 230,  48,  0, 0, 4, 0, 0, 0, 0, 0;
%                38, 60, 0, 0, 1, 0, 1, 1, 141, 1,  230, 48,  0, 0, 0, 0, 0, 0, 0, 0]; assuming this starting matrix - can create code to generate matrix later
stateMatrix = zeros(size,24);
ageCol = 1;
gfrCol = 2;
microCol = 3;
macroCol = 4;
genderCol = 5;% male = 1 , female = 2
raceCol = 6; % white = 1, black = 2, hispanic = 3
htCol = 7;
diabetesCol = 8;
sbpCol = 9;
smokeCol = 10; % 1=yes, 0=no
totalColCol = 11;
hdlColCol = 12;
lvhCol = 13;
percentCol = 14;
ckdCol = 15;
chdCol = 16;
miCol = 17;
strokeCol = 18;
cvdCol = 19;
deathCol=20;
costCol = 21;
esrdCol = 22;
qalyCol = 23;
reduCol = 24;

%%
%Check Input eGFR, race gender, and treatment effect!!!
initialage = 30;
timehorizon = 90-initialage;

%initiate age column
%stateMatrix(:,ageCol)=30;
stateMatrix(:,ageCol) = initialage;
%initiate gfr column
%rng(0,'twister');
% Std = 14;
% Mean = 55;

% Std = 14;
% Mean = 45; 
  
% Std = 14;
% Mean = 30;

% Std = 0;
% Mean = 15;
 Std = 19.313;
Mean = 101.9409;

gfrInitial = Std.*randn(size,1) + Mean;
stateMatrix(:,gfrCol) = gfrInitial;

gfr = stateMatrix(:,gfrCol);

reduction = 0.2; %treatment effect
testcase = 1; %0:base 1:all male 2:all female
%%

%initiate the race and gender
WMnum = floor(size*0.36522);
BMnum = floor(size*0.06045);
HMnum = floor(size*0.07758);
WFnum = floor(size*0.35729);
BFnum = floor(size*0.06723);
HFnum = floor(size*0.07224);
leftNum = size- WMnum - BMnum - HMnum-WFnum - BFnum- HFnum;
%assert(leftNum/size <= 0.001);

%make all male for validation purposes
if testcase == 1
    WFnum = 0;
    BFnum = 0;
    HFnum = 0;
end

%make all female for validation purposes
if testcase == 2
    WMnum = 0;
    BMnum = 0;
    HMnum = 0;
end

%make all white male for validation purposes
if testcase == 3
BMnum = 0;
HMnum = 0;
WFnum = 0;
BFnum = 0;
HFnum = 0;
end

%make all white female for validation purposes
if testcase == 4
WMnum = 0;
BMnum = 0;
HMnum = 0;
BFnum = 0;
HFnum = 0;
end

%make all black male for validation purposes
if testcase == 5
WMnum = 0;
HMnum = 0;
WFnum = 0;
BFnum = 0;
HFnum = 0;
end

%make all black female for validation purposes
if testcase == 6
WMnum = 0;
BMnum = 0;
HMnum = 0;
WFnum = 0;
HFnum = 0;
end

WMnumT = WMnum;
BMnumT = BMnum;
HMnumT = HMnum;
WFnumT = WFnum;
BFnumT = BFnum;
HFnumT = HFnum;

WMnum = floor(size*WMnumT/(WMnumT+BMnumT+HMnumT+WFnumT+BFnumT+HFnumT));
BMnum = floor(size*BMnumT/(WMnumT+BMnumT+HMnumT+WFnumT+BFnumT+HFnumT));
HMnum = floor(size*HMnumT/(WMnumT+BMnumT+HMnumT+WFnumT+BFnumT+HFnumT));
WFnum = floor(size*WFnumT/(WMnumT+BMnumT+HMnumT+WFnumT+BFnumT+HFnumT));
BFnum = floor(size*BFnumT/(WMnumT+BMnumT+HMnumT+WFnumT+BFnumT+HFnumT));
HFnum = floor(size*HFnumT/(WMnumT+BMnumT+HMnumT+WFnumT+BFnumT+HFnumT));

%generate the random index for each race and gender
WMind = randsample(size,WMnum);
left = setdiff(1:size,WMind);
BMind = randsample(left,BMnum);
left = setdiff(left,BMind);
HMind = randsample(left,HMnum);
left = setdiff(left,HMind);
WFind = randsample(left,WFnum);
left = setdiff(left,WFind);
BFind = randsample(left,BFnum);
left = setdiff(left,BFind);
HFind = randsample(left,HFnum);
left = setdiff(left, HFind);

%initiate the gender and race colomn of the state matrix
%White male
stateMatrix(WMind,raceCol)=1;
stateMatrix(WMind,genderCol)=1;
stateMatrix(left,raceCol)=1;
stateMatrix(left,genderCol)=1;
%Black male
stateMatrix(BMind,raceCol)=2;
stateMatrix(BMind,genderCol)=1;
%Hispanic male
stateMatrix(HMind,raceCol)=3;
stateMatrix(HMind,genderCol)=1;
%White female
stateMatrix(WFind,raceCol)=1;
stateMatrix(WFind,genderCol)=2;
%Black female
stateMatrix(BFind,raceCol)=2;
stateMatrix(BFind,genderCol)=2;
%Hispanic female
stateMatrix(HFind,raceCol)=3;
stateMatrix(HFind,genderCol)=2;


N = size; %number of people
stage5Ind = zeros(N,1);
miInd = zeros(N,1);
%generate lifetime percentile for simulating total Cholesterol
randForcho = rand(size,1);

costYear=zeros(size,timehorizon); %tracks cost per year for a person
qalyYear=zeros(size,timehorizon);
costYearDisc=zeros(size,1);
qalyYearDisc=zeros(size,1);

%lifetime for each person
liveyear = zeros(N,1)+30;
%initialize test variables
microNum = zeros(timehorizon,1);
macroNum = zeros (timehorizon,1);
diabetesNum = zeros(timehorizon,1);
htNum = zeros(timehorizon,1);
NsmokeWM = zeros(1,1);
NsmokeBM = zeros(1,1);
NsmokeHM = zeros(1,1);
NsmokeWF = zeros(1,1);
NsmokeBF = zeros(1,1);
NsmokeHF = zeros(1,1);

ckdstage0Num = zeros(timehorizon,1);
ckdstage1Num = zeros(timehorizon,1);
ckdstage2Num = zeros(timehorizon,1);
ckdstage3Num = zeros(timehorizon,1);
ckdstage4Num = zeros(timehorizon,1);
ckdstage5Num = zeros(timehorizon,1);
lvhNum = zeros(timehorizon,1);
deathNum = zeros(timehorizon,1);
cvdNum = zeros(timehorizon,1);
miNum = zeros(timehorizon,1);
chdNum = zeros(timehorizon,1);
strokeNum = zeros(timehorizon,1);
sbpmean = zeros(timehorizon,1);

chdever = zeros(size,1);
cvdever = zeros(size,1);

CHDincidentMI = zeros(size,1);

strokeEver = zeros(size,1);
stage3gfr = zeros(timehorizon,1);
alivenum = zeros(timehorizon,1)+size;


%test total cholesterol at specific age
totchoPer = zeros(6,10);
choind = 1;

%test SBP value of non-ckd man
SBPmatrix = zeros(6,11);
sbpind =1;

%construct matrix to record average year at each ckd stage
%column1: ckd stage, column2-7: counters for recording ckd stage from normal
%to stage 5
ckdYmatrix= zeros(N,7);

%% set constant values

%% initiate smoking (Section 4.4)
raceMat = stateMatrix(:, raceCol);
genderMat = stateMatrix(:, genderCol);
smokePrev = lookupSmokePrev(smokingPrevTable, raceMat, genderMat);

%simulate if these people are smokers (Section 4.4)
isSmoker = simulateProtein(smokePrev, N);
stateMatrix(:,smokeCol) = isSmoker;  %write down new smoking status

%test
smoker = find(stateMatrix(:,smokeCol)==1);
WMsmoker = find(stateMatrix(smoker,raceCol)==1 & stateMatrix(smoker,genderCol)==1);
BMsmoker = find(stateMatrix(smoker,raceCol)==2 & stateMatrix(smoker,genderCol)==1);
HMsmoker = find(stateMatrix(smoker,raceCol)==3 & stateMatrix(smoker,genderCol)==1);
WFsmoker = find(stateMatrix(smoker,raceCol)==1 & stateMatrix(smoker,genderCol)==2);
BFsmoker = find(stateMatrix(smoker,raceCol)==2 & stateMatrix(smoker,genderCol)==2);
HFsmoker = find(stateMatrix(smoker,raceCol)==3 & stateMatrix(smoker,genderCol)==2);

NsmokeWM = length(WMsmoker);
NsmokeBM = length(BMsmoker);
NsmokeHM = length(HMsmoker);
NsmokeWF = length(WFsmoker);
NsmokeBF = length(BFsmoker);
NsmokeHF = length(HFsmoker);

%% HDL cholesterol (Section 4.3)
HDLgender = stateMatrix(:, genderCol);

%initiate HDL Cholesterol
HDLcho = getHDLcho(HDLgender);
stateMatrix(:, hdlColCol) = HDLcho;

%% initiate LVH(Section 4.5)
LVHrace = stateMatrix(:,raceCol);
LVHckd = stateMatrix(:,ckdCol);

LVHprev = lookupLVH(LVHrace,LVHckd);

%simulate if these people get LVH (Section 4.5)
isLVH = simulateProtein(LVHprev, N);
stateMatrix(:,lvhCol) = isLVH;  %write down new lvh status
%% Framingham Equation: Set-Up

%initiate numbers to identify which outcome you want to predict
timeFrame = 1;
chd = 1;
mi = 2;
chdDeath = 3;
stroke = 4;
cvd = 5;
cvdDeath = 6;

%% assign percentile

percentile = assignPercent(N);
stateMatrix(:,percentCol) = percentile;

%% running simulation
%change age

for i = 1:timehorizon
    %% get data of people that are dead
    aliveP = find(stateMatrix(:,deathCol)==0);
    if isempty(aliveP) == 1
        break
    else
        aliveN =length(aliveP);
        
        %% count stage 5 years
        aliveFive = find(stateMatrix(:,ckdCol)==5 & stateMatrix(:,deathCol)==0);
        stateMatrix(aliveFive,esrdCol) = stateMatrix(aliveFive,esrdCol)+1;
        
        %% hold current MI condition
        
        lastyearMI = stateMatrix(aliveP,miCol);
        
        %% simulate diabetes (Section 4.1)
        nodiabetes = find(stateMatrix(:,diabetesCol)==0 & stateMatrix(:,deathCol)==0); %get the people without diabetes
        ageMat = stateMatrix(nodiabetes,ageCol);
        raceMat = stateMatrix(nodiabetes,raceCol);
        genderMat = stateMatrix(nodiabetes,genderCol);
        diaPrev = lookupDiaPrev(diabetesPrevTable, ageMat, raceMat, genderMat);
        
        %simulate if these people get diabetes
        isDiabetic = simulateProtein(diaPrev, length(nodiabetes));
        stateMatrix(nodiabetes, diabetesCol) = isDiabetic;
        %% simulate total cholesterol (Section 4.3)
        %this is an input for Framingham
        %polynomial - use exponents
        totalchoAges = stateMatrix(aliveP, ageCol); %get their ages
        totalchoGender = stateMatrix(aliveP, genderCol); %get their genders
        
        %simulate total Cholesterol
        totalCHO = gettotalCHO(totalchoAges, totalchoGender,randForcho);
        stateMatrix(aliveP, totalColCol) = totalCHO;
        
        %test total cholesterol for man
        if i==1 || i == 11 || i == 21 || i == 31 ||  i== 41 || i == 56
            alivetotal = stateMatrix(aliveP,totalColCol);
            man = find(stateMatrix(aliveP,genderCol)==1);
            mantotal = alivetotal(man,1);
            totchoPer(choind,:)= [i+29,prctile(mantotal,[5,10,15,25,50,75,85,90,95])];
            choind = choind + 1;
        end
        %% simulate LVH (Section 4.5)
        %this is an input for Framingham
        
        
        %% simulate if people get micro (Section 3.1)
        %find people without micro
        noMicro = find(stateMatrix(:,microCol)==0 & stateMatrix(:,deathCol)==0); %returns vector of row numbers of ppl without micro
        microAges = stateMatrix(noMicro, ageCol); %get their ages
        microGender = stateMatrix(noMicro, genderCol); %get their genders
        microHT = stateMatrix(noMicro, htCol); %get their hypertension status
        microDiab = stateMatrix(noMicro, diabetesCol); %get their diabetes status
        microRedu = stateMatrix(noMicro,reduCol);
        %whether patients have reduction rate
        withMicro = find(stateMatrix(:,microCol)==1 & stateMatrix(:,deathCol)==0);
        stateMatrix(withMicro,reduCol) = simulateProtein(0.75,length(withMicro));
        
        
        microProbs = lookupProbs(microTable, microAges, microGender, microHT, microDiab,microRedu);
        noMicroN = length(noMicro); %get number of people who have micro
        
        %simulate if these people get micro
        getMicro = simulateProtein(microProbs, noMicroN);
        stateMatrix(noMicro,microCol) = getMicro;  %write down new micro status
        

        
        %% simulate if people get macro (Section 3.1)
        %find people with micro and without macro
        noMacro = find(stateMatrix(:,macroCol)==0 & stateMatrix(:,microCol)==1 & stateMatrix(:,deathCol)==0); %returns vector of row numbers of ppl without macro and WITH micro
        microStatus = stateMatrix(noMacro,microCol);%get their micro status
        
        
        macroAges = stateMatrix(noMacro, ageCol); %get their ages
        macroGender = stateMatrix(noMacro, genderCol); %get their genders
        macroHT = stateMatrix(noMacro, htCol); %get their hypertension status
        macroDiab = stateMatrix(noMacro, diabetesCol); %get their diabetes status
        macroProbs = lookupProbs(macroTable, macroAges, macroGender, macroHT,macroDiab,microRedu);
        noMacroN = length(noMacro); %get number of people who have macro
        
        %simulate if these people get macro
        getMacro = simulateProtein(macroProbs, noMacroN);
        stateMatrix(noMacro,macroCol) = getMacro;  %write down new macro status
        
        %find out people get macro in this loop
        newMacro = find(stateMatrix(noMacro,macroCol)==1);
        %set the micro status of these people to 0
        microStatus(newMacro,1)=0;
        %write dowm new micro status to the state matrix
        stateMatrix(noMacro,microCol)= microStatus;
        
        withMacro = find(stateMatrix(:,macroCol)==1 & stateMatrix(:,deathCol)==0);
        stateMatrix(withMacro,reduCol) = simulateProtein(0.75,length(withMacro));
        
        %% decrease GFR (Section 3.2)
        ageid = stateMatrix(aliveP,ageCol)>=50;
        raceid = stateMatrix(aliveP,raceCol)==2;
        femaleid = stateMatrix(aliveP,genderCol)==2;
        gfrVal = stateMatrix(aliveP,gfrCol); %get gfr values of everyone
        y = stateMatrix(aliveP,gfrCol)>= 60; %returns logical matrix
        y1 = stateMatrix(aliveP,gfrCol)>=30 & stateMatrix(aliveP,gfrCol)<=59;
        y2 = stateMatrix(aliveP,gfrCol)>=15 & stateMatrix(aliveP,gfrCol)<=29;
        
        macroStat = stateMatrix(aliveP,macroCol); %returns column of macro statuses
        %microStat = stateMatrix(aliveP,microCol); %returns column of macro statuses
        %proteinStat = max(microStat,macroStat);
        % debug: we should make sure that GFR can't be < 0- figure out why it does that
        % and fix
        coefficient = ones(aliveN,1);
        %generate random number from triangular distribution
        %td = makedist('Triangular','a',0,'b',1,'c',2);
        %rng('default');  % For reproducibility
        %coefficient(micro,1)= random(td,microLength,1);%generate rundom numer
        htStat = stateMatrix(aliveP,htCol);
        diabetesStat = stateMatrix(aliveP,diabetesCol);
        reduStat = stateMatrix(aliveP,reduCol);
        gfrNew = gfrDecrement_4(ageid, raceid, femaleid, gfrVal, y, y1, y2, macroStat,htStat, diabetesStat,coefficient,reduStat);
        %     gfrNew = gfrDecrement(gfrVal, y, macroStat,htStat, diabetesStat,coefficient);
        stateMatrix(aliveP,gfrCol) = gfrNew; %replace old gfr values with new ones
        
        %% CKD SIMULATON
        Normal= find(stateMatrix(:,ckdCol)==0 & stateMatrix(:,deathCol)==0); %returns vector of row numbers of ppl with normal ckd stage(use later for update onetime lvh)
        
        ckdGFR = stateMatrix(aliveP,gfrCol); %get gfr values of everyone
        ckdMicro = stateMatrix(aliveP,microCol); %get the micro column
        ckdMacro = stateMatrix(aliveP,macroCol); %get the macro column
        
        %determine the CKD state
        ckdState = getCKDstate(ckdMicro, ckdMacro, ckdGFR);
        stateMatrix(aliveP,ckdCol) = ckdState;
        
        stage5= find(stateMatrix(:,ckdCol)==5);
        stage5Ind(stage5,1) = stage5Ind(stage5,1) + 1;
        
        
        % LVH onetime incidence upon CKD Incidence
        newCKD= stateMatrix(Normal,ckdCol); %get their updated ckd state after simulation
        thisrace = stateMatrix(Normal, raceCol);%get their races
        thisLVH = stateMatrix(Normal, lvhCol); %get their LVH status
        newLVH = LVHonetime(thisrace, thisLVH, newCKD); %update LVH status
        
        
        %simulate if these people get LVH
        stateMatrix(Normal, lvhCol) = newLVH;  %write down new macro status
        
        % update the counter for each individual of its time at each ckd stage
        ckdalive = stateMatrix(aliveP,ckdCol);%get the ckd stage of alive people
        ckdYalive = ckdYmatrix(aliveP,:);%get their ckd year counter
        ckdYmatrix(aliveP,:) = update_ckdcounter(ckdYalive,ckdalive,aliveN);%update the counter
        
        %% simulate SBP without CKD (Section 4.2)
        %this is used to determine HT
        %uses percentiles, constant
        
        noCkd = find(stateMatrix(:,ckdCol)==0 & stateMatrix(:,deathCol)==0); %returns vector of row numbers of ppl without ckd
        noCkdPercentiles = stateMatrix(noCkd, percentCol); %get their percentage
        noCkdAges = stateMatrix(noCkd, ageCol); %get their ages
        noCkdGender = stateMatrix(noCkd, genderCol); %get their genders
        noCkdRace = stateMatrix(noCkd, raceCol); %get their races
        
        %calculate sbp from the equation
        noCkdsbpVal = SBPequation(noCkdPercentiles, noCkdAges, noCkdGender,noCkdRace);
        %lookup sbp table
        %noCkdsbpVal = lookupSBP(noCkdSbpTable, noCkdPercentiles, noCkdAges, noCkdGender);
        stateMatrix(noCkd,sbpCol) = noCkdsbpVal;
        
        
        
        %% simulate SBP with CKD (Section 4.2)
        %this is used to determine HT
        %uses percentiles, constant
        
        yesCkd = find(stateMatrix(:,ckdCol)~=0 & stateMatrix(:,deathCol)==0); %returns vector of row numbers of ppl with ckd
        yesCkdPercentiles = stateMatrix(yesCkd, percentCol); %get their ages
        yesCkdAges = stateMatrix(yesCkd, ageCol);%get their ages
        yesCkdGender = stateMatrix(yesCkd, genderCol); %get their genders
        yesCkdRace = stateMatrix(yesCkd, raceCol);
        yesCkdsbpVal = YesSBPequation(yesCkdPercentiles, yesCkdAges, yesCkdGender,yesCkdRace);
        %lookup sbp table
        %yesCkdsbpVal = lookupSBP(yesCkdSbpTable, yesCkdPercentiles, yesCkdAges, yesCkdGender);
        stateMatrix(yesCkd,sbpCol) = yesCkdsbpVal;
        
        %% simulate HT (Section 4.2)
        %if SBP >140
        htYes = stateMatrix(aliveP,sbpCol)> 140;
        stateMatrix(aliveP,htCol) = htYes;
        
        %% Framingham Equation for chronic conditions (stroke, MI, cvd, chd)
        
        %get the people with and without CHD
        
        CHDmatrix = stateMatrix(aliveP,[genderCol,ageCol,sbpCol,smokeCol,totalColCol,hdlColCol,diabetesCol,lvhCol]);
        constantFile = 'sbpPrediction.csv';
        constantTable = csvread(constantFile);
        
        %chd simulation
        randNum = rand(N,1);
        chdProb = riskPredict(CHDmatrix,constantTable,chd,timeFrame);
        thisgfr = stateMatrix(aliveP,gfrCol);
        newchdProb = multiplier(thisgfr, chdProb);
        ifchd =  randNum(aliveP,1) <= newchdProb;
        stateMatrix(aliveP,chdCol) = ifchd;
        
        
        %mi simulation
        yesCHD = find(stateMatrix(:,chdCol)==1 & stateMatrix(:,deathCol)==0);
        stateMatrix(yesCHD,cvdCol)=1;
        %extract the random number
        yesCHDrand = randNum(yesCHD,1);
        %this line tests CHD lifetime incidence
        chdever(yesCHD,1)=1;
        %continue mi simulation
        yeschdMatrix = stateMatrix(yesCHD,[genderCol,ageCol,sbpCol,smokeCol,totalColCol,hdlColCol,diabetesCol,lvhCol]);
        miProb = riskPredict(yeschdMatrix,constantTable,mi,timeFrame);
        thisgfr = stateMatrix(yesCHD,gfrCol);
        newMI = multiplier(thisgfr, miProb);
        
        %if people are assigned with CVD, their chances of getting MI increase,
        %so multiply by the index 2.19
        yesCVD = find(stateMatrix(yesCHD, cvdCol)==1);
        getMI = newMI(yesCVD,1);
        getMI = getMI * 2.19;
        newMI(yesCVD,1) = getMI;
        stateMatrix(yesCHD,miCol) = yesCHDrand <= newMI;
        
        %update MI index
        yesMI= find(stateMatrix(:,miCol)==1& stateMatrix(:,deathCol)==0);
        miInd(yesMI,1) = miInd(yesMI,1) + 1;
        
        %test CHDincidentMI lifetime incidence
        CHDincMI = find(stateMatrix(:,chdCol)==1 & stateMatrix(:,miCol)==1);
        CHDincidentMI(CHDincMI,1)=1;
        
        %stroke simulation
        thisgfr = stateMatrix(aliveP,gfrCol);
        StrokeMatrix = stateMatrix(aliveP,[genderCol,ageCol,sbpCol,smokeCol,totalColCol,hdlColCol,diabetesCol,lvhCol]);
        strokeProb = riskPredict(StrokeMatrix,constantTable,stroke,timeFrame);
        newStroke = multiplier(thisgfr,strokeProb);
        
        %take out the probability of subsequent stroke events
        
        yesCVD = find(stateMatrix(aliveP,cvdCol)==1);%find people with cvd
        newStroke(yesCVD,1)= newStroke(yesCVD,1)*1.86; %multiply by the multiplier
        ifStroke = simulateProtein(newStroke,length(newStroke));
        stateMatrix(aliveP, strokeCol)= ifStroke;
        
        %test stroke lifetime incidence
        yesStroke = find(stateMatrix(:,strokeCol)==1);
        strokeEver(yesStroke,1)=1;
        
        %cvd simulation
        getCVD = find(stateMatrix(:,chdCol)==1 | stateMatrix(:,strokeCol)==1);
        stateMatrix(getCVD,cvdCol) =  1;
        %this two lines test the CVD lifetime incidence
        yesCVD = find(stateMatrix(:,cvdCol)==1);
        cvdever(yesCVD,1)=1;
        
        
        %% Death simulation (Section 6)
        for race = 1:3
            for gender = 1:2
                %get the rows of corresponding gender and race
                %add stroke
                findrows= find(stateMatrix(:,genderCol)==gender & stateMatrix(:,raceCol)==race & stateMatrix(:,deathCol)==0 );
                inputmatrix = stateMatrix(findrows,[ageCol,ckdCol,gfrCol,cvdCol,diabetesCol,htCol,microCol,macroCol,reduCol]);
                findstage5 = stage5Ind(findrows,1);
                miStage = miInd(findrows,1);
                sheetname = strcat('sheet', num2str(race),num2str(gender));
                %sheet11 = 'WM_nonCVD';
                %sheet12 = 'WF_nonCVD';
                %sheet21 = 'BM_nonCVD';
                %sheet22 = 'BF_nonCVD';
                
                deathtable = xlsread(deathFile,sheetname);
              
                deathprob = getdeath_1(inputmatrix,findstage5,miStage,deathtable);
                stateMatrix(findrows,deathCol)=deathprob;
            end
        end
        prob = stateMatrix(aliveP,deathCol);
        simulateDeath =  simulateProtein(prob, length(prob));
        stateMatrix(aliveP,deathCol)= simulateDeath;
        
        %% Cost (Section 7)
        
        aliveP = find(stateMatrix(:,deathCol)==0);
        gfrCost = stateMatrix(aliveP,gfrCol);
        ageCost = stateMatrix(aliveP,ageCol);
        genCost = stateMatrix(aliveP,genderCol);
        protCost = max(stateMatrix(aliveP,microCol),stateMatrix(aliveP,macroCol));
        diaCost = stateMatrix(aliveP,diabetesCol);
        htCost = stateMatrix(aliveP,htCol);
        smokeCost = stateMatrix(aliveP,smokeCol);
        ckdCost = stateMatrix(aliveP,ckdCol);
        esrdCount = stateMatrix(aliveP,esrdCol);
        costVec = cost_2(gfrCost,ageCost,genCost,protCost,diaCost,htCost,smokeCost,ckdCost,esrdCount);
        if reduction >0
            
            treatcost = treatment_cost(stateMatrix);
            costVec = costVec + treatcost;
        end
        costYear(aliveP,i) = costVec; %cost for the year
        %get total - multiple by discount vector
        stateMatrix(aliveP,costCol) = stateMatrix(aliveP,costCol)+costVec; %cumulative cost of that person
        
        %% QALYs
        gfrQALY = stateMatrix(aliveP,gfrCol);
        microQALY = stateMatrix(aliveP,microCol);
        lastyearMI;
        thisyearMI = stateMatrix(aliveP,miCol);
        strokeQALY = strokeEver(aliveP,1);
        chdQALY = stateMatrix(aliveP,chdCol);
        QALY = qaly(gfrQALY,microQALY,strokeQALY,lastyearMI,thisyearMI,chdQALY);
        qalyYear(aliveP,i) = QALY;
        
        %% test
        aliveMatrix = stateMatrix(aliveP,:);
        %test
        if i==1 || i == 8 || i == 21 || i == 31 ||  i== 41 || i == 51
            aliveSBP = stateMatrix(aliveP,sbpCol);
            manNockd = find(aliveMatrix(:,genderCol)==1 & aliveMatrix(:,ckdCol)==0);
            mansbp = aliveSBP(manNockd,1);
            SBPmatrix(sbpind,:)= [i+29,prctile(mansbp,[5,10,15,25,50,75,85,90,95,100])];
            sbpind = sbpind + 1;
        end
        
        
        thisyearDeath = find(stateMatrix(:,deathCol)==1);
        deathNum(i,1) = length(thisyearDeath);
        
        alivenum(i,1) = alivenum(i,1)-deathNum(i,1);
        
        thisYeardiabetes = find(stateMatrix(:,diabetesCol)==1);
        numdiabetes = length(thisYeardiabetes);
        diabetesNum(i,1)= numdiabetes;
        
        thisyearht = find(stateMatrix(:,htCol)==1 );
        htNum(i,1) = length(thisyearht);
        
        thisYearmicro = find(stateMatrix(:,microCol)==1 & stateMatrix(:,deathCol)==0);
        nummicro = length(thisYearmicro);
        microNum(i,1)= nummicro;
        
        thisYearmacro = find(stateMatrix(:,macroCol)==1 & stateMatrix(:,deathCol)==0);
        nummacro = length(thisYearmacro);
        macroNum(i,1)= nummacro;
        
        sbpmean(i,1)= mean(stateMatrix(:,sbpCol));
        LVHthisyear = find(stateMatrix(:,lvhCol)==1);
        lvhNum(i,1) = length(LVHthisyear);
        
        stage0 = find(stateMatrix(:,ckdCol)==0 & stateMatrix(:,deathCol)==0);
        ckdstage0Num(i,1)=length(stage0);
        stage1 = find(stateMatrix(:,ckdCol)==1& stateMatrix(:,deathCol)==0);
        ckdstage1Num(i,1)=length(stage1);
        stage2 = find(stateMatrix(:,ckdCol)==2& stateMatrix(:,deathCol)==0);
        ckdstage2Num(i,1)=length(stage2);
        stage3 = find(stateMatrix(:,ckdCol)==3& stateMatrix(:,deathCol)==0);
        ckdstage3Num(i,1)=length(stage3);
        stage4 = find(stateMatrix(:,ckdCol)==4& stateMatrix(:,deathCol)==0);
        ckdstage4Num(i,1)=length(stage4);
        stage5 = find(stateMatrix(:,ckdCol)==5& stateMatrix(:,deathCol)==0);
        ckdstage5Num(i,1)=length(stage5);
        
        chdNum(i,1)= length(find(stateMatrix(:,chdCol)==1));
        cvdNum(i,1)= length(find(stateMatrix(:,cvdCol)==1));
        miNum(i,1)= length(find(stateMatrix(:,miCol)==1));
        strokeNum(i,1)= length(find(stateMatrix(:,strokeCol)==1));
        
        %% discount
        discRate=0.03;
        costDisc = costYear(:,i)*((1/(1+discRate))^(i-1));
        costYearDisc(:,1)= costYearDisc(:,1) + costDisc;
        qalyDisc = qalyYear(:,i)*((1/(1+discRate))^(i-1));
        qalyYearDisc(:,1)=qalyYearDisc(:,1) + qalyDisc;
        
        %% save stateMatrix
        stateArray{i,1} = stateMatrix;
        
        %% age everyone who is still alive
        alive = find(stateMatrix(:,deathCol)==0);%get the row numbers of ppl that are still alive
        stateMatrix(alive, ageCol) = stateMatrix(alive, ageCol) + 1;
        liveyear(alive,1)=stateMatrix(alive, ageCol);
    end
end

save('stateArrayFile','stateArray','costYear','qalyYear')

%      %write the data into excel file
%      Age = (30:90)';
%      Alivenumber = alivenum;
%      Deathnumber = deathNum;
%
%      %get number of people and percentage in each ckd stage
%      Stage0Num = ckdstage0Num;
%      Stage0Percentage = ckdstage0Num./alivenum;
%
%      Stage1Num = ckdstage1Num;
%      Stage1Percentage = ckdstage1Num./alivenum;
%
%      Stage2Num = ckdstage2Num;
%      Stage2Percentage = ckdstage2Num./alivenum;
%
%      Stage3Num = ckdstage3Num;
%      Stage3Percentage = ckdstage3Num./alivenum;
%
%      Stage4Num = ckdstage4Num;
%      Stage4Percentage = ckdstage4Num./alivenum;
%
%      Stage5Num = ckdstage5Num;
%      Stage5Percentage = ckdstage5Num./alivenum;
%
%      %get the data for hypertension
%      hypertension = htNum ./size;
%      %write all data into table
%      T1 = table(Age, Alivenumber, Deathnumber,Stage0Num,Stage0Percentage, Stage1Num, Stage1Percentage,Stage2Num, Stage2Percentage,Stage3Num, Stage3Percentage,Stage4Num, Stage4Percentage,Stage5Num, Stage5Percentage,hypertension);
%      filename = 'test.xlsx';
%      writetable(T1,filename,'Sheet','Row Data2');
%
%      cvd_lifetime = length(find(cvdever(:,1)==1))/size;
%      chd_lifetime = length(find(chdever(:,1)==1))/size;
%      stroke_lifetime = length(find(strokeEver(:,1)==1))/size;
%      diabetes_lifetime = length(find(stateMatrix(:,diabetesCol)==1))/size;
%      lvh_lifetime = length(find(stateMatrix(:,lvhCol)==1))/size;
%      ht_lifetime = length(find(stateMatrix(:,htCol)==1))/size;
%      averagelivetime = mean(liveyear);
%      T2 = table(diabetes_lifetime,lvh_lifetime,cvd_lifetime,chd_lifetime,stroke_lifetime,ht_lifetime,averagelivetime);
%      writetable(T2,filename,'Sheet','Row Data','Range','B65');
%
%      %write total Cholesterol data
%      writematrix(totchoPer,filename,'Sheet','Row Data','Range','B80' );
%      %HDL cholesterol
%      male = find( stateMatrix(:,genderCol)==1);
%      maleHDL = stateMatrix(male,hdlColCol);
%      malePer = prctile(maleHDL,[5,10,15,25,50,75,85,90,95]);
%      female = find(stateMatrix(:,genderCol)==2);
%      femaleHDL = stateMatrix(female,hdlColCol);
%      femalePer = prctile(femaleHDL,[5,10,15,25,50,75,85,90,95]);
%
%      %find average time at each ckd stage
%      averagetime = zeros(7,6);%Row: total population, WM,WF,BM,BF,HM,HF; Column: ckdstage 0-5
%      WMind = find(stateMatrix(:,genderCol)==1 & stateMatrix(:,raceCol)==1);
%      for stage=0:5 %for each ckd stage
%          %total
%          exclude0 = find (ckdYmatrix(:,stage+2)~=0);
%          averagetime(1,stage+1)=mean(ckdYmatrix(exclude0,stage+2));
%          %White male
%          WMexclude0 = intersect(WMind,exclude0);
%          averagetime(2,stage+1)=mean(ckdYmatrix(WMexclude0,stage+2));
%          %White female
%          WFexclude0 = intersect(WFind,exclude0);
%          averagetime(3,stage+1)=mean(ckdYmatrix(WFexclude0,stage+2));
%          %Black male
%          BMexclude0 = intersect(BMind,exclude0);
%          averagetime(4,stage+1)=mean(ckdYmatrix(BMexclude0,stage+2));
%          %Black female
%          BFexclude0 = intersect(BFind,exclude0);
%          averagetime(5,stage+1)=mean(ckdYmatrix(BFexclude0,stage+2));
%          %Hispanic male
%           HMexclude0 = intersect(HMind,exclude0);
%          averagetime(6,stage+1)=mean(ckdYmatrix(HMexclude0,stage+2));
%          %Hispanic female
%          HFexclude0 = intersect(HFind,exclude0);
%          averagetime(7,stage+1)=mean(ckdYmatrix(HFexclude0,stage+2));
%      end
%      writematrix(malePer,filename,'Sheet','Row Data','Range','C96' );
%      writematrix(femalePer,filename,'Sheet','Row Data','Range','C99' );
%
%      writematrix(SBPmatrix,filename,'Sheet','Row Data','Range','B105' );
%      writematrix(averagetime,filename,'Sheet','Row Data','Range','B115' );


%this example doesn't work because apple is the worsttt

[NUM WORD ALL] = xlsread('/SampleData.xlsx','Sheet1', 'a28:fl35238');


dates = unique(ALL(2:length(ALL),3), 'stable'); %finds all unique dates, stable means leave in order you find it
Date = {};
Qavg = zeros(length(dates),1);
Havg = zeros(length(dates),1);
for i = 1:length(dates)
    inxcells = strfind(ALL(2:length(ALL),3), char(dates(i))); %char converts dates stored into characters
    indices = find(not(cellfun('isempty',inxcells))); %going to look in inxcells matrix to find all the ones that are not empty, gives us the row number for all points on October first
    
    Date(i) = char(dates(i));
    Qavg(i) = nanmean(cell2mat(ALL((indices+1),5))); %nanmean ignores missing data
    Havg(i) = nanmean(cell2mat(ALL((indices+1),6)));
end

xlswrite('cleandata.xls',[Qavg,Havg])
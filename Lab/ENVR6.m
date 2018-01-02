data = xlsread('ApalachicolaMonthlyFlows.xlsx');
datamax = max(data(:,2:13));
datamin = min(data(:,2:13));
datamean = mean(data(:,2:13));
datamonth = 1:12;

hold on
plot(datamonth,datamax)
plot(datamonth,datamin)
plot(datamonth,datamean)
legend('Maximum Flow','Minimum Flow','Mean Flow')
xlabel('Month')
ylabel('Cubis Feet/Second')
hold off

%%

hold on
plot(

%ahhh started too late and now I don't know - see David's file


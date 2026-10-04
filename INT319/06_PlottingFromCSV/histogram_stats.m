[f,p] = uigetfile('*.csv');

if isequal(f,0)
    return;
end

T = readtable(fullfile(p,f));
disp(T.Properties.VariableNames')
c = input('Data column number: ');
d = T{:,c};

histogram(d);

title('Histogram');
xlabel(T.Properties.VariableNames{c});
ylabel('Frequency');

fprintf('Mean %.2f Median %.2f Std %.2f Min %.2f Max %.2f\n', ...
    mean(d), median(d), std(d), min(d), max(d));

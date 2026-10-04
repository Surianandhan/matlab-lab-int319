[f,p] = uigetfile('*.csv');

if isequal(f,0)
    return;
end

T = readtable(fullfile(p,f));

disp(T.Properties.VariableNames')

v = input('Values column number: ');
l = input('Labels column number: ');

bar(T{:,v});

xticks(1:height(T));
xticklabels(string(T{:,l}));

title('Bar Plot');

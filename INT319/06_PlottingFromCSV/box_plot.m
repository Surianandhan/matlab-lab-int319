[f,p] = uigetfile('*.csv');

if isequal(f,0)
    return;
end

T = readtable(fullfile(p,f));

disp(T.Properties.VariableNames')

c = input('Data column number: ');

d = T{:,c};

boxplot(d);

title('Box Plot');
ylabel(T.Properties.VariableNames{c});
grid on;

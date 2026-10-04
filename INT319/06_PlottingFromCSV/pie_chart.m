[f,p] = uigetfile('*.csv');

if isequal(f,0)
    return;
end

T = readtable(fullfile(p,f));

disp(T.Properties.VariableNames')

v = input('Values column number: ');
l = input('Labels column number: ');

pie(T{:,v},cellstr(string(T{:,l})));

title('Pie Chart');

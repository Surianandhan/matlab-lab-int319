[f,p] = uigetfile('*.csv');

if isequal(f,0)
    return;
end

T = readtable(fullfile(p,f));

disp(T.Properties.VariableNames')

a = input('Latitude column number: ');
b = input('Longitude column number: ');

geoplot(T{:,a},T{:,b},'r-o');

geobasemap streets;

title('Geographic Plot');

[f,p] = uigetfile('*.csv');

if isequal(f,0)
    return;
end

T = readtable(fullfile(p,f));

disp(T.Properties.VariableNames')

x = input('X column number: ');
y = input('Y column number: ');

plot(T{:,x},T{:,y},'-o');

title('Line Plot');
xlabel(T.Properties.VariableNames{x});
ylabel(T.Properties.VariableNames{y});
grid on;

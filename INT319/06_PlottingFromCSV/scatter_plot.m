[f,p] = uigetfile('*.csv');

if isequal(f,0)
    return;
end

T = readtable(fullfile(p,f));

disp(T.Properties.VariableNames')

x = input('X column number: ');
y = input('Y column number: ');

scatter(T{:,x},T{:,y},'filled');

title('Scatter Plot');
xlabel(T.Properties.VariableNames{x});
ylabel(T.Properties.VariableNames{y});
grid on;

[f,p] = uigetfile('*.txt');

if isequal(f,0)
    return;
end

t = fileread(fullfile(p,f));

t = replace(t,[".","?","!",",",";",":"]," ");

w = split(t);

w = w(w ~= "");

wordcloud(categorical(w));

title('Word Cloud');

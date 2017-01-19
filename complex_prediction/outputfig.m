%Print figure in 3 formats, PNG,EPS(vector),Matlab Fig,DB
function outputfig(figure,filename,folder_name)

%save fig
saveas(figure,fullfile(folder_name, filename),'fig');

%save png
saveas(figure,fullfile(folder_name, filename),'png');

%save as eps; Vector image that is scalable at any size
saveas(figure,fullfile(folder_name, filename),'epsc');

end
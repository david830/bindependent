%Print figure in 3 formats, PNG,EPS(vector),Matlab Fig,DB
% inputs Matlab Fig, filename, (optional) folder name

function outputfig(figure,filename,folder_name)

% Make file save path depending on number of input arguments
if nargin == 3
    save_path = fullfile(folder_name, filename);
    
    %Make folder if necessary
    if exist(folder_name,'dir') == 0
        mkdir(folder_name);
    end  
elseif nargin == 2
   save_path = fullfile(filename);
else
    error('Not enough parameters given to outputfig.m');
end    


%% Save Figures
%save fig
saveas(figure,save_path,'fig');

%save png
% saveas(figure,save_path,'png');

%save as eps; Vector image that is scalable at any size
% saveas(figure,save_path,'epsc');

end
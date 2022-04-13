% Script for dyslexia internship. Gert-Jan Munneke (2012) 
% Saving ERSP and ITC plots as .bmp files for every condition and every
% channel.

% resetting matlab:
close all
clear all
clc

% setting the current directory:
filepath = 'D:\\raw_bdf_dyslexia\\';
cd D:/raw_bdf_dyslexia

% opening eeglab:
eeglab

% specifying the filenames of datasets that correspond to the conditions.
condition = {'CONTROL_words.set' 'CONTROL_symbols.set' 'LEXY_words.set' 'LEXY_symbols.set'};

% loop over conditions:
for conditioni = 1 : length(condition)
    
    % loading dataset:
    EEG = pop_loadset('filename',condition{conditioni},'filepath',filepath);

    % loop over channels:
    for channeli = 1:64
        
        % plotting ERSP and ITC: 
        figure; 
        title(strcat(condition{conditioni},' channel: ',EEG.chanlocs(channeli).labels,' number: ',num2str(channeli)));
        pop_newtimef( EEG, 1, channeli, [-125  1123], [1         0.5] , 'topovec', 27, ...
            'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'baseline',[0], 'alpha',.01, ...
            'plotphase', 'off', 'padratio', 4);

        % saving the figure as a .bmp file:
        figure_filename = strcat('ERSP_ITC_',condition{conditioni},'_channumber_',num2str(channeli),'_',EEG.chanlocs(channeli).labels,'.bmp');
        saveas(gcf,figure_filename)

        % closing the current figure window:
        close all

    end % ends loop over channels
    
    % clear dataset from memory:
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    
end % ends loop over conditions


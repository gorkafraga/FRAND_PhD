% Script for dyslexia internship. Gert-Jan Munneke (2012) 
% Extracting the ERSP and ITC values between CONTROLwords and LEXYwords.

% resetting matlab:
close all
clear all
clc

% setting the current directory:
filepath = 'D:\\raw_bdf_dyslexia\\';
cd D:/raw_bdf_dyslexia

% opening eeglab:
eeglab

% creating a data structure to store the values in:
%diffWORDS.channels = struct('ersp', {}, 'itc', {}, 'tftdata', {}, ...
%    'erspboot', {}, 'itcboot', {}, 'powbase', {});

% loading datasets:
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','CONTROL_words.set','filepath','D:\\raw_bdf_dyslexia\\');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = pop_loadset('filename','LEXY_words.set','filepath','D:\\raw_bdf_dyslexia\\');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

tic

% extracting ERSP and ITC values:    

% loop over channels:
for channeli = 38:64 % 4 iterations took my laptop 882 seconds.

    % extracting the ERSP and ITC values:
    [ersp,itc,powbase,times,freqs,erspboot,itcboot,tfdata] = ...
                newtimef( {ALLEEG(1).data(channeli,:,:) ALLEEG(2).data(channeli,:,:)}, EEG.pnts, [-125   1123], EEG.srate, [1   0.5] , 'chaninfo', EEG.chaninfo,...
                'baseline',0, 'plotphase', 'off', 'padratio', 4, 'alpha', .01);
    
    % storing the values in the corresponding place in the datastructure:
    % diffWORDS.channels(channeli).ersp = ersp;
    % diffWORDS.channels(channeli).itc = itc;
    % diffWORDS.channels(channeli).tfdata = tfdata;
    % diffWORDS.channels(channeli).erspboot = erspboot;
    % diffWORDS.channels(channeli).itcboot = itcboot;
    % diffWORDS.channels(channeli).powbase = powbase;
    
    % saving the figure as a .m file:
    figure_filename = strcat('diff_ERSP_ITC_CTRLwords_LXYwords','_channumber_',num2str(channeli),'_',EEG.chanlocs(channeli).labels,'.m');
    saveas(gcf,figure_filename)

    % closing the current figure window:
    close all
    
end % ends loop over channels

toc

%save the workspace in a .m file:
    % save('new_diff_CTRLwords__LXYwords_DATA_chan_1-37.mat', 'diffWORDS', 'freqs', 'times')
    
    
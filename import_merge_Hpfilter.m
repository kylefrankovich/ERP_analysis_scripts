% script that imports, merges, and hi-pass filters raw EEG data

clear all
close all
DIR = ('/Users/kfranko/Desktop/LOTP_ERP_data/');
ANALYSIS_DIR = ('/Users/kfranko/Desktop/ERP_analysis_scripts/');
SUBDIR = ('S02');
SUB = {'2'};
date_run = '051316';

for i = 1:length(SUB)
    
    %     for j = 7; % the number of files to be merged
    %
    %         fprintf('running: %d\n', j)
    %
    %         k = num2str(j);
    %
    %         [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    %
    %         %load raw file
    %         EEG = pop_loadbv([DIR SUBDIR], ['S' SUB{i} '_4AFC_ERP2_' date_run '_' '1' '.vhdr']);
    %         [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '_4AFC_ERP2_' '1'], 'savenew', [DIR SUBDIR '/' SUB{i} '_4AFC_ERP2_' '1' '.set'], 'gui', 'off');
    %
    %     end
    
    % load data:
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    % import raw data and save each file individually:
    EEG = pop_loadbv([DIR SUBDIR], ['S' SUB{i} '_4AFC_ERP2_' date_run '_' '1' '.vhdr']);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '_4AFC_ERP2_' '1'], 'savenew', [DIR SUBDIR '/' SUB{i} '_4AFC_ERP2_' '1' '.set'], 'gui', 'off');
    
    EEG = pop_loadbv([DIR SUBDIR], ['S' SUB{i} '_4AFC_ERP2_' date_run '_' '2' '.vhdr']);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', [SUB{i} '_4AFC_ERP2_' '2'], 'savenew', [DIR SUBDIR '/' SUB{i} '_4AFC_ERP2_' '2' '.set'], 'gui', 'off');
    
    EEG = pop_loadbv([DIR SUBDIR], ['S' SUB{i} '_4AFC_ERP2_' date_run '_' '3' '.vhdr']);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3, 'setname', [SUB{i} '_4AFC_ERP2_' '3'], 'savenew', [DIR SUBDIR '/' SUB{i} '_4AFC_ERP2_' '3' '.set'], 'gui', 'off');
    
    EEG = pop_loadbv([DIR SUBDIR], ['S' SUB{i} '_4AFC_ERP2_' date_run '_' '4' '.vhdr']);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4, 'setname', [SUB{i} '_4AFC_ERP2_' '4'], 'savenew', [DIR SUBDIR '/' SUB{i} '_4AFC_ERP2_' '4' '.set'], 'gui', 'off');
    EEG = pop_loadbv([DIR SUBDIR], ['S' SUB{i} '_4AFC_ERP2_' date_run '_' '5' '.vhdr']);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5, 'setname', [SUB{i} '_4AFC_ERP2_' '5'], 'savenew', [DIR SUBDIR '/' SUB{i} '_4AFC_ERP2_' '5' '.set'], 'gui', 'off');
    EEG = pop_loadbv([DIR SUBDIR], ['S' SUB{i} '_4AFC_ERP2_' date_run '_' '6' '.vhdr']);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 6, 'setname', [SUB{i} '_4AFC_ERP2_' '6'], 'savenew', [DIR SUBDIR '/' SUB{i} '_4AFC_ERP2_' '6' '.set'], 'gui', 'off');
    EEG = pop_loadbv([DIR SUBDIR], ['S' SUB{i} '_4AFC_ERP2_' date_run '_' '7' '.vhdr']);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 7, 'setname', [SUB{i} '_4AFC_ERP2_' '7'], 'savenew', [DIR SUBDIR '/' SUB{i} '_4AFC_ERP2_' '7' '.set'], 'gui', 'off');
    %     %remove boundary code at very beginning
    %     if strcmpi(EEG.event(1).type, 'boundary') && EEG.event(1).latency<2
    %         EEG = pop_editeventvals(EEG, 'delete', 1);
    %     end
    
    % merge data into single file:
    % merge sets & convert boundary codes back to numerics, any remaining codes
    % changed to 1000s
    EEG = pop_mergeset( ALLEEG, [1  2  3  4  5  6  7], 0);
    LengthDataset = length(EEG.event);
    stringEventCounter = 1000;
    for j = 1:LengthDataset
        if ischar(EEG.event(j).type) && ~strcmpi(EEG.event(j).type, 'boundary')
            
            newEventType = str2double(EEG.event(j).type);
            
            if ~isnan(newEventType)
                EEG.event(j).type = newEventType;
            elseif isnan(newEventType)
                EEG.event(j).type = stringEventCounter;
                stringEventCounter = stringEventCounter+1;
            end
            
        elseif ischar(EEG.event(j).type) && strcmpi(EEG.event(j).type, 'boundary')
            EEG.event(j).type = -99;
        end;
    end;
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 8, 'setname', [SUB{i} '_4AFC_ERP2_merged'], 'savenew', [DIR SUBDIR '/' SUB{i} '_4AFC_ERP2_' 'merged' '.set'],'gui','off');
    
    
    %hpfilt data
    EEG = pop_basicfilter (EEG, 1:32 , 'Boundary', 'boundary', 'Cutoff', 0.1, 'Design', 'butter', 'Filter', 'highpass', 'Order', 2, 'RemoveDC', 'on');
    [ALLEEG EEG CURRENTSET] = pop_newset (ALLEEG, EEG, 9, 'setname', [SUB{i} '_4AFC_ERP2_merged' '_hpfilt'], 'savenew', [DIR SUBDIR '/' SUB{i} '_4AFC_ERP2_' 'merged' '_hpfilt.set'], 'gui', 'off');
    
    %rereference to P9/P10 & add bipolars
    EEG = pop_eegchanoperator( EEG, [ANALYSIS_DIR 're_reference_P9P10.txt']);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 10, 'setname', [SUB{i} '_4AFC_ERP2_merged' '_hpfilt_VEOG_reref'], 'savenew', [DIR SUBDIR '/' SUB{i} '_4AFC_ERP2_' 'merged' '_hpfilt_reref.set'], 'gui', 'off');
    
    %     %Shift Event Codes
    %     eventcodes = {'11', '12', '21', '22'};
    %     timeshift  = 0.026;   % Shift 26 milliseconds forwards in time
    %     rounding = 'floor';
    %     EEG  = erplab_shiftevents_eeg(EEG, eventcodes, timeshift, rounding);
    %     [ALLEEG EEG CURRENTSET] =  pop_newset(ALLEEG, EEG, 4, 'setname', [SUB{i} '_V' m '_hpfilt_VEOG_reref_shifted'], 'savenew', [DIR SUB{i} '/' SUB{i} '_V' m '_hpfilt_reref_shifted.set'], 'gui', 'off');
    %
    
    %create event list
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', [DIR SUB{i} '/' sid '_DP_Eventlist.txt'] );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 11, 'setname', [sid '_DP_merged_hpfilt_reref_elist'], 'savenew', [DIR SUB{i} '/' sid '_DP_merged_hpfilt_reref_elist.set'], 'gui', 'off');
    
    % bin events
    EEG  = pop_binlister( EEG , 'BDF', [DIR 'BDF_DP.txt'], 'ExportEL', [DIR SUB{i} '/' sid '_DP_Eventlist_Bins.txt'], 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 12, 'setname', [sid '_DP_merged_hpfilt_reref_elist_bins'], 'savenew', [DIR SUB{i} '/' sid '_DP_merged_hpfilt_reref_elist_bins.set'], 'gui', 'off');
    
    %create epochs
    EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 13, 'setname', [sid '_DP_merged_hpfilt_reref_elist_bins_epoch'], 'savenew', [DIR SUB{i} '/' sid '_DP_merged_hpfilt_reref_elist_bins_epoch.set'], 'gui', 'off');
    
    %Low Pass filter data for Artifact Rejection
    EEG  = pop_basicfilter( EEG,  1:42 , 'Boundary', 'boundary', 'Cutoff',  30, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  2);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 14, 'setname', [sid '_DP_merged_hpfilt_reref_elist_bins_epoch_lpfilt'], 'savenew',  [DIR SUB{i} '/' sid '_DP_merged_hpfilt_reref_elist_bins_epoch_lpfilt.set'], 'gui', 'off');
    
    %Create ERP
    ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DSindex',  6, 'ExcludeBoundary', 'on' );
    ERP = pop_savemyerp( ERP, 'erpname', [sid '_DP_erp'], 'filename', [DIR SUB{i} '/' sid '_DP_erp.erp']);
    close all
    
    
end

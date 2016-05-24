% LOTP_4AFC_ERP2 ERP data processing script:


% importing file parameters:

ERP_data_folder = '/Users/kfranko/Desktop/LOTP_ERP_data/';
ANALYSIS_DIR = ('/Users/kfranko/Desktop/ERP_analysis_scripts/');
sub_data_folder = 'S03';
sub_num = 'S3';

data_directory = fullfile(ERP_data_folder, sub_data_folder);

file_name_template = '_LOTP_4AFC_ERP2_';

file_name = [sub_num file_name_template];


[data_directory, '/', sub_num, file_name_template, 'merged_data_test.set']



% load the subject's data:

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

EEG = pop_loadbv(data_directory, [file_name '1' '.vhdr']);
%EEG.setname='S3_file1';
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', 'S3_file1', 'gui', 'off');

EEG = pop_loadbv(data_directory, [file_name '2' '.vhdr']);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', 'S3_file2', 'gui', 'off');

EEG = pop_loadbv(data_directory, [file_name '3' '.vhdr']);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3, 'setname', 'S3_file3', 'gui', 'off');

EEG = pop_loadbv(data_directory, [file_name '4' '.vhdr']);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4, 'setname', 'S3_file4', 'gui', 'off');




%% merge files:


EEG = pop_mergeset( ALLEEG, [1  2  3  4], 0);
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

% save merged dataset:
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5, 'setname', [sub_num '_merged_data'], 'savenew', [data_directory,'/',sub_num,file_name_template,'merged_data.set'],'gui','off');

%% hpfilt data
EEG = pop_basicfilter (EEG, 1:32 , 'Boundary', 'boundary', 'Cutoff', 0.1, 'Design', 'butter', 'Filter', 'highpass', 'Order', 2, 'RemoveDC', 'on');
[ALLEEG EEG CURRENTSET] = pop_newset (ALLEEG, EEG, 6, 'setname', [sub_num '_4AFC_ERP2_merged' '_hpfilt'], 'gui', 'off');


%rereference to P9/P10 & add bipolars
EEG = pop_eegchanoperator( EEG, [ANALYSIS_DIR 're_reference_P9P10.txt']);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 7, 'setname', [sub_num '_4AFC_ERP2_merged' '_hpfilt_VEOG_reref'], 'gui', 'off');



%     %Shift Event Codes
%     eventcodes = {'11', '12', '21', '22'};
%     timeshift  = 0.026;   % Shift 26 milliseconds forwards in time
%     rounding = 'floor';
%     EEG  = erplab_shiftevents_eeg(EEG, eventcodes, timeshift, rounding);
%     [ALLEEG EEG CURRENTSET] =  pop_newset(ALLEEG, EEG, 4, 'setname', [SUB{i} '_V' m '_hpfilt_VEOG_reref_shifted'], 'savenew', [DIR SUB{i} '/' SUB{i} '_V' m '_hpfilt_reref_shifted.set'], 'gui', 'off');
%

%create event list
EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', [data_directory,'/',sub_num,file_name_template,'eventlist.txt']);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 8, 'setname', [sub_num '_4AFC_ERP2_merged_hpfilt_reref_elist'], 'gui', 'off');



% bin events
EEG  = pop_binlister( EEG , 'BDF', [ANALYSIS_DIR 'LOTP_4AFC_bdf.txt'], 'ExportEL', [data_directory,'/',sub_num,file_name_template,'eventlist_bins.txt'], 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 9, 'setname', [sub_num '_4AFC_ERP2_merged_hpfilt_reref_elist_bins'], 'gui', 'off');




%create epochs
EEG = pop_epochbin( EEG , [-200.0  700.0],  'pre');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 10, 'setname', [sub_num '_4AFC_ERP2_merged_hpfilt_reref_elist_bins_epoch'], 'gui', 'off');




%Low Pass filter data for Artifact Rejection
EEG  = pop_basicfilter( EEG,  1:34 , 'Boundary', 'boundary', 'Cutoff',  30, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  2);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 11, 'setname', [sub_num '_4AFC_ERP2_merged_hpfilt_reref_elist_bins_epoch_lpfilt'], 'gui', 'off');



% update the gui:

[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG,EEG);
eeglab redraw;


% artifact rejection:

% moving window, channels 1:32, 100 threshold, windowsize = 200, stepsize =
% 100
EEG  = pop_artmwppth( EEG , 'Channel',  1:32, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -200 698], 'Windowsize',  200, 'Windowstep',  100 ); % GUI: 23-May-2016 16:59:21
EEG.setname='S3_4AFC_ERP2_merged_hpfilt_reref_elist_bins_epoch_lpfilt_arMW';

% VEOG artifact detection; moving window. test window = [-200 795.9];
% threshold = 80 uV; window width = 200 ms; window step = 50ms; channel
% 34

EEG  = pop_artmwppth( EEG , 'Channel',  34, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -200 698], 'Windowsize',  200, 'Windowstep',  50 ); %for version 2.0.0.57
EEG.setname='S3_4AFC_ERP2_merged_hpfilt_reref_elist_bins_epoch_lpfilt_arMW_arVEOG';


% Artifact detection. Step-like artifacts in the bipolar
% HEOG channel (channel 33, created earlier with Channel Operations)
% Threshold = 30 uV; Window width = 400 ms;
% Window step = 10 ms; Flags to be activated = 1 & 3

EEG  = pop_artstep( EEG , 'Channel',  33, 'Flag',  1, 'Threshold',  30, 'Twindow', [ -200 698], 'Windowsize',  400, 'Windowstep',  10 );
EEG.setname='S3_4AFC_ERP2_merged_hpfilt_reref_elist_bins_epoch_lpfilt_arMW_arVEOG_arHEOG';



% averaging:
%Create ERP
ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DSindex',  6, 'ExcludeBoundary', 'on' );
ERP = pop_savemyerp( ERP, 'erpname', [sid '_DP_erp'], 'filename', [DIR SUB{i} '/' sid '_DP_erp.erp']);
close all

ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DSindex',14, 'ExcludeBoundary', 'on', 'SEM', 'on' );% GUI: 23-May-2016 17:52:05



% bin operations:


ERP = pop_binoperator( ERP, {'nbin1 = (BIN1+BIN4+BIN17+BIN20+BIN33+BIN36+BIN49+BIN52) label = left target, blocked, fast, averaged across red/blue, A/B/C/D','nbin2 = (BIN2+BIN3+BIN18+BIN19+BIN34+BIN35+BIN50+BIN51) label = right target, blocked, fast, averaged across red/blue, A/B/C/D','nbin3 = (BIN5+BIN8+BIN21+BIN24+BIN37+BIN40+BIN53+BIN56) label = left target, blocked, slow, averaged across red/blue, A/B/C/D','nbin4 = (BIN6+BIN7+BIN22+BIN23+BIN38+BIN39+BIN54+BIN55) label = right target, blocked, slow, averaged across red/blue, A/B/C/D'});
ERP = pop_savemyerp(ERP, 'erpname', 'S3_4AFC_ERP2_erp_collapsed', 'filename', 'S3_4AFC_ERP2_erp_collapsed.erp', 'filepath', '/Users/kfranko/Desktop/ERP_analysis_scripts', 'Warning', 'on');% GUI: 23-May-2016 18:57:55









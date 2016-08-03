% script for plotting comparison of averaged occipital electrode site


ERP_data_folder = '/Users/kfranko/Box Sync/ERP_experiment_data/LOTP_4AFC_processed_data/';
subject_list = {'S01','S03','S04','S05','S06','S07','S08','S09','S12','S13','S14','S16','S17','S18', 'S19', 'S20', 'S21'};
subject_numbers = {'S1','S3','S4','S5','S6','S7','S8','S9','S12','S13','S14','S16','S17','S18', 'S19', 'S20', 'S21'};


subjects_w_o_mixed = ['S01','S05','S06','S07','S08'];

% use matlab map object (similar to a dictionary) so that we can get
% subjects by their subject number, not order number:

subjectMap = containers.Map(subject_list, subject_numbers);

numsubjects = length(subject_list); % number of subjects

% review subs: S06: 5; S07: 6; S09: 8; S12: 9; S16: 12; S18: 14;
% 

sub_to_process = 'S09';
cur_sub = subjectMap(sub_to_process);
sub_folder = fullfile(ERP_data_folder, sub_to_process, '/');


% plot non-occipital waveforms:

fprintf('\n******\nProcessing subject %s\n******\n\n', sub_to_process);

% load ERP:
ERP = pop_loaderp( 'filename', [cur_sub '_LOTP_4AFC_ERP2_ERP_contra_ipsi_diff_blocked_mixed.erp'], 'filepath', sub_folder );

% plot blocked:

ERP = pop_ploterps( ERP, [ 1 2],  1:11 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 4 3], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 103.714 29.6429 106.857 31.9286], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -200.0 698.0   -200:100:600 ], 'YDir', 'normal' );

% plot mixed (not subjects 1, 5, 6, 7, 8):

ERP = pop_ploterps( ERP, [ 3 4],  1:11 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 4 3], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 103.714 29.6429 106.857 31.9286], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -200.0 698.0   -200:100:600 ], 'YDir', 'normal' );



%%%%%%% plot w/ occipital waveforms: 


% plot blocked:

% load ERP:
ERP = pop_loaderp( 'filename', [cur_sub '_LOTP_4AFC_ERP2_ERP_contra_ipsi_diff_blocked_mixed_occip.erp'], 'filepath', sub_folder );


ERP = pop_ploterps( ERP, [ 1 2],  1:12 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 4 3], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 103.714 29.6429 106.857 31.9286], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -200.0 698.0   -200:100:600 ], 'YDir', 'normal' );

% plot mixed (not subjects 1, 5, 6, 7, 8):

ERP = pop_ploterps( ERP, [ 3 4],  1:12 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 4 3], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 103.714 29.6429 106.857 31.9286], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -200.0 698.0   -200:100:600 ], 'YDir', 'normal' );













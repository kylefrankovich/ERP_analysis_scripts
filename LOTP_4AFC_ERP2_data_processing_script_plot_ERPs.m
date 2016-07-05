% script for plotting individual subject ERPs

ERP_data_folder = '/Users/kfranko/Box Sync/ERP_experiment_data/LOTP_4AFC_processed_data/';
subject_list = {'S01','S03','S04','S05','S06','S07','S08','S09','S12','S13','S14','S16','S17','S18', 'S19', 'S20', 'S21'};
subject_numbers = {'S1','S3','S4','S5','S6','S7','S8','S9','S12','S13','S14','S16','S17','S18', 'S19', 'S20', 'S21'};

% use matlab map object (similar to a dictionary) so that we can get
% subjects by their subject number, not order number:

subjectMap = containers.Map(subject_list, subject_numbers);

numsubjects = length(subject_list); % number of subjects

% review subs: S06: 5; S07: 6; S09: 8; S12: 9; S16: 12; S18: 14;
% 

sub_to_process = 'S07';
cur_sub = subjectMap(sub_to_process);
sub_folder = fullfile(ERP_data_folder, sub_to_process, '/');
old_analysis_date = '06_23_16'; % 6/23/16 needs the "old_analysis" folder below; later comparisons probably won't
%sub_folder_old_data = fullfile(ERP_data_folder, sub_to_process, '/', 'old_analysis/');
sub_folder_old_analysis_pre_06_23 = fullfile(ERP_data_folder, 'archived_data_analysis/', old_analysis_date, sub_to_process, '/', 'old_analysis/');
sub_folder_old_analysis_06_23 = fullfile(ERP_data_folder, 'archived_data_analysis/', old_analysis_date, sub_to_process, '/');



% plot old analysis:

% all bins (pre-06_23_16 analysis):

fprintf('\n******\nProcessing subject %s\n******\n\n', sub_to_process);
% for subjects w/ mixed: '_LOTP_4AFC_ERP2_ERP_contra_ipsi_diff_blocked_mixed.erp'
% w/o mixed: '_LOTP_4AFC_ERP2_ERP_contra_ipsi_diff.erp'
ERP = pop_loaderp( 'filename', [cur_sub '_LOTP_4AFC_ERP2_ERP_contra_ipsi_diff.erp'], 'filepath', char(sub_folder_old_analysis_pre_06_23) );
% ERP = pop_ploterps( ERP, [ 5 6],33 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 6 6], 'ChLabel', 'on', 'FontSizeChan',10, 'FontSizeLeg',12, 'FontSizeTicks',10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',1, 'Maximize', 'on', 'Position', [ 103.667 29.6364 107 32], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',0, 'xscale', [ -200.0 698.0 -200:100:600 ], 'YDir', 'normal' );
% from Jackie:
ERP = pop_ploterps( ERP, [ 1 2],  1:11 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 4 3], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 103.714 29.6429 106.857 31.9286], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -200.0 698.0   -200:100:600 ], 'YDir', 'normal' );

% only P07/P08:

ERP = pop_ploterps( ERP,  [1 2], 9, 'AutoYlim', 'off', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 1 1], 'ChLabel', 'on', 'FontSizeChan',...
  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' , 'b-' }, 'LineWidth',  1, 'Maximize', 'off',...
 'Position', [ 103.667 29.6667 106.833 31.9167], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale', [ -200.0 698.0 -200:100:600 ],...
 'YDir', 'normal', 'yscale',  [ -6.4 6.4   -6.4:.8:6.4 ] );


% all bins (06_23_16 analysis (weird waveforms w/ all responses)):

fprintf('\n******\nProcessing subject %s\n******\n\n', sub_to_process);
% for subjects w/ mixed: '_LOTP_4AFC_ERP2_ERP_contra_ipsi_diff_blocked_mixed.erp'
% w/o mixed: '_LOTP_4AFC_ERP2_ERP_contra_ipsi_diff.erp'
ERP = pop_loaderp( 'filename', [cur_sub '_LOTP_4AFC_ERP2_ERP_contra_ipsi_diff_blocked_mixed.erp'], 'filepath', char(sub_folder_old_analysis_06_23) );
ERP = pop_ploterps( ERP, [ 1 2],  1:11 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 4 3], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 103.714 29.6429 106.857 31.9286], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -200.0 698.0   -200:100:600 ], 'YDir', 'normal' );

% only P07/P08:

ERP = pop_ploterps( ERP,  [1 2], 9, 'AutoYlim', 'off', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 1 1], 'ChLabel', 'on', 'FontSizeChan',...
  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' , 'b-' }, 'LineWidth',  1, 'Maximize', 'off',...
 'Position', [ 103.667 29.6667 106.833 31.9167], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale', [ -200.0 698.0 -200:100:600 ],...
 'YDir', 'normal', 'yscale',  [ -6.4 6.4   -6.4:.8:6.4 ] );



% plot new analysis:

fprintf('\n******\nProcessing subject %s\n******\n\n', sub_to_process);
ERP = pop_loaderp( 'filename', [cur_sub '_LOTP_4AFC_ERP2_ERP_contra_ipsi_diff_blocked_mixed.erp'], 'filepath', char(sub_folder) );

ERP = pop_ploterps( ERP, [1 2],  1:11 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 4 3], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 103.714 29.6429 106.857 31.9286], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
 [ -200.0 698.0   -200:100:600 ], 'YDir', 'normal' );

% only P07/P08:

ERP = pop_ploterps( ERP,  [1 2], 9, 'AutoYlim', 'off', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 1 1], 'ChLabel', 'on', 'FontSizeChan',...
  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' , 'b-' }, 'LineWidth',  1, 'Maximize', 'off',...
 'Position', [ 103.667 29.6667 106.833 31.9167], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale', [ -200.0 698.0 -200:100:600 ],...
 'YDir', 'normal', 'yscale',  [ -6.4 6.4   -6.4:.8:6.4 ] );




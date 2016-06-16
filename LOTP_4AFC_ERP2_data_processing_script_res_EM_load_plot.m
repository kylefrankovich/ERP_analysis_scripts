
ERP_data_folder = '/Users/kfranko/Box Sync/ERP_experiment_data/LOTP_4AFC_processed_data/';
subject_list = {'S01','S03','S04','S05','S06','S07','S08','S09','S12','S13','S14','S16','S17','S18','S19'};

numsubjects = length(subject_list); % number of subjects

cur_sub = 6;
sub_folder = fullfile(ERP_data_folder, subject_list(cur_sub), '/');

fprintf('\n******\nProcessing subject %s\n******\n\n', subject_list{cur_sub});
ERP = pop_loaderp( 'filename', 'ERP_collapsed_res_EM.erp', 'filepath', char(sub_folder) );                                                                                                                                                                                                                                                                                                
ERP = pop_ploterps( ERP, [ 5 6],33 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 6 6], 'ChLabel', 'on', 'FontSizeChan',10, 'FontSizeLeg',12, 'FontSizeTicks',10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',1, 'Maximize', 'on', 'Position', [ 103.667 29.6364 107 32], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',0, 'xscale', [ -200.0 698.0 -200:100:600 ], 'YDir', 'normal' );



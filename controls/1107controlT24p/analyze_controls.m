% auto generated by colorModel.py, modified by us

stem1107 = '../../../2012-11-07-Time_series_x2/';

beadfile = [stem1107 'Time_data/2012-11-07_BEADS-T24_42_63_P3.fcs'];
blankfile = [stem1107 'Time_data/T63-1_B9_B09_P3.fcs'];
channels{1} = Channel('Pacific Blue-A', 405, 0, 0);
channels{1} = setPrintName(channels{1}, 'Blue');
channels{1} = setLineSpec(channels{1}, 'b');
colorfiles{1} = [stem1107 'Time_data/T63-1_B6_B06_P3.fcs'];

channels{2} = Channel('PE-Tx-Red-YG-A', 561, 610, 20);
channels{2} = setPrintName(channels{2}, 'Red');
channels{2} = setLineSpec(channels{2}, 'r');
colorfiles{2} = [stem1107 'Time_data/T63-1_B5_B05_P3.fcs'];

channels{3} = Channel('FITC-A', 488, 515, 20);
channels{3} = setPrintName(channels{3}, 'Yellow');
channels{3} = setLineSpec(channels{3}, 'y');
colorfiles{3} = [stem1107 'Time_data/T63-1_B7_B07_P3.fcs'];

colorpairfiles{1} = {channels{2}, channels{3}, channels{1}, [stem1107 'Time_data/T63-1_B8_B08_P3.fcs']};
colorpairfiles{2} = {channels{3}, channels{1}, channels{2}, [stem1107 'Time_data/T63-1_B8_B08_P3.fcs']};
colorpairfiles{3} = {channels{1}, channels{2}, channels{3}, [stem1107 'Time_data/T63-1_B8_B08_P3.fcs']};
CM = ColorModel(beadfile, blankfile, channels, colorfiles, colorpairfiles);
CM=set_bead_plot(CM, 2);
CM=set_bead_min(CM, 2);
CM=set_bead_peak_threshold(CM, 300);
CM=set_FITC_channel_name(CM, 'FITC-A');
CM=set_translation_plot(CM, true);
CM=set_translation_channel_min(CM,[2,2,2]);
CM=set_noise_plot(CM, true);
settings = TASBESettings();
CM=resolve(CM, settings);
save('-V7','CM121107-T24p.mat','CM');

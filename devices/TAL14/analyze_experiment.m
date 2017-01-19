% auto generated by Experiment.py

stem1031 = '../../../2012-10-31-Triplicate_full_set/TAL14/';
%stem1106 = '../../../2012-11-06-LmrA-data/';
%stem1107 = '../../../2012-11-07-Time_series_x2/';
stem1110 = '../../../2012-11-10-Last_set/TAL14/';

experimentName = 'CascadeTriplicate';
device_name = 'TAL14';
inducer_name = 'Dox';
load('../../controls/CMtriplicate.mat');
input = channel_named(CM, 'Blue');
output = channel_named(CM, 'Yellow');
constitutive = channel_named(CM, 'Red');
level_file_pairs = ...
  {0.0,    {[stem1031 'TAL14-1_B4_B04_P3.fcs'],  [stem1031 'TAL14-2_A1_A01_P3.fcs'], [stem1110 'TAL14_A1_A01_P3.fcs']};
  0.1,    {[stem1031 'TAL14-1_B5_B05_P3.fcs'], [stem1110 'TAL14_A2_A02_P3.fcs']}; % Omitting low-quality 10/31 'TAL14-2_A2_A02_P3.fcs'
  0.2,    {[stem1031 'TAL14-1_B6_B06_P3.fcs'], [stem1110 'TAL14_A3_A03_P3.fcs']}; % Omitting low-quality 10/31 'TAL14-2_A3_A03_P3.fcs'
  0.5,    {[stem1031 'TAL14-1_B7_B07_P3.fcs'],  [stem1031 'TAL14-2_A4_A04_P3.fcs'], [stem1110 'TAL14_A4_A04_P3.fcs']};
  1.0,    {[stem1031 'TAL14-1_B8_B08_P3.fcs'],  [stem1031 'TAL14-2_A5_A05_P3.fcs'], [stem1110 'TAL14_A5_A05_P3.fcs']};
  2.0,    {[stem1031 'TAL14-1_B9_B09_P3.fcs'],  [stem1031 'TAL14-2_A6_A06_P3.fcs'], [stem1110 'TAL14_A6_A06_P3.fcs']};
  5.0,    {[stem1031 'TAL14-1_B10_B10_P3.fcs'], [stem1031 'TAL14-2_A7_A07_P3.fcs'], [stem1110 'TAL14_A7_A07_P3.fcs']};
  10.0,   {[stem1031 'TAL14-1_B11_B11_P3.fcs'], [stem1031 'TAL14-2_A8_A08_P3.fcs'], [stem1110 'TAL14_A8_A08_P3.fcs']};
  20.0,   {[stem1031 'TAL14-1_B12_B12_P3.fcs'], [stem1031 'TAL14-2_A9_A09_P3.fcs'], [stem1110 'TAL14_A9_A09_P3.fcs']};
  50.0,   {[stem1031 'TAL14-1_C1_C01_P3.fcs'], [stem1110 'TAL14_A10_A10_P3.fcs']}; % Omitting low-quality 10/31 'TAL14-2_A10_A10_P3.fcs'
  100.0,  {[stem1031 'TAL14-1_C2_C02_P3.fcs'],  [stem1031 'TAL14-2_A11_A11_P3.fcs'], [stem1110 'TAL14_A11_A11_P3.fcs']};
  200.0,  {[stem1031 'TAL14-1_C3_C03_P3.fcs'],  [stem1031 'TAL14-2_A12_A12_P3.fcs'], [stem1110 'TAL14_A12_A12_P3.fcs']};
  500.0,  {[stem1031 'TAL14-1_C4_C04_P3.fcs'],  [stem1031 'TAL14-2_B1_B01_P3.fcs'], [stem1110 'TAL14_B1_B01_P3.fcs']};
  1000.0, {[stem1031 'TAL14-1_C5_C05_P3.fcs'],  [stem1031 'TAL14-2_B2_B02_P3.fcs'], [stem1110 'TAL14_B2_B02_P3.fcs']};
  2000.0, {[stem1031 'TAL14-1_C6_C06_P3.fcs'],  [stem1031 'TAL14-2_B3_B03_P3.fcs'], [stem1110 'TAL14_B3_B03_P3.fcs']}};
experiment = Experiment(experimentName,{inducer_name}, level_file_pairs);
fprintf('Starting analysis...\n');
bins = BinSequence(4,0.1,10,'log_bins');
AP = AnalysisParameters(bins,{'input',input; 'output',output; 'constitutive' constitutive});
AP=setMEFLPerPlasmid(AP,1000');
AP=setMinValidCount(AP,100');
AP=setPemDropThreshold(AP,5');
AP=setUseAutoFluorescence(AP,false');
sampleresults = process_data(CM,experiment,AP);
results = summarize_data(CM,experiment,AP,sampleresults);
OS = OutputSettings('Fine',device_name,'');
plot_bin_statistics(sampleresults,OS);
plot_IO_characterization(results,OS);
OSind = OutputSettings('Fine',inducer_name,'');
plot_inducer_characterization(results,OSind);
save('-V7','TAL14-Fine.mat','CM','experiment','AP','sampleresults','results');

% auto generated by Experiment.py

stem1031 = '../../../2012-10-31-Triplicate_full_set/LmrA-TAL21/';
stem1110 = '../../../2012-11-10-Last_set/LmrA-TAL21/';

experimentName = 'CascadeTriplicate';
device_name = 'LmrA-TAL21';
inducer_name = 'Dox';
load('../../controls/CMtriplicate.mat');
input = channel_named(CM, 'Blue');
output = channel_named(CM, 'Yellow');
constitutive = channel_named(CM, 'Red');
level_file_pairs = ...
 {0.0,    {[stem1031 'LmrA-TAL21-1_A1_A01_P3.fcs'],  [stem1031 'LmrA-TAL21-2_D10_D10_P3.fcs'], [stem1110 'LmrA-TAL21_C7_C07_P3.fcs']};
  0.1,    {[stem1031 'LmrA-TAL21-1_A2_A02_P3.fcs'],  [stem1031 'LmrA-TAL21-2_D11_D11_P3.fcs'], [stem1110 'LmrA-TAL21_C8_C08_P3.fcs']};
  0.2,    {[stem1031 'LmrA-TAL21-1_A3_A03_P3.fcs'],  [stem1031 'LmrA-TAL21-2_D12_D12_P3.fcs'], [stem1110 'LmrA-TAL21_C9_C09_P3.fcs']};
  0.5,    {[stem1031 'LmrA-TAL21-1_A4_A04_P3.fcs'],  [stem1031 'LmrA-TAL21-2_E1_E01_P3.fcs'],  [stem1110 'LmrA-TAL21_C10_C10_P3.fcs']};
  1.0,    {[stem1031 'LmrA-TAL21-1_A5_A05_P3.fcs'],  [stem1031 'LmrA-TAL21-2_E2_E02_P3.fcs'],  [stem1110 'LmrA-TAL21_C11_C11_P3.fcs']};
  2.0,    {[stem1031 'LmrA-TAL21-1_A6_A06_P3.fcs'],  [stem1031 'LmrA-TAL21-2_E3_E03_P3.fcs'],  [stem1110 'LmrA-TAL21_C12_C12_P3.fcs']};
  5.0,    {[stem1031 'LmrA-TAL21-1_A7_A07_P3.fcs'],  [stem1031 'LmrA-TAL21-2_E4_E04_P3.fcs'],  [stem1110 'LmrA-TAL21_D1_D01_P3.fcs']};
  10.0,   {[stem1031 'LmrA-TAL21-1_A8_A08_P3.fcs'], [stem1110 'LmrA-TAL21_D2_D02_P3.fcs']}; % Failed data point: 'LmrA-TAL21-2_E5_E05_P3.fcs'
  20.0,   {[stem1031 'LmrA-TAL21-1_A9_A09_P3.fcs'],  [stem1031 'LmrA-TAL21-2_E6_E06_P3.fcs'],  [stem1110 'LmrA-TAL21_D3_D03_P3.fcs']};
  50.0,   {[stem1031 'LmrA-TAL21-1_A10_A10_P3.fcs'], [stem1031 'LmrA-TAL21-2_E7_E07_P3.fcs'],  [stem1110 'LmrA-TAL21_D4_D04_P3.fcs']};
  100.0,  {[stem1031 'LmrA-TAL21-1_A11_A11_P3.fcs'], [stem1031 'LmrA-TAL21-2_E8_E08_P3.fcs'],  [stem1110 'LmrA-TAL21_D5_D05_P3.fcs']};
  200.0,  {[stem1031 'LmrA-TAL21-1_A12_A12_P3.fcs'], [stem1110 'LmrA-TAL21_D6_D06_P3.fcs']}; % Failed data point: 'LmrA-TAL21-2_E9_E09_P3.fcs'
  500.0,  {[stem1031 'LmrA-TAL21-1_B1_B01_P3.fcs'],  [stem1110 'LmrA-TAL21_D7_D07_P3.fcs']}; % Failed data point:  'LmrA-TAL21-2_E10_E10_P3.fcs'
  1000.0, {[stem1031 'LmrA-TAL21-1_B2_B02_P3.fcs'],  [stem1031 'LmrA-TAL21-2_E11_E11_P3.fcs'], [stem1110 'LmrA-TAL21_D8_D08_P3.fcs']};
  2000.0, {[stem1031 'LmrA-TAL21-1_B3_B03_P3.fcs'],  [stem1031 'LmrA-TAL21-2_E12_E12_P3.fcs'], [stem1110 'LmrA-TAL21_D9_D09_P3.fcs']}};
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
save('-V7','LmrA-TAL21-Fine.mat','CM','experiment','AP','sampleresults','results');

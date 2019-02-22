# ekostat_data
Data prepared with ekostat_calculator.

The data contains one point per observation. Observations are identified by the SAMPLE_ID column. Data is compiled from a download from [sharkweb](https://sharkweb.smhi.se/). Contains data only from the months specified in HVMFS 2013:19 for each type area (summer jul-aug or jun-aug, winter dec-mar or dec-feb).

- Nutrients, surface mean values 0-10 m
- Oxygen, concentration in bottomwater and percent area below deficiency limit
- Chlorophyll, hose or bottle data according to HVMFS 2013:19 and with comments when is does not fulfill HVMFS 2013:19 requirements. One data point per sample, if duplicates are taken from the same occation they can be separeted be the SAMPLE_ID column
- Biovolume, hose data according to HVMFS 2013:19 and with comments when is does not fulfill HVMFS 2013:19 requirements. One data point per sample.
- BQI, no pre-treatment

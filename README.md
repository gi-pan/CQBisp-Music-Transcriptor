# CQBisp-Music-Transcriptor


QCBisp Music Transcriptor		v1.0 (2009)
--------------------------------------------

by Gianni Pantaleo, Paolo Nesi and Fabrizio Argenti – Department of Information Engineering, University of Florence, Italy

This software is an automatic music transcription tool, based on Constant-Q Bispectral Analysis. It is described in the following paper:

F. Argenti, P. Nesi and G. Pantaleo, "Automatic Transcription of Polyphonic Music Based on the Constant-Q Bispectral Analysis," in IEEE Transactions on Audio, Speech, and Language Processing, vol. 19, no. 6, pp. 1610-1630, Aug. 2011, doi: 10.1109/TASL.2010.2093894.
https://ieeexplore.ieee.org/abstract/document/5640655

The system was submitted to the 2009 Edition of MIREX (https://www.music-ir.org/mirex/wiki/MIREX_HOME), the Music Information Retrieval Evaluation Exchange contest. It achieved the best performance results in the Task 2B:Piano-Only Note Tracking (Average F-Measure Onset-Offset):
https://www.music-ir.org/mirex/wiki/2009:Multiple_Fundamental_Frequency_Estimation_%26_Tracking_Results#Detailed_Results_3

The system has been realized in Matlab v7.1 and v7.2 (R2006a). It has been tested on Matlab 
v7.1, v7.2 (R006a), v7.8 (R2009a) and R2017a.


Running Instructions
--------------------

To start the program, use the function do_Multi_F0.m from the Matlab command window:

   [mirex_list mirex_list_sec f0_frame_cell] = do_Multi_F0(path_in, wavname, path_out);




I / O Parameters
----------------

OUTPUTS --------------------
 
mirex_list	: Mirex format List for F0-tracking: 3-column array: 
		  mirex_list = [ONSET_samples    OFFSET_samples    F0s]. 
		  The list is ordered by ONSET_samples.
 
mirex_list_sec	: Mirex format List for F0-tracking: 3-column array: 
		  mirex_list = [ONSET_times    OFFSET_times    F0s]. 
		  The list is ordered by ONSET_times.
 
f0_frame_cell	: Cell of 10 ms spaced frame-elements; each element contains a 
		  list of active estimated F0 at that frame.

 
INPUTS ---------------------
 
path_in		: Absolute path of the folder in which the input .wav file is stored. 
		  Type the desired folder path, ending with "\\", for example 
		  'C:\CQBisp\Inputs\\'.
 
wavname 	: File name of the input .wav file. The input audio file is supposed to be a PCM .wav file sampled 
		  at 44.1 kHz, 16 bits.
 
path_out	: Absolute path of the folder in which the output files will be stored. 
		  Type the desired folder path, ending with "\\", for example 
		  'C:\CQBisp\Outputs\\'.
                  The 'path_out' folder MUST already exist or it MUST have been created before.



Output Files
------------
Both the 2 output files are created in the folder 
specified by ‘path_out’ by calling the function do_Multi_F0.m . Output files are in the following format:

[wavname]_F0_frame_by_frame.txt : 3-column txt file, each row containing a 10 ms time stamp and a list of active F0s in that frame, separated by a tab. The first line is filled with a date – time string. This file is for Mirex Task 1: Multiple F0-estimation on frame-by-frame basis.
	
[wavname]_F0_tracking.txt  :  3-column txt file, each row containing onset time, offset time and estimated note frequency, separated by a tab. Rows are ordered in terms of onset times.   The first line is filled with a date – time string. This file is for Mirex Task 2: Note Tracking.

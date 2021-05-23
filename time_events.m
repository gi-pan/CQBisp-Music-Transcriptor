%{
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.
You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
%}

function [mirex_list mirex_list_sec output_cell] = time_events (asse, param, STFT, En_TF, onsets, path_out)



logappend('NOTES DURATION Estimation','START');

[mirex_list mirex_list_sec] = get_note_list(En_TF, STFT, onsets, asse, param, path_out);

logappend('NOTES DURATION Estimation','END');
disp(' ');



logappend('F0_tracking','START');

output_cell = f0_frame_by_frame(mirex_list, param, path_out);

logappend('F0_tracking','END');
disp(' ');




return
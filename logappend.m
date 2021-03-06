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

function logappend(module, msg)

%--------------------------------------------
%	logappend(module, msg)
%
%	refreshing gloal vars
%
%	sys_TIME sys_MODULE sys_MSG sys_LOG;
%--------------------------------------------

global sys_TIME;
global sys_MODULE;
global sys_MSG;	

global sys_LOG;

if isempty(sys_TIME)
	tic;
end

time = fix(toc);

sys_TIME{end+1} = time;
sys_MODULE{end+1} = module;
sys_MSG{end+1} = msg;

logstr = strcat(' ___ ', module, ' ___ ', msg);

sys_LOG{end+1} = logstr;

sec 	= num2str(mod(time,60));
min 	= num2str(floor(time/60));
hour 	= num2str(floor(time/3600));

disp([hour blanks(1) min blanks(1) sec blanks(3) logstr]);

return

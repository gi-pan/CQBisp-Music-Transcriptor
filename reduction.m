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

function rid_spectra = reduction(spectra)

dim = round(length(spectra)/3);

for id = 1 : dim
    int = spectra(3*id-2 : 3*id);
    [val x] = max(abs(int));
    rid_spectra(id) = (spectra((3*id)-3+x));
end


return
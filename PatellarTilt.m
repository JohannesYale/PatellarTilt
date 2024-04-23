% MIT License
% 
% Copyright (c) 2024 Johannes Sieberer
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.


%% Get all knees
listing = dir ("ReliabilityFiles/AI/*.csv"); %Rater for maunal placement
 cases = struct2table(listing).name;
 results.Patellartilt = zeros(1,1);
results = struct2table(results);
f= 0;
%% Iterate through everything
for n = 1:height(listing)
%% Import data
casen = cases(n);
data = importfile(strcat("ReliabilityFiles/AI/",casen)); %Rater for maunal placement
    if(height(data) <= 26)
        %% Get Points (x,y,y)
        femPostCondLat = table2array(data(5,10:12));
        femPostCondMed = table2array(data(6,10:12));
        patLatBod = table2array(data(9,10:12));
        patMedBod = table2array(data(10,10:12));
        results.Cases(n+f) = casen;
        %% Calc stuff
        femLine = femPostCondMed - femPostCondLat;
        patLine = patMedBod - patLatBod;
        femLineXY = [femLine(1),femLine(2)];
        patLineXY = [patLine(1),patLine(2)];
        if(femLineXY(1) < 0) % Left and right knee
        results.Patellartilt(n+f) = acos(min(1,max(-1, femLineXY(:).' * patLineXY(:) / norm(femLineXY) / norm(patLineXY) ))) *180/pi;
        else
        results.Patellartilt(n+f) = acos(min(1,max(-1, patLineXY(:).' * femLineXY(:) / norm(femLineXY) / norm(patLineXY) )))*180/pi;   
        end
    else
        for m = 0:1
            if(m == 0) %Left
            femPostCondLat = table2array(data(9,10:12));
            femPostCondMed = table2array(data(10,10:12));
            patLatBod = table2array(data(17,10:12));
            patMedBod = table2array(data(18,10:12));
            f = f+m;
            results.Cases(n+f) = strcat(casen,"L");
            % Calc Patellar tilt 
            femLine = femPostCondMed - femPostCondLat;
            patLine = patMedBod - patLatBod;
            femLineXY = [femLine(1),femLine(2)];
            patLineXY = [patLine(1),patLine(2)];
            results.Patellartilt(n+f) = acos(min(1,max(-1, femLineXY(:).' * patLineXY(:) / norm(femLineXY) / norm(patLineXY) ))) *180/pi;
            
            else %Right
            femPostCondLat = table2array(data(11,10:12));
            femPostCondMed = table2array(data(12,10:12));
            patLatBod = table2array(data(19,10:12));
            patMedBod = table2array(data(20,10:12));
            f = f+m;
            results.Cases(n+f) = strcat(casen,"R");
            % Calc Patellar tilt 
            femLine = femPostCondMed - femPostCondLat;
            patLine = patMedBod - patLatBod;
            femLineXY = [femLine(1),femLine(2)];
            patLineXY = [patLine(1),patLine(2)];
            results.Patellartilt(n+f) = acos(min(1,max(-1, patLineXY(:).' * femLineXY(:) / norm(femLineXY) / norm(patLineXY) )))*180/pi;   
            end
        end
    end
end
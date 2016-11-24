function result = xbus(varargin)
%XBUS Inserts a bus of nodes into a matpc netlist.
%    XBUS generates a string of space separated node names. Each input
%    argument should be a (cell) array. All elements of these arrays are
%    converted to strings (strings remain strings). For each combination, a
%    concatenation of the strings generates a new node name. For sorting,
%    the first argument is considered to be the most significant.
%
%    Example:
%
%    xbus('in',0:7,'_')
%    results in
%    "in0_ in1_ in2_ in3_ in4_ in5_ in6_ in7_"
%
%    xbus('cell',0:1,'_',1:-1:0)
%    results in
%    "cell0_1 cell0_0 cell1_1 cell_1_0"
%
%    xbus('in',0:2,{'', 'bar'})
%    results in
%    "in0 in0bar in1 in1bar in2 in2bar"
%
%    After adding each node, XBUS checks if the string is longer than 80
%    characters.  If so, the next node will be added on a new line,
%    starting with the Spice line continuation character ('+') and a space.
%    Thus, every line is about 80 characters long, mostly somewhat longer
%    since a new line is started only after 80 characters have been
%    exceeded.
%
%    Apart from improving readability in the output file, this is essential
%    for large buses since some simulators limit the maximum number of
%    characters on a line to e.g. 1024.
%
%    This function was originally written by Bram Rooseleer and is based on
%    code made by Jorg Daniels.  It has been adapted later by Pieter Nuyts.
%
%    NOTE:
%
%    This function was originally called BUS and, when renamed to BUS, it
%    is a valid BUS function for use with the short bus syntax (using $[])
%    introduced in MAT2SPICE version 2.  However, for standard buses, a
%    simpler BUS syntax may be preferred that includes for example an
%    underscore before or square brackets around every argument, such as
%    the BUS function supplied with MAT2SPICE version 2.  This function can
%    then be used through an explicit call (using the syntax $<xbus(...)>$)
%    when more flexibility is needed.  Therefore this function was renamed
%    to XBUS.
%
%    Last edited Sep 29, 2009 by Pieter Nuyts
%    Documentation last edited July 26, 2010 by Pieter Nuyts
%
%    Based on version 0.0 (Bram Rooseleer)
%    Version 0.0.2 (Pieter Nuyts)
%
%    See also BUS, MAT2SPICE

% CHANGES BY PIETER NUYTS
%------------------------
% v0.0.1, 2009-08-26 -- Changed 'comma separated' into 'space separated' in
%         documentation
% v0.0.2, 2009-09-29 -- Added support for line breaking.  This makes the
%         resulting Spice files more readable and avoids HSpice errors
%         saying some input line is longer than 1024 characters (unless you
%         are really mean and make one bus node have more than
%         (1024-TEXTWIDTH) characters or put a lot before or after the
%         $<bus(...)>$ command.
% ------, 2010-02-03 -- Copied and renamed to XBUS to work with MAT2SPICE
%         v2.0
% ------, 2010-07-26 -- Added more documentation

indices = ones(1,length(varargin));
range = zeros(1,length(varargin));
for i=1:length(varargin)
    range(i) = length(varargin{i});
    if ischar(varargin{i})
        range(i) = 1;
    end
end

result = '';
resultline = '';

% Approximate text width.  Differs from standard wrapping width in that a
% new line is only started when the current line has TEXTWIDTH or more
% characters, so that almost every line will be slightly longer than 80
% instead of slightly shorter.  Also the first and last lines of the result
% may end up longer since the $<bus(...)>$ mat2spice command may not be
% alone on its line, so there may be more text before or after the
% approximately 80 characters.
% Set to Inf to disable wrapping.
textwidth = 80;
linecontchar = '+'; % Line continuation character

for i=1:prod(range)
    for j=1:length(indices)
         set = varargin{j};
         if ischar(set)
             resultline = [resultline set]; %#ok<AGROW>
         elseif iscell(set)
             resultline = [resultline mat2str2(set{indices(j)})]; %#ok<AGROW>
         else
             resultline = [resultline mat2str2(set(indices(j)))]; %#ok<AGROW>
         end
    end
    indices(end) = indices(end)+1;
    for j=length(indices):-1:1
        if indices(j) > range(j)
            indices(j) = 1;
            if j ~= 1
                indices(j-1) = indices(j-1) + 1;
            else
                % Append last line to RESULT as well
                result = [result resultline]; %#ok<AGROW>
                
                % Now return
                return
            end
        end
    end
    
    if length(resultline) >= textwidth
        % Append current line to RESULT
        result = [result resultline sprintf('\n')]; %#ok<AGROW>
        
        % Empty RESULTLINE and start with a continuation character
        resultline = linecontchar;
    end
    resultline = [resultline ' ']; %#ok<AGROW>
end

% Append last line to RESULT as well
result = [result resultline];

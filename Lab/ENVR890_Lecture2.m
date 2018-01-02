%%%%%%%%%%%%%%%INPUT/OUTPUT IN MATLAB%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%In addition to manually inputting values into variables and matricies,
%matlab also has the capability to read in entire files and assign them to
%memory.  Before the files can be read into matlab, some information about
%the file format is neccessary.

%%Matlab can import a wide variety of files - and not just data.  Videos,
%%images, and audio can all be read into matlab for manipulation.  For a
%%description of the different file formats that matlab has the capability
%%to read, type in help fileformats into the command window.  Each file
%%format is listed, followed by the command used to read the file and the
%%type of value returned by the command.  For a detailed description of the
%%uses of individual commands, type in help followed by the command name.
%%Note: the help command in matlab can be used for any matlab built-in
%%function and can be an incredibly helpful tool when exploring matlab.

%%For our purposes, we will look at four different input/output functions,
%%xlsread, csvread, dlmread, and the fopen function.

%%XLSREAD
%xlsread will read an .xls (excel) file.  It will divide the file into
%three parts - a matrix with all of the numerical data, a cell with all of
%the text data, and a cell with both kinds of data

[NUM WORD ALL] = xlsread('/SampleData.xlsx');

% Numerical data - Matlab will only read what it recognizes as numerical
% data.  However, notice that there is some data missing.  Those values are
% filled with NaN (not a number).  Matlab can't handle NaNs in combination
% with other numeric operations, so be wary:

blackhole = 5 + NUM(3,1);

%Text data - these are called 'strings' and work similarly to numbers.
%Although they do not have numerical values, Matlab can identify when two
%strings are the same or different, so they can be used in some logical
%statements.  

'string' == 'string'
'stringA' == 'stringB'
%'strings' == 'string'

%Cells are matricies that can hold any type of data.  The data held within
%a cell can be of different types (numbers, strings, even other cells).  
%Elements of the cell can be accessed in two different ways, either with
% exact indexing or by subsetting rows or columns:

cellElement  = WORD(15,1);
cellPortion  = WORD(28,:);
cellPortion2 = WORD{28,1:4};
% This creates a sub-set of the cell, which becomes a cell itself
% and data types are converted accordingly.

%xlsread can also be used to read off of a individual 'sheet' in excel
[NUM2 WORD2 COMBINED2] = xlsread('/SampleData.xlsx','Sheet1');%using the sheet name
[NUM2 WORD2 COMBINED2] = xlsread('/SampleData.xlsx','Sheet2');%using the sheet number

%or a given range of cells within a sheet
[NUM3 WORD3 COMBINED3] = xlsread('/SampleData.xlsx','Sheet1', 'a29:e1000');


%%delimited-data reading: csvread and dlmread

%individual pieces of data in files are seperated by what is called a
%'delimiter'.  In order for matlab to read the data file, the delimiter
%must typically be reported.

%csvread - comma delimited files
commas = csvread('sample.csv');

%to begin reading at a given row/column combination, starting with row = 0
%and column = 0 - this means the first row read is row 4 and the first
%column read is column 3
commas2 = csvread('sample.csv',3,2);

%a range of numbers, in the form [row_start column_start row_end
%column_end] can also be used to limit the size of the data read.  note
%that the first two values in the range vector should be equal to the
%starting values input into the function csvread
range = [2 1 3 2];
commas3 = csvread('sample.csv',2,1,range);

%dlmread - other delimited files
%dlmread can either infer what delimiter is used based on the format of the
%individual file, or one can be specified

dlm = dlmread('sample.txt');
dlm2 = dlmread('sample.txt',' ');

%%fopen
%more generic file-reading techniques can be used by fopen, which only
%gives matlab 'access' to a file.  fopen must be used along with other
%functions to read data into matlab's memory
filename = 'Borg_TriangleNOAA5.out';
fid = fopen(filename);
C = textscan(fid,'%n%n%n%n%n%n%n','Headerlines',5);
fclose(fid)


%fopen can also be combined with the function fgetl to read one line at a
%time.  fgetl will read an entire line as a string, even if that line
%includes numbers
filename = 'sample.csv';
fid = fopen(filename);
numLines = 0;
tline = fgetl(fid);
tline = fgetl(fid);
tline = fgetl(fid);
fclose(fid)

%in order to get usable data from this file, we will have to manipulate the
%function fgetl a little bit.  This is a data file with what look to be two
%different delimeters, a ',' and a ';'.  In actuality, the file is from
%outside the US where a comma is used in place of a period as a decimal.
%This will screw up the reading, especially if you try to open the file up
%in something like Excel.  Instead of going through and manually finding
%and replacing all the commas with periods (as there could be many, many
%different files), we want to write a matlab script that will help to read
%the file
filename = 'RE120012.csv';
fid = fopen(filename);%open read access in matlab
tline = fgetl(fid);
tline = fgetl(fid);%the file has two headerlines, we want to skip through them
numLines = 0;
while 1%we don't know how many lines are in each file, we can break the loop
        %once we reach the end of the file
    numLines = numLines+1;%keep track of the line number
    tline = fgetl(fid);%reads each line
    if ~ischar(tline)%this will end the loop when there is nothing left to read
        break
    end
    
    %each tline will be a string of characters.  we don't know how big each
    %string will be (and this can change from line to line).  Need to find
    %out what point all the breaks occur
    for y = 1:length(tline)%loop looking for the first comma
        if tline(y) ==','
            comma(1) = y;%saves the location of the comma
            break
        end
    end
    for z = (y+1):length(tline)%loop looking for the first semicolon
        if tline(z) == ';'
            semicolon(1) = z;
            break
        end
    end
    for a = (z+1):length(tline)%loop looking for the second comma
        if tline(a) == ','
            comma(2) = a;
            break
        end
    end
    for b = (a+1):length(tline)%loop looking for the second semicolon
        if tline(b) ==';'
            semicolon(2) = b;
            break
        end
    end
    augChar = tline(1:(comma(1)-1));%non-decimal portion of the first number
    aug1Char = tline((comma(1)+1):(semicolon(1)-1));%decimal portion of the first number
    aug2Char = tline((semicolon(1)+1):(comma(2)-1));%non-decimal portion of the second number
    aug3Char = tline((comma(2)+1):(semicolon(2)-1));%decimal portion of the second number
    
    %combines the string components and turns them into numbers
    combinedNums(numLines,1) = str2num([augChar '.' aug1Char]);
    combinedNums(numLines,2) = str2num([aug2Char '.' aug3Char]);
end
fclose(fid)




%%Writing files
%Files are written in matlab in much the same way as they are read.
xlswrite('combined.xls',ALL)%can write both cells and number arrays
csvwrite('numbers.csv',NUM)%only number arrays
dlmwrite('numbers.out',NUM,'delimiter',' ')

%fopen can also be used to open a new file for writing
fid = fopen('combinedNums.txt','w+');
fprintf(fid,'%f %f\n',combinedNums)%the backslash n at the end signfies a new line
fclose(fid)                         %the delimiter is what is in between the %f


fid = fopen('combinedNums.txt','w+');
fprintf(fid,'%f,%f\n',combinedNums)%the backslash n at the end signfies a new line
fclose(fid)                         %the delimiter is what is in between the two %f's


%variables can also be saved to a folder as matlab variables using the save
%command

save anythingWorks %this saves everything in the memory as the file anythingWorks.mat
save anythingWorks combinedNums %this saves the array combinedNums as the file anythingWorks.mat
load anythingWorks










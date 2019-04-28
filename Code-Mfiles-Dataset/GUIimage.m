function GUIimage
%% Grafical User Interface----Image Enhancement Based on Genetic Algorithm
%
%when press a button: 
%1- select and read an image that user choose from listbox
%2- send GA parameters and image matrix with original size to 'main' function
%3- show wanted values after evaluation process by main and return wanted values
% wanted values are: 1-number of edges detected by sobel operator 
%                      2- PSNR (Peak Signal to Noise Ratio)
%                           3-running time
%% ************************************************************************
close all;
clear all;
clc;

%Controls Colors Define
panel_color=[0.55 0.75 0.65];
entryField_color=[1 1 1];
button_color=[0.4 0.4 0.9];
res_color=[0.2 0.2 0.3];

%% Handles and Controls Define
hFigure=figure(...
    'Units','Pixels',...
    'Position',[100 100 400 400],...
    'Toolbar','none',...
    'MenuBar','none',...
    'NumberTitle','off',...
    'Color',[.5 .5 .5],...
    'Name','Image Enhancement Genetic Algorithm');

hPanel=uipanel(...
    'Parent', hFigure,...
    'Units','Pixels',...
    'Position',[0 0 400 400],...
    'BackgroundColor',panel_color);

hGen=uicontrol(...
    'Style','Edit',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[5 10 100 25],...
    'String','100',...
    'BackgroundColor',entryField_color);

hGenl=uicontrol(...
    'Style','Text',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[110 10 100 17],...
    'String','Max Generation',...
    'BackgroundColor',panel_color);

hPc=uicontrol(...
    'Style','Edit',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[5 40 100 25],...
    'String','0.8',...
    'BackgroundColor',entryField_color);

hPcl=uicontrol(...
    'Style','Text',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[110 40 100 17],...
    'String','Crossover Rate',...
    'BackgroundColor',panel_color);

hPm=uicontrol(...
    'Style','Edit',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[5 70 100 25],...
    'String','0.1',...
    'BackgroundColor',entryField_color);

hPml=uicontrol(...
    'Style','Text',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[110 70 100 17],...
    'String','Mutation Rate',...
    'BackgroundColor',panel_color);

hPopsize=uicontrol(...
    'Style','Edit',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[5 100 100 25],...
    'String','10',...
    'BackgroundColor',entryField_color);

hPopsizel=uicontrol(...
    'Style','Text',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[110 100 100 17],...
    'String','Population Size',...
    'BackgroundColor',panel_color);

hedges=uicontrol(...
    'Style','Text',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[230 30 70 25],...
    'FontSize',14,...
    'String','0',...
    'BackgroundColor',res_color);

hedgel=uicontrol(...
    'Style','Text',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[305 30 100 17],...
    'String','Number of Edges',...
    'BackgroundColor',panel_color);

hpsnr=uicontrol(...
    'Style','Text',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[230 60 70 25],...
    'FontSize',14,...
    'String','0',...
    'BackgroundColor',res_color);

hpsnrl=uicontrol(...
    'Style','Text',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[305 60 100 17],...
    'String','PSNR',...
    'BackgroundColor',panel_color);

htime=uicontrol(...
    'Style','Text',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[230 90 70 25],...
    'FontSize',14,...
    'String','0',...
    'BackgroundColor',res_color);

htimel=uicontrol(...
    'Style','Text',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[305 90 100 17],...
    'String','Running Time',...
    'BackgroundColor',panel_color);

himlist=uicontrol(...
    'Style','listbox',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[90 160 110 215],...
    'String','Galaxia-225|5236-220|7741-230|Crowd-230|Plane-256|baboon-rgb-235|lenna-rgb-235|galax-rgb-235|lenna-256|f16-rgb-512|peppers-rgb-256|test-256|galaxrgb|NGC|spiral',...
    'BackgroundColor',entryField_color);

himlistl=uicontrol(...
    'Style','Text',...
    'Parent',hPanel,...
    'Units','Pixel',...
    'Position',[205 240 190 100],...
    'HorizontalAlignment','center',...
    'String','Select Test Image. Press "Show image" if Want to See Image. Press "Get Enhance" to Enhancing Image',...
    'BackgroundColor',panel_color);

hButton=uicontrol(...
    'Style','pushbutton',...
    'Parent',hPanel,...
    'Units','Pixels',...
    'Position',[5 130 100 20],...
    'String','Get Enhance',...
    'BackgroundColor',button_color,...
    'Callback',@Start_callback);

hButton1=uicontrol(...
    'Style','pushbutton',...
    'Parent',hPanel,...
    'Units','Pixels',...
    'Position',[90 375 110 20],...
    'String','Show image',...
    'BackgroundColor',button_color,...
    'Callback',@Showimage_callback);

handles=[hFigure,hPanel,hGen,hPc,hPm,hPopsize,hedges,hpsnr,htime,...
    hButton,hButton1,himlist];

set(handles,...
    'Units','Normalized'); %normalized position units: from (0,0) to (1,1)

%% Callbacks for Buttons

    %callback for button 'Get enhance' 
    function Start_callback(hObject,eventdata)
        
        %reading parameters
        Gen=str2double(get(hGen,'String'));              
        Pc=str2double(get(hPc,'String'));
        Pm=str2double(get(hPm,'String'));
        Popsize=str2double(get(hPopsize,'String'));
        imname=get(himlist,'Value'); %get selected value number from listbox
        
        %read selected image
        switch imname
            case 1
                imtest=imread('5236.tif');
            case 2
                imtest=imread('52361.tif');
            case 3
                imtest=imread('7741.tif');
            case 4
                imtest=imread('crowd.tif');
            case 5
                imtest=imread('plane.tif');
            case 6
                imtest=imread('baboon1.tif');
            case 7
                imtest=imread('lenna1.tif');
            case 8
                imtest=imread('galaxrgb.tif');
            case 9
                imtest=imread('lenna256.gif');
            case 10
                imtest=imread('f16.tif');
            case 11
                imtest=imread('peppers.tif');
            case 12
                imtest=imread('t.tiff');
            case 13
                imtest=imread('galax.tif');
            case 14
                imtest=imread('NGC.tif');
            case 15
                imtest=imread('spiral.tif');
        end
        
        % send required value to 'main' function for evaluate 'PSNR'
        % Number of edges and running time
        [psnr,edg,time]= main(Popsize,Pc,Pm,Gen,imtest);
        set(hedges,'String',num2str(edg)); %return evaluated values and show
        set(hpsnr,'String',num2str(psnr));
        set(htime,'String',num2str(time));
    end

    % Callback for button 'Show Image'
    % role: show selected image before enhancement if user want
    function Showimage_callback(hObject,eventdata)
        imname=get(himlist,'Value');
        switch imname
            case 1
                imtest=imread('5236.tif');
            case 2
                imtest=imread('52361.tif');
            case 3
                imtest=imread('7741.tif');
            case 4
                imtest=imread('crowd.tif');
            case 5
                imtest=imread('plane.tif');
            case 6
                imtest=imread('baboon1.tif');
            case 7
                imtest=imread('lenna1.tif');
            case 8
                imtest=imread('galaxrgb.tif');
            case 9
                imtest=imread('lenna256.gif');
            case 10
                imtest=imread('f16.tif');
            case 11
                imtest=imread('peppers.tif');
            case 12
                imtest=imread('t.tiff');
            case 13
                imtest=imread('galax.tif');
            case 14
                imtest=imread('NGC.tif');
            case 15
                imtest=imread('spiral.tif');
        end
        figure('Position',[800 550 256 256]);
        imshow(imtest);
    end

%**************************************************************************
%***************************** END Function********************************
end
%**************************************************************************
%**************************************************************************
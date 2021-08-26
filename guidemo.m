function varargout = guidemo(varargin)
% GUIDEMO MATLAB code for guidemo.fig
%      GUIDEMO, by itself, creates a new GUIDEMO or raises the existing
%      singleton*.
%
%      H = GUIDEMO returns the handle to a new GUIDEMO or the handle to
%      the existing singleton*.
%
%      GUIDEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDEMO.M with the given input arguments.
%
%      GUIDEMO('Property','Value',...) creates a new GUIDEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guidemo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guidemo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guidemo

% Last Modified by GUIDE v2.5 09-Feb-2019 21:15:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guidemo_OpeningFcn, ...
                   'gui_OutputFcn',  @guidemo_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guidemo is made visible.
function guidemo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guidemo (see VARARGIN)

% Choose default command line output for guidemo
handles.output = hObject;
i=1;
j=1;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guidemo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guidemo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[img, pathname] = uigetfile('*.*', 'Pick a MATLAB code file');
    if isequal(img,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
        img=imread(strcat(pathname,img));
        axes(handles.axes1);
        imshow(img);
        img=rgb2gray(img)
        img=imresize(img,[92 112]);

     handles.img=img;
    end
   
 % Update handles structure
guidata(hObject, handles);   

% --- Executes on button press in Add_Image_to_Database.
function Add_Image_to_Database_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Image_to_Database (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
messaggio='Insert the number of class: each class determins a person. The ID number is a progressive, integer number. Each class should include a number of images for each person, with some variations in expression and in the lighting.';
img=handles.img;
% x = rgb2gray(img);
   
%     img=imresize(x,[92 112]);

        if exist('img')
            if (exist('sign_database.dat')==2)
                load('sign_database.dat','-mat');
                sign_number=sign_number+1;
                data{sign_number,1}=double(img);
                prompt={strcat(messaggio,'Class number must be a positive integer <= ',num2str(max_class))};
                title='Class number';
                lines=1;
                def={'1'};
                answer=inputdlg(prompt,title,lines,def);
                zparameter=double(str2num(char(answer)));
                if size(zparameter,1)~=0
                    class_number=zparameter(1);
                    if (class_number<=0)||(class_number>max_class)||(floor(class_number)~=class_number)||(~isa(class_number,'double'))||(any(any(imag(class_number))))
                        warndlg(strcat('Class number must be a positive integer <= ',num2str(max_class)),' Warning ')
                    else
                        disp('Features extraction...please wait');
                        if class_number==max_class;
                            % this person (class) has never been added to
                            % database before this moment
                            max_class = class_number+1;
                            [features1,valid_points1] = findfeatures(img)

                        
                        else
                            % this person (class) has already been added to
                            % database
                             [features1,valid_points1] = findfeatures(img)

%                             features  = findfeatures(img);
                        end


                        data{sign_number,2} = class_number;
                        L = length(features1);
                        count=features_size;
                        value=count;
                        features_data{count,1} = features1;
                        features_data{count,2} = class_number;
                        features_data{count,3} = valid_points1;
                        count=count+1;

                            
                        features_size = count;
                        clc;
                        save('sign_database.dat','data','sign_number','max_class','features_data','features_size','-append');
                        msgbox(strcat('Database already exists: image succesfully added to class number ',num2str(class_number)),'Database result','help');
                        clear('img')
                    end
                else
                    warndlg(strcat('Class number must be a positive integer <= ',num2str(max_class)),' Warning ')
                end
            else
                sign_number=1;
                 count=1;

                max_class=1;
                data{sign_number,1}=double(img);
                prompt={strcat(messaggio,'Class number must be a positive integer <= ',num2str(max_class))};
                title='Class number';
                lines=1;
                def={'1'};
                answer=inputdlg(prompt,title,lines,def);
                zparameter=double(str2num(char(answer)));
                if size(zparameter,1)~=0
                    class_number=zparameter(1);
                    if (class_number<=0)||(class_number>max_class)||(floor(class_number)~=class_number)||(~isa(class_number,'double'))||(any(any(imag(class_number))))
                        warndlg(strcat('Class number must be a positive integer <= ',num2str(max_class)),' Warning ')
                    else
                        disp('Features extraction...please wait');
                        max_class=2;
                        data{sign_number,2}=class_number;
                         [features1,valid_points1] = findfeatures(img)
%                         features  = findfeatures(img);
%                         L = length(features1);
%                         for ii=1:L
                            features_data{count,1} = features1;
                            features_data{count,2} = class_number;
                            features_data{count,3} = valid_points1;
                            count=count+1;

                        features_size = count;
                        clc;
                        save('sign_database.dat','data','sign_number','max_class','features_data','features_size');
                        msgbox(strcat('Database was empty. Database has just been created. Image succesfully added to class number ',num2str(class_number)),'Database result','help');
                        clear('img')
                    end
                
                else
                    warndlg(strcat('Class number must be a positive integer <= ',num2str(max_class)),' Warning ')
                end

            end
        else
            errordlg('No image has been selected.','File Error');
        end


% --- Executes on button press in Database.
function Database_Callback(hObject, eventdata, handles)
% hObject    handle to Database (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (exist('sign_database.dat')==2)
            load('sign_database.dat','-mat');
            msgbox(strcat('Database has ',num2str(sign_number),' image(s). There are',num2str(max_class-1),' class(es). Input images must have the same size.'),'Database result','help');
        else
            msgbox('Database is empty.','Database result','help');
        end


% --- Executes on button press in Recognition.
function Recognition_Callback(hObject, eventdata, handles)
% hObject    handle to Recognition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=handles.img;
mxc=[];
cls=[];
if exist('img')

            if (exist('sign_database.dat')==2)
                disp('Features extraction for face recognition...please wait');
                % code for face recognition
                                load('sign_database.dat','-mat');

                 [features1,valid_points1] = findfeatures(img)
                 ddd=features_size-1;
                 for i=1:ddd
                     
                     features2 = features_data{i,1};
                     valid_points2=features_data{i,3};
                     class=features_data{i,2};
                     [Count] = CompareFeatures(features1,valid_points1,features2,valid_points2)
                     
                     mxc(i)=Count;
                     cls(i)=class;

                 end
%                  mxc=finalcount{:,1};
%                  cls=finalcount{:,2}
                 [Maxcount,index]=max(mxc);
                 Recognizedclass=cls(index);
                 
                    if (Maxcount >= 2) 
%%
                    disp('matched');
                    str5='matched';
                    disp(Recognizedclass);
                    Recognizedclass1=num2str(Recognizedclass);
                    set(handles.edit2,'String',Recognizedclass1);
                    set(handles.edit3,'String',str5);

                    else

                    disp('Not Matched');
                    str5='Not matched';
                    Recognizedclass1='Nil'
                    set(handles.edit3,'String',str5);
                    set(handles.edit2,'String',Recognizedclass1);


                    end

                 disp('brekpoint');

%                 features  = findfeatures(img);
%                 L = length(features);
%                 score = zeros(max_class-1,1);
%                 for ii=1:L
%                     pesi = zeros(features_size,1);
%                     for jj=1:features_size
%                         pesi(jj)=norm(features{ii}-features_data{jj,1});
%                     end
%                     [val,pos]=min(pesi);
%                     trovato = features_data{pos,2};
%                     score(trovato)=score(trovato)+1;
%                 end
%                 [val,pos]=max(score);
%                 clc;
%                 disp('Person recognized ID');
%                 disp(pos);
%                 pos1=num2str(pos)
%                 set(handles.edit_class,'String',pos);
            else
                warndlg('No image processing is possible. Database is empty.',' Warning ')
            end
        else
            warndlg('Input image must be selected.',' Warning ')
        end






% --- Executes on button press in Delete_Database.
function Delete_Database_Callback(hObject, eventdata, handles)
% hObject    handle to Delete_Database (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (exist('sign_database.dat')==2)
    button = questdlg('Do you really want to remove the Database?');
    if strcmp(button,'Yes')
        delete('sign_database.dat');
        msgbox('Database was succesfully removed from the current directory.','Database removed','help');
    end
else
    warndlg('Database is empty.',' Warning ')
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

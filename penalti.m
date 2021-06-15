function [H] = penalti()
    clear all
    close all
    pkg load image
    
    F = [0 0;0 2.44;7.32 2.44;7.32 0];
    img = imread(input('nome do imagem:  ', 's'));
    imshow(img)
    title('Clique na sequencias: dir-inf; dir-sup; esq-sup; esqu-inf')
    [plin,pcol] = ginput(4);
    close all
    
    L = [plin,pcol];
    [A,avgres] = dlt2d(F,L);
    Href = rec2d(A, L);
    disp('Reconstruction goal reference')
    disp(Href)
    
    imshow(img)
    title('Mark your points')
    [plinpix,pcolpix] = ginput();
    
    cc2d = [plinpix, pcolpix];
    
    H = rec2d(A, cc2d);
    
end



function [A,avgres] = dlt2d(F,L,Cut)
% function [A,avgres] = dltfu2d(F,L,Cut)
% Description: Program to calculate 2-dimensional DLT coefficient for one camera
%               Note that at least 4 (valid) calibration points are needed
%               function [A,avgres] = dltfu(F,L,Cut)
% Input:  - F      matrix containing the global coordinates (X,Y)
%                  of the calibration frame
%                  e.g.: [0 20;0 50;0 100;60 20 ...]
%         - L      matrix containing 2d coordinates of calibration 
%                  points seen in camera (same sequence as in F)
%                  e.g.: [1200 1040; 1200 1360; ...]
%         - Cut    points that are not visible in camera;
%                  not being used to calculate DLT coefficient
%                  e.g.: [1 7] -> calibration point 1 and 7 
%                  will be discarded.
%                  This input is optional (default Cut=[]) 
% Output: - A      8 DLT coefficients
%         - avgres average residuals (measure for fit of dlt)
%                  given in units of camera coordinates
%
% Author: Christoph Reinschmidt, HPL, The University of Calgary
% Date:        January, 1994
% Last changes: November 29, 1996
% Version:     1.0
% References:  Woltring and Huiskes (1990) Stereophotogrammetry. In
%               Biomechanics of Human Movement (Edited by Berme and
%               Cappozzo). pp. 108-127.
% Adapted from dltfu.m (3-dimensional DLT)
% Liduin Meershoek, University of Utrecht
% April, 1997
%

if nargin==2; Cut=[]; end;

#if size(F) ~= size(L)
#disp('# of calibration points entered and seen in camera do not agree'), break
#end

m=size(F,1); Lt=L'; C=Lt(:);

for i=1:m
  B(2*i-1,1)  = F(i,1); 
  B(2*i-1,2)  = F(i,2); 
  B(2*i-1,3)  = 1;
  B(2*i-1,7)  =-F(i,1)*L(i,1);
  B(2*i-1,8)  =-F(i,2)*L(i,1);
  B(2*i,4)    = F(i,1);
  B(2*i,5)    = F(i,2);
  B(2*i,6)    = 1;
  B(2*i,7)    =-F(i,1)*L(i,2);
  B(2*i,8)    =-F(i,2)*L(i,2);
end

% Cut the lines out of B and C including the control points to be discarded
Cutlines=[Cut.*2-1, Cut.*2];
B([Cutlines],:)=[];
C([Cutlines],:)=[];

% Solution for the coefficients
A=B\C;
D=B*A;
R=C-D;
res=norm(R); avgres=res/size(R,1)^0.5;
end


function [H] = rec2d(A,cc2d)
%function [H] = rec2d(A,cc2d)
% Description: Reconstruction of 2D coordinates with the use of local camera
%         coordinates and the DLT coefficients for one camera.
% Input:  - A  file containing DLT coefficients of the camera
%              [a1 ; a2 ;...]
%         - cc2d  camera coordinates of points
%              [xcam,ycam ;same at time 2]
% Output: - H  global coordinates, residuals,
%              [Xt1,Yt1; same for t2]
% Author: Christoph Reinschmidt, HPL, The University of Calgary
% Date:        September, 1994
% Last change:  November 29, 1996
% Version:     1.1
% Adapted from reconfu.m (3-dimensional DLT)
% Liduin Meershoek, University of Utrecht
% April, 1997


n=size(A,2);
% check whether the numbers of cameras agree for A and cc2d
%if size(A,2)~=1 | size(cc2d,2)~=2; disp('there is more then one camera given in A or cc2d')
%                   disp('hit any key and then "try" again'); pause; break
%end


H(size(cc2d,1),2)=[0];         % initialize H

% ________Building cc2d1, cc2d2:       cc2d1 * G (X,Y) = cc2d2________________________

for k=1:size(cc2d,1)  %number of time points
    cc2d1=[]; cc2d2=[];  % initialize cc2d1,cc2d2
    x=cc2d(k,1); y=cc2d(k,2);
    if ~(isnan(x) | isnan(y))  % do not construct cc2d1,cc2d2 if camx,y=NaN
     cc2d1=[A(1)-x*A(7), A(2)-x*A(8) ; ...
         A(4)-y*A(7), A(5)-y*A(8) ];
     cc2d2=[x-A(3);y-A(6)];
    end

  if (size(cc2d2,1))==2  % check whether data available
   g=cc2d1\cc2d2;
  else
   g=[NaN;NaN];
  end

  H(k,:)=[g'];
end
 end
function a = demo(pic)
% Demo for keypoint detection
%
% Aug. 23, 2016
%
% For further details, visit http://www.robots.ox.ac.uk/~vgg/software/keypoint_detection/

%close all; clear; clc

% Update these according to your requirements
USE_GPU = 0; % 1 for GPU
%img_fn = './test/1.png';
img_fn = pic;
imshow(img_fn)
DEMO_BASEDIR = pwd;
DEMO_MODEL_FN = fullfile(DEMO_BASEDIR,'data','keypoint-v2.mat');
MATCONVNET_DIR = fullfile(DEMO_BASEDIR, 'lib', 'matconvnet-custom');

%
% Compile matconvnet
% http://www.vlfeat.org/matconvnet/install/
%
if ~exist( fullfile(MATCONVNET_DIR, 'matlab', 'mex'), 'dir' )
  disp('Compiling matconvnet ...')
  addpath('./lib/matconvnet-custom/matlab');
  if ( USE_GPU )
    vl_compilenn('enableGpu', true);
  else
    vl_compilenn('enableGpu', false);
  end
  fprintf(1, '\n\nMatcovnet compilation finished.');
end

% setup matconvnet path variables
matconvnet_setup_fn = fullfile(MATCONVNET_DIR, 'matlab', 'vl_setupnn.m');
run(matconvnet_setup_fn) ;

% Initialize keypoint detector
keypoint_detector = KeyPointDetector(DEMO_MODEL_FN, MATCONVNET_DIR, USE_GPU);

% Detect keypoints
fprintf(1, '\nDetecting keypoints in image : %s', img_fn);
[kpx, kpy, kpname] = get_all_keypoints(keypoint_detector, img_fn);

% Display the keypoints
% 1 img = imread(img_fn);
img = img_fn;
figure('Name', 'Detected Keypoints');
imshow(img); hold on;
plot(kpx, kpy, 'r.', 'MarkerSize', round(size(img,2)/10)); hold on;

voffset = -10;
for i=1:length(kpname)
  text(double(kpx(i)), double(kpy(i) + voffset), ...
    kpname{i}, 'color', 'yellow', 'FontSize', 8, ...
    'backgroundcolor', 'black'); 
  hold on;
  voffset = voffset * -1; % to prevent cluttering of annotations
end
hold off;

xy = [kpx(7),kpx(4),kpx(5),kpx(6),kpx(3),kpx(2),kpx(1),kpx(8),kpx(10),kpx(14),kpx(15),kpx(16),kpx(13),kpx(12),kpx(11);
    kpy(7),kpy(4),kpy(5),kpy(6),kpy(3),kpy(2),kpy(1),kpy(8),kpy(10),kpy(14),kpy(15),kpy(16),kpy(13),kpy(12),kpy(11)] 

fprintf(1, '\nShowing detected keypoints:');
for i=1:length(kpname)
  fprintf(1, '\n%s\tat\t(%d,%d)', kpname{i}, kpx(i), kpy(i));
  
end
fprintf(1, '\n');
save('../camera_and_pose/release/data/3.mat','img', 'xy');
end
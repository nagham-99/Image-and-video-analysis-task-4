videoReader = VideoReader('fishes2_enh.mpg');
objWrite = VideoWriter('test');
open(objWrite);
videoPlayer = vision.VideoPlayer('Position',[100,100,680,520]);
objectFrame = readFrame(videoReader);
objectRegion = [173 191 399 1080];



objectImage = insertShape(objectFrame,'Rectangle',objectRegion,'Color','red');
figure;
imshow(objectImage);
title('Red box shows object region');
points = detectMinEigenFeatures(rgb2gray(objectFrame),'ROI',objectRegion);
pointImage = insertMarker(objectFrame,points.Location,'+','Color','white');
figure;
imshow(pointImage);
title('Detected interest points');
tracker = vision.PointTracker('MaxBidirectionalError',1);
initialize(tracker,points.Location,objectFrame);
while hasFrame(videoReader)
      frame = readFrame(videoReader);
      [points,validity] = tracker(frame);
      out = insertMarker(frame,points(validity, :),'+');
      videoPlayer(out);
         writeVideo(objWrite, out);

end
release(videoPlayer);
close(objWrite);

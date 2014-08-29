%evaluate on the val2 set from imagenet2013 
%use the default parameters as used in the demo:
%% load pre-trained edge detection model and set opts (see edgesDemo.m)
addpath(genpath('../'));

model=load('models/forest/modelBsds'); model=model.model;
model.opts.multiscale=0; model.opts.sharpen=2; model.opts.nThreads=4;

%% set up opts for edgeBoxes (see edgeBoxes.m)
opts = edgeBoxes;
opts.alpha = .65;     % step size of sliding window search
opts.beta  = .75;     % nms threshold for object proposals
opts.minScore = .01;  % min score of boxes to detect
opts.maxBoxes = 1e4;  % max number of boxes to detect


%config specifies the image location location to save output etc.
config=createConfig();

imageLoc=config.path.imageLoc;
saveLoc=config.path.outputLoc;

imageIds = textread([config.path.inputLoc config.list.imageList],'%s%*[^\n]');
for i=1:length(imageIds)

	imageName=imageIds{i}
	im=imread([imageLoc imageName '.JPEG']);
	if(size(im, 3) == 1)
		im=repmat(im,[1,1,3]);
	end
	
	bbs=edgeBoxes(im,model,opts);

	saveFile=[imageName '.mat'];
	save([saveLoc saveFile], 'bbs');
end

edgeBoxesEvaluateABO;

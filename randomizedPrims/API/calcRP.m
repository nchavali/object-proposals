function calcRP( configjson )
    rpconfig = configjson.randomPrim;
    params=LoadConfigFile(fullfile(rpconfig.rpPath, 'config/rp.mat'));
    
    if(~exist(rpconfig.imageLocation, 'dir'))
        fprintf('Image Location does not exist. Please check path once again \n');
        return;
    end
    
    images = dir(rpconfig.imageLocation);
    images = regexpi({images.name}, '.*jpg|.*jpeg|.*png|.*bmp', 'match');
    images = [images{:}];
    
    for i=1:length(images)
        imname = char(images(i));
        impath = fullfile(rpconfig.imageLocation, imname);
        im=imread(impath);

        if(size(im, 3) == 1)
            im=repmat(im,[1,1,3]);
        end
        
        fprintf('Running Randomized Prims for %s\n', imname);
        [proposals]=RP(im,params);
        saveFile=[imname '.mat'];
        save([rpconfig.outputLocation saveFile], 'proposals');
    end
end


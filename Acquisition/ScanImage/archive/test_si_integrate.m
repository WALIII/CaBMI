% scrap convert to SI format

imagingScanfield = hSI.hRoiManager.currentRoiGroup.rois(1).scanfields(1);
sources{1} = ROI.BinaryMask;
channel = 2; % green channel is 2...
    
sourceperplane = zeros(1, numel(sources));

for n = 1:numel(sources)
    theSources=sources{n};
    if n == 1
        auxn = 0;
    else
        auxn = sourceperplane(n-1);
    end
    sourceperplane(n) = size(theSources,3) + auxn;
    for k = 1:size(theSources,3)
        mask = theSources(:,:,k);
        introi.scanfields.channel = channel;
        intsf = scanimage.mroi.scanfield.fields.IntegrationField.createFromMask(imagingScanfield,mask);
        intsf.threshold = 100;
        introi = scanimage.mroi.Roi();
        introi.discretePlaneMode=1;
        introi.add(Zplanes(n + plane_offset), intsf);
        hSI.hIntegrationRoiManager.roiGroup.add(introi);
        i=i+1;
    end
end
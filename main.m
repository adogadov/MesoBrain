% Mask - binary image mask
% dFF0 - relative fluorescence data
dFF0=double(dFF0)*factor;%convert int16 to double
thr=0.5e-2;
Rmin=20;
PeaksArray=[];
PeaksArrayPrevious=[];
PeaksArrayInd=[];
PeaksArrayIndPrevious=[];
Waves=[];
wavecounter=0;
Nframes = size(dFF0,3);


for i=1:Nframes
Im = dFF0(:,:,i);
meanImVal = mean(Im(:));
Im=Mask.*Im+real(~Mask)*meanImVal;
    A=waveletDecompose(Im,10,20);

    
    WHmax=imextendedmax(A,thr);
    WHmaxCon=bwconncomp(WHmax);
    % Measure blob properties
    Peaks = regionprops(WHmaxCon,A,'WeightedCentroid','Centroid','PixelList','PixelValues');
    PeaksArray=zeros(size(Peaks,1),2);
    cnt=1;
    
    for j=1:size(Peaks,1)
        [~,nmax]=max(Peaks(j).PixelValues);
%         PeaksArray(cnt,:)=Peaks(j).PixelList(nmax,:);
        PeaksArray(cnt,:)=Peaks(j).WeightedCentroid;
        cnt=cnt+1;
    end
    
    
    
    PeaksArray=PeaksArray(1:cnt-1,:);


   
    
    
    if isempty(PeaksArrayPrevious)
      for j=1:size(PeaksArray,1)
        wavecounter=wavecounter+1;
        Waves.(horzcat('p',int2str(wavecounter))).x=PeaksArray(j,1);
        Waves.(horzcat('p',int2str(wavecounter))).y=size(A,2)+1-PeaksArray(j,2);
        Waves.(horzcat('p',int2str(wavecounter))).t0=i;
        Waves.(horzcat('p',int2str(wavecounter))).t=i;
        Waves.(horzcat('p',int2str(wavecounter))).tn=i;
        Waves.(horzcat('p',int2str(wavecounter))).Amp=A(max(1,min(256,round(PeaksArray(j,2)))),max(1,min(256,round(PeaksArray(j,1)))));
        PeaksArrayInd=[PeaksArrayInd wavecounter];
      end
    else
        DistMatrix=createDistMatrix(PeaksArrayPrevious,PeaksArray);
        MinDistPos = checkMatr(DistMatrix,Rmin);
        for j=1:length(MinDistPos)
            if ~isnan(MinDistPos(j))
                Waves.(horzcat('p',int2str(PeaksArrayIndPrevious(MinDistPos(j))))).x=...
                    [Waves.(horzcat('p',int2str(PeaksArrayIndPrevious(MinDistPos(j))))).x;PeaksArray(j,1)];
                Waves.(horzcat('p',int2str(PeaksArrayIndPrevious(MinDistPos(j))))).y=...
                    [Waves.(horzcat('p',int2str(PeaksArrayIndPrevious(MinDistPos(j))))).y; size(A,2)+1-PeaksArray(j,2)];
                 Waves.(horzcat('p',int2str(PeaksArrayIndPrevious(MinDistPos(j))))).t=...
                    [Waves.(horzcat('p',int2str(PeaksArrayIndPrevious(MinDistPos(j))))).t; i];
                Waves.(horzcat('p',int2str(PeaksArrayIndPrevious(MinDistPos(j))))).tn=i;
                Waves.(horzcat('p',int2str(wavecounter))).Amp=...
                    [Waves.(horzcat('p',int2str(wavecounter))).Amp;A(max(1,min(256,round(PeaksArray(j,2)))),max(1,min(256,round(PeaksArray(j,1)))))];
                PeaksArrayInd=[PeaksArrayInd PeaksArrayIndPrevious(MinDistPos(j))];
            else
                wavecounter=wavecounter+1;
                Waves.(horzcat('p',int2str(wavecounter))).x=PeaksArray(j,1);
                Waves.(horzcat('p',int2str(wavecounter))).y=size(A,2)+1-PeaksArray(j,2);
                Waves.(horzcat('p',int2str(wavecounter))).t0=i;
                Waves.(horzcat('p',int2str(wavecounter))).t=i;
                Waves.(horzcat('p',int2str(wavecounter))).tn=i;
                Waves.(horzcat('p',int2str(wavecounter))).Amp=A(max(1,min(256,round(PeaksArray(j,2)))),max(1,min(256,round(PeaksArray(j,1)))));          
                PeaksArrayInd=[PeaksArrayInd wavecounter];
            end
            
        end

    end
    PeaksArrayIndPrevious=PeaksArrayInd;
    PeaksArrayPrevious=PeaksArray;
    PeaksArrayInd=[];
    PeaksArray=[];
end 
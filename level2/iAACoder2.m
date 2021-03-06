function x = iAACoder2(AACSeq2, fNameOut)

frameNumber = size(AACSeq2 , 2);

channel_1 = [];
channel_2 = [];

frameF = [iTNS(AACSeq2(1).chl.frameF, AACSeq2(1).frameType, AACSeq2(1).chl.TNScoeffs) iTNS(AACSeq2(1).chr.frameF, AACSeq2(1).frameType, AACSeq2(1).chr.TNScoeffs)] ;

frameT = iFilterbank( frameF, AACSeq2(1).frameType, AACSeq2(1).winType );
prevFrameT = frameT;

%Exclude first frame
%channel_1 = [ channel_1 ; frameT(1:1024,1)];
%channel_2 = [ channel_2 ; frameT(1:1024,2)];

for i=2:frameNumber
    if strcmp(AACSeq2(i).frameType ,'ESH')
        frameF = cat(3, iTNS(AACSeq2(i).chl.frameF, AACSeq2(i).frameType, AACSeq2(i).chl.TNScoeffs) , iTNS(AACSeq2(i).chr.frameF, AACSeq2(i).frameType, AACSeq2(i).chr.TNScoeffs)) ;
        frameF = permute(frameF, [1 3 2]);
    else
        frameF = [iTNS(AACSeq2(i).chl.frameF, AACSeq2(i).frameType, AACSeq2(i).chl.TNScoeffs) iTNS(AACSeq2(i).chr.frameF, AACSeq2(i).frameType, AACSeq2(i).chr.TNScoeffs)] ;
    end
    
    frameT = iFilterbank( frameF, AACSeq2(i).frameType, AACSeq2(i).winType );
    
    %Add overlapping parts of frames
    channel_1 = [ channel_1 ; prevFrameT(1025:2048,1)+frameT(1:1024,1) ];
    channel_2 = [ channel_2 ; prevFrameT(1025:2048,2)+frameT(1:1024,2) ];
    
    prevFrameT = frameT;

end

%Exclude last frame
%channel_1 = [ channel_1 ; frameT(1025:2048,1) ];
%channel_2 = [ channel_2 ; frameT(1025:2048,2) ];

y = [channel_1 channel_2 ];

%Write decoded audio
audiowrite(fNameOut, y, 48000) ;

if nargout == 1
    x = y;
end


end
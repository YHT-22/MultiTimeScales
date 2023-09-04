function neighbor = FindNeighbor(idx, OriginMex)
    Wid = size(OriginMex, 2);
    Heg = size(OriginMex, 1);
   
    for NIdx = 1 : numel(idx)

        North = idx(NIdx) - Wid;%North
        NorthWest = idx(NIdx) - Wid - 1;%NorthWest
        NorthEast = idx(NIdx) - Wid + 1;%NorthEast
        West = idx(NIdx) - 1;%West
        East = idx(NIdx) + 1;%East
        SorthWest = idx(NIdx) + Wid - 1;%SorthWest
        Sorth = idx(NIdx) + Wid;%Sorth
        SorthEast = idx(NIdx) + Wid + 1;%SorthEast

        neighbor{NIdx, 1} = idx(NIdx);
        if idx(NIdx) == 1 %left-top
            neighbor{NIdx, 2}(1) = East;
            neighbor{NIdx, 2}(2) = Sorth;
            neighbor{NIdx, 2}(3) = SorthEast;                
        elseif idx(NIdx) == Wid %right-top
            neighbor{NIdx, 2}(1) = West;
            neighbor{NIdx, 2}(2) = SorthWest;
            neighbor{NIdx, 2}(3) = Sorth;
        elseif idx(NIdx) + Wid - 1 == numel(OriginMex) %left-bottom
            neighbor{NIdx, 2}(1) = North;
            neighbor{NIdx, 2}(2) = NorthEast;
            neighbor{NIdx, 2}(3) = East;                
        elseif idx(NIdx) == numel(OriginMex) %right-bottom
            neighbor{NIdx, 2}(1) = NorthWest;
            neighbor{NIdx, 2}(2) = North;
            neighbor{NIdx, 2}(3) = West;
        elseif idx(NIdx) - Wid < 0 && idx(NIdx) ~= 1 %top-edge
            neighbor{NIdx, 2}(1) = West;
            neighbor{NIdx, 2}(2) = East;
            neighbor{NIdx, 2}(3) = SorthWest;
            neighbor{NIdx, 2}(4) = Sorth;
            neighbor{NIdx, 2}(5) = SorthEast;
        elseif idx(NIdx) + Wid - 1 > numel(OriginMex) && idx(NIdx) ~= numel(OriginMex) %bottom-edge
            neighbor{NIdx, 2}(1) = NorthWest;
            neighbor{NIdx, 2}(2) = North;
            neighbor{NIdx, 2}(3) = NorthEast;
            neighbor{NIdx, 2}(4) = West;
            neighbor{NIdx, 2}(5) = East;
        elseif mod(idx(NIdx), Wid) == 1 && idx(NIdx) ~= 1 && idx(NIdx) + Wid - 1 ~= numel(OriginMex) %left-edge
            neighbor{NIdx, 2}(1) = North;
            neighbor{NIdx, 2}(2) = NorthEast;
            neighbor{NIdx, 2}(3) = East;
            neighbor{NIdx, 2}(4) = Sorth;
            neighbor{NIdx, 2}(5) = SorthWest;           
        elseif mod(idx(NIdx), Wid) == 0 && idx(NIdx) ~= Wid && idx(NIdx) ~= numel(OriginMex) %right-edge
            neighbor{NIdx, 2}(1) = NorthWest;
            neighbor{NIdx, 2}(2) = North;
            neighbor{NIdx, 2}(3) = West;
            neighbor{NIdx, 2}(4) = SorthWest;
            neighbor{NIdx, 2}(5) = Sorth;               
        else
            neighbor{NIdx, 2}(1) = NorthWest;
            neighbor{NIdx, 2}(2) = North;
            neighbor{NIdx, 2}(3) = NorthEast;
            neighbor{NIdx, 2}(4) = West;
            neighbor{NIdx, 2}(5) = East;
            neighbor{NIdx, 2}(6) = SorthWest;
            neighbor{NIdx, 2}(7) = Sorth;
            neighbor{NIdx, 2}(8) = SorthEast;                
        end
    end
end
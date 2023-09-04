%% Rat Linear Array
cd(fileparts(mfilename("fullpath")));
ID = [7.5, 7.6];
for idx =1 : length(ID)
    MSTIGen("ID", ID(idx));
%     MSTIomiGen("ID", ID(idx));
end


function save_scene(S)

scenes = dir('scene_*.mat');
number = [];
for i = 1:numel(scenes)
    numberStr = regexp(scenes(i).name,...
        'scene_(\d*).mat','tokens');
    numberStr  = numberStr{1};
    number(i) = str2double(numberStr);
end

if ~isempty(number)
    file_number = number(end)+1;
else
    file_number = 1;
end

filename = sprintf('scene_%s.mat',num2str(file_number,'%03i'));

save(filename,'S');
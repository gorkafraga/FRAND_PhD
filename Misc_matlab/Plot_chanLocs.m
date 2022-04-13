DIROUTPUT = 'Z:\fraga\';
Z:\fraga\EEG_ABMP\Kraak_analysis\Kraak EEG
figure; 
topoplot([],EEG.chanlocs,'headrad', 'rim','intsquare', 'on','style','blank',...
'electrodes','ptslabels','chaninfo',EEG.chaninfo);

set(gcf,'Color','w')
set(get(gca,'Title'),'Visible','off')
children = get(gca,'Children');
% %%
for l = 1:length(children);
     if strcmp(get(children(l),'Type'),'text')==1 ;
     set(children(l),'Visible', 'on', 'FontName','Calibri');
     elseif strcmp(get(children(l),'Marker'),'.')==1
         set(children(l),'MarkerSize',15);
    elseif strcmp(get(children(l),'Type'),'patch') ==1
        set(children(l),'EdgeColor',[.4 .4 .4],'FaceColor',get(children(l),'EdgeColor'))
    elseif  strcmp(get(children(l),'Type'),'line') ==1
       set(children(l),'lineWidth',2)
     end
    
end
axis tight
set(gcf, 'Position', get(0,'Screensize'));

cd (DIROUTPUT)
 export_fig ('scalplocation', '-tiff', '-cmyk', '-r300')
%   saveas (gcf,'ScalpLocations', 'tiff')
  close gcf

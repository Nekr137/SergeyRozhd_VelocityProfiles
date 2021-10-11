function sr_save_figure(h, filenameWithExt)
    rez=300; %resolution (dpi) of final graphic
    figpos=getpixelposition(h); %dont need to change anything here
    resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
    set(h,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
    %path='C:\Documents and Settings\yournamehere\Desktop\'; %the folder where you want to put the file
    print(h, filenameWithExt, '-dtiff', ['-r', num2str(rez)], '-v')
end
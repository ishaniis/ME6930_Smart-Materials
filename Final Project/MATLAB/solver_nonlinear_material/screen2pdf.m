function screen2pdf(filename)

filename=[filename];
print(gcf, '-depsc2','-loose',[filename,'.eps']);
system(['epstopdf ',filename,'.eps']);


%setenv('PATH', [getenv('PATH') ';C:\Program Files (x86)\MiKTeX 2.9\miktex\bin']);
%system(['pdfcrop ',filename,'.pdf']); 

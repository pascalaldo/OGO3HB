function sw = CalculateSW()
sw = [];
for i = 1:40
    filename = sprintf('FitResults\\%d\\fit_%d.mat',i,i);
    if exist(filename,'file') == 2
        load(filename);
        sw = [sw; Surface.RiemannsumPV(x,nipar) i];
        saveas(gcf,sprintf('FitResults\\%d\\riemann_%d.fig',i,i));
        close(gcf);
    end
end
end

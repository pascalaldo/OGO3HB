function FitResults()
global showplots;
for i = 1:40
    showplots = false;
    filename = sprintf('Results\\%d_res1.mat',i);
    if exist(filename,'file') == 2 && ~exist(sprintf('FitResults\\%d',i),'dir')
        mkdir(sprintf('FitResults\\%d',i));
        fprintf('Fitting patient %d\n',i);
        load(filename);
        psz = size(hbp);
        if psz(2) > psz(1), hbp = hbp'; end
        [x nipar] = Fit.FitModel(vt,v,hbt,hbp,i);
        showplots = true;
        Model.Circulation(x,nipar);
        saveas(gcf,sprintf('FitResults\\%d\\model_%d.fig',i,i));
        close(gcf);
    end
end
end

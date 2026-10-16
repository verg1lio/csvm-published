function verify_core
% Equivalence test: csvm_core against reference runs of the original
% CSV_Method script (ref_<seed>.mat), plus flux budget and timing checks.

seeds=[2026 7];
flds={'mV','mB','mF','mS','INT_EQ','C','F','E'};
allok=true;
for s=seeds
    R=load(sprintf('ref_%d.mat',s));
    out=csvm_core(struct('seed',s,'maps',true));
    for k=1:numel(flds)
        a=R.(flds{k}); b=out.(flds{k});
        ok=isequaln(a,b); allok=allok&&ok;
        fprintf('seed %4d  %-7s identical=%d  max|diff|=%g\n',s,flds{k},...
            ok,max(abs(a(:)-b(:))));
    end
    g={'MV','MB','MF','MS'};
    for k=1:4
        ok=isequaln(R.(g{k}),out.maps.([g{k} '0'])); allok=allok&&ok;
        fprintf('seed %4d  %s0     identical=%d\n',s,g{k},ok);
    end
    fprintf('seed %4d  mse original=%.12f  core=%.12f\n',s,R.mse,out.mse);

    % flux budgets (grid sums), step i -> i+1
    fx=out.flux; N=size(fx.B,1); a=1:N-1; b=2:N;
    rB=fx.B(b,:)-(fx.B(a,:)+fx.B_in(a,:)-fx.B_herb(a,:)-fx.B_to_F(a,:)+fx.B_clamp(a,:));
    rF=fx.F(b,:)-(fx.F(a,:)+fx.B_to_F(a,:)-fx.F_herb(a,:)-fx.F_to_S(a,:)+fx.F_clamp(a,:));
    rS=fx.S(b,:)-(fx.S(a,:)+fx.F_to_S(a,:)-fx.S_herb(a,:)-fx.S_out(a,:)+fx.S_clamp(a,:));
    rP=fx.F_to_S-(fx.F_rand+fx.F_poll+fx.F_self);
    fprintf('seed %4d  budget residual / max stock: B %.2e  F %.2e  S %.2e  split %.2e\n',...
        s,max(abs(rB(:)))/max(fx.B(:)),max(abs(rF(:)))/max(fx.F(:)),...
        max(abs(rS(:)))/max(fx.S(:)),max(abs(rP(:)))/max(fx.F_to_S(:)));
    fprintf('seed %4d  clamp totals (share of inflow): B %.2e  F %.2e  S %.2e\n',s,...
        sum(fx.B_clamp(:))/sum(fx.B_in(:)),sum(fx.F_clamp(:))/sum(fx.B_to_F(:)),...
        sum(fx.S_clamp(:))/sum(fx.F_to_S(:)));
end
fprintf('ALL IDENTICAL: %d\n',allok);

% switches and options run without error
o=csvm_core(struct('seed',1,'V1E',[0 0 6 0],'phi_herb',false,'phi_poll',false));
fprintf('switch run ok, mse=%.4f\n',o.mse);
o=csvm_core(struct('seed',1,'RorN',0));
fprintf('RorN=0 run ok, mse=%.4f\n',o.mse);

% timing
tic; for k=1:10; csvm_core(struct('seed',k)); end; t1=toc/10;
tic; for k=1:10; csvm_core(struct('seed',k,'fluxes',false)); end; t2=toc/10;
fprintf('time per run: %.3f s (fluxes on), %.3f s (fluxes off)\n',t1,t2);

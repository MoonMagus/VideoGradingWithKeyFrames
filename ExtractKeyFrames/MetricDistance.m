function metric = MetricDistance(P,Q)
% 计算两幅图像之间的最优传输距离.

PMS = P.MS;
PES = P.ES;
PMM = P.MM;
PEM = P.EM;
PMH = P.MH;
PEH = P.EH;
QMS = Q.MS;
QES = Q.ES;
QMM = Q.MM;
QEM = Q.EM;
QMH = Q.MH;
QEH = Q.EH;
metricS = trace(PES + QES - 2*(PES^(1/2)*QES*PES^(1/2))^(1/2)) + norm(PMS - QMS)^2;
metricM = trace(PEM + QEM - 2*(PEM^(1/2)*QEM*PEM^(1/2))^(1/2)) + norm(PMM - QMM)^2;
metricH = trace(PEH + QEH - 2*(PEH^(1/2)*QEH*PEH^(1/2))^(1/2)) + norm(PMH - QMH)^2;
metric = metricS + metricM + metricH;
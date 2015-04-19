function [BestPointLabels, BestMedoids, MedoidsSize] = KMedoids(MetricMatrix, Data, K)  
%%-----------------------------------------------------------------------  
% K-Medoids聚类算法 : K-Medoids Clustering
% Author: 冯亚男
% CreateTime: 2015-01-17 
%%------------------------------------------------------------------------  
%    Data是 [2 x NumFrames]矩阵. Data(1):Covariance, Data(2):Means  
%    K是聚类的数目. 
%-------------------------------------------------------------------------  
global  StatusBarHandle;
[~,Num] = size(Data);   
      
% 选取初始点   
% RepeatTimes = max(20,Num/(5*K)); 
RepeatTimes = 100;    
Errors = zeros(1,RepeatTimes);
KMedoidsSize = zeros(RepeatTimes, K);
RepeatTimes_SuccessPoints_Labels = zeros(RepeatTimes, Num);  
RepeatTimes_KMedoids = zeros(RepeatTimes, K);  
PointLabels = zeros(1,Num); 

for CurrentRepeat = 1:RepeatTimes  
    % 定义内部迭代阈值.
    iter = 0;  
    max_iteration = 1e+3; 
    KMedoids = sort(randperm(Num,K));
    %KMedoids
    UpdatedMedoids = zeros(1,K); 
    
    while iter < max_iteration  
        iter = iter+1; 
        %初始化K个中心点后对数据点进行初始分类.  
        [~,PointLabelsIndex] = min(MetricMatrix(KMedoids,:));  
        PointLabels = KMedoids(PointLabelsIndex);
   
        %更新K个中心点.
        [SortedLabel, MetricIndex] = sort(PointLabels);
        [~, SumIndex] = unique(SortedLabel);
        %SortedLabel
        SumIndex(K+1) = Num+1;
        Errors(CurrentRepeat) = 0;
        for i = 1:K
            %SumIndex
            KMedoidsSize(CurrentRepeat,i) = SumIndex(i+1) - SumIndex(i);
            index = MetricIndex(SumIndex(i):SumIndex(i+1)-1);
            [CurClusterError, UpdatedMedoidsIndex] = min(sum(MetricMatrix(index,index)));
            Errors(CurrentRepeat) = Errors(CurrentRepeat) + CurClusterError;
            UpdatedMedoids(i) = index(UpdatedMedoidsIndex);
        end
                    
        % 判断是否达到结束条件
        if KMedoids == UpdatedMedoids    
           %disp(['###迭代 ' num2str(iter) ' 次得到收敛的解'])  
           RepeatTimes_SuccessPoints_Labels(CurrentRepeat,:) = PointLabels;  
           RepeatTimes_KMedoids(CurrentRepeat,:) = UpdatedMedoids; 
           break  
        end  
        % 更新中心点集合.
        KMedoids = UpdatedMedoids;  
    end  
    
    %内部循环终止时强制写入中心点数据.
    if iter == max_iteration     
       RepeatTimes_SuccessPoints_Labels(CurrentRepeat,:) = PointLabels;  
       RepeatTimes_KMedoids(CurrentRepeat,:) = UpdatedMedoids;  
    end      
    FreshListBox(['第' num2str(CurrentRepeat) '次聚类结束'], StatusBarHandle);
    disp(['第' num2str(CurrentRepeat) '次聚类结束'])
end

%%比较聚类结果      
[~,BestIndex] = min(Errors);  
BestPointLabels = RepeatTimes_SuccessPoints_Labels(BestIndex,:);   
BestMedoids = RepeatTimes_KMedoids(BestIndex,:);  
MedoidsSize = KMedoidsSize(BestIndex,:);

% %绘制聚类点.
% figure;
% color = 'brgmcyk';
% m = length(color);
% for i = 1 : K
%     PlotIndex = find(BestPointLabels == BestMedoids(i));
%     CovData = Data(1,:);
%     CovAxis = CovData(PlotIndex); 
%     MeanData =  Data(2,:);
%     MeanAxis = MeanData(PlotIndex);
%     hold on;
%     scatter(CovAxis,MeanAxis,36,color(mod(i-1,m)+1));
% end  
        
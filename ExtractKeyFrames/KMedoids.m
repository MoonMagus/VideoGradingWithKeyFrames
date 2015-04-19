function [BestPointLabels, BestMedoids, MedoidsSize] = KMedoids(MetricMatrix, Data, K)  
%%-----------------------------------------------------------------------  
% K-Medoids�����㷨 : K-Medoids Clustering
% Author: ������
% CreateTime: 2015-01-17 
%%------------------------------------------------------------------------  
%    Data�� [2 x NumFrames]����. Data(1):Covariance, Data(2):Means  
%    K�Ǿ������Ŀ. 
%-------------------------------------------------------------------------  
global  StatusBarHandle;
[~,Num] = size(Data);   
      
% ѡȡ��ʼ��   
% RepeatTimes = max(20,Num/(5*K)); 
RepeatTimes = 100;    
Errors = zeros(1,RepeatTimes);
KMedoidsSize = zeros(RepeatTimes, K);
RepeatTimes_SuccessPoints_Labels = zeros(RepeatTimes, Num);  
RepeatTimes_KMedoids = zeros(RepeatTimes, K);  
PointLabels = zeros(1,Num); 

for CurrentRepeat = 1:RepeatTimes  
    % �����ڲ�������ֵ.
    iter = 0;  
    max_iteration = 1e+3; 
    KMedoids = sort(randperm(Num,K));
    %KMedoids
    UpdatedMedoids = zeros(1,K); 
    
    while iter < max_iteration  
        iter = iter+1; 
        %��ʼ��K�����ĵ������ݵ���г�ʼ����.  
        [~,PointLabelsIndex] = min(MetricMatrix(KMedoids,:));  
        PointLabels = KMedoids(PointLabelsIndex);
   
        %����K�����ĵ�.
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
                    
        % �ж��Ƿ�ﵽ��������
        if KMedoids == UpdatedMedoids    
           %disp(['###���� ' num2str(iter) ' �εõ������Ľ�'])  
           RepeatTimes_SuccessPoints_Labels(CurrentRepeat,:) = PointLabels;  
           RepeatTimes_KMedoids(CurrentRepeat,:) = UpdatedMedoids; 
           break  
        end  
        % �������ĵ㼯��.
        KMedoids = UpdatedMedoids;  
    end  
    
    %�ڲ�ѭ����ֹʱǿ��д�����ĵ�����.
    if iter == max_iteration     
       RepeatTimes_SuccessPoints_Labels(CurrentRepeat,:) = PointLabels;  
       RepeatTimes_KMedoids(CurrentRepeat,:) = UpdatedMedoids;  
    end      
    FreshListBox(['��' num2str(CurrentRepeat) '�ξ������'], StatusBarHandle);
    disp(['��' num2str(CurrentRepeat) '�ξ������'])
end

%%�ȽϾ�����      
[~,BestIndex] = min(Errors);  
BestPointLabels = RepeatTimes_SuccessPoints_Labels(BestIndex,:);   
BestMedoids = RepeatTimes_KMedoids(BestIndex,:);  
MedoidsSize = KMedoidsSize(BestIndex,:);

% %���ƾ����.
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
        
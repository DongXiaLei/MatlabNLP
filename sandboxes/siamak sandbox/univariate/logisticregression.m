% predicting numerical values using Linear Regression

clear all;
 
disp('Reading featur vector');

featurs = csvread('forWeka_featuresonly.csv');

num_data = 300;
size_training = floor(.6*num_data);

trainingset = featurs(1:size_training,:);
testset = featurs((size_training+1):num_data,:);


disp('Splitting up data into training/test sets');
[num,txt,raw] = xlsread('C:\MatlabNLP\examples\gsa\data\final104.xls');

% reading the description of each shoe
descriptions = raw(2:size(raw,1),2);
style_ratings = num(1:size(num,1),1);
comfort_ratings = num(1:size(num,1),4);
overal_ratings = num(1:size(num,1),5);

% only take m data points
m=num_data;
descriptions = descriptions(1:m);
style_ratings = style_ratings(1:m);
comfort_ratings = comfort_ratings(1:m);
overal_ratings = overal_ratings(1:m);

responsevals = [style_ratings, comfort_ratings, overal_ratings];

responsevals_training = responsevals(1:size_training,:);
responsevals_test = responsevals((size_training+1):num_data,:);
disp('Multinomial logistic regression');
% http://www.mathworks.com/help/toolbox/stats/mnrfit.html

tic;

a_orig = responsevals_training(:,1)';
b_orig = responsevals_test(:,1)';
b_out = [];
logistic = mnrfit(trainingset,a_orig,'model','ordinal','link','logit');
for i=5:-1:1
    disp(i);
    a = (a_orig==i);
    b = (b_orig==i);
    SVMStruct = mnrfit(trainingset,a','model','ordinal','link','logit'); %SVMStruct = svmtrain(Training,Group)
    Group = svmclassify(SVMStruct,testset);
    b_out = [b_out,Group];
    toc;
end
output = (sum(b_out,2)==1)'.*max((b_out.*repmat([5,4,3,2,1],size(b_out,1),1))')
cMat2 = confusionmat(output,b_orig)
toc;



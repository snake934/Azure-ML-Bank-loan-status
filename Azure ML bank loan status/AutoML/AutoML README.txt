-------------------------------
AutoML
-------------------------------
In the classification of bank loan status, a logistic regression model was produced to set a baseline to compare developed model's performance against. AutoML was used to automatically test various binary classification models in different configurations to quickly and efficiently identify an optimal candidate for deployment and deployment. Azure AutoML was selected because it can efficiently build , train and test many models quickly and produce the necessary files to deploy and integrate a machine learning model with user interface.

------------------------------
How to run
------------------------------
1) To run the AutoML on azure set up compute instance (Standard_E4ds_v4 in UK south) and cluster compute (Standard_E4s_v3 in UK south used here) and open terminal in compute instance.
2) Clone the GitHub repo containing AutoML code and data

	rm -r Azure-ML-Bank-loan-status -f
	git clone https://github.com/snake934/Azure-ML-Bank-loan-status.git Azure-ML-Bank-loan-status

3) Authenticate identity in cli and set up data asset from ml table. Use processed data 

	z login --identity
	d Azure-ML-Bank-loan-status/'Azure ML bank loan status'
	z ml data create --type mltable --name "bank-loan-training" --path ./proc_data
4) Refresh directory tree and navigate to AutoML folder and open Bank_Loan_automl.ipnyb
5) Run the Bank_Loan_automl.ipnyb notebook. A link to AutoML job will be generated below to monitor progress and model trials



Three iterations of AutoML was performed with 5 fold cross validation, featurisation enabled for processing raw csv data, deep learning disabled and 10 trials with accuracy as primary metric. These iterations include:

1) AutoML with Raw data:

Initial run produced a voting ensemble which did not perform better compared to baseline logistic regression. Both with around 81% accuracy but the AutoML performed worse in f1 suggesting the baseline overall performed better overall. This could possibly be due to incorrect featurisation and data processing.

 -----------------------------
Baseline logistic regression
-----------------------------
Accuracy:0.8192771084337349
precision:0.794392523364486
recall:0.9941520467836257
f1:0.8831168831168831
AUC:0.7852001799370221
----------------------------

-----------------------------
AutoML raw data
-----------------------------
Accuracy:0.8137015873015873
precision:0.8541971540214368
recall:0.7097610028617988
f1:0.7347070994896103
AUC:0.8545476087679515
----------------------------

2) AutoML with Pre-processed data:

Many data points in the bank loan dataset contained capitalisation differences such as "Yes" and "yes". All such cases were combined and categorical features were one hot encoded or converted to Boolean categories like gender. To see the specific transformations, see "Azure ML bank loan status/Baseline logistic regression/baseline logistic regression.ipynb". The same cleaned dataset used in baseline model testing was used in AutoML to explore its effect. This resulted in a 11% accuracy improvement from a stacked ensemble model. AutoML improved in all metrics with processed data when compared to with raw data and also against baseline. The baseline model only performed better in recall. This was only tested with 10 trials and 5 fold cross validation limiting search space so now with AutoML giving improved results the final run is performed with more trials and cross validations

-----------------------------
AutoML with pre-processed data 
-----------------------------
Accuracy:0.923497214665112
precision:0.9193577500412282
recall:0.899666340987148
f1:0.9078074639232814
AUC:0.9552598192319335
----------------------------

3) AutoML with 30 trials:

Running AutoML with 30 trials and 10 cross validation folds produced a voting ensemble model with negligible improvements over previous runs in all areas but recall. This is the model I will deploy. Images of metrics are in the AutoML 30 trials folder along with output and log folders and model.pkl file


-----------------------------
AutoML with pre-processed data 
-----------------------------
Accuracy:0.9380323
precision:0.9459292
recall:0.8184381
f1:0.9238764
AUC:0.9788184
----------------------------


-----------------------------
Selected model
-----------------------------
Voting Ensemble of 3 models
1) Robust scaler with KNN 0.16666 weight
- numeric features scales to 10-90th percentile without centering 
- KNN with Manhattan metric, 4 neighbours and distance weights

2) MaxAbsScaler with XGBoost classifier 0.5 weight
- MaxAbsScaler used on data
- XGBoost classifier with tree method as auto

3) MaxAbsScaler with LightGBM 0.3333 weight
- MaxAbsScaler used on data
- LightGBM with min_data_in_leaf set to 20



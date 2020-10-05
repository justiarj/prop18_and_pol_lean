# prop18_and_pol_lean

# README
### Prop 18 and Political Lean

*This is the main directory for data and support files related to the Prop 18 and Political Lean project.*

View our visualization: https://grahamporter.shinyapps.io/Data_Challenge_2020_Prop_18/?_ga=2.171362080.1608641742.1601746586-1706688654.1601746586

### last updated: October 4, 2020
### last update by: Anson Justi 


### Purpose/motivation
Do other states with similar laws to prop 18, which would allow 17 year olds to vote in primaries if they will be 18 during the general election, experience noticeable changes in political lean before and after passage of this kind of law? 

We felt that any law that may increase voter participation among a specific demographic might find opposition among some political interest because greater voter participation among a demographic could push a location’s political makeup in the direction of one party or another. We thought examining how margin of victory, or political lean, affected the political landscape would be informative. 

### Directory Manifest

*  Folders:
	* Shiny App Data Challenge - In this folder, you will find another folder labelled "Data" and two r scripts labelled "Data Setup.R" and "app.R".
	
	* Data - In this folder, you will find our data. "pres_dat_76_16.xlsx" and "sen_dat_76_18.xlsx" are the downloaded data files which we input into our script. 
	They contain results for presidential elections and senate elections between 1976 and 2018. "prop18_lean_omni.csv" is our final output data file that is cleaned, 
	combined, and ready to visualize with the "app.R" file. 


* Files:
	*  Data Setup.R - This is the file we used to clean our data. It uses "pres_dat_76_16.xlsx" and "sen_dat_76_18.xlsx" to produce "prop18_lean_omni.csv". 
	The following changes were made in excel to "sen_dat_76_18.xlsx": 
	We removed all CT senate elections, the 2012 and 2018 ME senate elections, and the 1976 VA senate election. All of these included major vote getters from 
	three or more different parties. 
	Bernie Sanders was also reclassified from an independent to democratic candidate. 
	
	* app.R - This is the file we used to produce the data visualization in Rshiny. It takes "prop18_lean_omni.csv" as its input. 



### Personnel/Contributors

* Anson Justi - ajusti@ucdavis.edu - MS Environmental Policy and Management
* Graham Porter - sgporter@ucdavis.edu - MS Environmental Policy and Management


### Project URLs 

* https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/42MVDX # US Presidential Election Data For 1976 - 2016
* https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/PEJ5QU # US Senate Election Data For 1976 - 2018
* https://dataverse.harvard.edu/dataverse/medsl_election_returns # MIT Election Data + Science Lab
* https://www.ncsl.org/research/elections-and-campaigns/primaries-voting-age.aspx # Identifying State's Voting Age for Primary Elections

### Project Repositories

* For all relevant files: https://github.com/justiarj/prop18_and_pol_lean/tree/main/Shiny%20App%20Data%20Challenge 



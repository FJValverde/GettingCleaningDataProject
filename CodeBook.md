# Introduction

This codebook tries to follow the guidelines of:

http://www.icpsr.umich.edu/files/deposit/Guide-to-Codebooks_v1.pdf .

We only document here those values which are changed from the original
variables in
<tt>UCI HAR Dataset/features.txt</tt>
# Variables

They are explained as 

**activity** - (factor) An identifier for the activity obtained from
file <tt>UCI HAR Dataset/activity\_labels.txt</tt> as per the
project requirements in point 3. 
	_Values:_ <tt> WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING,
	STANDING, LAYING </tt>
	
**subject** - (factor) An index number into an (unknown) list of users
whose behaviour was sampled in the original experiment. This was
transformed into a factor, since the integer encoding allows some
manipulations (sums, means) that make no sense for these data.
	_Values:_ <tt> </tt>
	
**measurement variables** - (numeric) These are numeric variables,
  obtained as the mean of the original variables selected as per the
  requirements in point 2 of the project. 
	_Values:_ a numeric value in [-1,1]. This is always the mean of
  some normalized value, hence units/dimensions make no sense. 

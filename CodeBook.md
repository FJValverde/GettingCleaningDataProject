# Introduction

This codebook tries to follow the guidelines of:

http://www.icpsr.umich.edu/files/deposit/Guide-to-Codebooks_v1.pdf .

We only document here those values which are changed from the original
variables in
<tt>UCI HAR Dataset/features.txt</tt>.
For information on the original content of the variables that motivate
the selection and encoding below consult
<tt>UCI HAR Dataset/features_info.txt</tt>.

# Variables

They are explained as:
* **name** (type) Explanatory text
  _Values:_ A list of possible values.

**activity** - (factor) An identifier for the activity obtained from
file <tt>UCI HAR Dataset/activity\_labels.txt</tt> as per the
project requirements in point 3. 
	_Values:_ <tt> WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING,
	STANDING, LAYING </tt>
	
**subject** - (factor) An index number into an (unknown) list of users
whose behaviour was sampled in the original experiment. This was
transformed into a factor, since the integer encoding allows some
manipulations (sums, means) that make no sense for these data.
_Values:_ <tt> 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19
20 21 22 23 24 25 26 27 28 29 30 </tt>
	
**measurement variables (66)** - (numeric) These are numeric variables,
  obtained as the mean of the original variables selected as per the
  requirements in point 2 of the project. The names of these variables
  are *camlCase* as opposed to lower case, as they encode many
  distinctions:

1. Only base variable names for magnitudes that had *both* a mean and
   a standard deviation measured were retained.

5. Dots were removed from the names.

2. Variables in the time domain were prefixed with "time" whereas
	those of the frequency domain were prefixed with "frequency".

3. The original abbreviations "Acc" and "Gyro" were expanded to
   describe the sensor taking the measurement "Accelerator" or "Gyroscope".

4. "mean" and "std" were capitalized (to fit in the camelCase scheme),
   and they were postfixed to X, Y, Z (to conform to the pattern with
   Magnitude measurements). 

	_Values:_ a numeric value in [-1,1]. This is always the mean of
  some normalized value, hence dimensionless. 

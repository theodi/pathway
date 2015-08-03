This directory contains the configuration for the questionnaire used in the assessment tool.

For ease of maintenance the primary version of the questionnaire is being kept in a spreadsheet. The application code will process this to populate the application data model.

__NOTE__: currently the application doesn't have a fully developed model for versioning the questionnaire. Care needs to be taken when creating entirely new versions, rather than updated. This is something that was planned to be improved at a later date. Currently the version number in the database is collected as a basic versioning mechanism, but this is not evident to the user and there is no way to stage releases: a newly added version will immediately become the default for users.

The spreadsheet consist of three worksheets:

* `activities` - list of the dimensions and activities that define the framework for the questionnaire
* `questions` - all questions, answers and help text
* `improvements` - list of suggested improvements associated with specific answers

### Activities
  
The `activities` worksheet has the following columns:

* `Dimension` - name of dimension (from the open data maturity model), these are categories and have many activities
* `Activity` - name of activity (from the open data maturity model)

### Questions

The `questions` worksheet is structured as follows:

* `ID` -- stable identifier for the question
* `Dimension` -- the dimension of the maturity model to which the question relates. Should match an entry in the `activities` worksheet
* `Activity` -- the activity to which the question relates. Should match an entry in the `activities` worksheeet
* `Question Text` -- the text of the question
* `Question Notes` -- any help text that should be displayed to the user alongside the question
* `Dependency` -- indicates whether this question is dependent on whether the user has given a positive answer to a previous question
* `Answer ID` -- stable identifier for the answer
* `Answer Text` -- text for an answer to this question
* `Positive?` -- indicates whether this is a positive or negative answer. Selecting a negative answer will mean the user is not asked any further questions. A positive answer may mean that the user has to answer some additional dependent questions
* `Maturity Score` -- the score that the user receives for answering this question, any path through the questions for a specific activity should yield a single score
* `Internal Notes` -- working notes for editors, not to be loaded into the database

### Improvements

The `improvements` worksheet is structured as follows:

* `ID` -- stable identifier for the improvement
* `Answer ID` -- the answer to which the improvement relates. Should match an entry in the `questions` worksheet
* `Notes` -- the text displayed to the user

An answer may have several improvements associated with it, e.g. a list of recommended tasks. These are displayed to the user based ordered by the ID in the spreadsheet.



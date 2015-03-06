This directory contains the configuration for the questionnaire used in the assessment tool.

For ease of maintenance the primary version of the questionnaire is being kept in a spreadsheet. The application code will process this to populate the application data model.

The spreadsheet consists of a single worksheet with the following columns:

* `ID` -- stable identifier for the question
* `Dimension` -- the dimension of the maturity model to which the question relates
* `Activity` -- the activity to which the question relates
* `Question Text` -- the text of the question
* `Question Notes` -- any notes that should be displayed to the user alongside the question
* `Dependency` -- indicates whether this question is dependent on whether the user has given a positive answer to a previous question
* `Answer ID` -- stable identifier for the answer
* `Answer Text` -- text for an answer to this question
* `Positive?` -- indicates whether this is a positive or negative answer. A negative answer will mean the user is not asked any further questions. A positive answer may mean that the user has to answer some additional dependent questions
* `Maturity Score` -- the score that the user receives for answering this question, any path through the questions for a specific activity should yield a single score
* `Internal Notes` -- working notes for editors, not to be loaded into the database



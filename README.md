# ODMAT

[Open Data Pathway](http://pathway.theodi.org) is a tool to help organisations carry out an assessment of their open data maturity.

The tool allows users to complete a series of short questionnaires to help calculate the maturity of a number of processes in the 
organisation, e.g. how data is released and governed.

After completing an assessment the tool will provide the organisation with a maturity score and will create a suggested action plan 
to help them improve their rating. The report will also include any notes and links to evidence provided during the assessment.

To help benchmark organisations, and to provide a sense of the maturity of the overall community of users, the tool also includes 
[some anonymised statistics](http://pathway.theodi.org/statistics). These statistics are [published as open data](http://pathway.theodi.org/statistics/data).

## Summary of features

Open Data Pathway is a rails app that currently supports the following user features.

Follow the [public feature roadmap for Open Data Pathway](https://trello.com/b/2xc7Q0kd/labs-public-toolbox-roadmap?menu=filter&filter=label:Pathway)

### Assessments

* User can register with the site to create one or more assessments
* Basic account management features, including profile editing, password management, etc.
* User can link themselves to a data.gov.uk organisation to benchmark against their peer organisations
* Assessment can be started and resumed at any point; user can tackle activity assessments in any order
* Simple multiple choice questions with supporting help text; user can attach notes and add links to provide evidence of progression

### Reports

* Maturity assessments automatically calculated when assessment is finalised
* Maturity scores available as high-level summary as well as a detailed breakdown for each activity
* Maturity scores can be downloaded as a CSV file to allow scores to be used elsewhere
* The user leading the assessment can share the report with colleagues using a signed link
* The completed report includes the answers and evidence provided by the user, as well as suggestions for how to improve
* Application retains archive of reports to allow for, e.g. annual assessments of progress
* User can set targets scores for each activity, to indicate how they expect to improve between assessments

### Statistics

* Heatmap showing scores for all completed assessments in the system and those for all data.gov.uk organisations
* A data.gov.uk organisation can compare itself against others in its department (e.g. Defra)
* Statistics are published as open data for reuse by the community

## Development

[![Build Status](http://img.shields.io/travis/theodi/ODMAT.svg)](https://travis-ci.org/theodi/ODMAT)
[![Dependency Status](http://img.shields.io/gemnasium/theodi/ODMAT.svg)](https://gemnasium.com/theodi/ODMAT)
[![Code Climate](http://img.shields.io/codeclimate/github/theodi/ODMAT.svg)](https://codeclimate.com/github/theodi/ODMAT)
[![Badges](http://img.shields.io/:badges-4/4-ff6799.svg)](https://github.com/badges/badgerbadgerbadger)

### Requirements
Ruby 2.4.1

### Environment variables

The `.env` file in the application directory should contain:
 
```
MANDRILL_APIKEY=...
MANDRILL_USERNAME=...
GOOGLE_ANALYTICS_TRACKER=UA-XXXX-Y
ADMIN_EMAIL=...
ADMIN_PASSWORD=...
HEATMAP_THRESHOLD=1
```

The variables are:

* `MANDRILL_APIKEY` and `MANDRILL_USERNAME` are for accessing mandrill API for sending emails
* `GOOGLE_ANALYTICS_TRACKER` is the Google Analytics key, this can be defaulted in the dev environment
* `ADMIN_EMAIL` and `ADMIN_PASSWORD` are read during `rake db:seed` to create a default admin user in the system with the given credentials
* `HEATMAP_THRESHOLD` is the number of completed assessments that must be in the system before the statistics are shown to users. Helps to anonymise data when there are only a small number of completed assessments in the system or from a specific data.gov.uk organisation. Recommend to use `1` in development and `5` in production.

These environment variables should also be configured on Heroku - see [below](#deployment-on-heroku). The Mandrill ones (and those for Postgres which are not shown here) are handled when the addon is deployed for the app. The others needs to be manually added.

### Development: Running the full application locally

Checkout the repository and run ```bundle``` in the checked out directory.
To start the application run `rails s` in the checked out directory

### Tests

Open Data Pathway uses ```rspec``` and ```cucumber``` frameworks and requires an ```.env``` file with the variables stipulated above

To run unit tests execute `bundle exec rspec`

To run Cucumber features execute `bundle exec cucumber`

### Rake Tasks

In addition to the default Rails tasks the application has a couple of extra rake tasks

* `questionnaire:import` - import the questionnaire in `survey/survey.xls` into the database, used when seeding the app. Should have version number and optional notes parameters, e.g. `rake questionnaire:import[1]` imports the survey as version `.
* `questionnaire:update` - updates a specified version of the questionnaire, using the questions from `survey/survey.xls`. Should have version number parameter, e.g. `rake questionnaire:update[1]` imports the survey as version `. Use this when changes have been made to the survey text.
* `organisations:import` - imports the list of data.gov.uk organisations into the database
* `organisations:weekly_import` - hack to run the above on a weekly basis in heroku
* `statistics:generate` - generate the statistics for all completed assessments. Should be configured to run on heroku via the scheduler

Both the statistics generation and weekly organisation import should be configured to run regularly on heroku via the scheduler.

The questionnaire import is only used when seeding the database or when making enough modifications to the questionnaire that it warrants creating a new version (see below). If there have just been changes to the text for existing questions or help text then use the import task, specifying the right version.

### The Survey Questionnaire

The questions for the assessment can be found in `survey/survey.xls`. A spreadsheet was used to try to make it easier to review and edit the question text separately from the application. The spreadsheet is read by the `questionnaire:import` and `questionnaire:update` tasks to populate and update the database.

__NOTE__: currently the application doesn't have a fully developed model for versioning the questionnaire. Care needs to be taken when creating entirely new versions, rather than updated. This is something that was planned to be improved at a later date. Currently the version number in the database is collected as a basic versioning mechanism, but this is not evident to the user and there is no way to stage releases: a newly added version will immediately become the default for users.

The spreadsheet consist of three worksheets:

* `activities` - list of the dimensions and activities that define the framework for the questionnaire
* `questions` - all questions, answers and help text
* `improvements` - list of suggested improvements associated with specific answers

#### Activities
  
The `activities` worksheet has the following columns:

* `Dimension` - name of dimension (from the open data maturity model), these are categories and have many activities
* `Activity` - name of activity (from the open data maturity model)

#### Questions

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

#### Improvements

The `improvements` worksheet is structured as follows:

* `ID` -- stable identifier for the improvement
* `Answer ID` -- the answer to which the improvement relates. Should match an entry in the `questions` worksheet
* `Notes` -- the text displayed to the user

An answer may have several improvements associated with it, e.g. a list of recommended tasks. These are displayed to the user based ordered by the ID in the spreadsheet.

## Deployment

### Deployment on Heroku

Currently there are two deployment: a live site and a test server. Both use the following add-ons:

* Heroku Postgres
* Mandrill
* Heroku Scheduler - for running the data.gov.uk download and statistics generation

The Travis build is configured to automatically deploy successful builds of master to the `odmat-staging` application. 

Releases to production have so far been done manually: the production heroku app is set up as a remote git repo and code is pushed to that (`git push production master`).

```
$ git remote -v
origin	git@github.com:theodi/ODMAT.git (fetch)
origin	git@github.com:theodi/ODMAT.git (push)
production	https://git.heroku.com/odmat.git (fetch)
production	https://git.heroku.com/odmat.git (push)
```

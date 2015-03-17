# ODMAT
Open Data Maturity Assessment Tool 

[![Build Status](http://img.shields.io/travis/theodi/ODMAT.svg)](https://travis-ci.org/theodi/ODMAT)
[![Dependency Status](http://img.shields.io/gemnasium/theodi/ODMAT.svg)](https://gemnasium.com/theodi/ODMAT)
[![Code Climate](http://img.shields.io/codeclimate/github/theodi/ODMAT.svg)](https://codeclimate.com/github/theodi/ODMAT)
[![Badges](http://img.shields.io/:badges-4/4-ff6799.svg)](https://github.com/badges/badgerbadgerbadger)

Configuration notes:

For development `.env` should contain:

```
MANDRILL_APIKEY=...
MANDRILL_USERNAME=...
GOOGLE_ANALYTICS_TRACKER=UA-XXXX-Y
```

These environment variables should also be configured on Heroku. The Mandrill ones are handled when the addon is deployed for the app. The GA one needs to be manually added


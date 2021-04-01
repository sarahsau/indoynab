# indoynab |  [indoynab.github.io](herokusite)

Convert your Indonesian bank statements into CSV files compatible with You Need A Budget (YNAB) app.

No data is stored; your statement is automatically deleted after conversion.


### My bank isn't in **indoynab** yet, can you include it?
Yes! Go go to [Request adding a bank](https://github.com/sarahsau/Indo2YNAB/discussions/categories/-request-adding-a-bank) and post your request there + give a sample of the bank's statement. You can either:
- upload into the post (please sanitize any personal information)
- email me your statement at itsme@sarahsausan.com, if the statement is difficult to sanitize

If you program, you're welcome to create a pull request to add a new bank yourselves. Add a new converter logic in `app/models/lib/[new_bank_name.rb]`. We are using ruby 3.0 + Rails 6.1.3.  


### Changelog
- **v1.0** | Rails application
- **v0.2** | refactored and cleaned up Ruby script version  
- **v0.1** | initial Ruby script for converting bank statements (archived)

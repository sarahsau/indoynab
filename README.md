# indoynab |  [sarahsau.github.io/indoynab](https://blueberry-surprise-28648.herokuapp.com/)

A converter for your Indonesian bank statements into CSV files compatible with You Need A Budget (YNAB) app.

No data is stored; your statement is automatically deleted after conversion.


### My bank isn't in **indoynab** yet, can you include it?
Yes! Post your request to [the discussion forum](https://github.com/sarahsau/indoynab/discussions/categories/adding-a-bank-request), attaching a sample of the bank's statement. Please sanitize any personal information such as real name and account number. For PDF statements, you can use free programs like [Sejda PDF editor](https://www.sejda.com/pdf-editor) to remove personal info beforehand.

If you program, you're welcome to create a pull request to add a new bank yourselves. Add a new converter logic in `app/models/bank_[new_bank_abbreviation.rb]`. We are using ruby 3.0 + Rails 6.1.3.  


### Changelog
- **v1.0** | Rails application
- **v0.2** | refactored and cleaned up Ruby script version (archived)
- **v0.1** | initial Ruby script for converting bank statements (deprecated)

### Contributors
- [Sarah S](https://github.com/sarahsau) - owner
- [Keisuke Inaba](https://github.com/kei178) - pdf conversion example
- [Wesley Couch](https://github.com/wesmcouch) - csv conversion example

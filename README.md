# indoynab |  [sarahsau.github.io/indoynab](https://indoynab.herokuapp.com/)

An online YNAB converter for your Indonesian bank statements.
No installation required, no sign-up needed, no file stored.

Currently covering:
- Bank Central Asia (BCA) - CSV and PDF statements
- Bank Negara Indonesia (BNI)
- Bank Syariah Indonesia (BSI)
- BTPN Jenius

As easy as 123: Select Bank > Select Statement > Convert.

### Liking Indoynab? 
<a href="https://www.buymeacoffee.com/sarahsau" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>


### My bank isn't in **indoynab** yet, can you include it?
Yes! 

Post your request to [the discussion forum](https://github.com/sarahsau/indoynab/discussions/categories/adding-a-bank-request), and send the example file to indoynab [at] sarahsau [dot] com. Please sanitize your personal information such as real name and account number. For PDF statements, you can use free programs like [Sejda PDF editor](https://www.sejda.com/pdf-editor) to remove personal info beforehand.

If you program, you're welcome to create a pull request to add a new bank yourselves. Add a new converter logic in `app/models/bank_[new_bank_abbreviation.rb]`. We are using ruby 3.0 + Rails 6.1.3. 


### Changelog
- **v1.0** | Rails application
- **v0.2** | refactored and cleaned up Ruby script version (archived)
- **v0.1** | initial Ruby script for converting bank statements (deprecated)

### Contributors
- [Sarah S](https://github.com/sarahsau) - owner
- [Keisuke Inaba](https://github.com/kei178) - pdf conversion gem
- [Wesley Couch](https://github.com/wesmcouch) - csv conversion example
- [Ragenrave](https://github.com/Ragenrave) - BSI and Jenius requester 

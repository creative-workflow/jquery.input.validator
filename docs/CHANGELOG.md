# Changelog

##### 1.1.9
  * strip non printable chars before validationg email, tel and numbers

##### 1.1.8
  * fix required for radios

##### 1.1.3
  * attach error hint to custom element by data attribute `ivalidator-attach-hint-to`.

##### 1.1.2
  * correct value detection for radio

##### 1.1.1
  * add equal validator for password repeat for ex.

##### 1.1.0
  * allow email regexp to macth two char local domains and host subdomains

##### 1.0.21
  * better email regexp

##### 1.0.20
  * fix validating checkboxes

##### 1.0.19
  * better email regexp

##### 1.0.17
  * add `scrollToOnInvalid` and `scrollToOnInvalidOffset` for circumvent ios focus restrictions

##### 1.0.16
  * use slideUp/Down to show hide hints
  * reorder rules, from specific to generic
  * fix focus frist error

##### 1.0.15
  * add class `error` to default error class (next to `invalid`)
  * handle `aria-invalid` attribute

##### 1.0.14
  * more flexible validation of string defined elements or jquery many result sets

##### 1.0.13
  * dont focus invalid if single element is validated
  * add `[readonly]` to ignored elements

##### 1.0.12
  * add valid messages
  * remove bower dev dependencies

##### 1.0.8
  * refactor
  * many more tests

##### 1.0.7
  * rename `validateElement` to `validateOne`

##### 1.0.6
  * rename `inputValidator` to `iValidator`
  * add specs
  * enhance docs
  * `validate` and `validateOne` returning now true on success

##### 1.0.5
  * test for automated releases

##### 1.0.4
  * test for automated releases

##### 1.0.3
  * refactor `onBuildErrorHint`
  * clear input events before attaching
  * add tests for jquery>=1.10, >=2, >=3
  * more automations tasks
  * introduce test helper
  * refactor specs

##### 1.0.2
  * fix error hint
  * change rule ordering

##### 1.0.1
  * readme

##### 1.0.0
  * initial

### Resources
  * [Readme](../README.md)
  * [Documentation](DOCUMENTATION.md)
  * [Contributing](CONTRIBUTING.md)

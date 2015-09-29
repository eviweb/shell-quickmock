# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

### [Unreleased][unreleased]

#### Changed
- detail the expectation catalog in README

#### Fixed
- add missing _must_ keyword in expectation convention paragraph of README
- add missing comment for QuickMock.support.backupPrefix
- leading and trailing spaces are removed from expectation names during mock creation
- testQuickMockSupportNormalizeSpaces did not get the correct result from the function under test
- QuickMock.support.normalizeSpaces did not do what it was expected to...

#### Added
- shouldReceive expectation
- shouldNotReceive expectation
- andReturn expectation
- mocking integration tests
- trim support function
- new expectation _Known Issues_ section in README
- new README section about customization of the mock behaviour

### 0.2.1 - 2015-09-29
#### Changed
- update README with mocking and expecation documentation

#### Added
- mock support
- expectation support library basis

### 0.2.0 - 2015-09-29
#### Removed    
- QUICKMOCK_STUBS global var in favor of a more generic QUICKMOCK_DOUBLES
- QuickMock.trackStub in favor of a more generic QuickMock.trackDouble
- QuickMock.releaseStubs in favor of a more generic QuickMock.releaseDoubles

#### Changed
- split inner libraries and their corresponding tests into their own files
- update README to reflect API modifications

#### Added
- QUICKMOCK_DOUBLES global var in replacement of QUICKMOCK_STUBS
- quickmock common library:
    * QuickMock.trackDouble in replacement of QuickMock.trackStub
    * QuickMock.releaseDoubles in replacement of QuickMock.releaseStubs
- QuickMock.support.backupPrefix to provide a prefix for command backups (no more hardcoded)

### 0.1.0 - 2015-09-28
#### Added
- package files
- stub support
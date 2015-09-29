# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

### [Unreleased][unreleased]

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

### 0.1.0 - 2015-09-28
#### Added
- package files
- stub support
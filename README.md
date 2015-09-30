Shell QuickMock
===============
bash shell mocking library.   

##### Health status
[![Travis CI - Build Status](https://travis-ci.org/eviweb/shell-quickmock.svg)](https://travis-ci.org/eviweb/shell-quickmock)
[![Github - Last tag](https://img.shields.io/github/tag/eviweb/shell-quickmock.svg)](https://github.com/eviweb/shell-quickmock/tags)

Installation
------------
from within your project directory, run:    
`git submodule add --name shell-quickmock https://github.com/eviweb/shell-quickmock lib/shell-quickmock`   

Usage
-----
source the bootstrap file: `./lib/shell-quickmock/bootstrap.sh`, then use the provided utilities.    
_ie. from a script at the root of your project it could be something like this:_    
```bash
#! /bin/bash
. "$(dirname $(readlink -f $BASH_SOURCE))/lib/shell-quickmock/bootstrap.sh"

#### Do your stuff ####
```
Stubbing API
------------
### Stub a command or a function
Done using **QuickMock.newStub**    
_Synopsis:_ `QuickMock.newStub "command_name" ["command_body"]`

It will create a function named *command_name* with *command_body* as its function body.   
*command_body* is optional, if omitted it will be replaced by the default: `return 0;`   
The stubbing process only alters the runtime shell.
    
> **Important note**   
> If a command with the same name already exists, it will be overwritten for the runtime duration.    
> You can easily release your stub during the same process to get back the original command or function.    
> see [Release a Double](#release-a-double)     

```bash
# ie stubbing ls
QuickMock.newStub "ls" "echo 'my-file'"
```

Mocking API
-----------
### Create a Mock
Done using **QuickMock.newMock**    
_Synopsis:_ `QuickMock.newMock "mock_name" "expectation1" ["expectation2" ["expectation3"]...]`

It will create a function named *mock_name* with all expectations concatened using the `&&` operator as its function body.   
At least one expectation is required.    
As the stubbing process, mocking only alters the runtime shell and also can be released (see [Release a Double](#release-a-double)).   

> **Important note**   
> All arguments passed to the `QuickMock.newMock` must be (double-)quoted    

```bash
QuickMock.newMock "mycmd" "what_do_I_expect"
```

Expectations
------------
### Convention
An expectation:
* is a function that will be evaluated at runtime
* must be provided as a string
* name must begin with a double undescore `__` *(ie. __doSomething is valid, iamWrong is not)*
* whose name begins by `__should` will receive the arguments with which the mock is called

> While waiting for some examples, please refer to the [mock tests](tests/mock_test.sh)

### Known Issues
* currently an expectation must be given in the form of a one line string

### Catalog of expectation providers
#### shouldReceive
Used to check the correctness of the arguments passed to the mock.    
_Synopsis:_ `QuickMock.newMock "mock" "$(shouldReceive arg1 [arg2 [arg3]...])"`    
_Example:_    

```bash
QuickMock.newMock "mock" "$(shouldReceive a b c)"

mock a b c  # succeed
mock a      # failed
```

#### shouldNotReceive
Used to ensure some arguments are not passed to the mock.    
_Synopsis:_ `QuickMock.newMock "mock" "$(shouldNotReceive arg1 [arg2 [arg3]...])"`    
_Example:_    

```bash
QuickMock.newMock "mock" "$(shouldNotReceive arg1 arg2)"

mock arg3 arg4  # succeed
mock arg3 arg1  # failed
```

#### andReturn
Used to define some values to be returned by the mock.    
_Synopsis:_ `QuickMock.newMock "mock" "$(andReturn val1 [val2 [val3]...])"`    
_Example:_    

```bash
QuickMock.newMock "mock" "$(andReturn value to be returned)"

res=$(mock) # $res = "value to be returned"
```

### Customize the mock behaviour
Now it is possible to customize the mock behaviour by putting together several expectations.    
_Example:_    

```bash
QuickMock.newMock "mock" "$(shouldReceive arg1)" "$(shouldNotReceive arg2)" "$(andReturn value for arg1)"

res=$(mock arg1) # succeed and $res = "value for arg1"
res=$(mock arg2) # failed and $res should contain an error message
```

Common API
----------
### Release a Double
Done using **QuickMock.releaseDoubles**    
_Synopsis:_ `QuickMock.releaseDoubles ["double1_name" ["double2_name"]...]`    


This will release the provided doubles and revert the potentially overwritten commands or functions.    
Double names are optional. If none is given then all created doubles are released.    

```bash
# ie releasing the ls stub
QuickMock.releaseDoubles "ls"
```

License
-------
this project is licensed under the terms of the [MIT License](/LICENSE)
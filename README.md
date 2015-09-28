Shell QuickMock
===============
bash shell mocking library.

Installation
------------
from within your project directory, run:    
`git submodule add --name shell-quickmock https://github.com/eviweb/shell-testlib lib/shell-quickmock`   

Usage
-----
source the bootstrap file: `./lib/shell-quickmock/bootstrap.sh`, then use the provided utilities.    
_ie. from a script at the root of your project it could be something like this:_    
```bash
#! /bin/bash
. "$(dirname $(readlink -f $BASH_SOURCE))/lib/shell-quickmock/bootstrap.sh"

#### Do your stuff ####
```
Stubbing
--------
### Stub a command or a function
Done using **QuickMock.newStub**    
_Synopsis:_ `QuickMock.newStub "command_name" ["command_body"]`

It will create a function named *command_name* with *command_body* as its function body.   
*command_body* is optional, if omitted it will be replaced by the default: `return 0;`   
The stubbing process only alters the runtime shell.
    
> **Important note**   
> If a command with the same name already exists, it will be overwritten for the runtime duration.    
> You can easily release your stub during the same process to get back the original command or function.    
> see [Release a Stub](#release-a-stub)     

```bash
# ie stubbing ls
QuickMock.newStub "ls" "echo 'my-file'"
```

### Release a Stub
Done using **QuickMock.releaseStubs**    
_Synopsis:_ `QuickMock.releaseStubs ["stub1_name" ["stub2_name"]...]`    


This will release the provided stubs and revert the potentially overwritten commands or functions.    
Stub names are optional. If none is given then all created stubs are released.    

```bash
# ie releasing the ls stub
QuickMock.releaseStubs "ls"
```

License
-------
this project is licensed under the terms of the [MIT License](/LICENSE)
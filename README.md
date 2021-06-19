# Academic Search Help

Welcome to the **Academic Search Project**. This program is to help you find the information about great scientists like H-index, years in science and count of articles with their citations.

## Requirements

This is Linux program, but it is based on platform undependable libraries, so can be compiled under each system that supports analogs of following packages.
 
The program requires analogs of the packages in you system, that are listed below.

* `Qt4-Core`
* `Qt4-WebKit`
* `Qt4-Gui`
* `libXML`
* `R-core`
* `XML R-package`

To install Qt libraries and libXML you can use packages from your repository.
To install XML you can type `install.packages("XML")` in the R console. Be sure that R can connect to the CRAN-repository.

## Install

To install program you should run `build.sh` script in the root of package or something like below:

    mkdir bin &&
    mkdir bin/gui &&
    cd bin/gui &&
    qmake ../src/gui &&
    make && make clean

The program will be compiled into `bin/gui/gui`.

## Using

### Engines

We support two basic engines: *Google Scholar* and *Microsoft Academic Search*.
Search base of the first engine is larger than of the last one.
But if you want to search a lot of persons we recommend to use engine by *Microsoft* because *Google* will
**ban** you soon in this case for a long time (several days) and will not response.
Also there are combined engine *Google Schoolar + Miscrosoft Academic Search* and
two fake engines: single *Test Search* and combined *Double Test Search*.
The two last engines simply wait random time and response with random results.
Summary, engines:

* Google Scholar;
* Microsoft Academic Search;
* Google Scholar + Microsoft Academic Search;
* Fake Single Test engine;
* Fake Test multi-engine.

### Search modes

There 4 modes of search:

* Single person and single search engine;
* Single person and multi-engine;
* Many persons and single engine;
* Many persons and multi-engine.

In the *single person and single engine* mode graph of articles and approximation
(if needed and possible) will be generated.
Mode of search depends on request and is detected automatically.

### Search information

The program is to search the next information about persons:

* H-index or Hirsch index (or approximation);
* Count of articles;
* Years in science (approximation).

### Search load

You can load file with search requests. The file should contain new-line separated names of scientists you want to search information about. To load search request simple click on the button **...**.

### Search save

You can save results of searching in JSON format by clicking on the button **Save as JSON...**.

### Searching

For each person and for each search engine the program will generate a one thread.
There is a minute per each task of search timeout.
Sometimes `Google` engine can **ban** you.
`Microsoft` engine can generate bad results of searching or do not response for a long time.
In bad result case you will see `NA` results in result tables.
